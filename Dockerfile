# Stage 1: Composer
FROM composer:lts AS composer

WORKDIR /app

# Copy composer files
COPY composer.json composer.lock ./

# Install dependencies
RUN composer install --no-dev --no-interaction --prefer-dist --no-scripts --no-progress

# Stage 2: Application build
FROM php:8.2-fpm-alpine AS app

# Install dependencies
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && docker-php-ext-install pdo pdo_mysql \
    && apk del .build-deps

# Copy application files
WORKDIR /var/www/html
COPY --from=composer /app/vendor /var/www/html/vendor
COPY ./src /var/www/html

# Set the correct permissions
RUN chown -R www-data:www-data /var/www/html

USER www-data

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
