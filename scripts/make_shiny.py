#!/usr/bin/env python3
"""Derive a beast's shiny sprite from its regular sprite. Handles both PNG and animated GIF.

Reverse-engineered from the regular/shiny pairs shipped in src/beast_png_*_data.cairo and
src/beast_gif_*_data.cairo. In both formats the rule is the same recolour, sampled purely on
the row index - t = y / (height - 1) - using the six pastel stops that `logo_pastel_rainbow`
and `shinyRim` already use in src/beast_card.cairo. Horizontal position plays no part, and the
silhouette is never altered.

The two formats differ only in how the non-outline pixels are stored, and this mirrors what the
shipped art actually does:

  PNG   transparent stays transparent; the opaque black body stays opaque black.
  GIF   everything that is not outline becomes transparent - body included. Regular GIFs sit on
        an opaque black field, shiny GIFs drop it. Both render identically inside the card,
        which paints a black plate behind the art.

Verified by regenerating this repo's own shiny art from its own regular art:

  PNG   70/73 beasts exact. Only chimera and hippogriff (5px each) and rakshasa (1px) differ,
        and 2 sprites are skipped for using an encoding this script does not read.
  GIF   51/75 beasts exact, frame for frame. The 24 that differ were hand-retouched after
        generation rather than derived - rakshasa again by a single pixel.

In none of those beasts is the ramp colour ever wrong; the only differences are which pixels
count as outline. So a mismatch means the shiny was touched up by hand, not that the rule is off.

Usage:
    python3 scripts/make_shiny.py <regular.png|regular.gif> [shiny_out]

    # regenerate a shiny beside its source
    python3 scripts/make_shiny.py assets/my_beast/regular_static.png
    python3 scripts/make_shiny.py assets/my_beast/regular_animated.gif

Stdlib only - no PIL in this repo's toolchain.
"""
import struct
import sys
import zlib
from pathlib import Path

# Pastel rainbow, matching src/beast_card.cairo's logo_pastel_rainbow stops.
STOPS = [
    (0.0, (0x73, 0xFF, 0x73)),
    (0.2, (0xFF, 0xFF, 0x73)),
    (0.4, (0xFF, 0xBE, 0x73)),
    (0.6, (0xFF, 0x73, 0x73)),
    (0.8, (0xC0, 0x73, 0xDC)),
    (1.0, (0x73, 0x73, 0xFF)),
]

# Tier accent colours: any of these reads as "outline" and gets recoloured. Taken from the
# palettes actually shipped in src/beast_png_regular_data.cairo rather than from
# beast_card.cairo::get_tier_color - the art and the card disagree on T1, which appears as both
# #ff8000 (5 sprites) and #ff8800 (3 sprites). A regular sprite is only ever black plus its
# accent, so matching on colour is unambiguous.
TIER_COLORS = {
    (0xFF, 0x80, 0x00),  # T1 orange, as authored
    (0xFF, 0x88, 0x00),  # T1 orange, card constant
    (0x8C, 0x00, 0xBF),  # T2 purple
    (0x00, 0x00, 0xFF),  # T3 blue
    (0x00, 0xFF, 0x00),  # T4 green
    (0xFF, 0xFF, 0xFF),  # T5 white
}


def ramp(t):
    for i in range(len(STOPS) - 1):
        t0, c0 = STOPS[i]
        t1, c1 = STOPS[i + 1]
        if t0 <= t <= t1:
            f = (t - t0) / (t1 - t0)
            return tuple(round(c0[k] + (c1[k] - c0[k]) * f) for k in range(3))
    return STOPS[-1][1]


