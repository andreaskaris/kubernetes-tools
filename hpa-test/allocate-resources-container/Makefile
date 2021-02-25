IMG ?= hpa-tester

binaries: clean
	mkdir bin 2>/dev/null
	go build -o bin/churn churn.go
	gcc malloc.c -o bin/mallocmb

clean:
	rm -Rf bin

podman-build: binaries
	buildah bud -t $(IMG) .

podman-push:
	podman push $(IMG)
