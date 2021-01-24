FROM php:8.0.1-cli-alpine

WORKDIR /usr/local/bauhaus

COPY --from=composer:2.0.8 /usr/bin/composer /usr/bin/composer
ENV COMPOSER_HOME /var/cache/composer

RUN apk add --no-cache \
        $PHPIZE_DEPS \
        git \
        openssh \
        vim && \
    mkdir -p /opt/php-libs  cd /opt/php-libs && \
    git clone https://github.com/krakjoe/pcov.git /opt/php-libs/pcov && \
    cd /opt/php-libs/pcov && \
    phpize && \
    ./configure --enable-pcov && \
    make && \
    make install && \
    docker-php-ext-enable \
        pcov
