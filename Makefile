ifndef package
$(error package was not provided)
endif

cacheDir = $(shell pwd)/docker/.cache
packageDir = $(shell pwd)/packages/${package}
reportsDir = $(shell pwd)/reports/${package}

composerCacheDir = ${cacheDir}/composer
phpunitCacheDir = ${cacheDir}/phpunit/${package}
phpunitCoverageDir = ${reportsDir}/coverage
phpunitCoverageClover = ${phpunitCoverageDir}/clover.xml
phpunitCoverageHtml = ${phpunitCoverageDir}/html

setup: clone install

clone: branch ?= main
clone: url = $(if ${CI},https://github.com/,git@github.com:)bauhausphp/${package}.git
clone:
	@git clone -b ${branch} ${url} ${packageDir}

update: cmd = update
update: composer

install: cmd = install -n
install: composer

require: cmd = require ${dep}
require: composer

composer: run = composer ${cmd}
composer: docker-run

tests: cloverOutput =
tests: htmlOutput =
tests: run = phpunit --covarage-clover ${phpunitCoverageClover} --covarage-html ${phpunitCoverageHtml}
tests: docker-run

coverage: coverageClover = -x ${phpunitCoverageClover}
coverage: run = coveralls
coverage: docker-run

sh: run = sh
sh: docker-run

docker-run: tty = $(if ${CI},,-it)
docker-run:
	@docker run --rm ${tty} \
	    --name bauhausphp-dev-${package} \
	    -v ${packageDir}:/usr/local/bauhaus \
	    -v ${composerCacheDir}:/var/cache/composer \
	    -v ${phpunitCacheDir}:/var/cache/phpunit \
	    -v ${phpunitCoverageDir}:/var/tmp/coverage \
	    ghcr.io/bauhausphp/contributor-tool:latest \
	    ${run}
