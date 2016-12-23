SHELL = bash
CACHE = http://$(CACHE_VIP):3128

container = block-$(shell basename $(PWD))

docker:
	@docker build -t $(container) --build-arg http_proxy="$(CACHE)" $(opt) .

image:
	@docker commit $(container) $(container) $(opt)

daemon:
	@docker rm -f $(container) $(container) 2>/dev/null || true
	@docker run -d -ti -p 2222:22 -v /vagrant:/vagrant --name $(container) $(container)
	@docker exec -u ubuntu $(container) bash -c "echo $$(head -1 ~/.ssh/authorized_keys) | tee ~/.ssh/authorized_keys"

deploy:
	@env HOME_REPO=$(shell git config --local remote.origin.url) home remote cache init ssh -A -p 2222 ubuntu@localhost --

ssh:
	@ssh -t -A -p 2222 ubuntu@localhost

enter:
	@docker exec -ti -u ubuntu $(container) bash -il
