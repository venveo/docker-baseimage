## Venveo Docker Baseimages

This repository contains our default images to quickly build environments for our developers to build applications locally.

## Example docker-compose.yml

```
version: '2'
services:

        # the web container
        web-server:
            image: venveo/baseimage:7.0-apache
            volumes:
                - "./php:/var/www/public"
            ports:
                - "80:80"
                - "443:443"
            links:
                - mysql-server
                - redis-server
                - memcached-server
            depends_on:
                - mysql-server
                - redis-server
                - memcached-server
            environment:
                - APP_ENV=local
                - APP_CPTRIGGER=manage

        # mysql container
        mysql-server:
            image: venveo/baseimage:5.7-mysql
            volumes:
                - "./mysql/data:/var/lib/mysql"
            ports:
                - "3306:3306"
            environment:
                - MYSQL_ROOT_PASSWORD=TestingRootPassword
                - MYSQL_DATABASE=testing_db
                - MYSQL_USER=testing_user
                - MYSQL_PASSWORD=testing_password
                - MYSQL_ALLOW_EMPTY_PASSWORD=no

        # redis container
        redis-server:
            image: venveo/baseimage:3.2-redis
            ports:
                - "6379:6379"

        # memcached container
        memcached-server:
            image: venveo/baseimage:1.4-memcached
            ports:
                - "11211:11211"
```

## Building the Images

TODO - write up how we build the images

## Testing

TODO - write up how we test this and build details.

## Credits

* [Jason McCallister](https://github.com/themccallister)

## About Venveo

Venveo is a Digital Marketing Agency for Building Materials Companies in Blacksburg, VA. Learn more about us on [our website](https://www.venveo.com).

## License

The MIT License (MIT). Please see [License File](LICENSE) for more information.
