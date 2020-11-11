#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script

# https://github.com/quay/clair
echo "=============================scan images w clair============================================================="
minikube status
kubectl cluster-info
kubectl get pods --all-namespaces
kubectl get pods -n default
kubectl get pod -o wide #The IP column will contain the internal cluster IP address for each pod.
kubectl get service --all-namespaces # find a Service IP,list all services in all namespaces

git clone https://github.com/Chathuru/clair-scanner.git
helm install clair
sleep 1200 #20 mins

# set up a 3rd party Clair scanner client
wget https://github.com/arminc/clair-scanner/releases/download/v12/clair-scanner_linux_amd64
mv clair-scanner_linux_amd64 clair-scanner
chmod +x clair-scanner

# Find the Clair node port assign by the k8s cluster
kubectl get service

# Scan docker images
./clair-scanner -h
# ./clair-scanner --ip <IP_OF_THE_CLIENT_NODE> -c "http://<K8S_CLUSTER_IP>:<NODE_PORT>" <DOCKER_IMAGE_NAME>
# ./clair-scanner --ip 192.168.118.13 -c "http://192.168.118.18:32159" centos:7



echo "============================status check=============================================================="
minikube status
kubectl cluster-info
kubectl get pods --all-namespaces
kubectl get pods -n default
kubectl get pod -o wide #The IP column will contain the internal cluster IP address for each pod.
kubectl get service --all-namespaces # find a Service IP,list all services in all namespaces
echo "============================status check=============================================================="

