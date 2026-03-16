FROM php:8.3-apache

ARG USER_ID=1000
ARG GROUP_ID=1000

# System dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libwebp-dev \
    libfreetype6-dev \
    libzip-dev \
    libxml2-dev \
    libonig-dev \
    libicu-dev \
    && rm -rf /var/lib/apt/lists/*

# PHP extensions required by PrestaShop 9
RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    --with-webp \
    && docker-php-ext-install \
    pdo_mysql \
    mysqli \
    gd \
    zip \
    intl \
    mbstring \
    xml \
    bcmath \
    opcache

# Memcached extension
RUN apt-get update && apt-get install -y libmemcached-dev zlib1g-dev \
    && pecl install memcached \
    && docker-php-ext-enable memcached \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache mod_rewrite (required by PrestaShop)
RUN a2enmod rewrite

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Match host UID/GID to avoid file permission issues on Linux/WSL
RUN groupmod -g ${GROUP_ID} www-data \
    && usermod -u ${USER_ID} -g ${GROUP_ID} www-data

# PHP config
COPY php.ini /usr/local/etc/php/conf.d/prestashop.ini

# Apache config
COPY apache.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html