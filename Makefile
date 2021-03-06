ifndef package
$(error package was not provided)
endif

defaultBranch = main

#
# Setup
setup: clone install

clone: dir = $(shell pwd)/packages/${package}
clone: branch ?= ${defaultBranch}
clone: url = $(if ${CI},${urlHttps},${urlGit})
clone: urlGit = git@github.com:bauhausphp/${package}.git
clone: urlHttps = https://github.com/bauhausphp/${package}.git
clone:
	@git clone -b ${branch} ${url} ${dir}

#
# Composer
update: cmd = composer update
update: run-docker

install: cmd = composer install -n
install: run-docker

require: cmd = composer require ${dep}
require: run-docker

#
# Test
tests:
	@make test-cs
	@make test-unit
	@make test-infection

test-cs: cmd = phpcs -ps
test-cs: run-docker

test-stan: cmd = phpstan analyze -c phpstan.neon
test-stan: run-docker

test-unit: cmd = phpunit $(if ${filter}, --filter=${filter}) --coverage-clover reports/clover.xml --coverage-html reports/html
test-unit: run-docker

test-infection: cmd = infection -j2 -s
test-infection: run-docker

coverage: cmd = php-coveralls -vvv $(if ${dryrun},--dry-run) -x reports/clover.xml -o reports/coveralls.json
coverage: run-docker

#
# General
run-docker:
	@make -C docker run $(if ${tag}, tag=${tag}) package=${package} cmd='${cmd}'

sh: cmd = sh
sh: run-docker

fix-cs: cmd = phpcbf
fix-cs: run-docker