def read_png(path):
    data = Path(path).read_bytes()
    if data[:8] != b"\x89PNG\r\n\x1a\n":
        raise SystemExit(f"{path}: not a PNG")
    chunks, i = {}, 8
    while i < len(data):
        ln = struct.unpack(">I", data[i : i + 4])[0]
        tag = data[i + 4 : i + 8].decode("latin1")
        chunks[tag] = chunks.get(tag, b"") + data[i + 8 : i + 8 + ln]
        i += 8 + ln + 4
    w, h, depth, ctype, _, _, interlace = struct.unpack(">IIBBBBB", chunks["IHDR"])
    if depth != 8 or interlace:
        raise SystemExit(f"{path}: need 8-bit non-interlaced (got depth={depth} interlace={interlace})")

    bpp = {0: 1, 2: 3, 3: 1, 4: 2, 6: 4}[ctype]
    raw = zlib.decompress(chunks["IDAT"])
    stride = w * bpp
    rows, prev, pos = [], bytearray(stride), 0
    for _ in range(h):
        f = raw[pos]
        pos += 1
        line = bytearray(raw[pos : pos + stride])
        pos += stride
        for x in range(stride):
            a = line[x - bpp] if x >= bpp else 0
            b = prev[x]
            c = prev[x - bpp] if x >= bpp else 0
            if f == 1:
                line[x] = (line[x] + a) & 255
            elif f == 2:
                line[x] = (line[x] + b) & 255
            elif f == 3:
                line[x] = (line[x] + (a + b) // 2) & 255
            elif f == 4:
                p = a + b - c
                pa, pb, pc = abs(p - a), abs(p - b), abs(p - c)
                line[x] = (line[x] + (a if (pa <= pb and pa <= pc) else (b if pb <= pc else c))) & 255
        rows.append(bytes(line))
        prev = line

    plte = chunks.get("PLTE", b"")
    trns = chunks.get("tRNS", b"")
    pal = [tuple(plte[j : j + 3]) for j in range(0, len(plte), 3)]

    pixels = []
    for y in range(h):
        row = []
        for x in range(w):
            v = rows[y][x * bpp : (x + 1) * bpp]
            if ctype == 3:
                idx = v[0]
                alpha = trns[idx] if idx < len(trns) else 255
                row.append((*pal[idx], alpha))
            elif ctype == 6:
                row.append(tuple(v))
            elif ctype == 2:
                row.append((*v, 255))
            else:
                raise SystemExit(f"{path}: unsupported colour type {ctype}")
        pixels.append(row)
    return w, h, pixels


def write_png_palette(path, w, h, pixels):
    """Write a palettised PNG with a single fully-transparent entry at index 0."""
    palette, index = [(0, 0, 0)], {}
    alphas = [0]
    out = bytearray()
    for y in range(h):
        out.append(0)  # filter: None
        for x in range(w):
            r, g, b, a = pixels[y][x]
            if a == 0:
                out.append(0)
                continue
            key = (r, g, b)
            if key not in index:
                if len(palette) >= 256:
                    raise SystemExit("palette overflow")
                index[key] = len(palette)
                palette.append(key)
                alphas.append(255)
            out.append(index[key])

    def chunk(tag, data):
        return (
            struct.pack(">I", len(data))
            + tag
            + data
            + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF)
        )

    plte = b"".join(bytes(c) for c in palette)
    png = b"\x89PNG\r\n\x1a\n"
    png += chunk(b"IHDR", struct.pack(">IIBBBBB", w, h, 8, 3, 0, 0, 0))
    png += chunk(b"PLTE", plte)
    png += chunk(b"tRNS", bytes(alphas))
    png += chunk(b"IDAT", zlib.compress(bytes(out), 9))
    png += chunk(b"IEND", b"")
    Path(path).write_bytes(png)
    return png, len(palette)


def make_shiny(w, h, pixels):
    shiny, recoloured = [], 0
    for y in range(h):
        row = []
        for x in range(w):
            r, g, b, a = pixels[y][x]
            if a == 0:
                row.append((0, 0, 0, 0))
            elif (r, g, b) in TIER_COLORS:
                row.append((*ramp(y / (h - 1)), 255))
                recoloured += 1
            else:
                row.append((r, g, b, a))
        shiny.append(row)
    return shiny, recoloured


# ---------------------------------------------------------------------------- GIF
def _sub_blocks(d, i):
    out = bytearray()
    while d[i]:
        n = d[i]
        out += d[i + 1 : i + 1 + n]
        i += n + 1
    return bytes(out), i + 1


def _lzw_decode(data, mcs, npixels):
    clear, end = 1 << mcs, (1 << mcs) + 1
    width = mcs + 1
    table = [bytes([i]) for i in range(clear)] + [b"", b""]
    out, bitpos, prev = bytearray(), 0, None
    total = len(data) * 8
    while bitpos + width <= total and len(out) < npixels:
        byte, off = bitpos >> 3, bitpos & 7
        code = (int.from_bytes(data[byte : byte + 3].ljust(3, b"\0"), "little") >> off) & ((1 << width) - 1)
        bitpos += width
        if code == clear:
            table = [bytes([i]) for i in range(clear)] + [b"", b""]
            width, prev = mcs + 1, None
            continue
        if code == end:
            break
        if code < len(table):
            entry = table[code]
        elif prev is not None:
            entry = prev + prev[:1]
        else:
            break
        out += entry
        if prev is not None:
            table.append(prev + entry[:1])
            if len(table) >= (1 << width) and width < 12:
                width += 1
        prev = entry
    return bytes(out[:npixels])


