set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/docker-args.sh"

exec docker run -it --name "${NAME:-ddppo-eval}" "${DOCKER_ARGS[@]}" "$IMAGE"
