#!/usr/bin/env bash

docker build \
    -f Docker/ubuntu-16.04/Dockerfile \
    .

# -t build \              # tag the image as "build"