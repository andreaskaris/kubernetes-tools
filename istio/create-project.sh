#!/bin/bash

# https://docs.openshift.com/container-platform/4.3/service_mesh/service_mesh_day_two/ossm-auto-route.html#ossm-auto-route-enable_{context}
cat <<'EOF' > patch.yaml
spec:
  istio:
    gateways:
      istio-ingressgateway:
        ior_enabled: true
EOF
oc patch -n istio-system smcp basic-install --type merge -p "$(cat patch.yaml)"

cat <<'EOF' | oc apply -n istio-system -f -
apiVersion: maistra.io/v1
kind: ServiceMeshMemberRoll
metadata:
  name: default
  namespace: istio-system
spec:
  members:
    # a list of projects joined into the service mesh
    - application
    - bookinfo
EOF

oc new-project application
oc adm policy add-scc-to-user anyuid system:serviceaccount:application:default
