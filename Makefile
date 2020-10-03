packages = $(sort $(shell cat packages.txt))

init:
	@for p in ${packages}; do git clone git@github.com:bauhausphp/$${p}.git ./packages/$${p}; done

build:
	@docker build -t bauhaus .

sh:
	@docker run -it bauhaus sh

run: tty ?= yes
run: tty-arg = $(filter ${tty},yes,-it)
run:
	@docker ${tty-arg} -it bauhaus make ${command}
