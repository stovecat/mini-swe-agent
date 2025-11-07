BASE_DIR="/mnt/sda/hojae/mini-swe-agent"

EXP_DATE=$(date '+%Y%m%d_%H%M%S')

MODEL_NAME="qwen2.5-coder-32b-inst" # "qwen3-30b-a3b"  #"gpt-oss-120b"

mkdir -p ${BASE_DIR}/logs
mkdir -p ${BASE_DIR}/results
mkdir -p ${BASE_DIR}/results/${MODEL_NAME}_${EXP_DATE}

bash ${BASE_DIR}/scripts/cleanup.sh

mini-extra swebench \
	--config ${BASE_DIR}/src/minisweagent/config/extra/vllm_${MODEL_NAME}_swebench.yaml \
	--subset verified \
	--split test \
	--output ${BASE_DIR}/results/${MODEL_NAME}_${EXP_DATE} \
	--workers 32 


sb-cli submit swe-bench_verified test \
	--predictions_path ${BASE_DIR}/results/${MODEL_NAME}_${EXP_DATE}/preds.json \
	--run_id ${MODEL_NAME}_${EXP_DATE}

# Run 2 times due to time out
sb-cli submit swe-bench_verified test \
	--predictions_path ${BASE_DIR}/results/${MODEL_NAME}_${EXP_DATE}/preds.json \
	--run_id ${MODEL_NAME}_${EXP_DATE}
