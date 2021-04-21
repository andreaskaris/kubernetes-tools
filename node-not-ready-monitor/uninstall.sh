#!/bin/bash

for f in not-ready-monitor-role.yaml not-ready-monitor-role-binding.yaml not-ready-monitor-ds.yaml; do
  oc delete -f $f
done
echo "Moving to project 'default' and deleting project 'not-ready-monitor'"
oc project default
oc delete project not-ready-monitor

