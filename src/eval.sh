#!/usr/bin/env bash
# скрипт для простого запуска с указанной моделью и сидом, шелл автоматически запрускает контейнер и запускает там ран евала модели
# Добавлен хук видео через eval with csv
set -euo pipefail
DATASET=${1:-val_mini_100}
MODEL=${2:-gibson-2plus-resnet50}
SEED=${3:-1}

OUT=/data/ddppo_out/eval/$DATASET/$MODEL/seed$SEED
mkdir -p "$OUT"
rm -f "$OUT/episodes.csv" # чищу логи
export GLOG_minloglevel=2 MAGNUM_LOG=quiet HABITAT_SIM_LOG=quiet # выключил логи от хабитата
export EPISODE_CSV=$OUT/episodes.csv SAVE_VIDEO=${SAVE_VIDEO:-0}

# добавил распаралеливание, больше 5 не получается
python -u /opt/ddppo_eval/eval_with_csv.py --run-type eval --exp-config /opt/ddppo_eval/eval.yaml \
  habitat.seed="$SEED" \
  habitat.dataset.data_path=/data/datasets/pointnav/val_mini_prepared/$DATASET/$DATASET.json.gz \
  habitat_baselines.eval_ckpt_path_dir=/data/ddppo-models/converted/$MODEL.pth \
  "habitat_baselines.eval.video_option=[disk]" \
  habitat_baselines.tensorboard_dir="$OUT/tb" \
  habitat_baselines.video_dir="$OUT/video" \
  habitat_baselines.log_file="$OUT/eval.log" \
  2>&1 | tee "$OUT/stdout.log"

grep "Average episode" "$OUT/stdout.log" | tee "$OUT/metrics.txt"

