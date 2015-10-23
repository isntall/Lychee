FROM php:5.6-apache

# Install packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    imagemagick \
    libmagickwand-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev
# Install modules
RUN docker-php-ext-install iconv mcrypt  mysql mysqli pdo pdo_mysql exif && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install gd && \
    echo | pecl install imagick-beta

# Modify php.ini to contain the following settings:
#   max_execution_time = 200
#   post_max_size = 100M
#   upload_max_size = 100M
#   upload_max_filesize = 20M
#   memory_limit = 256M
RUN echo 'extension=imagick.so' > /usr/local/etc/php/conf.d/ext-imagick.ini
RUN echo 'max_execution_time = 200\npost_max_size = 100M\nupload_max_filesize = 20M\nupload_max_size = 100M\nmemory_limit = 256M'  >> /usr/local/etc/php/php.ini

RUN a2ensite 000-default

COPY src/commands/start /usr/local/bin/start
RUN chmod 755 /usr/local/bin/start
CMD ["/usr/local/bin/start"]
