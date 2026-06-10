FROM php:8.2-apache

# system dependencies (IMPORTANT FIX)
RUN apt-get update && apt-get install -y \
    unzip \
    zip \
    libzip-dev

# PHP extensions
RUN docker-php-ext-install pdo pdo_mysql zip

# Apache rewrite enable
RUN a2enmod rewrite

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

COPY . .

# install dependencies
RUN composer install --no-dev --optimize-autoloader

# Apache point to Laravel public folder
RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!/var/www/html/public!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# permissions
RUN chown -R www-data:www-data /var/www/html/storage \
    /var/www/html/bootstrap/cache

EXPOSE 80

CMD ["apache2-foreground"]