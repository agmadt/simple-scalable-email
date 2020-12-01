FROM php:7.4-fpm

RUN apt-get update && \
    apt-get install -y --force-yes --no-install-recommends \
        libmemcached-dev \
        libz-dev \
        libpq-dev \
        libjpeg-dev \
        libpng-dev \
        libfreetype6-dev \
        libssl-dev \
        libmcrypt-dev \
        openssh-server \
        libmagickwand-dev \
        git \
        nano \
        libzip-dev \
        zip \
        libxml2-dev \
        supervisor
        
RUN pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis

# Install soap extention
RUN docker-php-ext-install soap

# Install for image manipulation
RUN docker-php-ext-install exif

# Install the PHP mcrypt extention (from PECL, mcrypt has been removed from PHP 7.2)
RUN pecl install mcrypt-1.0.3
RUN docker-php-ext-enable mcrypt

# Install the PHP pcntl extention
RUN docker-php-ext-install pcntl

# Install the PHP zip extention
RUN docker-php-ext-install zip

# Install the PHP pdo_mysql extention
RUN docker-php-ext-install pdo_mysql

# Install the PHP pdo_pgsql extention
RUN docker-php-ext-install pdo_pgsql

# Install the PHP bcmath extension
RUN docker-php-ext-install bcmath

#####################################
# Imagick:
#####################################

RUN pecl install imagick && \
    docker-php-ext-enable imagick

#####################################
# GD:
#####################################

# Install the PHP gd library
RUN docker-php-ext-install gd && \
    docker-php-ext-configure gd \
        --with-jpeg=/usr/lib \
        --with-freetype=/usr/include/freetype2 && \
    docker-php-ext-install gd

#####################################
# PHP Memcached:
#####################################

# Install the php memcached extension
RUN pecl install memcached && docker-php-ext-enable memcached

WORKDIR /var/www

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

# RUN composer install

# RUN usermod -u 1000 www-data