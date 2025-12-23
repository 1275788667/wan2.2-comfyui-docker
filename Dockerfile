FROM nvidia/cuda:13.1.0-devel-ubuntu24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

# ===== 安装系统依赖 =====
RUN apt-get update && apt-get install -y \
    python3 \
    python3-venv \
    python3-pip \
    git \
    wget \
    curl \
    ffmpeg \
    libgl1 \
    libglib2.0-0 \
    ca-certificates \
    build-essential \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# ===== 设置工作目录 =====
WORKDIR /comfy

# ===== 克隆 ComfyUI =====
RUN git clone https://github.com/comfyanonymous/ComfyUI.git

WORKDIR /comfy/ComfyUI

# ===== 使用 venv 安装 Python 依赖 =====
RUN python3 -m venv venv && \
    venv/bin/pip install --upgrade pip setuptools wheel && \
    venv/bin/pip install torch==2.3.0+cu131 torchvision==0.18.1+cu131 torchaudio==2.3.0+cu131 \
        --index-url https://download.pytorch.org/whl/cu131 && \
    venv/bin/pip install -r requirements.txt

# ===== 复制 entrypoint.sh =====
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# ===== 暴露 ComfyUI 端口 =====
EXPOSE 8188

# ===== 交给 entrypoint 启动 =====
ENTRYPOINT ["/entrypoint.sh"]
