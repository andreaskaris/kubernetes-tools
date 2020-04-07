#!/bin/bash

# Each ingresscontroller runs 1 replica = this works with 3 workers

oc new-project test1
oc new-project test2

oc project default
oc scale ingresscontroller -n openshift-ingress-operator default --replicas 1
oc apply -f fh-build.yaml
oc start-build fh-build --wait
oc apply -f fh-ingress.yaml

oc project test1
oc apply -f operator-test2.yaml
oc adm policy add-scc-to-user anyuid -z default
oc apply -f fh-test1-build.yaml
oc start-build fh-test1-build --wait
oc apply -f fh-test1-ingress.yaml

oc project test2
oc apply -f operator-test2.yaml
oc adm policy add-scc-to-user anyuid -z default
oc apply -f fh-test2-build.yaml
oc start-build fh-test2-build --wait
oc apply -f fh-test2-ingress.yaml
