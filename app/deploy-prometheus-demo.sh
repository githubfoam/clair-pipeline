#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script


echo "===============================deploy Prometheus Grafana ==========================================================="

git clone https://github.com/pratikzdev/promethues-demo.git && cd promethues-demo
kubectl apply -f monitoring-namespace.yaml

kubectl apply -f prometheus-config.yaml

kubectl apply -f prometheus-deployment.yaml
kubectl get deployments --namespace=monitoring

kubectl apply -f prometheus-service.yaml
kubectl get services --namespace=monitoring prometheus -o yaml

minikube service --namespace=monitoring prometheus

kubectl apply -f grafana-deployment.yaml
kubectl apply -f grafana-service.yaml 

minikube service --namespace=monitoring grafana

kubectl apply -f node-exporter-daemonset.yml


# echo "===============================deploy Prometheus Grafana ==========================================================="
# git clone https://github.com/martinsirbe/prometheus-grafana-demo.git && cd prometheus-grafana-demo

# kubectl create namespace monitoring --context=minikube
# kubectl create configmap prometheus-config --from-file=prometheus-config.yaml -nmonitoring --context=minikube
# kubectl apply -f prometheus.yaml -nmonitoring --context=minikube
# kubectl create -f prometheus-node-exporter.yaml -nmonitoring --context=minikube

# minikube service --url --namespace=monitoring prometheus

# kubectl create configmap alertmanager-config --from-file=alertmanager-config.yaml -nmonitoring --context=minikube
# kubectl create -f alertmanager.yaml -nmonitoring --context=minikube

# minikube service --url --namespace=monitoring alertmanager

# kubectl create -f grafana.yaml -nmonitoring --context=minikube
# minikube service --url --namespace=monitoring grafana

# kubectl delete namespace monitoring --context=minikube
# kubectl delete clusterrolebinding prometheus --context=minikube
# kubectl delete clusterrole prometheus --context=minikube

