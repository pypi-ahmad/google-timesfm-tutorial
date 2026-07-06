#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

export UV_CACHE_DIR="${ROOT_DIR}/.uv-cache"
mkdir -p "${UV_CACHE_DIR}"

# Force JAX onto CPU if it's present (TimesFM xreg extra pulls it in). This avoids noisy GPU probing.
export JAX_PLATFORMS=cpu

uv run python - <<'PY'
import numpy as np
import timesfm

HORIZON = 8

model = timesfm.TimesFM_2p5_200M_torch.from_pretrained("google/timesfm-2.5-200m-pytorch")
model.compile(
    timesfm.ForecastConfig(
        max_context=64,
        max_horizon=128,
        normalize_inputs=True,
        use_continuous_quantile_head=True,
        force_flip_invariance=True,
        infer_is_positive=True,
        fix_quantile_crossing=True,
    )
)

# Two tiny synthetic series (lengths must be >= horizon and within compiled max_context).
inputs = [
    np.sin(np.linspace(0, 3.0, 64)).astype(np.float32),
    np.cos(np.linspace(0, 5.0, 64)).astype(np.float32),
]

point, quant = model.forecast(horizon=HORIZON, inputs=inputs)

assert tuple(point.shape) == (2, HORIZON), point.shape
assert quant.shape[0] == 2 and quant.shape[1] == HORIZON, quant.shape

print("ok: timesfm forecast smoke test passed")
PY

