docker stop qwen2.5-coder-32b-inst-vllm && docker rm qwen2.5-coder-32b-inst-vllm

#SNAP=$(ls -1t /mnt/sda/hojae/.cache/huggingface/hub/models--openai--gpt-oss-120b/snapshots | head -n1)

docker run -it --gpus '"device=2,3"' --ipc=host --name qwen2.5-coder-32b-inst-vllm \
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
  --tensor-parallel-size 2 \
  --model '/workspace/.cache/huggingface/hub/models--Qwen--Qwen2.5-Coder-32B-Instruct/snapshots/381fc969f78efac66bc87ff7ddeadb7e73c218a7' \
  --gpu-memory-utilization 0.90 \
  --max-model-len 32768 \
  --seed 0 \
  --served-model-name qwen2.5-coder-32b-inst \
  --generation-config vllm \
  --override-generation-config '{"temperature": 0.0, "top_p": 1, "top_k": 1, "repetition_penalty": 1.0}'


#  --model Qwen/Qwen2.5-Coder-32B-Instruct \
