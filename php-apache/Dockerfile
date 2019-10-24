FROM php:7.0-apache
MAINTAINER Ransom Roberson <ransom@venveo.com>

ARG BLD_PKGS="libfreetype6-dev libjpeg62-turbo-dev libpng12-dev libxml2-dev libmcrypt-dev libpq-dev libicu-dev unzip wget libz-dev libsasl2-dev libmagickwand-dev libmemcached-dev"
ARG PHP_EXTS="pdo pdo_pgsql pdo_mysql pgsql gd mysqli intl iconv mcrypt mbstring soap"

RUN echo \
   'deb ftp://ftp.us.debian.org/debian/ jessie main\n \
    deb ftp://ftp.us.debian.org/debian/ jessie-updates main\n \
    deb http://security.debian.org jessie/updates main\n' \
    > /etc/apt/sources.list

# install dependencies
RUN apt-get update && \
    apt-get -y install $BLD_PKGS \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql

# install extensions for PHP
RUN docker-php-ext-install $PHP_EXTS

# enable rewrites and headers
RUN a2enmod rewrite \
    && a2enmod headers

# install imagick, zip, and xdebug
RUN pecl install imagick-3.4.0RC4 zip-1.13.5 xdebug \
 && docker-php-ext-enable imagick zip xdebug

COPY build/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# install memcached for shared sessions
RUN curl -o /root/memcached.zip https://github.com/php-memcached-dev/php-memcached/archive/php7.zip -L
RUN cd /root && unzip memcached.zip && rm memcached.zip && \
 cd php-memcached-php7 && \
 phpize && ./configure --enable-sasl && make && make install && \
 cd /root && rm -rf /root/php-memcached-* && \
 echo "extension=memcached.so" > /usr/local/etc/php/conf.d/memcached.ini
 # comment out SASL for now
 # echo "memcached.use_sasl = 1" >> /usr/local/etc/php/conf.d/memcached.ini

 # add our php.ini
COPY build/php.ini /usr/local/etc/php/
COPY build/000-default.conf /etc/apache2/sites-available/

# install composer
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# delete www as composer will create it
RUN rm -rf /var/www/html && mkdir -p /var/www/public

# setup logs for apache
RUN mkdir -p /var/www/logs
RUN echo "error_log = /var/www/storage/logs/php_error.log" > /usr/local/etc/php/conf.d/log.ini
RUN echo "log_errors = On" >> /usr/local/etc/php/conf.d/log.ini
RUN echo "" > /etc/apache2/conf-enabled/log.conf

RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=2'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

# cleanup the image
RUN rm -rf /var/lib/apt/lists/*

# set the working directory
WORKDIR /var/www

# modify the www-data user
RUN usermod -u 1000 www-data \
    && mkdir /var/www/storage \
    && chmod 700 /var/www/storage \
    && chown -R www-data:www-data /var/www

# expose ports
EXPOSE 80
# TODO look at creating a valid SSL generator
EXPOSE 443
EXPOSE 9000