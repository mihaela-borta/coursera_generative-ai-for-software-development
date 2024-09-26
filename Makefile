.PHONY: help
.DEFAULT_GOAL := help

# provide ENV=dev to use .env.dev instead of .env
ENV_LOADED :=

ifeq ($(ENV), prod)
	ifneq (,$(wildcard .env))
		include .env
		@cat /.env
		export
				ENV_LOADED := Loaded config from .env
    endif
else
	ifneq (,$(wildcard .env.dev))
		include .env.dev
		export
				ENV_LOADED := Loaded config from .env.dev
	endif
endif


.PHONY: print-env
print-env:
	@printenv


help: logo ## get a list of all the targets, and their short descriptions
	@# source for the incantation: https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | awk 'BEGIN {FS = ":.*?##"}; {printf "\033[1;38;5;214m%-12s\033[0m %s\n", $$1, $$2}'

##########################
IMAGE_NAME := genai-for-sw
CONTAINER_NAME := genai-for-sw


build:
	DOCKER_BUILDKIT=1 docker build -t $(IMAGE_NAME) .

build-clean:
	DOCKER_BUILDKIT=1 docker build --no-cache -t $(IMAGE_NAME) .

run:
	docker run --name $(CONTAINER_NAME) \
  --rm \
  -p 8080:8080 \
  -v ./data:/app/data \
  -v ./src:/app/src \
  -v ./config:/app/config \
  $(IMAGE_NAME) \
  python -m jupyterlab --ip 0.0.0.0 --port 8080 --no-browser --allow-root


cleanup:
	docker stop $(CONTAINER_NAME)
	docker rm $(CONTAINER_NAME)

	docker rmi $(CONTAINER_NAME)

	docker container prune -f

	docker image prune -a -f

cleanup-all: ## clean-up all docker related stuff from the system
	docker system prune -a

logo:  ## prints the logo
	@cat logo.txt; echo "\n"