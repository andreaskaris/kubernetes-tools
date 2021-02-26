#!/bin/bash

REPLICAS=""
MEMORY_MB=""
CPU_MS=""

while true; do
	NEW_REPLICAS=$(kubectl get deployments $DEPLOYMENT_NAME -o json | jq '.spec.replicas')
	if [ "$NEW_REPLICAS" != "$REPLICAS" ]; then
		echo "Number of deployment replicas changed"
		REPLICAS=$NEW_REPLICAS
		MEMORY_MB=$(( $COMBINED_MEMORY_MB / $REPLICAS ))
		CPU_MS=$(( $COMBINED_CPU_MS / $REPLICAS ))

		if [ "$CHURN_PID" != "" ] && [ -d /proc/$CHURN_PID ]; then
			kill $CHURN_PID
		fi
		echo "CPU_MS = $CPU_MS"
		churn $CPU_MS &
		CHURN_PID=$!

		if [ "$MALLOCMB_PID" != "" ] && [ -d /proc/$MALLOCMB_PID ]; then
			kill $MALLOCMB_PID
		fi
		echo "MEMORY_MB = $MEMORY_MB"
		mallocmb $MEMORY_MB &
		MALLOCMB_PID=$!
	fi
	sleep $SLEEP_TIME
done
