#!/usr/bin/env bash
set -e

echo "🚀 Installing modal-deploy skill..."

# Create skills directory
mkdir -p ~/.hermes/skills/mlops/

# Clone repository
echo "📥 Cloning repository..."
if command -v gh &> /dev/null; then
    gh repo clone rajivmehtaflex/hermes-skill-modal-deploy /tmp/modal-deploy-install
else
    echo "⚠️  gh CLI not found, using curl..."
    curl -L https://github.com/rajivmehtaflex/hermes-skill-modal-deploy/archive/refs/heads/main.tar.gz | tar xz -C /tmp
    mv /tmp/hermes-skill-modal-deploy-main /tmp/modal-deploy-install
fi

# Install skill
echo "📦 Installing skill..."
cp -r /tmp/modal-deploy-install ~/.hermes/skills/mlops/modal-deploy

# Cleanup
rm -rf /tmp/modal-deploy-install

echo "✅ Skill installed at ~/.hermes/skills/mlops/modal-deploy"
echo ""
echo "Usage: Launch Hermes Agent and invoke 'load modal-deploy skill'"
