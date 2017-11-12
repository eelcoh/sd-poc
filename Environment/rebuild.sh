#!/bin/sh
docker build . -f RebuildClean -t environment-builder
docker run --rm -v $(PWD)/.stack-work/dist/linux/bin:/root/.local/bin --name environment-builder environment-builder
