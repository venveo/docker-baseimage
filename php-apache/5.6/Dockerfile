FROM php:5.6-apache
MAINTAINER Ransom Roberson <ransom@venveo.com>

RUN echo \
   'deb ftp://ftp.us.debian.org/debian/ jessie main\n \
    deb ftp://ftp.us.debian.org/debian/ jessie-updates main\n \
    deb http://security.debian.org jessie/updates main\n' \
    > /etc/apt/sources.list

# install dependencies
RUN apt-get clean && apt-get update -y && \
    apt-get -yq install \
    wget git pwgen unzip \
    libz-dev \
    libsasl2-dev \
    libmagickwand-dev --no-install-recommends

# install extensions for PHP w/ postgres
RUN apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        php5-pgsql \
        php5-gd \
        postgresql-client \
        libpq-dev \
        && docker-php-ext-install iconv mcrypt \
        && docker-php-ext-install mbstring

# enable rewrites
RUN a2enmod rewrite

# enable header mods
RUN a2enmod headers

# enable expiration mods
RUN a2enmod expires

# install zip archive
RUN pecl install zip-1.13.5 && docker-php-ext-enable zip

# install imagick
RUN pecl install imagick-3.4.0RC4 && docker-php-ext-enable imagick

# install xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug
RUN echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

# enable pdo_mysql
RUN docker-php-ext-install pdo pdo_mysql
# enable pdo_postgres
RUN docker-php-ext-install pdo pdo_pgsql
# enable php mysql
RUN docker-php-ext-install mysql
# enable GD image processing
RUN docker-php-ext-configure gd --with-jpeg-dir \
                                  --with-png-dir \
                                  --with-freetype-dir
RUN docker-php-ext-install gd

# install memcached for shared sessions
# RUN apt-get install -y libmemcached-dev
# RUN curl -o /root/memcached.zip https://github.com/php-memcached-dev/php-memcached/archive/php7.zip -L
# RUN cd /root && unzip memcached.zip && rm memcached.zip && \
#  cd php-memcached-php && \
#  phpize && ./configure --enable-sasl && make && make install && \
#  cd /root && rm -rf /root/php-memcached-* && \
#  echo "extension=memcached.so" > /usr/local/etc/php/conf.d/memcached.ini
 # comment out SASL for now
 # echo "memcached.use_sasl = 1" >> /usr/local/etc/php/conf.d/memcached.ini

 # add our php.ini
COPY build/php.ini /usr/local/etc/php/
COPY build/000-default.conf /etc/apache2/sites-available/

# install composer
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# delete www as composer will create it
RUN rm -rf /var/www/html && mkdir -p /var/www/public

# install the boilerplate with git
# RUN cd /var/www && git init
# RUN cd /var/www && git remote add origin https://github.com/venveo/craft-boilerplate
# RUN cd /var/www && git fetch
# RUN cd /var/www && git checkout -t origin/master
# RUN cd /var/www && bash install.sh

# setup logs for apache
RUN mkdir -p /var/www/logs
RUN echo "error_log = /var/www/logs/php_error.log" > /usr/local/etc/php/conf.d/log.ini
RUN echo "log_errors = On" >> /usr/local/etc/php/conf.d/log.ini
RUN echo "" > /etc/apache2/conf-enabled/log.conf

# install blackfire
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
    && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini

# cleanup the image
RUN rm -rf /var/lib/apt/lists/*

# set the working directory
WORKDIR /var/www

# modify the www-data user
RUN usermod -u 1000 www-data
RUN chown -R www-data:www-data /var/www
# RUN chown -R www-data:www-data /var/www/config
# RUN chown -R www-data:www-data /var/www/storage

# expose ports
EXPOSE 80
# TODO look at creating a valid SSL generator
EXPOSE 443
