#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script

#https://minikube.sigs.k8s.io/docs/start/
#https://github.com/kubernetes/minikube
echo "===============================deploy kubectl==========================================================="

# install kubectl
apt-get update -qq && apt-get install -yqq apt-transport-https gnupg2 curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
apt-get update -qq
apt-get install -yqq kubectl


# install jq
apt-get update -qq
apt-get install -yqq jq


echo "=============================deploy minikube============================================================="

# Sorry, Kubernetes 1.19.2 requires conntrack to be installed in root's path
apt-get update -qq
apt-get install -qqy conntrack 

# Install Minikube
# curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
# chmod +x minikube
# cp minikube /usr/local/bin/ && rm minikube

 curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
 install minikube-linux-amd64 /usr/local/bin/minikube

# curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.2.0/minikube-linux-amd64
# chmod +x minikube
# cp minikube /usr/local/bin/ && rm minikube
#starts Minikube with 6 CPUs, 12288 memory, 120G disk size
minikube start --vm-driver=none \
                --cpus 6 \
                --memory 7960 \
                --disk-size=120g \
                --extra-config=apiserver.authorization-mode=RBAC \
                --extra-config=kubelet.resolv-conf=/run/systemd/resolve/resolv.conf \
                --extra-config kubeadm.ignore-preflight-errors=SystemVerification

# Set docker environment to minikube
eval "$(minikube docker-env --profile=minikube)" && export DOCKER_CLI='docker'
minikube version
minikube status


