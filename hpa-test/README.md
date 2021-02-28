Build with:
~~~
make podman-build IMG=quay.io/akaris/hpa-tester:latest
make podman-push IMG=quay.io/akaris/hpa-tester:latest
~~~

Deploy the deployment in a dedicated namespace with:
~~~
oc apply -f role-list-deployments-pods.yaml
oc apply -f role-binding-list-deployments-pods.yaml
oc apply -f deployment-hpa-tester.yaml
~~~

The deployment will by default request 800ms in a single pod, and 2048 MB of memory:
~~~
        - name: COMBINED_CPU_MS
          value: "800"
        # combined Memory of all pods in MB
        - name: COMBINED_MEMORY_MB
          value: "2048"
~~~

If you change the replica count, the `entrypoint.sh` will make sure to distribute the memory MB and CPU ms between the number of replicas.


~~~
$ oc logs -f hpa-tester-5f7487c854-8scxc
(...)
Number of deployment replicas changed
CPU_MS = 800
MEMORY_MB = 2048
Specify the number of Megabytes to reserve, max 1024
Our PID is: 20
Run for 800ms every 1000ms
~~~

~~~
[akaris@linux hpa-test]$ oc get podmetrics
NAME                          CPU    MEMORY   WINDOW
hpa-tester-5f7487c854-8scxc   802m   9800Ki   5m0s
~~~

For example:
~~~
oc scale deployment hpa-tester --replicas 4
~~~

~~~
Number of deployment replicas changed
CPU_MS = 200
MEMORY_MB = 512
Our PID is: 105
Run for 200ms every 1000ms
~~~

~~~
[akaris@linux hpa-test]$ oc get podmetrics
NAME                          CPU    MEMORY     WINDOW
hpa-tester-5f7487c854-7r5fr   210m   535152Ki   5m0s
hpa-tester-5f7487c854-8scxc   206m   536516Ki   5m0s
hpa-tester-5f7487c854-g94rr   195m   531440Ki   5m0s
hpa-tester-5f7487c854-x2wmf   210m   533040Ki   5m0s
~~~
