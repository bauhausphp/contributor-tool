packages = $(sort $(shell cat packages.txt))

init:
	@for p in ${packages}; do [ ! -d $$p ] && git clone git@github.com:bauhausphp/$${p}.git ./packages/$${p}; done

build:
	@docker build -t bauhaus .

sh:
	@docker run -it bauhaus sh

run:
	@docker run -it bauhaus make ${command}
