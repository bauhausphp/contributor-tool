registry = ghcr.io
image = ${registry}/bauhausphp/contributor-tool
tag ?= latest

hostPackageDir = $(shell pwd)/../packages/${package}
hostCacheDir = $(shell pwd)/../docker/.cache
hostReportsDir = $(shell pwd)/../reports/${package}

workDir = /usr/local/bauhaus
cacheDir = /var/cache
reportsDir = /var/tmp/reports

build:
	@docker build -t ${image}:${tag} .

tag:
	@docker build ${image}:${tag} ${image}:${sourceTag}

login:
	@echo ${password} | docker login ${registry} -u ${username} --password-stdin

push:
	@docker push ${image}:${tag}

pull:
	@docker pull ${image}:${tag}

run: tty = $(if ${CI},,-it)
run: handledCmd = $(subst reports/,${hostReportsDir}/,${cmd})
run:
	@docker run --rm ${tty} \
	    --name bauhausphp-dev-${package} \
	    --env-file run.env \
	    -v ${hostPackageDir}:${workDir} \
	    -v ${hostCacheDir}:${cacheDir} \
	    -v ${hostReportsDir}:${reportsDir} \
	    ${image}:${tag} \
	    ${handledCmd}
