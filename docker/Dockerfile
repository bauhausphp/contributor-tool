FROM php:8.0.0RC3-cli-alpine

COPY ./ /docker

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
    docker-php-ext-enable pcov && \
    mv /docker/pcov.ini /usr/local/etc/php/conf.d/docker-php-pcov.ini && \
    curl --silent --show-error https://getcomposer.org/installer | php -- \
        --version='2.0.6' \
        --install-dir=/usr/local/bin \
        --filename=composer

WORKDIR /usr/local/bauhaus
