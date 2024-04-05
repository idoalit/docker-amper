FROM php:8.2-apache

# Define custom PHP configuration
RUN echo "post_max_size = 40M" >> /usr/local/etc/php/conf.d/custom.ini
RUN echo "upload_max_filesize = 40M" >> /usr/local/etc/php/conf.d/custom.ini
RUN echo "max_execution_time = 600" >> /usr/local/etc/php/conf.d/custom.ini

# move to tmp folder
WORKDIR /tmp

# install zip
RUN apt-get update && apt-get install -y \
    zip \
    libxml2-dev \
    libzip-dev \
    && apt-get clean

# Install zip and zml
RUN docker-php-ext-install zip xml

# install gd
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    && apt-get clean
    
RUN docker-php-ext-configure gd --with-jpeg --with-freetype 
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

# install PHPinnacle Buffer C Extension
RUN git clone https://github.com/phpinnacle/ext-buffer
RUN cd ext-buffer \
    && phpize \
    && ./configure \
    && make \
    && make install

# Install crontab
RUN apt-get update \
    && apt-get -y install cron \
    && apt-get clean

# Add crontab file
COPY crontab /etc/cron.d/crontab

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/crontab

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Start the cron service
CMD cron && tail -f /var/log/cron.log

# move to docroot
WORKDIR /var/www/html
