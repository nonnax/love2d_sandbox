#!/usr/bin/env bash
# -- Id$ nonnax Wed Jan 10 21:33:31 2024
# -- https://github.com/nonnax
ffmpeg -f x11grab -y -framerate 20 -s 1280x1024 -i :0.0 -c:v libx264 \
  -preset superfast -crf 18 "$(date +'%Y-%m-%d_%H-%M-%S').mp4"
