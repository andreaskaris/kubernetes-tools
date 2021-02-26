IMG ?= hpa-tester

binaries: clean
	bash -x build-binaries.sh

clean:
	rm -Rf bin

podman-build: binaries
	buildah bud -t $(IMG) .

podman-push:
	podman push $(IMG)
