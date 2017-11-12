#!/bin/sh
docker build . --no-cache -f Shipfile -t capability && docker tag capability gcr.io/sd-poc/capability:0.0.5 && gcloud docker -- push gcr.io/sd-poc/capability:0.0.5
