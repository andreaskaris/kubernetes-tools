prerequisites:
	bash configure-mixer.sh

install:
	bash create-project.sh
	oc apply -n application -f nginx-app-gateway.yaml
	oc apply -n application -f nginx-a.yaml
	oc apply -n application -f nginx-b.yaml
	oc apply -n application -f nginx-c.yaml

install-rate-limit:
	oc apply -f ratelimit.yaml
