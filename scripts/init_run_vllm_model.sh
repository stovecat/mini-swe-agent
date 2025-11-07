MODEL_NAME="gpt-oss-120b"
HF_MODEL_NAME="openai/gpt-oss-120b"

docker stop ${MODEL_NAME}-vllm && docker rm ${MODEL_NAME}-vllm

docker run -it --gpus '"device=2,3"' --ipc=host --name ${MODEL_NAME}-vllm \
  -v /mnt/sda/hojae:/workspace \
  -e HF_HOME=/workspace/.cache/huggingface \
  -e HF_HUB_DISABLE_XET=1 \
  -e VLLM_LOG_REQUESTS=1 \
  -e TIKTOKEN_RS_CACHE_DIR=/workspace/.cache/tiktoken_cache \
  -e TIKTOKEN_ENCODINGS_BASE=/workspace/.cache/tiktoken_cache \
  -e HF_HUB_OFFLINE=0 \
  -p 8394:8394 \
  vllm/vllm-openai:v0.10.2 \
  --host 0.0.0.0 \
  --port 8394 \
  --model ${HF_MODEL_NAME} \
  --tensor-parallel-size 2 \
  --gpu-memory-utilization 0.90 \
  --max-model-len 65536 \
  --seed 0 \
  --served-model-name ${MODEL_NAME} \
  --generation-config vllm \
  --override-generation-config '{"temperature": 0.0, "top_p": 1, "top_k": 1, "repetition_penalty": 1.0}'
