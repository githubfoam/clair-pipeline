#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script

git clone https://github.com/kaidotdev/vegeta-controller.git && cd vegeta-controller && ls -lai

# Installation
kubectl apply -k manifests

cat <<EOT | kubectl apply -f -
apiVersion: vegeta.kaidotdev.github.io/v1
kind: Attack
metadata:
  name: sample
spec:
  parallelism: 2
  scenario: |-
    GET http://httpbin/delay/1
    GET http://httpbin/delay/3
  output: text
EOT


kubectl get attack sample

kubectl get job sample-attack

kubectl logs -l app=sample-attack

