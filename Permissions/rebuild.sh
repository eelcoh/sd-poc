#!/bin/sh
docker build . --no-cache -t permissions-builder
docker run --rm -v $(PWD)/.stack-work/dist/linux/bin:/root/.local/bin --name permissions-builder permissions-builder
