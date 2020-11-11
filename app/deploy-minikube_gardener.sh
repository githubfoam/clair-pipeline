#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script

#https://istio.io/docs/setup/platform-setup/gardener/
#https://github.com/gardener/gardener/blob/master/docs/development/local_setup.md
snap install helm --classic
apt-get update -qq
apt-get -qqy install openvpn
egrep -c '(vmx|svm)' /proc/cpuinfo | echo "virtualization is  supported" | echo "virtualization is not supported"
apt-get -qq -y install conntrack #X Sorry, Kubernetes v1.18.3 requires conntrack to be installed in root's path
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/ # Download kubectl
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/ # Download minikube
mkdir -p $HOME/.kube $HOME/.minikube
touch $KUBECONFIG
snap install kubectl --classic && kubectl version –client

echo "=====================Local Gardener setup Using minikube====================================================================="
minikube config set embed-certs true
minikube start --profile=minikube --vm-driver=none --kubernetes-version=v$KUBERNETES_VERSION --embed-certs #  `--embed-certs` can be omitted if minikube has already been set to create self-contained kubeconfig files.
make dev-setup #point your KUBECONFIG environment variable to the local cluster you created in the previous step and run
kubectl apply -f example/10-secret-internal-domain-unmanaged.yaml
make start-apiserver
make start-controller-manager
make start-scheduler
make start-gardenlet
kubectl get shoots

# echo "=========================================================================================="
# # - sudo minikube start --profile=minikube --vm-driver=none --kubernetes-version=v$KUBERNETES_VERSION #the none driver, the kubectl config and credentials generated are owned by root in the root user’s home directory
# minikube update-context --profile=minikube
# "sudo chown -R travis: /home/travis/.minikube/"
# eval "$(minikube docker-env --profile=minikube)" && export DOCKER_CLI='docker'
#
# echo "=========================================================================================="
# kubectl version
# kubectl version --client #the version of the client
# kubectl cluster-info
# minikube status
#
# echo "=========================================================================================="
# echo "Waiting for Kubernetes to be ready ..."
# for i in {1..150}; do # Timeout after 5 minutes, 150x2=300 secs
#     if kubectl get pods --namespace=kube-system -lcomponent=kube-addon-manager|grep Running && \
#        kubectl get pods --namespace=kube-system -lk8s-app=kube-dns|grep Running ; then
#       break
#     fi
#     sleep 2
# done
#
# echo "============================status check=============================================================="
# minikube status
# kubectl cluster-info
# kubectl get pods --all-namespaces;
# kubectl get pods -n default;
#
# echo "===========================Local Gardener setup==============================================================="
# git clone git@github.com:gardener/gardener.git && cd gardener #Local Gardener setup
# make local-garden-up #Using the nodeless cluster setup
# make local-garden-down # tear down the local Garden cluster and remove the Docker containers
