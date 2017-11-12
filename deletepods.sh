#!/bin/sh
kubectl delete deployment service-discovery
kubectl delete service service-discovery

kubectl delete deployment permissions
kubectl delete service permissions

kubectl delete deployment environment
kubectl delete service environment

kubectl delete deployment capability
kubectl delete service capability
