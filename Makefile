repository_host = gitlab.com
repository_user = scrolliris

repositories = \
	scrolliris-console \
	scrolliris-console-translation

srv ?= $(shell pwd)/srv

checkout:
	@if [ ! -d "$(srv)" ]; then \
		mkdir $(srv); \
	fi
	@for repository in $(repositories); do \
		if [ ! -d "$(srv)/$$repository" ]; then \
			git clone git@$(repository_host):$(repository_user)/$$repository.git \
				$(srv)/$$repository && cd $(srv)/$$repository; \
			git remote rename origin gitlab; \
		else \
	    cd $(srv)/$$repository; \
			git pull gitlab master; \
		fi \
	done
.PHONY: checkout

network:
	@if docker network inspect scrolliris_backend >/dev/null 2>&1; then \
		echo "network named as scrolliris_backend already exists"; \
	else \
	  docker network create \
			-o "com.docker.network.bridge.name"="scrolliris" \
			scrolliris_backend; \
	fi
.PHONY: network

up: checkout network
	@docker-compose -f docker-compose.yml -p scrolliris up -d
.PHONY: up

down:
	@docker-compose -f docker-compose.yml -p scrolliris down
.PHONY: down

clean:
	@docker-compose -f docker-compose.yml -p scrolliris down \
		--rmi local --volumes
.PHONY: down

start: up
.PHONY: start

stop:
	@docker-compose -f docker-compose.yml -p scrolliris stop
.PHONY: stop

restart:
	@docker-compose -f docker-compose.yml -p scrolliris restart
.PHONY: restart
