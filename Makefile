%:
	@true
.PHONY: help app bin config db docs lib spec test tmp coverage
ARGS = $(filter-out $@, $(MAKECMDGOALS))

run:
	- docker-compose run --rm ruby /bin/bash

test:
	- docker-compose run --rm ruby rake test

coverage:
	- docker-compose run --rm ruby rake coverage
