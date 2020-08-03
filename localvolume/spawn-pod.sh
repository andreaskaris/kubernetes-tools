#!/bin/bash 

oc apply -f loopback-pvc.yaml
oc apply -f loopback-pod.yaml
