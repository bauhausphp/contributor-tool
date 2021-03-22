FROM php:8.0.3-cli-alpine

WORKDIR /usr/local/bauhaus

ENV COMPOSER_HOME /usr/local/composer
ENV PATH $PATH:$COMPOSER_HOME/vendor/bin:/usr/local/bauhaus/vendor/bin

COPY ./installs /root/
RUN sh /root/installs
