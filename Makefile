up:
	@docker compose --env-file ./.docker/.env -f ./.docker/docker-compose.yml up -d

down:
	@docker compose --env-file ./.docker/.env -f ./.docker/docker-compose.yml down

restart:
	@echo "Container name?"
	@read CONTAINER_NAME; \
		if [ -z $${CONTAINER_NAME} ]; then echo "Container name is empty. Aborting..."; exit 1; \
		else docker restart "$${CONTAINER_NAME}"; \
		fi

stop:
	@echo "Container name? (Leave empty to stop all containers)"
	@read CONTAINER_NAME; \
		if [ -z $${CONTAINER_NAME} ]; then echo "Container name is empty. Stopping all containers..."; docker compose --env-file ./.docker/.env -f ./.docker/docker-compose.yml stop; \
		else docker stop "$${CONTAINER_NAME}"; \
		fi

rm:
	@echo "Container name?"
	@read CONTAINER_NAME; \
		if [ -z $${CONTAINER_NAME} ]; then echo "Container name is empty. Aborting..."; exit 1; \
		else docker rm -f "$${CONTAINER_NAME}"; \
		fi

logs:
	@echo "Container name? (Leave empty to show all containers logs)"
	@read CONTAINER_NAME; \
		if [ -z $${CONTAINER_NAME} ]; then echo "Container name is empty. Showing all logs..."; docker compose --env-file ./.docker/.env -f ./.docker/docker-compose.yml logs; \
		else docker logs -f "$${CONTAINER_NAME}"; \
		fi

build:
	@docker compose --env-file ./.docker/.env -f ./.docker/docker-compose.yml build

build-no-cache:
	@docker compose --env-file ./.docker/.env -f ./.docker/docker-compose.yml build --no-cache

build-debug:
	@docker compose --env-file ./.docker/.env -f ./.docker/docker-compose.yml build --no-cache --progress plain

status:
	@docker ps -a

into-container:
	@echo "Container name?"
	@read CONTAINER_NAME; \
		if [ -z $${CONTAINER_NAME} ]; then echo "Container name is empty. Aborting..."; exit 1; \
		else docker exec -it $${CONTAINER_NAME} sh; \
		fi

clean-hosts-file:
	@if ! [ "$(shell id -u)" = 0 ];then echo "Error: Please run with sudo..."; exit 1; fi; \
	    sed -i "/boilerplate./d" /etc/hosts

docker-prune:
	@docker system prune -f --volumes --filter "label=com.docker.compose.project=boilerplate"
	@docker image rm mariadb:10.10.2-jammy 2>/dev/null || true
	@docker image ls --filter "reference=*boilerplate*" --quiet | xargs --no-run-if-empty docker image rm
	@docker image ls --filter "dangling=true" --quiet | xargs --no-run-if-empty docker image rm

clean-docker:
	@rm -f .docker/.env

clean-env-all: clean-docker

destroy: docker-prune clean-env-all

set-hosts-file:
	@if ! [ "$(shell id -u)" = 0 ];then echo "Error: Please run with sudo..."; exit 1; fi; \
		sed -i "/boilerplate./d" /etc/hosts; \
	    echo "127.0.0.1 api.boilerplate.localhost

install-docker:
	@cp -f .docker/.env.sample .docker/.env

install-env-all: install-docker

download-submodules:
	@git submodule update --init
	@git submodule foreach git checkout main

first-install: download-submodules install-env-all build up

update-submodules:
	@git submodule foreach git checkout main
	@git submodule foreach git pull --prune


mariadb-rm-volume:
	@docker stop blp-mariadb
	@docker rm -f blp-mariadb
	@docker volume rm blp-mariadb-volume

mariadb-reload-database: mariadb-rm-volume up
