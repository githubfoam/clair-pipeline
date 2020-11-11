#!/bin/bash
# openesb component list
#https://github.com/openebs/openebs/blob/master/k8s/openebs-operator.yaml

echo "=============================gluster============================================================="
minikube dashboard & # the Kubernetes dashboard
kubectl cluster-info
kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4
kubectl get pods
kubectl get deployments
kubectl get events
kubectl config view
#Create a Service
kubectl expose deployment hello-node --type=LoadBalancer --port=8080 #Expose the Pod to the public internet
kubectl get services
minikube service hello-node

minikube addons list #List the currently supported addons
minikube addons enable storage-provisioner-gluster #Enable an addon
minikube addons disable storage-provisioner #Enable an addon

minikube addons list #List the currently supported addons
kubectl get pod,svc -n kube-system #View the created Pod and Service
kubectl get pvc,pv

# create  PVC -  provision and bind to a PV
# kubectl apply -f https://gist.githubusercontent.com/bodom0015/d920e22df8ff78ee05929d4c3ae736f8/raw/edccc530bf6fa748892d47130a1311fce5513f37/test.pvc.default.yaml
# kubectl get pvc,pv
# Check the storage-provisioner logs
#kubectl logs -f storage-provisioner -n kube-system

# minikube addons disable  storage-provisioner-gluster
# minikube addons list
# # clean up the resources in the cluster
# kubectl delete service hello-node
# kubectl delete deployment hello-node
# minikube stop
# minikube delete #delete the Minikube VM
