#!/usr/bin/env python3
# надстройка поверх habitat run для просмотра каждого эпизода, написал для этого хук

import csv, os
import habitat_baselines.rl.ppo.ppo_trainer as T
from habitat_baselines.run import main

CSV, SAVE_VIDEO = os.environ["EPISODE_CSV"], os.environ.get("SAVE_VIDEO") == "1"
orig_generate_video = T.generate_video


def generate_video_hook(**kw):
    row = {"episode_id": kw["episode_id"], "num_steps": len(kw["images"]), **kw["metrics"]}
    new = not os.path.exists(CSV)
    with open(CSV, "a", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(row))
        if new:
            w.writeheader()
        w.writerow(row)
    if SAVE_VIDEO:
        orig_generate_video(**kw)


T.generate_video = generate_video_hook
main()
