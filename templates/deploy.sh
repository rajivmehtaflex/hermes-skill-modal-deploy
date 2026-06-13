#!/usr/bin/env bash
# Smart deployment script with GPU availability pre-check
# Usage: ./deploy.sh [--skip-check] (skip-check is now default)
#
# NOTE: GPU pre-check is disabled due to Modal CLI limitations.
# Deploy directly and check app logs if GPU allocation fails.

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration — use relative paths for portability
VENV_BIN=".venv/bin"
DEPLOY_CMD="$VENV_BIN/modal deploy modal_app.py"
CHECK_SCRIPT="$VENV_BIN/python check_gpu.py"

# Parse arguments
SKIP_CHECK=true  # Default: skip check
for arg in "$@"; do
    case $arg in
        --skip-check)
            SKIP_CHECK=true
            shift
            ;;
        --check)
            SKIP_CHECK=false
            shift
            ;;
        *)
            echo "Unknown argument: $arg"
            echo "Usage: $0 [--skip-check] [--check]"
            echo "  --skip-check  Skip GPU availability check (default)"
            echo "  --check       Run GPU availability placeholder check"
            exit 1
            ;;
    esac
done

echo "============================================================"
echo "🚀 Smart Deployment with GPU Pre-Check"
echo "============================================================"
echo ""

# Step 1: Check configuration
echo "📋 Step 1: Checking configuration..."
if [ ! -f ".env" ]; then
    echo -e "${RED}❌ .env file not found${NC}"
    exit 1
fi

GPU_MODEL=$(grep "^MODAL_GPU_MODEL=" .env | cut -d'=' -f2 | tr -d '"')
CPU=$(grep "^MODAL_CPU=" .env | cut -d'=' -f2)
MEMORY=$(grep "^MODAL_MEMORY=" .env | cut -d'=' -f2)

echo "   GPU Model: $GPU_MODEL"
echo "   CPU: $CPU cores"
echo "   Memory: $MEMORY MB"
echo ""

# Step 2: GPU check (optional, no-op)
if [ "$SKIP_CHECK" = true ]; then
    echo -e "${YELLOW}⚠️  Skipping GPU availability check (default)${NC}"
    echo "   Deploy directly. If GPU unavailable, check:"
    echo "     .venv/bin/modal app list"
    echo "     .venv/bin/modal app logs <app-name>"
    echo ""
else
    echo "🔍 Step 2: Running GPU availability placeholder..."
    echo ""

    if $CHECK_SCRIPT; then
        echo ""
        echo -e "${GREEN}✅ Check passed (no-op)${NC}"
    else
        echo ""
        echo -e "${RED}❌ Check failed${NC}"
        exit 1
    fi
    echo ""
fi

# Step 3: Deploy
echo "📦 Step 3: Deploying to Modal..."
echo ""

if $DEPLOY_CMD; then
    echo ""
    echo "============================================================"
    echo -e "${GREEN}🎉 Deployment successful!${NC}"
    echo "============================================================"
    echo ""
    echo "Next steps:"
    echo "  1. Check status: modal app list"
    echo "  2. View logs: modal app logs <app-name>"
    echo "  3. Access the app at the URL provided above"
else
    echo ""
    echo "============================================================"
    echo -e "${RED}❌ Deployment failed${NC}"
    echo "============================================================"
    echo ""
    echo "Troubleshooting:"
    echo "  1. Check logs: modal app logs <app-name>"
    echo "  2. Verify .env configuration"
    echo "  3. Try a different GPU model"
    exit 1
fi