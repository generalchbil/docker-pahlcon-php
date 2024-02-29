#!/usr/bin/make
include .env

ifndef UID
  UID := $(shell id -u)
endif
GID := $(shell id -g)

COMPOSE_CMD:=CURRENT_UID=$(UID) CURRENT_GID=$(GID) docker compose --env-file ./.env -f docker/${DOCKER_ENV}/docker-compose.yml

build:
	${COMPOSE_CMD} build

up:
	${COMPOSE_CMD} up -d

refresh:
	${COMPOSE_CMD} down --remove-orphans && ${COMPOSE_CMD} up -d --build --force-recreate

ps:
	${COMPOSE_CMD} ps

logs:
	${COMPOSE_CMD} logs -f --tail=100

watch:
	docker exec -it ${COMPOSE_PROJECT_NAME} npm run watch -f

exec:
	CURRENT_UID=$(UID) CURRENT_GID=$(GID) docker exec -it ${COMPOSE_PROJECT_NAME} bash

install:
	CURRENT_UID=$(UID) CURRENT_GID=$(GID) docker exec ${COMPOSE_PROJECT_NAME} bash /usr/local/bin/deploy.sh


start: build up install

