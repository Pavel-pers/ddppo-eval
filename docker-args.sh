IMAGE="${IMAGE:-ddppo-eval:v1}"
DATA_DIR="${DATA_DIR:-$HOME/TopoSLAM/prism_topomap_semantic_docker/data}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DOCKER_ARGS=(
  --rm
  --gpus all
  -e NVIDIA_DRIVER_CAPABILITIES=all
  --shm-size=16g
  --net=host
  --entrypoint bash
  -v "$DATA_DIR:/data"
)
if [[ "${MOUNT_SRC:-1}" == "1" ]]; then
  DOCKER_ARGS+=(-v "$REPO_DIR/src:/opt/ddppo_eval")
fi