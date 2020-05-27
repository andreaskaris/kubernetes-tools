#!/bin/bash

cat <<'EOF' 
From https://access.redhat.com/documentation/en-us/openshift_container_platform/4.3/html/service_mesh/day-two

     Log in to the OpenShift Container Platform CLI.

    Run this command to check the current Mixer policy enforcement status:

    $ oc get cm -n istio-system istio -o jsonpath='{.data.mesh}' | grep disablePolicyChecks

    If disablePolicyChecks: true, edit the Service Mesh ConfigMap:

    $ oc edit cm -n istio-system istio

    Locate disablePolicyChecks: true within the ConfigMap and change the value to false.
    Save the configuration and exit the editor.
    Re-check the Mixer policy enforcement status to ensure it is set to false. 
EOF
