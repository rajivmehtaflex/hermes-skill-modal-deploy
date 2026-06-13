# GPU Pre-Check Issue

## Problem

The original `modal-deploy` skill provided a `check_gpu.py` script that attempted to verify GPU availability before deployment. This script used the pattern:

```bash
modal shell --gpu T4 bash -c "nvidia-smi"
```

## Why It Doesn't Work

**Error:** `Cannot specify container configuration arguments (--gpu) when starting a new container from a function reference.`

Modal's `shell` command does NOT accept configuration arguments like `--gpu`, `--cpu`, or `--memory` when starting from a function reference (like `bash`). This is a fundamental limitation of the Modal CLI.

## Attempted Workarounds

### 1. Temp App Deployment (Failed)

Creating a minimal Modal app with GPU config and running it via `modal run`:

```python
import modal

app = modal.App("gpu-check")
@app.function(gpu="T4")
def check():
    import subprocess
    result = subprocess.run(["nvidia-smi"], capture_output=True)
    return result.stdout
```

**Issues:**
- `modal run` doesn't accept `--yes` flag, requires interactive confirmation
- The temporary app deployment adds complexity
- If GPU is unavailable, the deployment queues for the same duration as your real deployment
- Cleanup requires stopping the temporary app
- Often times out or hangs on the same GPU queues

### 2. Direct Deployment Verification (Recommended)

Skip the pre-check entirely. Deploy directly and check logs:

```bash
# Deploy
.venv/bin/modal deploy modal_app.py

# If it fails, check status
.venv/bin/modal app list

# View logs for GPU allocation errors
.venv/bin/modal app logs <app-name>
```

**Advantages:**
- Simpler workflow
- GPU availability queues are inevitable — pre-check doesn't help
- Deployment error messages are clear and actionable
- T4 and A10 GPUs typically allocate within 1-3 minutes anyway

## Updated Workflow

### Before (Broken)
1. Configure .env
2. Run GPU pre-check (fails with CLI error)
3. Deploy

### After (Recommended)
1. Configure .env
2. Deploy directly
3. If GPU allocation fails, check logs and switch GPU model

## GPU Alternatives

If a GPU model is unavailable, try these in order:

```python
ALTERNATIVES = {
    "B200": ["H100", "H200", "L40S", "A100", "A10", "L4", "T4"],
    "H200": ["H100", "L40S", "A100", "A10", "L4", "T4"],
    "H100": ["L40S", "A100", "A10", "L4", "T4"],
    "L40S": ["A100", "A10", "L4", "T4"],
    "A100": ["A10", "L4", "T4"],
    "A10":  ["L4", "T4"],
    "L4":   ["T4", "A10"],
    "T4":   ["A10", "L4", "A100"],
}
```

## Updated Templates

The `modal-deploy` skill now provides:
- `check_gpu.py` — A no-op placeholder that explains the limitation
- `deploy.sh` — Updated to skip GPU check by default (`--skip-check` is default)
- Updated SKILL.md — Documents the limitation and recommends direct deployment

## Related Modal CLI Commands

```bash
# Check authentication
.venv/bin/modal token info

# List deployed apps
.venv/bin/modal app list

# View app logs
.venv/bin/modal app logs <app-name>

# Stop a stuck app
.venv/bin/modal app stop <app-name> --yes

# Deploy
.venv/bin/modal deploy modal_app.py
```

## Session Reference

**Date:** 2026-06-13
**Context:** User requested T4 GPU deployment with 4 CPU cores and 8GB RAM.
**Discovery:** Attempted to use GPU pre-check script, encountered Modal CLI limitation.
**Resolution:** Deployed directly, T4 GPU allocated successfully within 2 minutes.
**Lesson:** GPU pre-checks are unreliable — deploy directly and check logs instead.