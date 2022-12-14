%:
	@true
.PHONY: help app bin config db docs lib spec test tmp coverage
ARGS = $(filter-out $@, $(MAKECMDGOALS))

run:
	- docker-compose run --rm ruby /bin/bash

test:
ifdef seed
	- docker-compose run --rm ruby rake test TESTOPTS='--seed=$(seed)'
else
	- docker-compose run --rm ruby rake test
endif

coverage:
	- docker-compose run --rm ruby rake coverage
