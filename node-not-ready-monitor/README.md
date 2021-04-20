## Node Not Ready Monitor

This daemonset checks the node status of every worker, every 5 seconds.
If a node shows `NotReady`, then the script in the ConfigMap will:

* create a sosreport
* gather /var/log/journal
* gather /var/log/containers

At time of this writing, nothing prevents this script from filling up the root disk if a Node's status flaps.

### Install instructions ###

Install instructions:
~~~
oc new-project not-ready-monitor || oc project not-ready-monitor
oc adm policy add-scc-to-user privileged -z default
for f in not-ready-monitor-role.yaml not-ready-monitor-role-binding.yaml not-ready-monitor-ds.yaml; do
  oc apply -f $f
done
~~~

