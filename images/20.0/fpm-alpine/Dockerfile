FROM nextcloud:20.0-fpm-alpine

LABEL maintainer="Monogramm Maintainers <opensource at monogramm dot io>"

# Install samba client, node and pageres-cli
RUN set -ex; \
    apk add --no-cache \
        imagemagick \
        samba-client \
        nodejs \
        npm \
        unzip \
    ; \
    apk add --no-cache --virtual .build-deps \
        autoconf \
        gcc \
        g++ \
        imagemagick-dev \
        samba-dev \
        make \
    ; \
    pecl uninstall imagick; \
    pecl install imagick; \
    pecl install smbclient; \
    docker-php-ext-enable smbclient; \
    mkdir -p /shared; \
    chown -R "www-data:$(id -gn www-data)" /shared; \
    \
    npm install --global pageres-cli@4.1.0 --unsafe-perm; \
    mkdir -p /var/www/.config; \
    chown -R "www-data:$(id -gn www-data)" /var/www/.config; \
    \
    runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )"; \
    apk add --virtual .nextcloud-phpext-rundeps $runDeps; \
    apk del .build-deps
