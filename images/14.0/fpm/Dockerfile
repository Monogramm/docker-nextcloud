FROM nextcloud:14.0-fpm

LABEL maintainer="Monogramm Maintainers <opensource at monogramm dot io>"

# Install samba client, node and pageres-cli
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
RUN set -ex; \
    \
    savedAptMark="$(apt-mark showmanual)"; \
    \
	apt-get update -q -y; \
	apt-get install -y --no-install-recommends \
		gnupg2 \
		libmagickcore-dev \
        libmagickcore-6.q16-3-extra \
		libmagickwand-dev \
		libsmbclient-dev \
		smbclient \
		unzip \
        wfrench \
        wngerman \
        wbritish \
        wspanish \
        witalian \
        wamerican \
        wportuguese \
        xfonts-base \
        xfonts-75dpi \
	; \
    pecl uninstall imagick; \
    pecl install imagick; \
    pecl install smbclient; \
    docker-php-ext-enable smbclient; \
	mkdir -p /shared; \
	chown -R "www-data:$(id -gn www-data)" /shared; \
    \
	curl -sL https://deb.nodesource.com/setup_10.x | bash -; \
	apt-get install -y --no-install-recommends \
		nodejs \
	; \
	npm install --global pageres-cli@4.1.0 --unsafe-perm; \
	mkdir -p /var/www/.config; \
	chown -R "www-data:$(id -gn www-data)" /var/www/.config; \
    \
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark; \
    ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
        | awk '/=>/ { print $3 }' \
        | sort -u \
        | xargs -r dpkg-query -S \
        | cut -d: -f1 \
        | sort -u \
        | xargs -rt apt-mark manual; \
    \
    apt-get clean; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*
