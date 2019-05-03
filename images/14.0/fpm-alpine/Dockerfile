FROM nextcloud:14.0-fpm-alpine

LABEL maintainer="Monogramm Maintainers <opensource at monogramm dot io>"

RUN set -ex; \
	# install the packages we need
	apk add --no-cache --virtual .build-deps \
		autoconf \
		gcc \
		g++ \
		imagemagick-dev \
		make \
		nodejs \
		nodejs-npm \
		unzip \
	; \
    \
	# Install pageres-cli globally
	npm install --global pageres-cli --unsafe-perm; \
	mkdir -p /var/www/.config; \
	chown -R "www-data:$(id -gn www-data)" /var/www/.config; \
    \
	apk del .build-deps

