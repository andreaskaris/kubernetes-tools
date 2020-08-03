## Resources ##

* https://docs.openshift.com/container-platform/3.11/install_config/configuring_local.html

## Howto ##

Run createlocalvolumes.sh on the OpenShift worker nodes to create 4 loopback devices mounted under /mnt/local-storage/loopbacks

Run apply-local-volume-config.sh on the master node (or from where you access the API) to create the volume provisioner and pvs. Run spawn-pod.sh to create the PVC with the local-loopbacks storageclass and a pod that uses that PVC.
