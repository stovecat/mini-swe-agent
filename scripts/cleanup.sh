#docker stop ollama_hojae
#docker start ollama_hojae
set -euo pipefail

# minisweagent-뒤에 hex가 붙은 이름만 매칭
pattern='^minisweagent-[0-9a-f]+$'

# 실행 중인 컨테이너 중에서 이름만 추출 → 패턴 매칭
mapfile -t targets < <(docker ps --format '{{.Names}}' | grep -E "$pattern" || true)

if ((${#targets[@]} == 0)); then
	echo "No running minisweagent-* containers."
else
	echo "Stopping containers:"
	printf '  - %s\n' "${targets[@]}"

	# 이름으로 정지 (이름으로도 stop 가능)
	printf '%s\0' "${targets[@]}" | xargs -0 -r docker stop
fi


mapfile -t targets < <(docker container ls -a --format '{{.Names}}' | grep -E "$pattern" || true)

if ((${#targets[@]} == 0)); then
	  echo "No minisweagent-* containers found (including stopped)."
	    exit 0
fi

echo "Removing containers:"
printf '  - %s\n' "${targets[@]}"

# 컨테이너 강제 제거(실행 중이면 stop 후 제거)
printf '%s\0' "${targets[@]}" | xargs -0 -r docker rm -f

echo "Done."


