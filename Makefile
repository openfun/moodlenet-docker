# -- Docker
COMPOSE              = docker-compose

default: help

bootstrap: ## Bootstrap MoodleNet
bootstrap: \
	build \
	run
.PHONY: bootstrap


build: ## Build frontend image
	@$(COMPOSE) build app
.PHONY: build

run: ## Run all docker service
	@$(COMPOSE) up -d
.PHONY: run

stop: ## Stop docker services
	@$(COMPOSE) stop
.PHONY: stop

down: ## Destroy all the docker-compose stack
	@$(COMPOSE) down
.PHONY: down

logs: ## Follow all containers logs
	@$(COMPOSE) logs -f
.PHONY: logs

shell: ## Runs an iex console
	@$(COMPOSE) exec backend bin/moodle_net remote
.PHONY: shell

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help
