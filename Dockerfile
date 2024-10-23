# Dockerfile
FROM php:8.2-fpm-alpine

# Variables de entorno para la instalación
ENV COMPOSER_HOME=/composer

# Instalar dependencias del sistema y extensiones PHP requeridas por Laravel
RUN apk add --no-cache \
    bash curl mysql-client libpng-dev \
    libjpeg-turbo-dev libwebp-dev libxpm-dev \
    freetype-dev libzip-dev zip unzip \
    oniguruma-dev nodejs npm \
    && docker-php-ext-configure gd \
        --with-jpeg --with-webp --with-xpm --with-freetype \
    && docker-php-ext-install -j$(nproc) \
        gd pdo pdo_mysql mbstring zip opcache bcmath \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Establecer directorio de trabajo
WORKDIR /var/www/html

# Copiar los archivos de configuración y dependencias primero (para usar la caché)
COPY composer.json composer.lock /var/www/html/

# Instalar las dependencias de Laravel
RUN composer install --no-dev --prefer-dist --no-scripts --no-autoloader \
    && rm -rf /composer/cache

# Copiar el resto del proyecto Laravel
COPY . /var/www/html

# Cambiar permisos del directorio de almacenamiento y cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Exponer el puerto 9000 para PHP-FPM
EXPOSE 9000

# Comando por defecto al iniciar el contenedor
CMD ["php-fpm"]
