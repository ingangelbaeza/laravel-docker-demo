# Usamos la imagen oficial de PHP FPM con Alpine, ligera y eficiente
FROM php:8.3-fpm-alpine AS base

# Actualizamos el índice de paquetes y añadimos extensiones necesarias en una sola capa
RUN apk add --no-cache \
    bash \
    curl \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    oniguruma-dev \
    mysql-client \
    && docker-php-ext-configure gd \
    --with-freetype=/usr/include/ \
    --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) \
    pdo_mysql \
    mbstring \
    gd

# Etapa para instalar Composer sin residuos de instalación
FROM composer:latest AS composer_installer

# Copiamos solo el binario de Composer para mantener la imagen limpia
COPY --from=composer_installer /usr/bin/composer /usr/bin/composer

# Volvemos a la imagen base para continuar configurando el contenedor final
FROM base

# Definimos el directorio de trabajo
WORKDIR /var/www/html

# Copiamos el código fuente de la aplicación al contenedor
COPY ./laravel /var/www/html

# Establecemos permisos adecuados para Laravel
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage

# Exponemos el puerto predeterminado de PHP-FPM
EXPOSE 9000

# Comando por defecto para ejecutar PHP-FPM
CMD ["php-fpm"]
