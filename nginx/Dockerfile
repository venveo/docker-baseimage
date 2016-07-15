FROM nginx:1.10
MAINTAINER Jason McCallster <jason@venveo.com>

# copy the configuration files
ADD build/nginx.conf /etc/nginx/
ADD build/application.conf /etc/nginx/sites-available/default

# set the upstream to use php-fpm
RUN echo "upstream php-upstream { server php-fpm:9000; }" > /etc/nginx/conf.d/upstream.conf

# modify the user
RUN usermod -u 1000 www-data

# set permissions on application directory
RUN chown -R www-data:www-data /var/www

# set the working directory
WORKDIR /usr/share/nginx

# run the nginx command
CMD ["nginx"]

# expose the ports
EXPOSE 80 443
