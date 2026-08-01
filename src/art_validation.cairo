//! Render-time validation of art returned by community art providers.
//!
//! A community species' `IBeastArtProvider` is an arbitrary artist-controlled
//! contract, so `token_uri` cannot trust what it returns. The returned string
//! is embedded verbatim inside a single-quoted `src='...'` attribute of the
//! generated SVG, which means an unvalidated provider could close the
//! attribute and inject markup into every token of its species — including
//! tokens held by people who never dealt with that artist.
//!
//! Requiring an exact media-type prefix from a fixed allowlist plus a strict
//! base64 body makes that impossible: no quote, angle bracket, or whitespace
//! can survive the charset check. Only structure is checked here. Whether the
//! payload decodes to a *good* image is the artist's problem; whether it can
//! break the document is ours.
//!
//! The factory provider (`stored_art_provider`) validates more strictly still
//! — it also verifies PNG/GIF magic bytes at write time — because it carries
//! the trusted "verified art" designation. This module is the weaker floor
//! that every provider, custom ones included, must clear at render time.

/// Media types a community provider may return. SVG is allowed because it is
/// consumed through an `<img>` element, where user agents render it in a
/// restricted mode with scripting disabled.
pub fn media_prefix_len(uri: @ByteArray) -> u32 {
    let candidates: Array<ByteArray> = array![
        "data:image/png;base64,", "data:image/gif;base64,", "data:image/webp;base64,",
        "data:image/svg+xml;base64,",
    ];

    let mut i = 0;
    let mut found: u32 = 0;
    let len = candidates.len();
    while i < len {
        let candidate = candidates.at(i);
        if starts_with(uri, candidate) {
            found = candidate.len();
            break;
        }
        i += 1;
    }
    found
}

/// Panics unless `uri` is an allowlisted image data URI with a structurally
/// valid standard-base64 payload. Deliberately imposes no size cap: if an
/// artist is willing to pay for the storage and the network accepts the
/// transaction, the art is valid.
pub fn assert_valid_render_uri(uri: @ByteArray) {
    let prefix_len = media_prefix_len(uri);
    assert(prefix_len != 0, 'Art: bad media type');

    let total_len = uri.len();
    let payload_len = total_len - prefix_len;
    assert(payload_len >= 4, 'Art: empty payload');
    assert(payload_len % 4 == 0, 'Art: bad payload length');

    // '=' padding may only occupy the final two bytes, and "=X" is never a
    // legal tail.
    let mut i = prefix_len;
    while i < total_len - 2 {
        assert(is_base64_char(uri.at(i).unwrap()), 'Art: bad payload');
        i += 1;
    }

    let second_last = uri.at(total_len - 2).unwrap();
    let last = uri.at(total_len - 1).unwrap();
    assert(is_base64_char(second_last) || second_last == '=', 'Art: bad payload');
    assert(is_base64_char(last) || last == '=', 'Art: bad payload');
    if second_last == '=' {
        assert(last == '=', 'Art: bad payload');
    }
}

fn starts_with(uri: @ByteArray, needle: @ByteArray) -> bool {
    let needle_len = needle.len();
    if uri.len() < needle_len {
        return false;
    }

    let mut i = 0;
    let mut matched = true;
    while i < needle_len {
        if uri.at(i).unwrap() != needle.at(i).unwrap() {
            matched = false;
            break;
        }
        i += 1;
    }
    matched
}

/// Strict base64 alphabet, excluding padding.
pub fn is_base64_char(byte: u8) -> bool {
    (byte >= 'A' && byte <= 'Z')
        || (byte >= 'a' && byte <= 'z')
        || (byte >= '0' && byte <= '9')
        || byte == '+'
        || byte == '/'
}

#[cfg(test)]
mod tests {
    use super::{assert_valid_render_uri, media_prefix_len};

    #[test]
    fn test_accepts_each_allowed_media_type() {
        assert_valid_render_uri(@"data:image/png;base64,iVBORw0KGgo=");
        assert_valid_render_uri(@"data:image/gif;base64,R0lGODlhAQAB");
        assert_valid_render_uri(@"data:image/webp;base64,UklGRhIAAABX");
        assert_valid_render_uri(@"data:image/svg+xml;base64,PHN2Zy8+");
    }

    #[test]
    fn test_media_prefix_len() {
        assert(media_prefix_len(@"data:image/png;base64,AAAA") == 22, 'png prefix len');
        assert(media_prefix_len(@"data:image/svg+xml;base64,AAAA") == 26, 'svg prefix len');
        assert(media_prefix_len(@"data:text/html;base64,AAAA") == 0, 'html not allowed');
    }

    #[test]
    #[should_panic(expected: 'Art: bad media type')]
    fn test_rejects_html_media_type() {
        assert_valid_render_uri(@"data:text/html;base64,PHNjcmlwdD4=");
    }

    #[test]
    #[should_panic(expected: 'Art: bad media type')]
    fn test_rejects_non_base64_data_uri() {
        // URL-encoded SVG carries raw markup; only base64 payloads are safe
        // to interpolate into the single-quoted attribute.
        assert_valid_render_uri(@"data:image/svg+xml,<svg/>");
    }

    #[test]
    #[should_panic(expected: 'Art: bad media type')]
    fn test_rejects_leading_whitespace() {
        assert_valid_render_uri(@" data:image/png;base64,iVBORw0KGgo=");
    }

    #[test]
    #[should_panic(expected: 'Art: bad payload')]
    fn test_rejects_attribute_escape() {
        // The exact attack the validator exists to stop: a quote would close
        // the src='...' attribute. Payload length stays 4-aligned so this
        // exercises the charset check, not the length check.
        assert_valid_render_uri(@"data:image/png;base64,AAAA'AAA");
    }

    #[test]
    #[should_panic(expected: 'Art: bad payload')]
    fn test_rejects_angle_bracket() {
        assert_valid_render_uri(@"data:image/png;base64,AAA<svg>AAAA");
    }

    #[test]
    #[should_panic(expected: 'Art: bad payload length')]
    fn test_rejects_unaligned_payload() {
        assert_valid_render_uri(@"data:image/png;base64,AAAAA");
    }

    #[test]
    #[should_panic(expected: 'Art: empty payload')]
    fn test_rejects_empty_payload() {
        assert_valid_render_uri(@"data:image/png;base64,");
    }

    #[test]
    #[should_panic(expected: 'Art: bad payload')]
    fn test_rejects_interior_padding() {
        assert_valid_render_uri(@"data:image/png;base64,AA=ABBBB");
    }

    #[test]
    #[should_panic(expected: 'Art: bad payload')]
    fn test_rejects_padding_followed_by_char() {
        assert_valid_render_uri(@"data:image/png;base64,AAAAAA=A");
    }
}
