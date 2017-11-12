#!/bin/sh
docker build . -t capability-builder
docker run --rm -v $(PWD)/.stack-work/dist/linux/bin:/root/.local/bin --name capability-builder capability-builder
