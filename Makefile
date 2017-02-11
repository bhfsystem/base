include Makefile.dream
include Makefile.docker

docker_default = docker-image

docker-image:
	time $(make) reset-xenial build

docker-update:
	time $(make) clean daemon build

virtualbox:
	time env http_proxy=$(cache_vip) plane rebase

