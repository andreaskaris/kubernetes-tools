FROM registry.access.redhat.com/ubi8/ubi:latest
RUN yum install sysstat -y
RUN yum install sos -y
RUN yum install jq -y
RUN curl -O https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest-4.5/openshift-client-linux.tar.gz
RUN tar -xf openshift-client-linux.tar.gz -C /usr/local/bin
