FROM php:5.6-apache

# Install packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    imagemagick \
    libmagickwand-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev && \
    docker-php-ext-install iconv mcrypt  mysql mysqli pdo pdo_mysql exif  mbstring zip && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install gd && \
    echo | pecl install imagick-beta && \
    apt-get clean && \
    apt-get autoremove -y

COPY src/conf/apache2/lychee.conf /etc/apache2/sites-available/lychee.conf
COPY src/conf/php/php.ini /usr/local/etc/php/php.ini
COPY src/conf/php/conf.d/ext-imagick.ini /usr/local/etc/php/conf.d/ext-imagick.ini
COPY src/commands/start /usr/local/bin/start
RUN a2ensite lychee
RUN chmod 755 /usr/local/bin/start
CMD ["/usr/local/bin/start"]
