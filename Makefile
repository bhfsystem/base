include Makefile.dream
include Makefile.docker

ifeq (aws,$(firstword $(MAKECMDGOALS)))
KEYPAIR := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(KEYPAIR):;@:)
endif

docker_default = docker-image

docker-image:
	$(MAKE)
	time $(make) reset-xenial build

docker-update:
	$(MAKE)
	time $(make) clean daemon build

virtualbox:
	$(MAKE) clean-cidata
	$(MAKE)
	time env http_proxy=$(cache_vip) plane media packer
	$(MAKE) clean-cidata
	$(MAKE)
	plane vagrant destroy -f || true
	time env http_proxy=$(cache_vip) BASEBOX_SOURCE="inception:packer" plane build

aws:
	$(MAKE)
	time env AWS_KEYPAIR=$(KEYPAIR) van rebase
