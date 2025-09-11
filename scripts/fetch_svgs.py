#!/usr/bin/env python3
"""
Fetch SVGs concurrently by calling token_uri for token IDs 1..N.

Requirements:
- 'starkli' must be installed and available on PATH (or provide --starkli).
- RPC URL and NFT address provided via flags or environment variables.

Example:
  python3 scripts/fetch_svgs.py \
    --rpc https://api.cartridge.gg/x/starknet/sepolia/rpc/v0_8 \
    --address 0x05f9e5d5c008cdaa7e2c3e1fcba58d917ff26e5408929349a4d143dd73b2fab3 \
    --start 1 --end 375 --concurrency 32 --outdir sample_outputs
"""

from __future__ import annotations

import argparse
import asyncio
import base64
import json
import os
import re
import sys
from pathlib import Path
from typing import Any, List, Tuple


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(description="Fetch SVGs via token_uri concurrently")
    p.add_argument("--rpc", default=os.environ.get("RPC_URL", ""), help="RPC endpoint URL")
    p.add_argument("--address", default=os.environ.get("NFT_ADDRESS", ""), help="NFT contract address")
    p.add_argument("--start", type=int, default=1, help="Starting token_id (inclusive)")
    p.add_argument("--end", type=int, default=375, help="Ending token_id (inclusive)")
    p.add_argument("--concurrency", type=int, default=32, help="Max concurrent calls")
    p.add_argument("--outdir", default="sample_outputs", help="Directory to write SVGs")
    p.add_argument("--starkli", default=os.environ.get("STARKLI", "starkli"), help="starkli binary path")
    p.add_argument("--timeout", type=float, default=45.0, help="Per-call timeout in seconds")
    p.add_argument("--retries", type=int, default=2, help="Retries per token on failure/timeout")
    p.add_argument("--progress-interval", type=float, default=10.0, help="Seconds between progress logs")
    p.add_argument("--verbose", action="store_true", help="Enable verbose debug logs to stderr")
    p.add_argument("--save-raw-dir", default=None, help="Optional dir to dump raw token_uri responses on failure")
    return p.parse_args()


def reconstruct_uri_from_limbs(raw: str, *, verbose: bool = False, tid: int | None = None) -> str:
    """Given starkli's array of hex words, reconstruct the original data URI string."""
    raw = raw.strip()
    try:
        arr = json.loads(raw)
    except json.JSONDecodeError:
        # Not JSON-array shaped; return raw as-is
        return raw

    if not isinstance(arr, list) or len(arr) < 2:
        return raw

    # New: Many starkli builds encode ByteArray as [n_words, words..., last_len].
    # Each word is 32 bytes with a leading 0x00 pad and 31 data bytes.
    # last_len is the number of valid bytes in the final word (<=31).
    try:
        n_words = int(str(arr[0]), 16)
    except Exception:
        return raw
    buf = bytearray()
    words = arr[1 : 1 + n_words]
    extra_data_word = None
    last_len = None
    # Some encodings append one extra word with the final partial bytes and a trailing last_len
    if len(arr) >= 1 + n_words + 2:
        extra_data_word = arr[1 + n_words]
        try:
            last_len = int(str(arr[1 + n_words + 1]), 16)
        except Exception:
            last_len = None
    for i, h in enumerate(words):
        hs = str(h)
        if hs.startswith("0x"):
            hs = hs[2:]
        if len(hs) % 2 == 1:
            hs = "0" + hs
        hs = hs.rjust(64, "0")
        try:
            limb = bytes.fromhex(hs)
        except ValueError:
            return raw
        data = limb[1:] if len(limb) == 32 else limb
        buf.extend(data)
    # Append extra tail if present
    if extra_data_word is not None and last_len:
        hs = str(extra_data_word)
        if hs.startswith("0x"):
            hs = hs[2:]
        if len(hs) % 2 == 1:
            hs = "0" + hs
        hs = hs.rjust(64, "0")
        try:
            limb = bytes.fromhex(hs)
        except ValueError:
            return raw
        data = limb[1:] if len(limb) == 32 else limb
        # last_len bytes are right-aligned within the 31-byte data
        buf.extend(data[-last_len:])
    try:
        s = buf.decode("utf-8", errors="ignore")
        if verbose:
            sys.stderr.write(
                f"[tid={tid}] reconstructed: n_words={n_words} extra={'yes' if extra_data_word else 'no'} last_len={last_len} bytes_buf={len(buf)} uri_len={len(s)}\n"
            )
        return s
    except Exception:
        return raw


def decode_base64_padded(b64s: str) -> bytes:
    # Support URL-safe variants and missing padding
    s = b64s.replace("-", "+").replace("_", "/")
    s += "=" * ((4 - (len(s) % 4)) % 4)
    return base64.b64decode(s)


