#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${NAMESPACE:-openedx}"

echo "==> Cluster nodes"
kubectl get nodes -o wide

echo "==> Namespaces"
kubectl get ns | grep -E "openedx|ingress-nginx|kube-system" || true

echo "==> Pods"
kubectl -n "$NAMESPACE" get pods -o wide

echo "==> Services"
kubectl -n "$NAMESPACE" get svc

echo "==> Ingress"
kubectl -n "$NAMESPACE" get ing

echo "==> HPA"
kubectl -n "$NAMESPACE" get hpa || true

echo "==> Nginx Ingress pods"
kubectl -n ingress-nginx get pods -o wide

echo "==> Secret check"
kubectl -n "$NAMESPACE" get secret openedx-external-services >/dev/null && echo "External services secret OK"
