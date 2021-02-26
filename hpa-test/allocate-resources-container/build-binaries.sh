#!/bin/bash

mkdir bin 2>/dev/null
go build -o bin/churn churn.go
gcc malloc.c -o bin/mallocmb
pushd bin
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
popd
