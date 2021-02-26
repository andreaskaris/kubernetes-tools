FROM fedora
COPY bin/mallocmb /usr/local/bin/mallocmb
COPY bin/churn /usr/local/bin/churn
COPY bin/kubectl /usr/local/bin/kubectl
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN yum install jq -y
