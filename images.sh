#!/usr/bin/env bash
# build the 7.0-apache image
docker build -t venveo/baseimage:7.0-apache ./php-apache

# build the 5.6-apache image
docker build -t venveo/baseimage:5.6-apache ./php-apache/5.6

# build the 5.7-mysql image
docker build -t venveo/baseimage:5.7-mysql ./mysql

# build the 1.4-memcached image
docker build -t venveo/baseimage:1.4-memcached ./memcached

# build the 3.2-redis image
docker build -t venveo/baseimage:3.2-redis ./redis

# build the 1.10-nginx image
docker build -t venveo/baseimage:1.10-nginx ./nginx

# build the 7.0-php-fpm image
docker build -t venveo/baseimage:7.0-php-fpm ./php-fpm

# build the 4.8-node-gulp image
docker build -t venveo/baseimage:4.8-node-gulp ./node/4.8-node-gulp/