DOCKER_IMAGE ?= "load_tests"
CONTAINER_NAME ?= "load_tests"
VOLUME_DIR ?= "/opt/loadtests"
CWD = $(shell pwd)

HOST ?= "http://127.0.0.1"
CLIENTS ?= 1
THREADS ?= 1
RAMP_TIME ?= 0
RUN_TIME ?= 60
REQUESTS ?= 1
HATCH_RATE ?= 1

all: create execute

build:
	@echo '===> [Start] Docker image build'
	@docker build -t $(DOCKER_IMAGE) .
	@echo '===> [End] Docker image build'

local:
	@$(MAKE) build
	@docker run --rm --name $(CONTAINER_NAME) -v $(CWD):$(VOLUME_DIR) -- $(DOCKER_IMAGE) locust --host=$(HOST) --clients=$(CLIENTS) --hatch-rate=$(HATCH_RATE) --run-time=$(RUN_TIME)s --no-web --only-summary

local-invokust:
	@$(MAKE) build
	@docker run --rm --name $(CONTAINER_NAME) -v $(CWD):$(VOLUME_DIR) -- $(DOCKER_IMAGE) ./local_locust.py	

create:
	@$(MAKE) build
	@docker run --rm --name $(CONTAINER_NAME) -v $(CWD):$(VOLUME_DIR) -- $(DOCKER_IMAGE) ./docker/save_lambda_function.sh

execute:
	@docker run --rm --name $(CONTAINER_NAME) -v $(CWD):$(VOLUME_DIR) -- $(DOCKER_IMAGE) ./invokr.py --function_name=locust --locust_file=locustfile.py --threads=$(THREADS) --ramp_time=$(RAMP_TIME) --locust_host=$(HOST) --time_limit=$(RUN_TIME) --locust_clients=$(CLIENTS) --locust_requests=$(REQUESTS) --hatch_rate=$(HATCH_RATE)

run:
	@docker run -it --rm --name $(CONTAINER_NAME) -v $(CWD):$(VOLUME_DIR) -- $(DOCKER_IMAGE) bash

.PHONY: all build local local-invokust create execute run
