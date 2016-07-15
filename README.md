# Venveo Docker Baseimages

This repository contains our default images to quickly build environments for our developers to build applications locally.

_**Note**: This is built using Docker for Mac or Docker for Windows. If you have any problems using this, please file an issue on this repository._

## Usage

**Install** Docker for Mac or Docker for Windows

**Add a docker-compose file**, you can use the example [`docker-compose.yml`](#example-docker-composeyml) , to the root of your project

**Change the `volumes` for the mysql-server container** in `docker-compose.yml` to be relative to your project (e.g in Craft CMS projects, we usually set the volumes to use `"./craft/storage/database:/var/lib/mysql"`). This ensures that the database is maintained throughout the Docker containers lifecycle. Here is what the `volumes` could look like:

```
volumes:
    - "./craft/storage/database:/var/lib/mysql"
```

**Add mysql-server volume to be ignored** from your repository, you can add a `.gitignore` in that directory that contains the following:

```
*
!.gitignore
```

**Change the `volumes` on the `web-server` container** to include your project files, assuming you have the compose file in the root, the `volumes` would look similar to this:

```
volumes:
    - ".:/var/www"
```

**Set any environment variables** you wish to use in the `web-server` container under the
`environment` key like so:

```
environment:
    APP_URL: http://localhost
    DB_HOST: mysql-server
    DB_USER: example_username_set_in_mysql_server
    DB_PASS: example_password_set_in_mysql_server
    DB_NAME: example_database_set_in_mysql_server
```

**Start the containers** by running `docker-compose up -d` (the -d flag makes the containers run in the background, remove the flag if you want to control the containers by keeping the terminal window open)

### Running Only Specific Containers

If you are using the provided `docker-compose.yml` and do not wish to utilize the `redis` or `memcached` servers, you can pass the container names to the `up` command to only start whats required, like so:

```
docker-compose up -d web-server mysql-server
```

Also, you can simply remove those services from the `docker-compose.yml` file, but make sure that you remove the containers from the web-servers `depends_on` and `links` to avoid errors.

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
                - APP_CPTRIGGER=admin

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
