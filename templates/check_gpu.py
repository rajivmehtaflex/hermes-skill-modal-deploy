#!/usr/bin/env python3
"""
GPU availability placeholder.
Reliable GPU pre-checks are not feasible due to Modal CLI limitations.
Use ./deploy.sh --skip-check and check deployment logs instead.
"""

import os
import sys
from dotenv import load_dotenv

load_dotenv()


def suggest_alternatives(failed_gpu: str) -> list[str]:
    """Suggest alternative GPU models ordered by availability."""
    alternatives = {
        "B200": ["H100", "H200", "L40S", "A100", "A10", "L4", "T4"],
        "H200": ["H100", "L40S", "A100", "A10", "L4", "T4"],
        "H100": ["L40S", "A100", "A10", "L4", "T4"],
        "L40S": ["A100", "A10", "L4", "T4"],
        "A100": ["A10", "L4", "T4"],
        "A10":  ["L4", "T4"],
        "L4":   ["T4", "A10"],
        "T4":   ["A10", "L4", "A100"],
    }
    return alternatives.get(failed_gpu, ["T4", "A10", "L4"])


if __name__ == "__main__":
    gpu_model = os.getenv("MODAL_GPU_MODEL", "T4").strip('"')

    print("=" * 60)
    print("🚀 Modal GPU Availability Checker (NO-OP)")
    print("=" * 60)
    print()
    print("⚠️  GPU pre-check is disabled due to Modal CLI limitations.")
    print()
    print("   The 'modal shell --gpu' pattern used in earlier versions")
    print("   is not supported and errors with:")
    print("   'Cannot specify container configuration arguments'")
    print()
    print("   Alternative approaches (temp app deployment) add")
    print("   complexity and often timeout on the same queues that")
    print("   would affect your real deployment.")
    print()
    print(f"📋 Configured GPU: {gpu_model}")
    print()
    print("💡 Recommended workflow:")
    print("   1. Use ./deploy.sh --skip-check")
    print("   2. If GPU unavailable, deployment will fail with clear error")
    print("   3. Check status: .venv/bin/modal app list")
    print("   4. View logs: .venv/bin/modal app logs <app-name>")
    print()
    print(f"💡 {gpu_model} alternatives if allocation fails:")
    for i, alt in enumerate(suggest_alternatives(gpu_model)[:3], 1):
        print(f"   {i}. {alt} GPU")
    print()
    print("✅ Skipping pre-check. Proceeding with deployment...")
    sys.exit(0)