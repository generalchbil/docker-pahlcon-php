ARG PHP_VERSION
ARG COMPOSER_VERSION

FROM composer:${COMPOSER_VERSION} AS composer
FROM php:${PHP_VERSION}-apache

ARG PSR_VERSION
ARG PHALCON_VERSION
ARG NODEJS_VERSION
ARG APP_HOST
ARG APP_HOST_ALIAS
ARG MATOMO_URL

RUN apt update && apt install -y zip unzip vim libmcrypt-dev curl pdftk && apt clean

# POSTFIX
RUN apt update && \
    apt upgrade -y && \
    apt install -y mailutils && \
    DEBIAN_FRONTEND=noninteractive apt install -y postfix \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*


# Configuration Postfix
COPY docker/php/main.cf /etc/postfix/main.cf

# install default NVM version
ENV NVM_DIR /usr/local/bin/nvm
RUN mkdir -p $NVM_DIR
RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
RUN /bin/bash -c "source $NVM_DIR/nvm.sh && nvm install ${NODEJS_VERSION} && nvm use ${NODEJS_VERSION}"

ENV NODE_PATH $NVM_DIR/versions/node/v$NODEJS_VERSION/bin
ENV PATH $NODE_PATH:$PATH

# Easy installation of PHP extensions in official PHP Docker images
# @see https://github.com/mlocati/docker-php-extension-installer
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions

# Install PHP extensions
RUN install-php-extensions xdebug pdo_mysql zip gd mcrypt soap

# Install psr
WORKDIR /tmp
RUN curl -LO https://github.com/jbboehr/php-psr/archive/v${PSR_VERSION}.tar.gz \
    && tar xzf /tmp/v${PSR_VERSION}.tar.gz \
    && docker-php-ext-install -j $(getconf _NPROCESSORS_ONLN) /tmp/php-psr-${PSR_VERSION} \
    && rm -r /tmp/v${PSR_VERSION}.tar.gz /tmp/php-psr-${PSR_VERSION}

# Install phalcon
WORKDIR /tmp
RUN curl -LO https://github.com/phalcon/cphalcon/archive/refs/tags/v${PHALCON_VERSION}.tar.gz \
    && tar xzf /tmp/v${PHALCON_VERSION}.tar.gz \
    && cd /tmp/cphalcon-${PHALCON_VERSION}/build \
    && ./install \
    && docker-php-ext-enable phalcon \
    && rm -r /tmp/v${PHALCON_VERSION}.tar.gz /tmp/cphalcon-${PHALCON_VERSION}


# Import composer and run dump
COPY --from=composer /usr/bin/composer /usr/local/bin/composer


# Copy virtual host config
COPY docker/php/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN sed -i -e 's|APP_HOST|'"${APP_HOST}"'|g' /etc/apache2/sites-available/000-default.conf &&\
    sed -i -e 's|APP_HOST_ALIAS|'"${APP_HOST_ALIAS}"'|g' /etc/apache2/sites-available/000-default.conf

ARG GID
ARG WEB_GROUPNAME
ARG UID
ARG WEB_USERNAME

# Don't run production as root
RUN groupmod --gid ${GID} ${WEB_GROUPNAME}
RUN usermod --uid ${UID} ${WEB_USERNAME}

RUN chown -R ${UID}:${GID} /var/www/html
COPY . /var/www/html
WORKDIR /var/www/html

EXPOSE 80
EXPOSE 443


# Import setup script
COPY docker/php/deploy.sh /usr/local/bin/deploy.sh
RUN chmod +x /usr/local/bin/deploy.sh
RUN a2enmod headers
RUN a2enmod rewrite

COPY docker/php/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]