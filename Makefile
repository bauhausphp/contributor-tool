ifndef package
$(error package was not provided)
endif

packageDir = $(shell pwd)/packages/${package}
templateDir = $(shell pwd)/packages/.template
composerCacheDir = $(shell pwd)/docker/.cache/composer

setup: clone #install

clone: branch ?= main
clone: url = $(if ${CI},https://github.com/,git@github.com:)bauhausphp/${package}.git
clone:
	echo @git clone -b ${branch} ${url} ${packageDir}

update: cmd = update
update: composer

install: cmd = install -n
install: composer

require: cmd = require ${dep}
require: composer

tests: cmd = run tests
tests: composer

composer: run = composer ${cmd}
composer: docker-run

sh: run = sh
sh: docker-run

docker-run:
	@docker run --rm -it \
	    --name bauhausphp-dev-${package} \
	    -v ${packageDir}:/usr/local/bauhaus \
	    -v ${composerCacheDir}:/var/cache/composer \
	    ghcr.io/bauhausphp/contributor-tool/package-dev:latest \
	    ${run}
