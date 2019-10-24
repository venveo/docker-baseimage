# Versions 3.8 and 3.7 are current stable supported versions.
FROM alpine:3.9
MAINTAINER Ransom Roberson <ransom@venveo.com>

ENV PHP_INI_DIR /etc/php/7.3
ENV COMPOSER_ALLOW_SUPERUSER=1

ARG DEPS="\
        php7.3 \
        imagemagick \
        php7.3-phar \
        php7.3-bcmath \
        php7.3-calendar \
        php7.3-mbstring \
        php7.3-exif \
        php7.3-ftp \
        php7.3-openssl \
        php7.3-zip \
        php7.3-sysvsem \
        php7.3-sysvshm \
        php7.3-sysvmsg \
        php7.3-shmop \
        php7.3-sockets \
        php7.3-zlib \
        php7.3-bz2 \
        php7.3-curl \
        php7.3-simplexml \
        php7.3-xml \
        php7.3-pdo \
        php7.3-pdo_mysql \
        php7.3-pdo_pgsql \
        php7.3-imagick \
        php7.3-opcache \
        php7.3-dom \
        php7.3-xmlreader \
        php7.3-xmlwriter \
        php7.3-tokenizer \
        php7.3-ctype \
        php7.3-session \
        php7.3-fileinfo \
        php7.3-iconv \
        php7.3-json \
        php7.3-posix \
        php7.3-apache2 \
        curl \
        ca-certificates \
        runit \
        apache2 \
"

# PHP.earth Alpine repository for better developer experience
ADD https://repos.php.earth/alpine/phpearth.rsa.pub /etc/apk/keys/phpearth.rsa.pub

RUN set -x \
    && echo "https://repos.php.earth/alpine/v3.9" >> /etc/apk/repositories \
    && apk add --no-cache $DEPS \
    && mkdir -p /run/apache2 \
    && ln -sf /dev/stdout /var/log/apache2/access.log \
    && ln -sf /dev/stderr /var/log/apache2/error.log


# Add basics first
#RUN apk add --update bash apache2 curl ca-certificates openssl openssh git tzdata openntpd nano

# Add apache to run and configure
RUN mkdir -p /run/apache2 \
    && sed -i "s/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ session_module/LoadModule\ session_module/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ session_cookie_module/LoadModule\ session_cookie_module/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ session_crypto_module/LoadModule\ session_crypto_module/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ deflate_module/LoadModule\ deflate_module/" /etc/apache2/httpd.conf \
    && sed -i "s#^DocumentRoot \".*#DocumentRoot \"/app/web\"#g" /etc/apache2/httpd.conf \
    && sed -i "s#/var/www/localhost/htdocs#/app/web#" /etc/apache2/httpd.conf \
    && printf "\n<Directory \"/app/web\">\n\tAllowOverride All\n</Directory>\n" >> /etc/apache2/httpd.conf

RUN mkdir /app && mkdir /app/web && chown -R apache:apache /app && chmod -R 755 /app && mkdir bootstrap
ADD bootstrap/start.sh /bootstrap/
RUN chmod +x /bootstrap/start.sh

EXPOSE 80
EXPOSE 443
ENTRYPOINT ["/bootstrap/start.sh"]