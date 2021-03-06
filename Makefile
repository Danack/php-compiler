#!make

.PHONY: composer-install
composer-install:
	docker run -v $(shell pwd):/compiler ircmaxell/php-compiler:16.04-dev php /composer.phar install --no-ansi --no-interaction --no-progress

.PHONY: composer-update
composer-update:
	docker run -v $(shell pwd):/compiler ircmaxell/php-compiler:16.04-dev php /composer.phar update --no-ansi --no-interaction --no-progress

.PHONY: shell
shell:
	docker run -it --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v $(shell pwd):/compiler ircmaxell/php-compiler:16.04-dev /bin/bash

.PHONY: docker-build
docker-build:
	docker build -t ircmaxell/php-compiler:16.04-dev Docker/dev/ubuntu-16.04
	docker build --no-cache -t ircmaxell/php-compiler:16.04 Docker/ubuntu-16.04

.PHONY: benchmark
benchmark: rebuild-changed
	docker run -v $(shell pwd):/compiler ircmaxell/php-compiler:16.04-dev php script/bench.php

.PHONY: build
build: composer-install rebuild rebuild-examples

.PHONY: rebuild
rebuild:
	docker run -v $(shell pwd):/compiler ircmaxell/php-compiler:16.04-dev php script/rebuild.php

.PHONY: rebuild-changed
rebuild-changed:
	docker run -v $(shell pwd):/compiler ircmaxell/php-compiler:16.04-dev php script/rebuild.php onlyChanged

.PHONY: rebuild-examples
rebuild-examples:
	docker run -v $(shell pwd):/compiler ircmaxell/php-compiler:16.04-dev php script/rebuild-examples.php

.PHONY: fix
fix:
	docker run -v $(shell pwd):/compiler ircmaxell/php-compiler:16.04-dev php vendor/bin/php-cs-fixer fix --allow-risky=yes

.PHONY: phan
phan:
	docker run -v $(shell pwd):/compiler ircmaxell/php-compiler:16.04-dev php vendor/bin/phan

.PHONY: test
test: rebuild-changed
	docker run -v $(shell pwd):/compiler ircmaxell/php-compiler:16.04-dev php vendor/bin/phpunit