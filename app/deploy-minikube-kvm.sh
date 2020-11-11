#!/bin/bash
set -eox pipefail #safety for script

echo "=============================minikube============================================================="
# fleet_script_minikube_kvm_latest_tasks : &fleet_script_minikube_kvm_latest_tasks #If you are running minikube within a VM, consider using --driver=none
#       script:
#           - docker version
#           - echo "==========================Check that your CPU supports hardware virtualization================================================================"
#           - egrep -c '(vmx|svm)' /proc/cpuinfo | echo "virtualization is  supported" | echo "virtualization is not supported"
#           - egrep -c ' lm ' /proc/cpuinfo # see if your processor is 64-bit
#           - echo "===============================Installation of KVM===========================================================" #https://help.ubuntu.com/community/KVM/Installation
#           - sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
#           - sudo adduser `id -un` libvirt #Bionic (18.04 LTS) and higher
#           - sudo adduser `id -un` kvm
#           - groups #ensure that your username is added to the groups
#           - virsh list --all #Verify Installation
#           - virt-host-validate #Once configured, validate that libvirt reports no errors #https://minikube.sigs.k8s.io/docs/drivers/kvm2/
#           - echo "=========================================================================================="
#           - sudo apt-get -qq -y install conntrack #X Sorry, Kubernetes v1.18.3 requires conntrack to be installed in root's path
#           - curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/ # Download kubectl
#           - curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/ # Download minikube
#           - mkdir -p $HOME/.kube $HOME/.minikube
#           - touch $KUBECONFIG
#           - sudo minikube start --profile=minikube --driver=kvm2 --kubernetes-version=v$KUBERNETES_VERSION #Start a cluster using the kvm2 driver, the kubectl config and credentials generated are owned by root in the root user’s home directory
#           - minikube config set driver kvm2 #make kvm2 the default driver
#           - minikube update-context --profile=minikube
#           - "sudo chown -R travis: /home/travis/.minikube/"
#           - eval "$(minikube docker-env --profile=minikube)" && export DOCKER_CLI='docker'
#           - echo "=========================================================================================="
#           - kubectl version --client #ensure the version
#           - kubectl cluster-info
#           - minikube status
#           - echo "=========================================================================================="
#           - |
#             echo "Waiting for Kubernetes to be ready ..."
#             for i in {1..150}; do # Timeout after 5 minutes, 150x2=300 secs
#               if kubectl get pods --namespace=kube-system -lcomponent=kube-addon-manager|grep Running && \
#                  kubectl get pods --namespace=kube-system -lk8s-app=kube-dns|grep Running ; then
#                 break
#               fi
#               sleep 2
#             done
#           - echo "============================status check=============================================================="
