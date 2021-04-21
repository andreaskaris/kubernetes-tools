## Node Not Ready Monitor

This daemonset checks the node status of every worker, every 5 seconds.
If a node shows `NotReady`, then the script in the ConfigMap will:

* create a sosreport
* gather /var/log/journal
* gather /var/log/containers

At time of this writing, nothing prevents this script from filling up the root disk if a Node's status flaps.

### Install instructions ###

#### Building the container

First, register the build system:
~~~
subscription-manager register ...
~~~

Then, build and push the container:
~~~
make build IMG=registry.example.com:5000/not-ready-monitor:latest
make push IMG=registry.example.com:5000/not-ready-monitor:latest
~~~

Now, start the actual DaemonSet:
~~~
make install IMG=registry.example.com:5000/not-ready-monitor:latest
~~~

In order to uninstall, run:
~~~
make uninstall
~~~

This will spawn a DaemonSet on all eligible nodes. Assuming that master NoSchedule taint s are in place, this should spawn a DaemonSet pod on each worker node:
~~~
[root@openshift-jumpserver-0 node-not-ready-monitor]# oc get pods -o wide
NAME                      READY   STATUS    RESTARTS   AGE   IP                NODE                 NOMINATED NODE   READINESS GATES
not-ready-monitor-2t88s   1/1     Running   0          60s   192.168.123.220   openshift-worker-0   <none>           <none>
not-ready-monitor-qc9cr   1/1     Running   0          60s   192.168.123.222   openshift-worker-1   <none>           <none>
~~~

Now, this can be tested by connecting to a worker node and running `systemctl stop kubelet`:
~~~
[root@openshift-worker-0 ~]# systemctl stop kubelet
[root@openshift-worker-0 ~]# 
~~~

One can at the same time follow the container's logs via crictl. The `oc` or `kubectl` command will not work given that the worker's kubelet is down.
~~~
[root@openshift-worker-0 ~]# crictl logs -f 7e1324bc895b9
All dependencies are ready.
Silently monitoring from now on every 5 seconds ...
.........................................................Kubelet is down
Generating sosreport

sosreport (version 3.9)

This command will collect diagnostic and configuration information from
(...)
~~~

The script will capture a sosreport, /var/log/journal, and /var/log/containers.

Then, the script will restart the worker's kubelet service and will exit.

As soon as the node's kubelet comes back online, the pod will be restarted and the script will start monitoring anew.

### Configuration

The following 3 settings should be customized:
~~~
MONITOR_INTERVAL_SEC=5   # monitor every 5 seconds
MIN_GATHER_INTERVAL_MIN=60   # only gather data once an hour
MIN_AVAILABLE_GB=500     # keep a minimum of 500 GB disk space on /var/tmp
~~~

