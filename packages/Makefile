packages ?= $(shell ls -d */)

composer:
	@for p in ${packages}; do composer ${command} -d $$p; done

install: command = install --ignore-platform-reqs
install: composer

update: command = update --ignore-platform-reqs
update: composer

tests: command = run test:unit
tests: composer
