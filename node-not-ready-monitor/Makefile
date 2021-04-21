IMG ?= registry.example.com:5000/not-ready-monitor:main

build:
	cd container && buildah bud -t $(IMG)

push:
	podman push $(IMG)

install:
	./install.sh $(IMG)

uninstall:
	./uninstall.sh
