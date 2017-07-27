# php-fpm + nginx docker example

This project uses a base image from `base/` folder to build a php project with `ONBUILD` directive

ENTRYPOINT directive seems not to be registered by heroku platform.

## How to build this example project
```
$ cd base
$ docker build -t pihvio/php-nginx-base .
$ cd ..
$ heroku container:push web
```