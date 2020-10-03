pkg = $(sort $(shell cat packages.txt))

init:
	@for p in ${pkg}; do [ ! -d $$p ] && git clone git@github.com:bauhausphp/$${p}.git ./packages/$${p}; done

build:
	@docker build -t bauhaus .

sh:
	@docker run -it bauhaus sh

run: tty ?= yes
run: tty-arg = $(filter ${tty},yes,-it)
run: v-arg = -v $(shell pwd)/packages:/usr/local/bauhaus
run: command = make ${make-target} packages='${pkg}'
run:
	@docker run ${tty-arg} ${v-arg} bauhaus ${command}

tests: make-target = tests
tests: run
