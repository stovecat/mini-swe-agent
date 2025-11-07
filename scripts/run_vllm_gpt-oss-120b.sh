docker stop gpt-oss-120b-vllm && docker rm gpt-oss-120b-vllm

#SNAP=$(ls -1t /mnt/sda/hojae/.cache/huggingface/hub/models--openai--gpt-oss-120b/snapshots | head -n1)

docker run -it --gpus '"device=2,3"' --ipc=host --name gpt-oss-120b-vllm \
  -v /mnt/sda/hojae:/workspace \
  -e HF_HOME=/workspace/.cache/huggingface \
  -e HF_HUB_DISABLE_XET=1 \
  -e VLLM_LOG_REQUESTS=1 \
  -e TIKTOKEN_RS_CACHE_DIR=/workspace/.cache/tiktoken_cache \
  -e TIKTOKEN_ENCODINGS_BASE=/workspace/.cache/tiktoken_cache \
  -e HF_HUB_OFFLINE=1 \
  -p 8394:8394 \
  vllm/vllm-openai:v0.10.2 \
  --host 0.0.0.0 \
  --port 8394 \
  --model '/workspace/.cache/huggingface/hub/models--openai--gpt-oss-120b/snapshots/b5c939de8f754692c1647ca79fbf85e8c1e70f8a' \
  --download-dir /workspace/models \
  --tensor-parallel-size 2 \
  --gpu-memory-utilization 0.90 \
  --max-model-len 65536 \
  --seed 0 \
  --served-model-name gpt-oss-120b \
  --generation-config vllm \
  --override-generation-config '{"temperature": 0.0, "top_p": 1, "top_k": 1, "repetition_penalty": 1.0}'


#  --async-scheduling \
