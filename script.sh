#!/usr/bin/env bash
# Compatibility entry point; setup_env.py also works without Bash on Windows.
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if command -v python3 >/dev/null 2>&1; then
    exec python3 "$script_dir/setup_env.py" "$@"
fi
exec python "$script_dir/setup_env.py" "$@"
