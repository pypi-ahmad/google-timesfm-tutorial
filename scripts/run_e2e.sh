#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

if ! command -v uv >/dev/null 2>&1; then
  echo "error: uv not found on PATH. Install uv first: https://github.com/astral-sh/uv" >&2
  exit 1
fi

export UV_CACHE_DIR="${ROOT_DIR}/.uv-cache"
mkdir -p "${UV_CACHE_DIR}"

mkdir -p artifacts

# Headless "Run All" execution. Writes an executed notebook to artifacts/.
uv run jupyter nbconvert \
  --to notebook \
  --execute \
  --ExecutePreprocessor.timeout=7200 \
  --output-dir artifacts \
  --output TimesFM_Zero_to_Mastery.executed.ipynb \
  TimesFM_Zero_to_Mastery.ipynb

echo "ok: executed notebook written to artifacts/TimesFM_Zero_to_Mastery.executed.ipynb"
