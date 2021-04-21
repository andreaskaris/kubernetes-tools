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

