FROM php:8.2-apache

# move to tmp folder
WORKDIR /tmp

# install zip
RUN apt-get update && apt-get install -y \
    zip \
    libxml2-dev \
    libzip-dev

# Install zip and zml
RUN docker-php-ext-install zip xml

# install gd
RUN apt-get update && apt-get install -y \
    libjpeg-dev \
    libjpeg62-turbo-dev \
    libpng-dev 
RUN docker-php-ext-configure gd --with-jpeg 
RUN docker-php-ext-install -j$(nproc) gd

# install yaz
RUN apt update && \
    apt install -y --no-install-recommends git subversion autoconf build-essential && \
    apt install -y --no-install-recommends libyaz-dev && \
    rm -rf /var/lib/apt/lists/*
RUN pecl install --force yaz && \
    pecl run-tests yaz
RUN docker-php-ext-enable yaz

# install mysqli
RUN docker-php-ext-install mysqli

# install pdo
RUN docker-php-ext-install pdo pdo_mysql

# install gettext
RUN docker-php-ext-install gettext

# move to docroot
WORKDIR /var/www/html