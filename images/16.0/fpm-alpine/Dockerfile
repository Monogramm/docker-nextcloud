FROM nextcloud:16.0-fpm-alpine

LABEL maintainer="Monogramm Maintainers <opensource at monogramm dot io>"

# Install samba client, node and pageres-cli
RUN set -ex; \
    apk add --no-cache \
        imagemagick \
        samba-client \
    ; \
	apk add --no-cache --virtual .build-deps \
		autoconf \
		gcc \
		g++ \
		imagemagick-dev \
        samba-dev \
		make \
		nodejs \
		nodejs-npm \
		unzip \
	; \
    pecl install smbclient; \
    docker-php-ext-enable smbclient; \
	mkdir -p /shared; \
	chown -R "www-data:$(id -gn www-data)" /shared; \
    \
	npm install --global pageres-cli --unsafe-perm; \
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
