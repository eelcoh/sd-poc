#!/bin/sh
docker build . --no-cache -f Shipfile -t environment && docker tag environment gcr.io/sd-poc/environment:0.0.3 && gcloud docker -- push gcr.io/sd-poc/environment:0.0.3
