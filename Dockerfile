# Use Debian as base image
FROM debian:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install Apache, PHP, and required PHP extensions
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    php-mysql \
    php-gd \
    php-curl \
    php-zip \
    php-pdo \
    php-pdo-mysql \
    libapache2-mod-php \
    unzip \
    curl \
    git \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    zlib1g-dev \
    libzip-dev \
    zip \
    nano \
    cron \
    freeradius \
    freeradius-mysql \
    freeradius-utils \
    freeradius-rest \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache rewrite module
RUN a2enmod rewrite


# Set working directory to Apache root
WORKDIR /var/www/html

# Set persistent volume
VOLUME /var/www/html

# Download and install PHPNuxBill (replace with latest URL or use git clone)
RUN curl -L -o phpnuxbill.zip https://github.com/hotspotbilling/phpnuxbill/archive/refs/heads/master.zip && \
    unzip phpnuxbill.zip && \
    mv phpnuxbill-master/* /var/www/html/ && \
    rm -rf phpnuxbill.zip phpnuxbill-master

# Set appropriate permissions
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# Expose HTTP, HTTPS & FreeRadius port
EXPOSE 80 443 1812/UDP 1813/UDP

# Start Apache in foreground
CMD ["apachectl", "-D", "FOREGROUND"]
