docker-image = bauhausphp-dev
pkgs-dir = $(shell pwd)/pkgs

clone-pkgs: pkgs = $(sort $(shell cat pkgs.txt))
clone-pkgs:
	@for p in ${pkgs}; do [ ! -d $$p ] && git clone git@github.com:bauhausphp/$${p}.git ./packages/$${p}; done

docker-build: docker-tag = ${docker-image}$(if ${tag},:${tag})
docker-build:
	@docker build --tag ${docker-tag} ./docker

docker-publish:
	@docker build -t ${docker-image} ./docker

docker-run: id = ${docker-image}-${pkg}
docker-run: options-arg = -it --rm --name ${id}
docker-run: v-arg = -v ${pkgs-dir}/${pkg}:/usr/local/bauhaus
docker-run:
	docker run ${options-arg} ${v-arg} ${docker-image} ${docker-cmd}

composer: docker-cmd = composer ${composer-cmd}
composer: docker-run

update: composer-cmd = update
update: composer

install: composer-cmd = install
install: composer

require: composer-cmd = require ${dep}
require: composer

tests: composer-cmd = run test:unit
tests: composer

sh: docker-cmd = sh
sh: docker-run
