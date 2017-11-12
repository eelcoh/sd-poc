#!/bin/sh
docker build . --no-cache -f Shipfile -t permissions && docker tag permissions gcr.io/sd-poc/permissions:0.0.7 && gcloud docker -- push gcr.io/sd-poc/permissions:0.0.7
