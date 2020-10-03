FROM php:8.0.0rc1-cli-alpine

COPY docker/ /docker

RUN apk add --no-cache \
        $PHPIZE_DEPS \
        git \
        openssh \
        vim \
    && mkdir -p /opt/php-libs  cd /opt/php-libs \
    && git clone https://github.com/krakjoe/pcov.git /opt/php-libs/pcov \
    && cd /opt/php-libs/pcov \
    && phpize \
    && ./configure --enable-pcov \
    && make \
    && make install \
    && docker-php-ext-enable pcov \
    && mv /docker/pcov.ini /usr/local/etc/php/conf.d/docker-php-pcov.ini
COPY --from=composer:1.10.13 /usr/bin/composer /usr/local/bin/composer

WORKDIR /usr/local/bauhaus

COPY ./packages .
RUN make install
