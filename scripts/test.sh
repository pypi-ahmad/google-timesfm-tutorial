#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

./scripts/smoke_test.sh

if [[ "${RUN_E2E:-0}" == "1" ]]; then
  ./scripts/run_e2e.sh
else
  echo "note: skipping e2e notebook execution (set RUN_E2E=1 to enable)"
fi

