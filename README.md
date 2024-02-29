# Dockerisation Phalcon 5 / PHP / APACHE / NODEJS / POSTFIX

## Description
- 🦅 Phalcon [5.2.1](https://docs.phalcon.io/5.0/en/introduction)
- nodejs
- postfix
- 🐘 PHP 8.1
- 🗄 mariadb
### Version 
NODEJS_VERSION=20.11.0
NODE_OPTIONS=--max-old-space-size=4096

PHALCON_VERSION=5.2.1
PSR_VERSION=1.2.0
PHP_VERSION=8.1.0
COMPOSER_VERSION=2.5

#### Configuration
⚠️ You need at least 2GB of memory for Docker.

Pre-requis:

```shell
git clone projetct
cp example.env .env
vim .env
```
put your application in folder source

to start (build + up + install ):
```shell
make start
```

to build:
```shell
make build
```

to up:
```shell
make up
```

to install (exec + install):
```shell
make install
```

to log:
```shell
make logs
```

to refresh:
```shell
make refresh
```