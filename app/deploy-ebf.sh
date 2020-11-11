#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script

#Install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl

#https://minikube.sigs.k8s.io/docs/start/
#https://github.com/kubernetes/minikube
# Install Minikube
# curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
# chmod +x minikube
# cp minikube /usr/local/bin/ && rm minikube


curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.2.0/minikube-linux-amd64
chmod +x minikube
cp minikube /usr/local/bin/ && rm minikube
#starts Minikube with 6 CPUs, 12288 memory, 120G disk size
minikube start --vm-driver=none \
                --cpus 6 \
                --memory 12288 \
                --disk-size=120g \
                --extra-config=apiserver.authorization-mode=RBAC \
                --extra-config=kubelet.resolv-conf=/run/systemd/resolve/resolv.conf \
                --extra-config kubeadm.ignore-preflight-errors=SystemVerification
                --iso-url https://storage.googleapis.com/minikube-performance/minikube.iso

#download and extract necessary kernel headers within minikube
minikube ssh -- curl -Lo /tmp/kernel-headers-linux-4.19.94.tar.lz4 https://storage.googleapis.com/minikube-kernel-headers/kernel-headers-linux-4.19.94.tar.lz4
minikube ssh -- sudo mkdir -p /lib/modules/4.19.94/build
minikube ssh -- sudo tar -I lz4 -C /lib/modules/4.19.94/build -xvf /tmp/kernel-headers-linux-4.19.94.tar.lz4
minikube ssh -- rm /tmp/kernel-headers-linux-4.19.94.tar.lz4

#run BCC tools as a Docker container in minikube
minikube ssh -- docker run --rm   --privileged   -v /lib/modules:/lib/modules:ro   -v /usr/src:/usr/src:ro   -v /etc/localtime:/etc/localtime:ro   --workdir /usr/share/bcc/tools   zlim/bcc ./execsnoop > /dev/null
