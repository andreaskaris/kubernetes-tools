#!/bin/bash

IMG=$1

tmp_file=$(mktemp)

cp not-ready-monitor-ds.yaml ${tmp_file}
sed -i "s#image: fedora#image: ${IMG}#" ${tmp_file}

oc new-project not-ready-monitor || oc project not-ready-monitor
oc adm policy add-scc-to-user privileged -z default
for f in not-ready-monitor-role.yaml not-ready-monitor-role-binding.yaml ${tmp_file}; do
  oc apply -f $f
done
rm -f ${tmp_file}