def extract_image_and_name(uri: str, fallback_tid: int, *, verbose: bool = False, save_meta_to: Path | None = None) -> Tuple[bytes | None, str]:
    # Extract metadata JSON from data URI
    m = re.search(r"data:application/json;base64,([A-Za-z0-9_\-/+=]+)", uri)
    if not m:
        if verbose:
            sys.stderr.write(f"[tid={fallback_tid}] no data:application/json base64 found; uri head={uri[:80]!r}\n")
        return None, f"beast_{fallback_tid}_not_shiny_not_animated.unknown"

    try:
        meta_json = decode_base64_padded(m.group(1)).decode("utf-8", errors="ignore")
        if verbose:
            sys.stderr.write(
                f"[tid={fallback_tid}] meta_json_len={len(meta_json)} head={meta_json[:80]!r}\n"
            )
        meta = json.loads(meta_json)
    except Exception as e:
        if verbose:
            sys.stderr.write(f"[tid={fallback_tid}] failed to decode/parse metadata JSON: {e}\n")
        return None, f"beast_{fallback_tid}_not_shiny_not_animated.unknown"

    image = meta.get("image", "")
    if verbose:
        sys.stderr.write(
            f"[tid={fallback_tid}] image field head={str(image)[:80]!r}\n"
        )
    # Match any image/* with optional parameters before base64 marker
    am = re.search(r"data:image/([a-zA-Z0-9+\.\-]+);base64,([A-Za-z0-9+/=]+)", image)
    if not am:
        if save_meta_to is not None:
            try:
                (save_meta_to / f"token_{fallback_tid}_meta.json").write_text(meta_json)
            except Exception:
                pass
        if verbose:
            sys.stderr.write(f"[tid={fallback_tid}] no image data URI found in metadata\n")
        return None, f"beast_{fallback_tid}_not_shiny_not_animated.unknown"
    mime_sub = am.group(1).lower()
    img_b64 = am.group(2)

    try:
        img_bytes = decode_base64_padded(img_b64)
    except Exception as e:
        if verbose:
            sys.stderr.write(f"[tid={fallback_tid}] failed to decode image b64: {e}\n")
        return None, f"beast_{fallback_tid}_not_shiny_not_animated.unknown"

    # Infer filename components
    beast_name = f"beast_{fallback_tid}"
    shiny_flag = "not_shiny"
    animated_flag = "not_animated"

    for attr in meta.get("attributes", []) or []:
        t = str(attr.get("trait_type", "")).lower()
        v = str(attr.get("value", ""))
        if t == "beast":
            beast_name = v.lower().replace(" ", "_") or beast_name
        elif t == "shiny":
            shiny_flag = "shiny" if v in ("1", "true", "True") else "not_shiny"
        elif t == "animated":
            animated_flag = "animated" if v in ("1", "true", "True") else "not_animated"

    # Determine extension
    if "svg" in mime_sub:
        ext = ".svg"
    elif "gif" in mime_sub:
        ext = ".gif"
    else:
        ext = ".png" if "png" in mime_sub else f".{mime_sub.split('+')[0]}"

    filename = f"token_{fallback_tid:03d}_{beast_name}_{shiny_flag}_{animated_flag}{ext}"
    return img_bytes, filename


async def call_token_uri(
    starkli: str,
    rpc: str,
    address: str,
    token_id: int,
    *,
    timeout: float,
    retries: int,
    verbose: bool,
    save_meta_to: Path | None,
) -> tuple[int, str | None, bytes | None, str | None]:
    """Call token_uri and return (token_id, filename, svg_bytes, raw_output).
    filename/svg_bytes may be None on failure. raw_output is the stdout text on last attempt.
    """
    last_out: str | None = None
    last_err: str | None = None
    for attempt in range(1, retries + 2):
        if verbose:
            sys.stderr.write(f"[tid={token_id}] attempt {attempt} starting\n")
        try:
            proc = await asyncio.create_subprocess_exec(
                starkli,
                "call",
                "--rpc",
                rpc,
                address,
                "token_uri",
                str(token_id),
                "0",
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.PIPE,
            )
            try:
                out_b, err_b = await asyncio.wait_for(proc.communicate(), timeout=timeout)
                out = out_b.decode(errors="ignore") if out_b is not None else ""
                err = err_b.decode(errors="ignore") if err_b is not None else ""
            except asyncio.TimeoutError:
                with contextlib.suppress(ProcessLookupError):
                    proc.kill()
                await proc.wait()
                last_out, last_err = None, f"timeout after {timeout}s"
                if verbose:
                    sys.stderr.write(f"[tid={token_id}] attempt {attempt} timeout\n")
                continue
            last_out, last_err = out, err
            if proc.returncode != 0:
                if verbose:
                    sys.stderr.write(f"[tid={token_id}] attempt {attempt} nonzero rc {proc.returncode}: {err.strip()}\n")
                continue

            uri = reconstruct_uri_from_limbs(out, verbose=verbose, tid=token_id)
            if verbose:
                sys.stderr.write(f"[tid={token_id}] uri head: {uri[:80]!r}\n")
            img_bytes, filename = extract_image_and_name(
                uri, token_id, verbose=verbose, save_meta_to=save_meta_to
            )
            if not img_bytes:
                if verbose:
                    sys.stderr.write(f"[tid={token_id}] attempt {attempt} no image extracted\n")
                continue
            return token_id, filename, img_bytes, out
        except Exception as e:
            last_err = f"exception: {e}"
            if verbose:
                sys.stderr.write(f"[tid={token_id}] attempt {attempt} exception: {e}\n")
            continue
    if verbose:
        sys.stderr.write(f"[tid={token_id}] failed after {retries+1} attempts. last_err={last_err}\n")
    return token_id, None, None, last_out


