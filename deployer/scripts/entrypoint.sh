#!/bin/bash

curl -o /usr/local/bin/oc.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable-4.6/openshift-client-linux.tar.gz
tar -xf /usr/local/bin/oc.tar.gz -C /usr/local/bin
chmod +x /usr/local/bin/oc

oc apply -f /scripts/statefulset.yaml

sleep infinity
