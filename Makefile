

include traefik.env

.PHONY: all to build restart logs

all:

clipboard:
	@( \
	echo "./docker-compose.yml ----------------------------"; \
	cat docker-compose.yml; \
	echo "./traefik.toml ----------------------------"; \
	cat traefik.toml; \
	echo "- ----------------------------------------"; \
	for i in dynamic/*.toml; do \
		echo "./$$i ----------------------------"; \
		cat $$i; \
	done; \
	) | xclip -i

dirs:
	mkdir -p letsencrypt logs

traefik.env:
	@echo
	@echo "Copy traefik.env-template to traefik.env and edit it to suit your needs"
	@echo
	@exit 1

build-clean: clean build
build: traefik.env dirs
	docker-compose up -d

clean:
	-docker container stop traefik-reverse-proxy
	-docker container rm traefik-reverse-proxy --force --volumes

really-clean: clean
	-rm -rf letsencrypt

restart:
	docker-compose restart reverse-proxy

logs:
	docker-compose logs reverse-proxy
tailf:
	docker-compose logs -f reverse-proxy

ash:
	docker exec -it traefik-reverse-proxy ash
