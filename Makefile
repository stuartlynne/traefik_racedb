
NAMECHEAP_API_USER = 'stuartlynne'
NAMECHEAP_API_KEY = '140badea0c584bb2b054e4a61f8a81f0'

.PHONY: all to build restart logs

all:

clipboard:
	@( \
	echo "docker-compose.yml ----------------------------"; \
	cat docker-compose.yml; \
	echo "traefik.toml ----------------------------"; \
	cat traefik.toml; \
	echo "- ----------------------------------------"; \
	) | xclip -i

dirs:
	mkdir -p letsencrypt logs

build-clean: clean build
build: dirs
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
