#!/bin/bash

oc new-project local-storage
oc apply -f local-volume-config.yaml

oc create serviceaccount local-storage-admin
oc adm policy add-scc-to-user privileged -z local-storage-admin
oc create -f https://raw.githubusercontent.com/openshift/origin/release-3.11/examples/storage-examples/local-examples/local-storage-provisioner-template.yaml
oc new-app -p CONFIGMAP=local-volume-config \
  -p SERVICE_ACCOUNT=local-storage-admin \
  -p NAMESPACE=local-storage \
  -p PROVISIONER_IMAGE=registry.redhat.io/openshift3/local-storage-provisioner:v3.11 \
  local-storage-provisioner
oc apply -f storage-class-loopbacks.yaml