def read_gif(path):
    d = Path(path).read_bytes()
    if d[:3] != b"GIF":
        raise SystemExit(f"{path}: not a GIF")
    w, h, packed, _, _ = struct.unpack("<HHBBB", d[6:13])
    i = 13
    gct = []
    if packed & 0x80:
        n = 2 << (packed & 7)
        gct = [tuple(d[i + j * 3 : i + j * 3 + 3]) for j in range(n)]
        i += n * 3

    frames, delay, transparent, disposal, loop = [], 0, None, 0, 0
    while i < len(d):
        b = d[i]
        if b == 0x3B:
            break
        if b == 0x21:
            label = d[i + 1]
            payload, i = _sub_blocks(d, i + 2)
            if label == 0xF9 and len(payload) >= 4:
                pk = payload[0]
                disposal = (pk >> 2) & 7
                delay = struct.unpack("<H", payload[1:3])[0]
                transparent = payload[3] if pk & 1 else None
            elif label == 0xFF and payload[:11] == b"NETSCAPE2.0" and len(payload) >= 16:
                loop = struct.unpack("<H", payload[14:16])[0]
            continue
        if b == 0x2C:
            left, top, fw, fh, fp = struct.unpack("<HHHHB", d[i + 1 : i + 10])
            i += 10
            pal = gct
            if fp & 0x80:
                n = 2 << (fp & 7)
                pal = [tuple(d[i + j * 3 : i + j * 3 + 3]) for j in range(n)]
                i += n * 3
            mcs = d[i]
            i += 1
            raw, i = _sub_blocks(d, i)
            frames.append(dict(left=left, top=top, w=fw, h=fh, palette=pal, delay=delay,
                               disposal=disposal, transparent=transparent,
                               indices=_lzw_decode(raw, mcs, fw * fh)))
            continue
        raise SystemExit(f"{path}: unexpected byte 0x{b:02x} at offset {i}")
    if not frames:
        raise SystemExit(f"{path}: no frames")
    return w, h, frames, loop


def composite_gif(w, h, frames):
    """Flatten each frame to a full-canvas RGBA grid.

    A frame's disposal method governs what the NEXT frame starts from, not its own base. Reading
    it the other way round quietly corrupts any file that mixes methods - which the shipped
    beast GIFs do.
    """
    blank = lambda: [[(0, 0, 0, 0)] * w for _ in range(h)]
    canvas, out = blank(), []
    for f in frames:
        before = [row[:] for row in canvas]
        base = [row[:] for row in canvas]
        for y in range(f["h"]):
            for x in range(f["w"]):
                v = f["indices"][y * f["w"] + x]
                if f["transparent"] is not None and v == f["transparent"]:
                    continue
                if v < len(f["palette"]):
                    base[f["top"] + y][f["left"] + x] = (*f["palette"][v], 255)
        out.append([row[:] for row in base])
        if f["disposal"] == 2:
            canvas = base
            for y in range(f["h"]):
                for x in range(f["w"]):
                    canvas[f["top"] + y][f["left"] + x] = (0, 0, 0, 0)
        elif f["disposal"] == 3:
            canvas = before
        else:
            canvas = base
    return out


class _Bits:
    def __init__(self):
        self.out, self.cur, self.n = bytearray(), 0, 0

    def emit(self, code, width):
        self.cur |= code << self.n
        self.n += width
        while self.n >= 8:
            self.out.append(self.cur & 0xFF)
            self.cur >>= 8
            self.n -= 8

    def flush(self):
        if self.n:
            self.out.append(self.cur & 0xFF)
            self.cur = self.n = 0
        return bytes(self.out)


def _lzw_encode(indices, mcs):
    clear, end = 1 << mcs, (1 << mcs) + 1
    width = mcs + 1
    table = {bytes([i]): i for i in range(clear)}
    nxt = end + 1
    b = _Bits()
    b.emit(clear, width)
    cur = b""
    for px in indices:
        nc = cur + bytes([px])
        if nc in table:
            cur = nc
            continue
        b.emit(table[cur], width)
        if nxt < 4096:
            table[nc] = nxt
            nxt += 1
            if nxt > (1 << width) and width < 12:
                width += 1
        else:
            b.emit(clear, width)
            table = {bytes([i]): i for i in range(clear)}
            nxt, width = end + 1, mcs + 1
        cur = bytes([px])
    if cur:
        b.emit(table[cur], width)
    b.emit(end, width)
    return b.flush()


