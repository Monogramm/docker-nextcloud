FROM nextcloud:15.0-apache

LABEL maintainer="mathieu.brunot at monogramm dot io"

RUN set -ex; \
	apt-get update -q; \
	# install the packages we need
	apt-get install -y --no-install-recommends \
		gnupg2 \
		libmagickcore-dev \
		libmagickwand-dev \
		unzip \
	; \
	# Install node
	curl -sL https://deb.nodesource.com/setup_10.x | bash -; \
	apt-get install -y --no-install-recommends \
		nodejs \
	; \
	rm -rf /var/lib/apt/lists/*; \
	# Install imagick
    pecl install imagick; \
    docker-php-ext-enable imagick; \
	# Install pageres-cli globally
	npm install --global pageres-cli --unsafe-perm; \
	mkdir -p /var/www/.config; \
	chown -R "www-data:$(id -gn www-data)" /var/www/.config

