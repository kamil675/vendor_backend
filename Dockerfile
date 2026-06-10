FROM php:8.2-apache

# install dependencies
RUN docker-php-ext-install pdo pdo_mysql

# enable apache rewrite
RUN a2enmod rewrite

WORKDIR /var/www/html

COPY . .

# permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80