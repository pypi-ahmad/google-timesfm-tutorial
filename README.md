# Google TimesFM: Zero to Mastery

Production-grade, end-to-end tutorial notebook for Google Research's TimesFM (Time Series
Foundation Model): zero-shot forecasting, covariates (XReg), and LoRA fine-tuning, benchmarked
against classical baselines on a real retail dataset.

## What You Get

- A single, fully self-contained notebook: [TimesFM_Zero_to_Mastery.ipynb](./TimesFM_Zero_to_Mastery.ipynb)
- Reproducible environment with `uv`: [pyproject.toml](./pyproject.toml), [uv.lock](./uv.lock)
- A headless "Run All" e2e runner: [scripts/run_e2e.sh](./scripts/run_e2e.sh)

## Requirements

- Linux
- Python `3.13.13` (see [.python-version](./.python-version))
- [`uv`](https://github.com/astral-sh/uv)
- Optional: NVIDIA GPU + CUDA for faster model inference / fine-tuning

Network access is required on first run to download:
- The dataset parquet from AutoGluon S3
- TimesFM checkpoints from Hugging Face / Google

## Quickstart

1. Create / sync the environment:

```bash
uv sync --dev
```

If you are in a restricted environment where `~/.cache` is not writable, set uv's cache directory:

```bash
export UV_CACHE_DIR="$PWD/.uv-cache"
uv sync --dev
```

2. Open the notebook:

```bash
uv run jupyter lab
```

Then open `TimesFM_Zero_to_Mastery.ipynb` and click "Run All".

## Reproducible E2E Run (Headless)

This runs the notebook end-to-end via `nbconvert` (equivalent to Jupyter "Run All") and writes an
executed copy to `artifacts/`.

```bash
./scripts/run_e2e.sh
```

## Local Tests

Fast smoke test (minimal model load + tiny forecast):

```bash
./scripts/test.sh
```

Run the full notebook e2e (slow; downloads + kernel sockets required):

```bash
RUN_E2E=1 ./scripts/test.sh
```

Notes:
- The notebook is written to run on CPU or GPU. GPU is recommended for speed.
- The covariates step uses TimesFM's XReg mechanism and forces JAX onto CPU to avoid VRAM
  contention (`JAX_PLATFORMS=cpu` is set inside the notebook before imports).
- Runtime depends heavily on hardware and first-run downloads.

## Dataset

The notebook uses the AutoGluon time-series retail sales dataset:

- `https://autogluon.s3.amazonaws.com/datasets/timeseries/retail_sales/train.parquet`

It contains weekly series with store-level covariates (e.g., promo flags) and is used to evaluate
forecast quality on a held-out horizon.

## Project Structure

```text
.
├─ TimesFM_Zero_to_Mastery.ipynb
├─ pyproject.toml
├─ uv.lock
└─ scripts/
   └─ run_e2e.sh
```

## License

MIT. See [LICENSE](./LICENSE).

## References

- TimesFM paper (ICML 2024): https://arxiv.org/abs/2310.10688
- Official repo: https://github.com/google-research/timesfm
- Hugging Face model cards:
  - https://huggingface.co/google/timesfm-2.5-200m-pytorch
  - https://huggingface.co/google/timesfm-2.5-200m-transformers
