#!/usr/bin/env bash
# скрипт для простого запуска с указанной моделью и сидом, шелл автоматически запрускает контейнер и запускает там ран евала модели
set -euo pipefail
DATASET=${1:-val_mini_100}
MODEL=${2:-gibson-2plus-resnet50}
SEED=${3:-1}

OUT=/data/ddppo_out/eval/$DATASET/$MODEL/seed$SEED
mkdir -p "$OUT"
export GLOG_minloglevel=2 MAGNUM_LOG=quiet HABITAT_SIM_LOG=quiet # выключил логи от хабитата

python -u -m habitat_baselines.run --run-type eval --exp-config /opt/ddppo_eval/eval.yaml \
  habitat.seed="$SEED" \
  habitat.dataset.data_path=/data/datasets/pointnav/val_mini_prepared/$DATASET/$DATASET.json.gz \
  habitat_baselines.eval_ckpt_path_dir=/data/ddppo-models/converted/$MODEL.pth \
  habitat_baselines.tensorboard_dir="$OUT/tb" \
  habitat_baselines.video_dir="$OUT/video" \
  habitat_baselines.log_file="$OUT/eval.log" \
  2>&1 | tee "$OUT/stdout.log"

grep "Average episode" "$OUT/stdout.log" | tee "$OUT/metrics.txt"
