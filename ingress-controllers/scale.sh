#!/bin/bash

oc scale ingresscontroller -n openshift-ingress-operator default --replicas 1
