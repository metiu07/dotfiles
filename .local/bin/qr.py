#!/usr/bin/env python3

import subprocess
import sys


def main():
    data = sys.stdin.buffer.read()
    chunk_size = 1500
    chunks = [data[i : i + chunk_size] for i in range(0, len(data), chunk_size)]

    for chunk in chunks:
        # Generate QR code
        qrencode = subprocess.Popen(
            ["qrencode", "-o", "-"], stdin=subprocess.PIPE, stdout=subprocess.PIPE
        )
        qr_output, _ = qrencode.communicate(input=chunk)

        # Display QR code
        wezterm = subprocess.Popen(
            ["wezterm", "imgcat", "--hold"], stdin=subprocess.PIPE
        )
        wezterm.communicate(input=qr_output)


if __name__ == "__main__":
    main()
