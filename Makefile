repository_host = gitlab.com
repository_user = scrolliris

repositories = \
	scrolliris-console \
	scrolliris-console-translation

srv ?= $(shell pwd)/srv

rc:
ifeq ($(shell ps -ef | grep "[d]ockerd" | awk {'print $2'}),)
	@echo "docker daemon does not exist" && exit 1
endif

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

network: rc
	@if docker network inspect scrolliris_backend >/dev/null 2>&1; then \
	  echo "network named as scrolliris_backend already exists"; \
	else \
	  docker network create \
	    -o "com.docker.network.bridge.name"="scrolliris" \
	    scrolliris_backend; \
	fi
.PHONY: network

init: rc network checkout
	@docker-compose -f docker-compose.yml -p scrolliris up --build -d
.PHONY: up

up: rc network
ifeq ($(shell [ "true" = "$${FETCH}" ] && echo $$?), 0)
	make checkout
endif
	@docker-compose -f docker-compose.yml -p scrolliris up -d
.PHONY: up

down: rc
	@docker-compose -f docker-compose.yml -p scrolliris down
.PHONY: down

clean: rc
	@docker-compose -f docker-compose.yml -p scrolliris down \
	  --rmi local --volumes
.PHONY: down

start: up
.PHONY: start

stop: rc
	@docker-compose -f docker-compose.yml -p scrolliris stop
.PHONY: stop

restart: rc
	@docker-compose -f docker-compose.yml -p scrolliris restart
.PHONY: restart
