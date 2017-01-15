DOCKER ?= $(shell which docker)
DOCKER_BUILD ?= $(DOCKER) build
DOCKER_USER ?= local

# TODO: move this to conf.mk
DOCKER_USER = jakelee8

DOCKER = $(shell which nvidia-docker)
DOCKER_BUILD_HOST_IP := $(shell $(DOCKER) network inspect -f '{{range .IPAM.Config}}{{.Gateway}}{{end}}' bridge)
DOCKER_BUILD += --build-arg 'http_proxy=http://$(DOCKER_BUILD_HOST_IP):3128/'
