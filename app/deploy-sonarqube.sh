#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script


echo "===============================deploy SonarQube==========================================================="

git clone https://github.com/mcaimi/k8s-demo-app.git && cd k8s-demo-app

# # run everything locally (eg. no secure Ingresses in place), add the url of the registry as an insecure source:
# minikube start --cpus=4 --memory=8GB --disk-size=20G --insecure-registry registry.apps.kubernetes.local

# Enable all needed k8s addons
for item in registry ingress istio-provisioner istio dashboard helm-tiller; do
  minikube addons enable $item
done

# Create the base namespaces
for i in jenkins dev preprod prod; do
  kubectl create ns $i
done

kubectl apply -f configmaps/components/docker-in-docker-insecure-registry-cm.yaml -n jenkins

kubectl create cm hadolint-config-cm --from-file=hadolint.yaml=configmaps/components/hadolint.yaml

kubectl apply -f k8s/components/registry-ingress-kubernetes.yaml -n kube-system

# ACCESS TO NAMESPACES
kubectl create sa ci-jenkins -n jenkins
kubectl create sa ci-jenkins -n dev
kubectl create sa ci-jenkins -n preprod
kubectl create sa ci-jenkins -n prod

#Deploy the sample application
kubectl get service --all-namespaces #list all services in all namespace
kubectl get services #The application will start. As each pod becomes ready, the Istio sidecar will deploy along with it.
kubectl get pods

# for i in {1..60}; do # Timeout after 5 minutes, 60x2=120 secs, 2 mins
#     if kubectl get pods --namespace=vote |grep Running ; then
#       break
#     fi
#     sleep 2
# done

# kubectl get service --all-namespaces #list all services in all namespace
# # Verify your installation
# kubectl get pod -n vote

# kubectl delete namespace vote

# echo "===============================deploy SonarQube==========================================================="
# git clone https://github.com/tjkemper/sonar-kubernetes.git && cd sonar-kubernetes

# # secret
# kubectl apply -f secrets/db-info.yaml --namespace operations

# # service
# kubectl apply -f services/sonar.yaml --namespace operations

# # deployment
# kubectl apply -f deployments/sonar.yaml --namespace operations

# # ingress
# kubectl apply -f ingress/sonar.yaml --namespace operations

# echo "===============================deploy SonarQube==========================================================="
# https://github.com/mattsauce/kubernetes-devops.git && cd kubernetes-devops

# Install SonarQube+Jenkins+Nexus
# ./kubernetes-devops.sh