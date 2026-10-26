set -euo pipefail
if (( $# == 0 )); then
  echo "usage: $0 'comm'" >&2
  exit 2
fi
source "$(dirname "${BASH_SOURCE[0]}")/docker-args.sh"

tty=()
[[ -t 0 && -t 1 ]] && tty=(-t)

exec docker run -i "${tty[@]}" "${DOCKER_ARGS[@]}" "$IMAGE" -c "$*"
