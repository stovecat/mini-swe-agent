docker stop qwen3-30b-a3b-vllm && docker rm qwen3-30b-a3b-vllm

#SNAP=$(ls -1t /mnt/sda/hojae/.cache/huggingface/hub/models--openai--gpt-oss-120b/snapshots | head -n1)

docker run -it --gpus '"device=2,3"' --ipc=host --name qwen3-30b-a3b-vllm \
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
  --model '/workspace/.cache/huggingface/hub/models--Qwen--Qwen3-30B-A3B-Instruct-2507/snapshots/0d7cf23991f47feeb3a57ecb4c9cee8ea4a17bfe' \
  --tensor-parallel-size 2 \
  --gpu-memory-utilization 0.90 \
  --max-model-len 131072 \
  --seed 0 \
  --served-model-name qwen3-30b-a3b \
  --generation-config vllm \
  --override-generation-config '{"temperature": 0.0, "top_p": 1, "top_k": 1, "repetition_penalty": 1.0}'


#  --model Qwen/Qwen3-30B-A3B-Instruct-2507 \
