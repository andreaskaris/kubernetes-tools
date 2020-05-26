#!/bin/bash

# Each ingresscontroller runs 1 replica = this works with 3 workers

# default ingress will match ns:
#     oc get ns -l type!=test1,type!=test2
# test1 ingress will match
#     oc get ns -l type=test1
# test2 ingress will match
#     oc get ns -l type=test2

oc new-project test1
oc new-project test2

oc project default
oc label namespace test1 "type=test1"
oc label namespace test2 "type=test2"
oc label node cluster-7n7w9-worker-zpq85 "ingressoperator=default"
oc label node cluster-7n7w9-worker-zpq84 "ingressoperator=test1"
oc label node cluster-7n7w9-worker-zpq83 "ingressoperator=test2"

oc project default
# oc scale ingresscontroller -n openshift-ingress-operator default --replicas 1
oc patch -n openshift-ingress-operator ingresscontroller default --type="merge" -p "$(cat operator-default-patch.yaml)"

oc project default
oc apply -f fh-build.yaml
oc start-build fh-build --wait
oc apply -f fh-ingress.yaml

oc project test1
oc apply -f operator-test1.yaml
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
