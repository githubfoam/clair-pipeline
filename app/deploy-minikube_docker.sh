#!/bin/bash
set -eox pipefail #safety for script

#           - |
#             set -eo pipefail #safety for script
#             if [[ $(egrep -c '(vmx|svm)' /proc/cpuinfo) == 0 ]]; then #check if virtualization is supported on Linux, xenial fails w 0, bionic works w 2
#                      echo "virtualization is not supported"
#             else
#                   echo "===================================="
#                   echo eval "$(egrep -c '(vmx|svm)' /proc/cpuinfo)" 2>/dev/null
#                   echo "===================================="
#                   echo "virtualization is supported"
#             fi
#           - sudo apt-get -qq -y install conntrack #X Sorry, Kubernetes v1.18.3 requires conntrack to be installed in root's path
#           - curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/ # Download kubectl
#           - curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/ # Download minikube
#           - mkdir -p $HOME/.kube $HOME/.minikube
#           - touch $KUBECONFIG
#           - minikube start --profile=minikube --driver=docker --kubernetes-version=v$KUBERNETES_VERSION #the none driver, the kubectl config and credentials generated are owned by root in the root user’s home directory
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
#           - minikube status
#           - kubectl cluster-info
#           - kubectl get pods --all-namespaces;
#           - kubectl get pods -n default;
#           - echo "=========================================================================================="
