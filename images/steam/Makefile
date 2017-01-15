include ../../mk/common.mk

BUILD = onbuild

build: steam $(BUILD)
.PHONY: build

steam:
	$(DOCKER_BUILD) -t "$(DOCKER_USER)/steam" steam
.PHONY: steam

$(BUILD):
	$(DOCKER_BUILD) -t "$(DOCKER_USER)/steam:$@" "$@"
.PHONY: $(BUILD)

push: build
	$(DOCKER) push "$(DOCKER_USER)/steam"
	$(DOCKER) push "$(DOCKER_USER)/steam:onbuild"
.PHONY: push

tag:
	$(eval DATE := $(shell date -u +'%Y-%m-%d'))
	$(DOCKER) tag "$(DOCKER_USER)/steam" "$(DOCKER_USER)/steam:$(DATE)"
	$(DOCKER) tag "$(DOCKER_USER)/steam:onbuild" "$(DOCKER_USER)/steam:onbuild-$(DATE)"
	$(DOCKER) push "$(DOCKER_USER)/steam:$(DATE)"
	$(DOCKER) push "$(DOCKER_USER)/steam:onbuild-$(DATE)"
.PHONY: tag

local:
	$(DOCKER_BUILD) -t "$(DOCKER_USER)/steam:local" \
		--build-arg "USER=$(USER)" \
		--build-arg "UID=$(shell id -u)" \
		local
.PHONY: local

run:
	$(eval UID := $(shell id -u))
	$(DOCKER) run -it --rm \
		--name steam \
		--net=host \
		--privileged \
		--shm-size=128MB \
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
		-e 'http_proxy=http://localhost:3128/' \
		-v /data/steam:/home/$(USER) \
		"$(DOCKER_USER)/steam:local" \
		|| $(DOCKER) start -ai steam
.PHONY: run
