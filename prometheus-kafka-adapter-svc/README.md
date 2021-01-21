> Disclaimer: I'm providing these instructions below for convenience. None of this is supported. It works, but Red Hat does not guarantee that it will not break in the future. Also, the prometheus-kafka-adapter is an upstream project and is not provided, supported nor tested by Red Hat.

For example, here is an unsupported procedure if you want to forward to kafka with https://github.com/Telefonica/prometheus-kafka-adapter

First, create the prometheus-kafka-adapter:
https://github.com/andreaskaris/kubernetes/tree/master/prometheus-kafka-adapter-svc

Clone the above resources and adjust as needed. In the above, I created a simple deployment with replica size 1 and an ingress rule. This is just an example, as it uses http.
~~~
oc apply -f prometheus-kafka-adapter-namespace.yaml ; oc apply -f prometheus-kafka-adapter-deployment.yaml ; oc apply -f prometheus-kafka-adapter-svc.yaml
~~~

Verify that this worked:
~~~
oc logs -l app=prometheus-kafka-adapter-pod -n prometheus-kafka-adapter -f
~~~

Open another CLI and call the ingress:
~~~
[akaris@linux prometheus-kafka-adapter-svc]$ oc get ingress
NAME                       CLASS    HOSTS                                                              ADDRESS                                   PORTS   AGE
prometheus-kafka-adapter   <none>   prometheus-kafka-adapter.apps.akaris21.focused-solutions.support   apps.akaris21.focused-solutions.support   80      5m26s
[akaris@linux prometheus-kafka-adapter-svc]$ curl http://prometheus-kafka-adapter.apps.akaris21.focused-solutions.support/receive
404 page not found[akaris@linux prometheus-kafka-adapter-svc]$ curl http://prometheus-kafka-adapter.apps.akaris21.focused-solutions.support/metrics
# HELP go_gc_duration_seconds A summary of the GC invocation durations.
# TYPE go_gc_duration_seconds summary
go_gc_duration_seconds{quantile="0"} 9.55e-06
go_gc_duration_seconds{quantile="0.25"} 9.945e-06
(...)
process_virtual_memory_bytes 7.44865792e+08
~~~

The logs will update like this:
~~~
[akaris@linux prometheus-kafka-adapter-svc]$ oc logs -l app=prometheus-kafka-adapter-pod -n prometheus-kafka-adapter
[GIN-debug] POST   /receive                  --> main.receiveHandler.func1 (3 handlers)
[GIN-debug] Environment variable PORT is undefined. Using port :8080 by default
[GIN-debug] Listening and serving HTTP on :8080
{"fields.time":"2021-01-21T18:29:23Z","ip":"212.129.81.175","latency":397,"level":"info","method":"GET","msg":"","path":"/receive","status":404,"time":"2021-01-21T18:29:23Z","user-agent":"curl/7.69.1"}
{"fields.time":"2021-01-21T18:29:31Z","ip":"212.129.81.175","latency":554268,"level":"info","method":"GET","msg":"","path":"/metrics","status":200,"time":"2021-01-21T18:29:31Z","user-agent":"curl/7.69.1"}
~~~

Now, follow https://access.redhat.com/solutions/4931911 to set up the forwarder from Prometheus.
~~~
[akaris@linux prometheus-kafka-adapter-svc]$ oc -n openshift-monitoring get configmap cluster-monitoring-config
Error from server (NotFound): configmaps "cluster-monitoring-config" not found
[akaris@linux prometheus-kafka-adapter-svc]$ oc -n openshift-monitoring create configmap cluster-monitoring-config
configmap/cluster-monitoring-config created
[akaris@linux prometheus-kafka-adapter-svc]$ oc -n openshift-monitoring edit configmap cluster-monitoring-config
configmap/cluster-monitoring-config edited
[akaris@linux prometheus-kafka-adapter-svc]$ oc -n openshift-monitoring get configmap cluster-monitoring-config
NAME                        DATA   AGE
cluster-monitoring-config   1      78s
[akaris@linux prometheus-kafka-adapter-svc]$ oc -n openshift-monitoring get configmap cluster-monitoring-config -o yaml
apiVersion: v1
data:
  config.yaml: |
    prometheusK8s:
      remoteWrite:
        - url: "http://prometheus-kafka-adapter.apps.akaris21.focused-solutions.support/receive"
kind: ConfigMap
metadata:
  creationTimestamp: "2021-01-21T18:30:55Z"
  name: cluster-monitoring-config
  namespace: openshift-monitoring
  resourceVersion: "1011016"
  selfLink: /api/v1/namespaces/openshift-monitoring/configmaps/cluster-monitoring-config
  uid: 02fee217-4249-4a23-88f5-292d3e2a9ea8
~~~

The prometheus pods will restart:
~~~
[akaris@linux prometheus-kafka-adapter-svc]$  oc get -n openshift-monitoring pods | grep prom
prometheus-adapter-6bc6c89488-pq2qb           1/1     Running   0          31h
prometheus-adapter-6bc6c89488-zt9fh           1/1     Running   0          31h
prometheus-k8s-0                              6/6     Running   1          2d2h
prometheus-k8s-1                              6/6     Running   1          2d2h
prometheus-operator-5b58d87784-hpkc4          2/2     Running   0          2d2h
~~~

And after a while, you will see the log update update in the prometheus-kafka-adapter-pod:
~~~
(...)
{"fields.time":"2021-01-21T18:32:38Z","ip":"54.194.217.48","latency":8160729,"level":"info","method":"POST","msg":"","path":"/receive","status":200,"time":"2021-01-21T18:32:38Z","user-agent":"Prometheus/2.22.2"}
{"fields.time":"2021-01-21T18:32:38Z","ip":"54.194.217.48","latency":8152701,"level":"info","method":"POST","msg":"","path":"/receive","status":200,"time":"2021-01-21T18:32:38Z","user-agent":"Prometheus/2.22.2"}
{"fields.time":"2021-01-21T18:32:38Z","ip":"54.194.217.48","latency":7058319,"level":"info","method":"POST","msg":"","path":"/receive","status":200,"time":"2021-01-21T18:32:38Z","user-agent":"Prometheus/2.22.2"}
(...)
~~~

All of the rest is then done in the prometheus-kafka-adapter-pod, meaning that you will have to correctly configure the environment variables in `prometheus-kafka-adapter-deployment.yaml` according to:
https://github.com/Telefonica/prometheus-kafka-adapter
