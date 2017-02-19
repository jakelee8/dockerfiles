include mk/common.mk

build: playonlinux squid wine
.PHONY: build

playonlinux: wine images/playonlinux/playonlinux/phoenicis-dist.zip
	$(DOCKER_BUILD) -t "$(DOCKER_USER)/playonlinux" "images/playonlinux/playonlinux"
.PHONY: playonlinux

squid:
	$(DOCKER) build -t "$(DOCKER_USER)/squid" "images/squid"
.PHONY: squid

squid-service: squid
	$(DOCKER) run -d \
		-v /data/docker-squid/cache:/var/cache/squid \
		-v /data/docker-squid/log:/var/cache/log \
		-p 127.0.0.1:3128:3128 \
		"$(DOCKER_USER)/squid"
.PHONY: squid-service

images/playonlinux/playonlinux/phoenicis-dist.zip:
	make wine
	$(DOCKER_BUILD) -t "$(DOCKER_USER)/playonlinux:build" "images/playonlinux/build"
	$(DOCKER) run -it --rm -v $(shell dirname $(shell realpath $@)):/dist "$(DOCKER_USER)/playonlinux:build"

wine:
	$(DOCKER_BUILD) -t "$(DOCKER_USER)/wine" "images/wine"
.PHONY: wine

run:
	$(eval UID := $(shell id -u))
	$(DOCKER) run -it --rm \
		--name playonlinux \
		--privileged \
		-e DISPLAY \
		-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
		-e 'XAUTHORITY=/tmp/.XAUTHORITY' \
		-v ~/.Xauthority:/tmp/.Xauthority:ro \
		-e 'PULSE_SERVER=unix:/tmp/.pulse-native' \
		-v /run/user/$(UID)/pulse/native:/tmp/.pulse-native \
		-v /home/$(USER)/.pulse-cookie:/home/$(USER)/.pulse-cookie:ro \
		-e 'DBUS_SESSION_BUS_ADDRESS=unix:path=/tmp/.dbus' \
		-v /run/user/1000/bus:/tmp/.dbus \
		-v /run/dbus/system_bus_socket:/run/dbus/system_bus_socket \
		-v /dev/uinput:/dev/uinput \
		-e 'http_proxy=http://$(DOCKER_BUILD_HOST_IP):3128/' \
		-v /data/playonlinux:/home/jake \
		-v /data/playonlinux/Games:/home/jake/.PlayOnLinux/wineprefix/TheSims4/drive_c/Games \
		"$(DOCKER_USER)/playonlinux" \
		|| $(DOCKER) start -ai playonlinux
.PHONY: run