import contextlib


async def worker(
    name: int,
    sem: asyncio.Semaphore,
    q: asyncio.Queue,
    starkli: str,
    rpc: str,
    address: str,
    outdir: Path,
    *,
    timeout: float,
    retries: int,
    verbose: bool,
    save_raw_dir: Path | None,
    counters: dict,
):
    while True:
        token_id = await q.get()
        if token_id is None:
            q.task_done()
            return
        if verbose:
            sys.stderr.write(f"[worker {name}] dequeued tid={token_id}\n")
        async with sem:
            tid, fname, data, raw = await call_token_uri(
                starkli, rpc, address, token_id, timeout=timeout, retries=retries, verbose=verbose, save_meta_to=save_raw_dir
            )
        if fname and data:
            path = outdir / fname
            try:
                path.write_bytes(data)
                print(f"wrote {path}")
                counters["ok"] += 1
            except Exception as e:
                sys.stderr.write(f"[tid={tid}] write error: {e}\n")
                counters["fail"] += 1
        else:
            sys.stderr.write(f"[tid={token_id}] no SVG extracted\n")
            counters["fail"] += 1
            if save_raw_dir is not None and raw:
                try:
                    p = save_raw_dir / f"token_{token_id}.json"
                    p.write_text(raw)
                except Exception as e:
                    sys.stderr.write(f"[tid={token_id}] failed to write raw: {e}\n")
        q.task_done()


async def progress_reporter(total: int, counters: dict, interval: float):
    try:
        while counters["done"] < total:
            await asyncio.sleep(interval)
            ok = counters["ok"]
            fail = counters["fail"]
            done = counters["done"]
            inflight = counters["inflight"]
            sys.stderr.write(
                f"[progress] done={done}/{total} ok={ok} fail={fail} inflight≈{inflight}\n"
            )
    except asyncio.CancelledError:
        return


async def main_async(args: argparse.Namespace) -> int:
    if not args.rpc or not args.address:
        sys.stderr.write("--rpc and --address are required (or set RPC_URL/NFT_ADDRESS)\n")
        return 2

    outdir = Path(args.outdir)
    outdir.mkdir(parents=True, exist_ok=True)

    save_raw_dir = None
    if args.save_raw_dir:
        save_raw_dir = Path(args.save_raw_dir)
        save_raw_dir.mkdir(parents=True, exist_ok=True)

    sem = asyncio.Semaphore(max(1, args.concurrency))
    q: asyncio.Queue[int | None] = asyncio.Queue()

    total = max(0, args.end - args.start + 1)
    counters = {"ok": 0, "fail": 0, "done": 0, "inflight": 0}

    # Enqueue token IDs
    for tid in range(args.start, args.end + 1):
        q.put_nowait(tid)
    # Add sentinels for workers to exit
    for _ in range(args.concurrency):
        q.put_nowait(None)

    workers = []
    for i in range(args.concurrency):
        task = asyncio.create_task(
            worker(
                i,
                sem,
                q,
                args.starkli,
                args.rpc,
                args.address,
                outdir,
                timeout=args.timeout,
                retries=args.retries,
                verbose=args.verbose,
                save_raw_dir=save_raw_dir,
                counters=counters,
            )
        )
        workers.append(task)

    progress_task = asyncio.create_task(
        progress_reporter(total=total, counters=counters, interval=args.progress_interval)
    )

    # Track completion based on queue size reductions
    try:
        last_q = q.qsize()
        while counters["done"] < total:
            await asyncio.sleep(0.5)
            # Approximate done count from total - current items left excluding sentinels
            current_q = q.qsize()
            items_left = max(0, current_q - args.concurrency)  # subtract sentinels
            counters["done"] = min(total, total - items_left)
            # Inflight estimate: tokens started but not yet finished
            started = counters["done"] + counters["inflight"]
            counters["inflight"] = max(0, min(args.concurrency, total - counters["done"]))
            last_q = current_q
    finally:
        await q.join()
        for w in workers:
            w.cancel()
        progress_task.cancel()
    return 0


def main() -> int:
    args = parse_args()
    try:
        return asyncio.run(main_async(args))
    except KeyboardInterrupt:
        return 130


if __name__ == "__main__":
    raise SystemExit(main())
