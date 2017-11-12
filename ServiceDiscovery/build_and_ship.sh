#!/bin/sh
docker build . -t service-discovery
docker tag service-discovery gcr.io/sd-poc/service-discovery:0.0.4
gcloud docker -- push gcr.io/sd-poc/service-discovery:0.0.4
