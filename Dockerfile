# Base Image
FROM php:8.5-fpm

ARG user
ARG uid

# ---------------------------
# System dependencies
# ---------------------------
RUN apt-get update && apt-get install -y \
    coreutils \
    libzip-dev \
    libsodium-dev \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    gnupg \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ---------------------------
# PHP extensions
# ---------------------------
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip sodium

# ---------------------------
# 🟢 Install PHP Redis extension (NECESSÁRIO PARA HORIZON)
# ---------------------------
RUN pecl install redis \
    && docker-php-ext-enable redis

# ---------------------------
# Install Composer
# ---------------------------
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# ---------------------------
# Install Node.js (Vite)
# ---------------------------
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

RUN npm install -g pnpm

# ---------------------------
# Working directory
# ---------------------------
WORKDIR /var/www

# Copy project
# COPY . /var/www

# Permissions
#RUN mkdir -p /var/www/storage/logs && \
#    chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache && \
#    chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Entrypoint
#COPY docker-compose/entrypoint.sh /usr/local/bin/entrypoint.sh
#RUN chmod +x /usr/local/bin/entrypoint.sh

#ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

#EXPOSE 80

CMD ["php-fpm"]
