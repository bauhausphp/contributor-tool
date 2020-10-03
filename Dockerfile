FROM php:8.0.0rc1-cli-alpine

WORKDIR /usr/local/bauhaus

COPY docker/* /opt/php-libs/files/

RUN apk add --no-cache $PHPIZE_DEPS git openssh vim
RUN cd /opt/php-libs \
    && git clone https://github.com/krakjoe/pcov.git \
    && cd pcov \
    && phpize \
    && ./configure --enable-pcov \
    && make \
    && make install \
    && docker-php-ext-enable pcov \
    && mv /opt/php-libs/files/pcov.ini /usr/local/etc/php/conf.d/docker-php-pcov.ini
RUN curl --silent --show-error https://getcomposer.org/installer | php -- \
        --version=1.10.13 \
        --install-dir=/usr/local/bin \
        --filename=composer

COPY ./packages .
RUN make install
