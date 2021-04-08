ifndef package
$(error package was not provided)
endif

hostPackageDir = $(shell pwd)/packages/${package}
hostComposerCacheDir = $(shell pwd)/docker/.cache/composer
hostReportsDir = $(shell pwd)/reports/${package}

workDir = /usr/local/bauhaus
composerCacheDir = /var/cache/composer
reportsDir = /var/tmp/reports
coverageOutputDir = ${reportsDir}/coverage

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

sh: run = sh
sh: docker-run

tests:
	${MAKE} test-cs
	${MAKE} test-unit
	${MAKE} test-infection

fix-cs: run = phpcbf
fix-cs: docker-run

test-cs: run = phpcs -ps
test-cs: docker-run

test-unit: run = phpunit --coverage-clover ${coverageOutputDir}/clover.xml --coverage-html ${coverageOutputDir}/html
test-unit: docker-run

test-infection: run = infection -j2 -s --min-msi=100 --min-covered-msi=100 ${githubArgs}
test-infection: githubArgs = $(if ${CI},--logger-github --git-diff-filter=A --git-diff-base=origin/main)
test-infection: docker-run

coverage: run = coveralls -vvv -x ${coverageOutputDir}/clover.xml -o ${coverageOutputDir}/coveralls.json
coverage: docker-run

docker-run: tty = $(if ${CI},,-it)
docker-run:
	@docker run --rm ${tty} \
	    --name bauhausphp-dev-${package} \
	    --env-file .docker-run.env \
	    -v ${hostPackageDir}:${workDir} \
	    -v ${hostComposerCacheDir}:${composerCacheDir} \
	    -v ${hostReportsDir}:${reportsDir} \
	    ghcr.io/bauhausphp/contributor-tool:latest \
	    ${run}
