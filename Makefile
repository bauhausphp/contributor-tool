ifndef package
$(error package was not provided)
endif

packageDir = $(shell pwd)/packages/${package}
composerCacheDir = $(shell pwd)/docker/.cache/composer

setup: clone install

clone: branch ?= main
clone:
	@git clone \
        -b ${branch} \
        git@github.com:bauhausphp/${package} \
        ${packageDir}

update: composerCmd = update
update: composer

install: composerCmd = install -n
install: composer

require: composerCmd = require ${dep}
require: composer

tests: composerCmd = run test:unit
tests: composer

composer: cmd = composer ${composerCmd}
composer: docker-run

sh: cmd = sh
sh: docker-run

docker-run:
	@docker run --rm -it \
	    --name bauhausphp-dev-${package} \
	    -v ${packageDir}:/usr/local/bauhaus \
	    -v ${composerCacheDir}:/var/cache/composer \
	    ghcr.io/bauhausphp/contributor-tool/package-dev:latest \
	    ${cmd}
