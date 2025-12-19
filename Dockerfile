FROM ghcr.io/saladtechnologies/comfyui-api:comfy0.3.76-api1.15.0-torch2.8.0-cuda12.8-runtime

# 防止 apt 交互
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /opt/ComfyUI

# 确保模型目录存在
RUN mkdir -p \
    /opt/ComfyUI/models/text_encoders \
    /opt/ComfyUI/models/vae \
    /opt/ComfyUI/models/unet \
    /opt/ComfyUI/models/loras

# 下载 Wan 相关模型（build 阶段只跑一次）
RUN wget -O /opt/ComfyUI/models/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors \
      https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors && \
    wget -O /opt/ComfyUI/models/vae/wan_2.1_vae.safetensors \
      https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors && \
    wget -O /opt/ComfyUI/models/unet/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors \
      https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors && \
    wget -O /opt/ComfyUI/models/unet/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors \
      https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors && \
    wget -O /opt/ComfyUI/models/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors \
      https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors && \
    wget -O /opt/ComfyUI/models/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors \
      https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors

# ⚠️ 不要改 CMD
# 保持官方行为：启动 comfyui-api（它会拉起 ComfyUI）
CMD ["./comfyui-api"]
