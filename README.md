[![License: AGPL v3][uri_license_image]][uri_license]
[![Build Status](https://travis-ci.org/Monogramm/docker-nextcloud.svg)](https://travis-ci.org/Monogramm/docker-nextcloud)
[![Docker Automated buid](https://img.shields.io/docker/build/monogramm/docker-nextcloud.svg)](https://hub.docker.com/r/monogramm/docker-nextcloud/)
[![Docker Pulls](https://img.shields.io/docker/pulls/monogramm/docker-nextcloud.svg)](https://hub.docker.com/r/monogramm/docker-nextcloud/)
[![](https://images.microbadger.com/badges/version/monogramm/docker-nextcloud.svg)](https://microbadger.com/images/monogramm/docker-nextcloud)
[![](https://images.microbadger.com/badges/image/monogramm/docker-nextcloud.svg)](https://microbadger.com/images/monogramm/docker-nextcloud)

# NextCloud custom Docker

Custom Docker image for NextCloud.

Provides a NextCloud with additional packages for samba, cron background tasks or Apps like NextCloud Passwords.

> [NextCloud cron Background jobs](https://docs.nextcloud.com/server/16/admin_manual/configuration_server/background_jobs_configuration.html#cron)

> [NextCloud Docker examples](https://github.com/nextcloud/docker/tree/master/.examples)

> [NextCloud Passwords](https://github.com/marius-wieschollek/passwords)

## What is NextCloud

A safe home for all your data. Access & share your files, calendars, contacts, mail & more from any device, on your terms.

> [Nextcloud.com](https://nextcloud.com/)

## Supported tags

<https://hub.docker.com/r/monogramm/docker-nextcloud/>

-   NextCloud 20.0
    -   `20.0-apache`, `20-apache`, `apache`, `20.0`, `latest` (_20.0/apache/Dockerfile_)
    -   `20.0-fpm-alpine`, `fpm-alpine` (_20.0/fpm-alpine/Dockerfile_)
    -   `20.0-fpm`, `fpm` (_20.0/fpm/Dockerfile_)

-   NextCloud 19.0
    -   `19.0-apache`, `19-apache`, `19.0`, `latest` (_19.0/apache/Dockerfile_)
    -   `19.0-fpm-alpine`, `fpm-alpine` (_19.0/fpm-alpine/Dockerfile_)
    -   `19.0-fpm`, `fpm` (_19.0/fpm/Dockerfile_)

-   NextCloud 18.0
    -   `18.0-apache`, `18-apache`,`18.0` (_18.0/apache/Dockerfile_)
    -   `18.0-fpm-alpine` (_18.0/fpm-alpine/Dockerfile_)
    -   `18.0-fpm` (_18.0/fpm/Dockerfile_)

-   NextCloud 17.0
    -   `17.0-apache`, `17-apache`, `17.0` (_17.0/apache/Dockerfile_)
    -   `17.0-fpm-alpine` (_17.0/fpm-alpine/Dockerfile_)
    -   `17.0-fpm` (_17.0/fpm/Dockerfile_)

-   NextCloud 16.0
    -   `16.0-apache`, `16-apache`, `16.0` (_16.0/apache/Dockerfile_)
    -   `16.0-fpm-alpine` (_16.0/fpm-alpine/Dockerfile_)
    -   `16.0-fpm` (_16.0/fpm/Dockerfile_)

## How to run this image ?

See NextCloud base image documentation for details.

> [Nextcloud GitHub](https://github.com/nextcloud/docker)

> [Nextcloud DockerHub](https://hub.docker.com/r/library/nextcloud/)

## Questions / Issues

If you got any questions or problems using the image, please visit our [Github Repository](https://github.com/Monogramm/docker-nextcloud) and write an issue.  

[uri_license]: http://www.gnu.org/licenses/agpl.html

[uri_license_image]: https://img.shields.io/badge/License-AGPL%20v3-blue.svg
