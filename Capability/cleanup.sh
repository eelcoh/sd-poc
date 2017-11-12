#!/bin/sh

kubectl delete service service-discovery
kubectl delete service permissions
kubectl delete service capability
kubectl delete service environment

kubectl delete deployment service-discovery
kubectl delete deployment permissions
kubectl delete deployment capability
kubectl delete deployment environment

gcloud container clusters delete sd-cluster
