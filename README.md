# Bauhaus PHP - Dev Tool

If you are here, you might be another contributor :)

Since Bauhaus PHP is a framework composed by many libraries, this
contributor-tool helps us in managing all packages.

```shell
$ make clone-pkgs
$ make tests pkg=<package-name>
```

## How it works

For keeping consistency while developing, we should have a standard environment
that all contributors can use for performing all actions given a package name.

For solving it we have our docker image
[bauhausphp/dev](https://hub.docker.com/repository/docker/bauhausphp/dev) which
should have the most recent versions of PHP and composer (at the time this was
written, the versions were PHP 8.0.0RC3 and composer 2.0.1).

For abstracting docker run, we have created a [Makefile](Makefile) which has the
most common things we have to run:

```shell
$ make install pkg=<package-name>       # Composer install
$ make update pkg=<package-name>        # Composer update
$ make tests pkg=<package-name>         # Run composer run tests
```
