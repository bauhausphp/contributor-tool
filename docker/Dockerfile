FROM php:8.0.2-cli-alpine

WORKDIR /usr/local/bauhaus

ENV COMPOSER_HOME /var/cache/composer
ENV PATH $PATH:/usr/local/bauhaus/vendor/bin

COPY ./installs /root/
RUN sh /root/installs
