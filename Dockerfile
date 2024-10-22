# Dockerfile
FROM php:8.2-fpm-alpine

# Instalar extensiones necesarias para Laravel
RUN apk add --no-cache \
    bash \
    curl \
    mysql-client \
    libpng-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    libxpm-dev \
    freetype-dev \
    libzip-dev \
    zip \
    unzip \
    oniguruma-dev \
    nodejs \
    npm \
    && docker-php-ext-configure gd \
    --with-jpeg \
    --with-webp \
    --with-xpm \
    --with-freetype \
    && docker-php-ext-install \
    gd \
    pdo \
    pdo_mysql \
    mbstring \
    zip \
    opcache \
    bcmath \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Establecer directorio de trabajo
WORKDIR /var/www/html

# Copiar todos los archivos del proyecto Laravel
COPY . /var/www/html

# Cambiar permisos del directorio de almacenamiento y cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Exponer el puerto 9000 para PHP-FPM
EXPOSE 9000

CMD ["php-fpm"]
