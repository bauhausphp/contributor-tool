docker-image := bauhausphp/dev:latest
pkg-dir = $(shell pwd)/pkgs/${pkg}
composer-cache-dir = $(shell pwd)/docker/.cache/composer

setup: clone install

clone: branch ?= main
clone: repo = git@github.com:bauhausphp/${pkg}.git
clone:
	rm -rf ${pkg-dir}
	git clone -b ${branch} ${repo} ${pkg-dir}

sh: cmd = sh
sh: docker-run

composer: cmd = composer ${composer-cmd}
composer: docker-run

update: composer-cmd = update
update: composer

install: composer-cmd = install -n
install: composer

require: composer-cmd = require ${dep}
require: composer

tests: composer-cmd = run test:unit
tests: composer

#
# Docker commands

docker-build:
	@docker build -t ${docker-image} ./docker

docker-login:
	@docker login -u ${username} -p ${password}

docker-push:
	@docker push ${docker-image}

docker-run: options := -it --rm --name bauhausphp-${pkg}
docker-run: volumes := -v ${pkg-dir}:/usr/local/bauhaus
docker-run: volumes += -v ${composer-cache-dir}:/var/cache/composer
docker-run:
	docker run ${options} ${volumes} ${docker-image} ${cmd}
