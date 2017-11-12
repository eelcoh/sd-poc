#!/bin/sh
docker build . -t environment-builder
docker run --rm -v $(PWD)/.stack-work/dist/linux/bin:/root/.local/bin --name environment-builder environment-builder
