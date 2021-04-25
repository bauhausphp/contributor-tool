FROM php:8.0.3-cli-alpine

ENV COMPOSER_HOME /usr/local/composer
ENV PATH $PATH:$COMPOSER_HOME/vendor/bin:/usr/local/bauhaus/vendor/bin

RUN apk add --no-cache \
    $PHPIZE_DEPS \
        git \
        openssh \
        vim && \
    # PCOV
    mkdir -p /opt/php-libs  cd /opt/php-libs && \
    git clone https://github.com/krakjoe/pcov.git /opt/php-libs/pcov && \
    cd /opt/php-libs/pcov && \
    phpize && \
    ./configure --enable-pcov && \
    make && \
    make install && \
    docker-php-ext-enable pcov && \
    # composer
    curl -sS https://getcomposer.org/installer | php -- \
        --version=2.0.12 \
        --install-dir=/usr/local/bin \
        --filename=composer

COPY composer.* $COMPOSER_HOME/
RUN composer global install --prefer-dist --no-cache --no-autoloader
