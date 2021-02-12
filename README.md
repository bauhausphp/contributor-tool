# Bauhaus PHP - Dev Tool

If you are here, you might want to contribute.

Since Bauhaus PHP is a framework composed by many libraries, this
contributor-tool helps us in managing all packages.

## How it works

For keeping consistency while developing, we should have a standard environment
used by all contributors.

For solving it we have a docker image [bauhausphp/contributor-tool/package-dev]
which should have the most recent versions of PHP and composer (at the time this
was written, the versions were PHP 8.0.2 and composer 2.0.9).

For abstracting docker run, we have a [Makefile] which has the most common
things we have to run.

## Running it

Setting up and running the tests of a new package on your local machine:

```shell
$ git clone git@github.com:bauhausphp/contributor-tool.git
$ cd contributor-tool
$ make setup package=<package-name> [branch=<branch>]
$ make tests package=<package-name>
```

The files of the package will be located inside `./packages/<package-name>`.

Here is how you can run the main composer commands:

```shell
$ make install package=<package-name>
$ make update package=<package-name>
$ make require package=<package-name> dep=<dependency-name>
```

In case you want to run the container shell:

```shell
$ make sh package=<package-name>
```

> Please, don't forget to replace `<package-name>` with the name of a package :D

[bauhausphp/contributor-tool/package-dev]: https://github.com/orgs/bauhausphp/packages/container/package/contributor-tool/package-dev
[Makefile]: Makefile
