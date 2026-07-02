#!/usr/bin/env bash
set -e

echo "🚀 Installing modal-deploy skill..."

DEST=~/.hermes/skills/mlops/modal-deploy
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

# Fetch repository
echo "📥 Downloading..."
if command -v gh &> /dev/null; then
    gh repo clone rajivmehtaflex/hermes-skill-modal-deploy "$TMP_DIR/skill" -- --depth 1
    rm -rf "$TMP_DIR/skill/.git"
else
    echo "⚠️  gh CLI not found, using curl..."
    curl -fsSL https://github.com/rajivmehtaflex/hermes-skill-modal-deploy/archive/refs/heads/main.tar.gz | tar xz -C "$TMP_DIR"
    mv "$TMP_DIR/hermes-skill-modal-deploy-main" "$TMP_DIR/skill"
fi

# Install skill (idempotent — replaces any previous install)
echo "📦 Installing skill..."
mkdir -p "$(dirname "$DEST")"
rm -rf "$DEST"
cp -r "$TMP_DIR/skill" "$DEST"

echo "✅ Skill installed at $DEST"
echo ""
echo "Usage: Launch Hermes Agent and invoke 'load modal-deploy skill'"
