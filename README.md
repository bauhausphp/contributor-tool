# Bauhaus PHP - Dev Tool

If you are here, you might want to contribute.

Bauhaus PHP is a framework composed by many packages. This
repository, `contributor-tool`, helps us in managing all of those packages.

## How it works

For keeping consistency while developing, we should have a standard environment
used by all contributors.

For solving it we have a docker image [bauhausphp/contributor-tool/package-dev]
which should have the most recent versions of PHP and composer (at the time this
was written, the versions were PHP 8.0.2 and composer 2.0.9).

On the other hand, there is a [Makefile] for abstracting docker run and other 
commands.

## Run it

1. Clone `contributor-tool` repository:

    ```shell
    $ git clone git@github.com:bauhausphp/contributor-tool.git
    $ cd contributor-tool
    ```

2. Setting up a package and running its tests:

    ```shell
    $ make setup package=<package-name> [branch=<branch>]
    $ make tests package=<package-name>
    ```

    The files of the package will be located inside `./packages/<package-name>`.

3. Running main composer commands:

    ```shell
    $ make install package=<package-name>
    $ make update package=<package-name>
    $ make require package=<package-name> dep=<dependency-name>
    ```

4. Running the container using shell with the package code in it:

   ```shell
   $ make sh package=<package-name>
   ```

> Please, don't forget to replace `<package-name>` with the name of a package :D

[bauhausphp/contributor-tool/package-dev]: https://github.com/orgs/bauhausphp/packages/container/package/contributor-tool/package-dev
[Makefile]: Makefile
