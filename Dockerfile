FROM php:8.2-apache

# =========================
# SYSTEM DEPENDENCIES
# =========================
RUN apt-get update && apt-get install -y \
    unzip \
    zip \
    libzip-dev \
    curl \
    git

# =========================
# PHP EXTENSIONS
# =========================
RUN docker-php-ext-install pdo pdo_mysql zip

# =========================
# APACHE CONFIG
# =========================
RUN a2enmod rewrite

# IMPORTANT: set Laravel public folder as root
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!/var/www/html/public!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# =========================
# COMPOSER INSTALL
# =========================
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# =========================
# WORKDIR
# =========================
WORKDIR /var/www/html

# =========================
# COPY PROJECT
# =========================
COPY . .

# =========================
# INSTALL DEPENDENCIES
# =========================
RUN composer install --no-dev --optimize-autoloader

# =========================
# PERMISSIONS FIX
# =========================
RUN chown -R www-data:www-data /var/www/html/storage \
    /var/www/html/bootstrap/cache

# =========================
# PORT
# =========================
EXPOSE 80

CMD ["apache2-foreground"]