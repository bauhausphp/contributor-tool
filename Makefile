ifndef package
$(error package was not provided)
endif

hostPackageDir = $(shell pwd)/packages/${package}
hostComposerCacheDir = $(shell pwd)/docker/.cache/composer
hostPhpunitCacheDir = $(shell pwd)/docker/.cache/phpunit/${package}
hostReportsDir = $(shell pwd)/reports/${package}

containerWorkDir = /usr/local/bauhaus
containerComposerCacheDir = /var/cache/composer
containerPhpunitCacheDir = /var/cache/phpunit
containerReportsDir = /var/tmp/reports

containerCoverageClover = ${containerReportsDir}/coverage/clover.xml
containerCoverageHtml = ${containerReportsDir}/coverage/html
containerCoverallsOutput = ${containerReportsDir}/coverage/coveralls.json

setup: clone install

clone: branch ?= main
clone: url = $(if ${CI},https://github.com/,git@github.com:)bauhausphp/${package}.git
clone:
	@git clone -b ${branch} ${url} ${hostPackageDir}

update: cmd = update
update: composer

install: cmd = install -n
install: composer

require: cmd = require ${dep}
require: composer

composer: run = composer ${cmd}
composer: docker-run

tests: run = phpunit --coverage-clover ${containerCoverageClover} --coverage-html ${containerCoverageHtml}
tests: docker-run

coverage: run = coveralls -vvv -x ${containerCoverageClover} -o ${containerCoverallsOutput}
coverage: docker-run

sh: run = sh
sh: docker-run

docker-run: tty = $(if ${CI},,-it)
docker-run:
	@docker run --rm ${tty} \
	    --name bauhausphp-dev-${package} \
	    --env-file .docker-run.env \
	    -v ${hostPackageDir}:${containerWorkDir} \
	    -v ${hostComposerCacheDir}:${containerComposerCacheDir} \
	    -v ${hostPhpunitCacheDir}:${containerPhpunitCacheDir} \
	    -v ${hostReportsDir}:${containerReportsDir} \
	    ghcr.io/bauhausphp/contributor-tool:latest \
	    ${run}