def _blocked(data):
    out = bytearray()
    for i in range(0, len(data), 255):
        part = data[i : i + 255]
        out.append(len(part))
        out += part
    out.append(0)
    return bytes(out)


def write_gif(path, w, h, frames_rgba, delays, loop=0):
    """Write a GIF whose palette index 0 is fully transparent."""
    palette, index = [(0, 0, 0)], {}
    indexed = []
    for grid in frames_rgba:
        buf = bytearray()
        for y in range(h):
            for x in range(w):
                r, g, b, a = grid[y][x]
                if a == 0:
                    buf.append(0)
                    continue
                if (r, g, b) not in index:
                    if len(palette) >= 256:
                        raise SystemExit("palette overflow")
                    index[(r, g, b)] = len(palette)
                    palette.append((r, g, b))
                buf.append(index[(r, g, b)])
        indexed.append(bytes(buf))

    bits = max(1, (len(palette) - 1).bit_length())
    size = 1 << bits
    gct = bytearray()
    for c in palette:
        gct += bytes(c)
    gct += b"\x00\x00\x00" * (size - len(palette))

    g = bytearray(b"GIF89a")
    g += struct.pack("<HH", w, h)
    g += bytes([0x80 | ((bits - 1) << 4) | (bits - 1), 0, 0])
    g += gct
    g += b"\x21\xff\x0bNETSCAPE2.0\x03\x01" + struct.pack("<H", loop) + b"\x00"
    mcs = max(2, bits)
    for buf, delay in zip(indexed, delays):
        # disposal 2 so every frame stands alone, matching the shipped shiny GIFs
        g += b"\x21\xf9\x04" + bytes([(2 << 2) | 1]) + struct.pack("<H", delay) + b"\x00\x00"
        g += b"\x2c" + struct.pack("<HHHH", 0, 0, w, h) + b"\x00"
        g += bytes([mcs]) + _blocked(_lzw_encode(buf, mcs))
    g += b"\x3b"
    Path(path).write_bytes(bytes(g))
    return bytes(g), len(palette)


def make_shiny_frames(w, h, frames_rgba):
    """GIF variant: outline -> ramp, everything else transparent."""
    out, recoloured = [], 0
    for grid in frames_rgba:
        row_out = []
        for y in range(h):
            row = []
            for x in range(w):
                r, g, b, a = grid[y][x]
                if a != 0 and (r, g, b) in TIER_COLORS:
                    row.append((*ramp(y / (h - 1)), 255))
                    recoloured += 1
                else:
                    row.append((0, 0, 0, 0))
            row_out.append(row)
        out.append(row_out)
    return out, recoloured


def main():
    if len(sys.argv) < 2:
        raise SystemExit(__doc__)
    src = Path(sys.argv[1])
    is_gif = src.suffix.lower() == ".gif"
    default = src.stem + "_shiny" + (".gif" if is_gif else ".png")
    dst = Path(sys.argv[2]) if len(sys.argv) > 2 else src.with_name(default)

    if is_gif:
        w, h, frames, loop = read_gif(src)
        shiny, recoloured = make_shiny_frames(w, h, composite_gif(w, h, frames))
        if recoloured == 0:
            raise SystemExit(
                f"{src}: found no tier-accent outline pixels {sorted(TIER_COLORS)} - "
                "is this already a shiny, or authored with a different accent colour?"
            )
        data, ncolors = write_gif(dst, w, h, shiny, [f["delay"] for f in frames], loop)
        print(f"{src.name} -> {dst.name}: {w}x{h}, {len(frames)} frames, "
              f"{recoloured} outline px recoloured, {ncolors} palette entries, {len(data)} bytes")
        return

    w, h, pixels = read_png(src)
    shiny, recoloured = make_shiny(w, h, pixels)
    if recoloured == 0:
        raise SystemExit(
            f"{src}: found no tier-accent outline pixels {sorted(TIER_COLORS)} - "
            "is this already a shiny, or authored with a different accent colour?"
        )
    data, ncolors = write_png_palette(dst, w, h, shiny)
    print(f"{src.name} -> {dst.name}: {w}x{h}, {recoloured} outline px recoloured, "
          f"{ncolors} palette entries, {len(data)} bytes")


if __name__ == "__main__":
    main()
