#!/usr/bin/env python3
# Веса 2020 года не подходили под 2.3 хабибат, поэтому пришлось их конвертировать, добавляя скользящую нормализацию
import inspect, os, sys, torch

src, dst = sys.argv[1], sys.argv[2]
kw = {"weights_only": False} if "weights_only" in inspect.signature(torch.load).parameters else {}
sd = torch.load(src, map_location="cpu", **kw)["state_dict"]

P = "actor_critic.net.visual_encoder."
C = sd[P + "backbone.conv1.0.weight"].shape[1]
sd.setdefault(P + "running_mean_and_var._mean", torch.zeros(1, C, 1, 1))
sd.setdefault(P + "running_mean_and_var._var", torch.ones(1, C, 1, 1))
sd.setdefault(P + "running_mean_and_var._count", torch.zeros(()))

os.makedirs(os.path.dirname(dst), exist_ok=True)
torch.save({"state_dict": sd, "extra_state": {"step": 0}, "config": None}, dst)
print(dst, "| ch:", C, "| keys:", len(sd))
