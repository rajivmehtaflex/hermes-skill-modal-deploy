import modal
import os
import sys
from dotenv import load_dotenv

load_dotenv()

app = modal.App("your-app-name")  # <-- Change this

# Optimized image with mount filtering
image = (
    modal.Image.debian_slim()
    .apt_install("curl")
    .pip_install("fastapi", "uvicorn", "python-dotenv")
    .add_local_dir(
        ".",
        remote_path="/root",
        ignore=[
            ".git",
            ".venv",
            "__pycache__",
            "*.pyc",
            "*.pyo",
            "docs/",
            "*.md",
            "uv.lock",
            ".env",
        ]
    )
)

# Parse resource configuration from .env
cpu = float(os.getenv("MODAL_CPU", "2.0"))
memory = int(os.getenv("MODAL_MEMORY", "4096"))
gpu_count = int(os.getenv("MODAL_GPU_COUNT", "0"))
gpu_model = os.getenv("MODAL_GPU_MODEL", "").strip().strip('"')
timeout = int(os.getenv("MODAL_TIMEOUT", "10800"))

# Build GPU config string
gpu_config = None
if gpu_count > 0:
    if gpu_model:
        gpu_config = f"{gpu_model}:{gpu_count}"
    else:
        gpu_config = str(gpu_count)

@app.function(
    image=image,
    cpu=cpu,
    memory=memory,
    gpu=gpu_config,
    scaledown_window=300,
    timeout=timeout
)
@modal.asgi_app()
def fastapi_app():
    sys.path.append("/root")
    os.chdir("/root")
    from main import app as fastapi_instance
    return fastapi_instance
