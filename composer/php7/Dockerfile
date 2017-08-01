FROM php
MAINTAINER Ransom Roberson <ransom@venveo.com>

RUN apt-get update && \
    apt-get install -y --no-install-recommends git zip unzip
RUN curl --silent --show-error https://getcomposer.org/installer | php && \
    mv composer.phar /bin/composer

WORKDIR /app