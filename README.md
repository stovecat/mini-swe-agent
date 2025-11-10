# mini-swe-agent

A minimal fork of [SWE-agent/mini-swe-agent](https://github.com/SWE-agent/mini-swe-agent), customized for local evaluation with **vLLM**.

---

## 🚀 Quick Setup

### 1. Install Miniforge

Miniforge is a lightweight Conda installer.

```bash
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh
```

> See the [official Miniforge repo](https://github.com/conda-forge/miniforge) for more details.

---


### 2. Clone Repository

```bash
git clone https://github.com/stovecat/mini-swe-agent.git
cd mini-swe-agent
```

---

### 3. Create Conda Environment

```bash
# modify `prefix` accordingly to reflect your working directory.
vi environment.yml
conda env create -f environment.yml
conda activate swe
```

---

### 4. SWE-bench CLI Setup

Install and configure the SWE-bench CLI:

```bash
pip install sb-cli
sb-cli gen-api-key your.email@example.com
```

Then export your API key and verify it:

```bash
export SWEBENCH_API_KEY=your_api_key
sb-cli verify-api-key YOUR_VERIFICATION_CODE
```

> See [SWE-bench CLI docs](https://www.swebench.com/sb-cli/) for reference.

---

### 5. Configure Environment Variables

Edit your `~/.bashrc` (or `~/.zshrc`) and add:

```bash
export HF_HOME=[YOUR_CACHE_PATH]/.cache/huggingface
export SWEBENCH_API_KEY=[YOUR_SWE_API_KEY]
```

```bash
source ~/.bashrc
conda activate swe
```

---

### 6. Launch vLLM

Run the model initialization script (modify variables as needed):

```bash
vi scripts/init_run_vllm_model.sh
```

**Required environment variables to modify:**

* `cuda device`
* `max-model-len`
* `tensor-parallel-size`
* `port number`
* `MODEL_NAME` (your vLLM service name)
* `HF_MODEL_NAME` (full Hugging Face model name, including org prefix)

> The working directory should be set so that `HF_HOME` in the docker is visible,
> e.g., if `HF_HOME=/mnt/sda/hojae/.cache/huggingface` in local, 
> `... -v /mnt/sda/hojae:/workspace \
> -e HF_HOME=/workspace/.cache/huggingface ...`

> If you are using OpenAI models like gpt-oss-120b, ensure that `tiktoken_cache` is stored under `.cache`.

```bash
bash scripts/init_run_vllm_model.sh
```

When the model loads successfully, **stop it** and create your run script (e.g. based on `scripts/run_vllm_gpt-oss-120b.sh`).

> ⚠️ Important:
> Use `HF_HUB_OFFLINE=1` (local mode) to ensure greedy decoding and temperature settings apply correctly.

> Your `MODEL_NAME` must have a corresponding entry in
> `src/minisweagent/config/model_prices_and_context_window.json`.

```bash
cp scripts/run_vllm_gpt-oss-120b.sh scripts/run_vllm_[MODEL_NAME].sh
vi scripts/run_vllm_[MODEL_NAME].sh
bash scripts/run_vllm_[MODEL_NAME].sh
```

---

### 7. Prepare Model YAML

Use `src/minisweagent/config/extra/vllm_gpt-oss-120b_swebench.yaml` as a template.

Set:

```yaml
model_name: [MODEL_NAME]
litellm_model_registry: [ABSOLUTE_PATH_TO `model_prices_and_context_window.json`]
port: [SAME_PORT_NUMBER_AS_IN_vLLM_LAUNCH_SCRIPT]
```

---

### 8. Run Evaluation

Edit and execute the evaluation script:

```bash
# Modify BASE_DIR and MODEL_NAME
vi scripts/eval_vllm_swebench.sh
bash scripts/eval_vllm_swebench.sh
```

---

## 🧩 Notes

* `MODEL_NAME` must match across:

  * vLLM launch script
  * YAML configuration
  * Evaluation script
  * `model_prices_and_context_window.json`

---

## 📚 References

* [SWE-bench](https://www.swebench.com)
* [SWE-agent GitHub](https://github.com/SWE-agent/mini-swe-agent)
* [vLLM Documentation](https://vllm.ai)