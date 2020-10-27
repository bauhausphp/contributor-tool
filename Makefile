docker-image := bauhausphp/dev:latest

clone-pkgs: pkgs = $(sort $(shell cat pkgs.txt))
clone-pkgs:
	@for p in ${pkgs}; do [ ! -d $$p ] && git clone git@github.com:bauhausphp/$${p}.git ./packages/$${p}; done

docker-build:
	docker build -t ${docker-image} ./docker

docker-login:
	docker login -u ${username} -p ${password}

docker-push:
	docker push ${docker-image}

docker-run: id = bauhausphp-${pkg}
docker-run: options-arg = -it --rm --name ${id}
docker-run: v-arg = -v $(shell pwd)/pkgs/${pkg}:/usr/local/bauhaus
docker-run:
	docker run ${options-arg} ${v-arg} bauhausphp/dev ${docker-cmd}

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
