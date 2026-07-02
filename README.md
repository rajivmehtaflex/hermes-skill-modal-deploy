# Hermes Agent Skill: Modal Deploy

Deploy GPU-enabled applications to Modal cloud with intelligent configuration and best practices.

## Quick Install

### Option 1: Using gh CLI (Recommended)

```bash
# Clone repository
gh repo clone rajivmehtaflex/hermes-skill-modal-deploy

# Install skill into Hermes Agent (idempotent; excludes .git)
mkdir -p ~/.hermes/skills/mlops/
rm -rf ~/.hermes/skills/mlops/modal-deploy
cp -r hermes-skill-modal-deploy ~/.hermes/skills/mlops/modal-deploy
rm -rf ~/.hermes/skills/mlops/modal-deploy/.git

# Verify installation
hermes skills list | grep modal-deploy
```

### Option 2: One-Line Install

```bash
curl -fsSL https://raw.githubusercontent.com/rajivmehtaflex/hermes-skill-modal-deploy/main/install.sh | bash
```

### Option 3: Using curl (without gh CLI)

```bash
# Download and install (idempotent)
curl -fsSL https://github.com/rajivmehtaflex/hermes-skill-modal-deploy/archive/refs/heads/main.tar.gz | tar xz
mkdir -p ~/.hermes/skills/mlops/
rm -rf ~/.hermes/skills/mlops/modal-deploy
mv hermes-skill-modal-deploy-main ~/.hermes/skills/mlops/modal-deploy
```

## Usage

Invoke skill in Hermes Agent:
```
load modal-deploy skill
```

## Resources

- **GPU Options**: T4, L4, A10, L40S, A100, H100, H200, B200
- **Pricing**: $0.59/h (T4) to $6.25/h (B200)
- **GPU Pre-Check**: Timeout-bounded allocation test (`templates/check_gpu.py`) for scarce GPUs
- **Templates**: `modal_app.py`, `main.py` (PTY-WebSocket bridge), `static/index.html` (xterm.js), `deploy.sh`, `check_gpu.py`, `.env.example`
- **Best Practices**: Mount filtering, WebSocket PTY bridge

## License

MIT
