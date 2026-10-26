FROM kirillmouraviev/prism-topomap:cuda12.1-ros-noetic-habitat_v0.2.3
COPY docker-opt/10_nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json

ENV NVIDIA_DRIVER_CAPABILITIES=all
COPY --chown=1000:1000 src/ /opt/ddppo_eval/

USER docker_prism
WORKDIR /home/docker_prism