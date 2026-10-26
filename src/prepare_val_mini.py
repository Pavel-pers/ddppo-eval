#!/usr/bin/env python3
import collections, glob, gzip, json, os

SRC = "/data/datasets/pointnav/mp3d_toposlam/val_mini"
OUT = "/data/datasets/pointnav/val_mini_prepared"

load = lambda path: json.load(gzip.open(path, "rt"))["episodes"]
scene = lambda e: os.path.basename(e["scene_id"])[:-4]

eps100 = []
for f in sorted(glob.glob(f"{SRC}/val_mini_*.json.gz")):
    for e in load(f):
        e["info"]["orig_id"] = e["episode_id"]
        e["episode_id"] = f"{scene(e)}_{int(e['episode_id']):02d}"
        eps100.append(e)

eps776, cnt = load(f"{SRC}/val_mini.json.gz"), collections.Counter()
for e in eps776:
    e["info"]["orig_id"] = e["episode_id"]
    e["episode_id"] = f"{scene(e)}_{cnt[scene(e)]:03d}"
    cnt[scene(e)] += 1

for name, eps in [("val_mini_100", eps100), ("val_mini_776", eps776)]:
    assert len({(e["scene_id"], e["episode_id"]) for e in eps}) == len(eps), "дубли id"
    assert all(os.path.exists(e["scene_id"]) for e in eps), "нет файла сцены"
    path = f"{OUT}/{name}/{name}.json.gz"
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with gzip.open(path, "wt") as f:
        json.dump({"episodes": eps}, f)
    print(name, len(eps), dict(collections.Counter(scene(e) for e in eps)), "->", path)
