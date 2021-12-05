#!/usr/bin/env python3
# -*- mode: python; coding: utf-8; fill-column: 80; -*-
"""Extract words from HTML-formatted dictionary files.
"""

import io
import re
import sys


# Minimum word length (in characters).
DEF_MIN_WLEN = 3

# Pattern to extract words enclosed in bold (`<b>...</b>`) tag.
WORD_REGEX = re.compile('^<p><b>(.*?)</b>')


def skip_until_body(lines):
    """Skip until the `<body>` tag is encountered."""
    for line in lines:
        if line == '<body>':
            break
    return lines

def extract_words(lines, min_wlen=DEF_MIN_WLEN):
    """Extract first word enclosed within bold tag '<p><b>...</b>'."""
    matches = (WORD_REGEX.match(line) for line in lines)
    words = (m.group(1) for m in matches if m)
    valid_words = (w for w in words if len(w) >= min_wlen)
    return valid_words

def parse_file(html_file):
    """Parse HTML-format dictionary and extract the words."""
    lines = (line.strip().lower() for line in html_file)
    lines = skip_until_body(lines)
    return extract_words(lines)

def main(in_file):
    with io.open(in_file, 'r', encoding='iso-8859-1') as f:
        for word in parse_file(f):
            print(word)

def show_help(prog, out):
    """Show help message."""
    out.write(f"Usage: {prog} <html-dict>\n")

if __name__ == '__main__':
    args = sys.argv

    if len(args) != 2:
        show_help(sys.argv[0], sys.stderr)
        sys.exit(1)

    main(args[1])
