#!/usr/bin/env python3
"""Create a local development environment on Windows, macOS, or Linux."""
import os
from pathlib import Path
import subprocess
import sys
import venv


def main():
    if sys.version_info < (3, 9):
        print("Python 3.9 or newer is required.", file=sys.stderr)
        return 1
    root = Path(__file__).resolve().parent
    target = root / ".venv"
    python = target / ("Scripts/python.exe" if os.name == "nt" else "bin/python")
    if not target.exists():
        venv.EnvBuilder(with_pip=True).create(target)
    elif not python.is_file():
        print("Existing .venv is incomplete; move it aside and retry.", file=sys.stderr)
        return 1
    try:
        subprocess.run([str(python), "-m", "pip", "install", "-r",
                        str(root / "requirements.txt")], check=True)
        subprocess.run([str(python), "-m", "pip", "check"], check=True)
    except subprocess.CalledProcessError as exc:
        return exc.returncode
    print("Environment ready: " + str(python))
    return 0


if __name__ == "__main__":
    sys.exit(main())
