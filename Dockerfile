# Use Debian as base image
FROM debian:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies and PHP modules
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    php-mysql \
    php-gd \
    php-curl \
    php-zip \
    php-pdo \
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
    supervisor \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Enable Apache rewrite module
RUN a2enmod rewrite

# Create supervisor directory
RUN mkdir -p /var/log/supervisor

# Copy supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# PHP version fix: dynamically detect the installed version
# (Debian does not always install PHP 8.2; it's usually 7.4 or 8.1)
#RUN PHP_VER=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;") && \
#    mkdir -p /etc/php/${PHP_VER}/apache2/conf.d

COPY php.ini /etc/php/8.2/apache2/conf.d/custom.ini

# Freeradius setup
COPY setup-freeradius.sh /usr/local/bin/setup-freeradius.sh
RUN chmod +x /usr/local/bin/setup-freeradius.sh && \
    /usr/local/bin/setup-freeradius.sh

# Set working directory to Apache root
WORKDIR /var/www/html

# Download and install PHPNuxBill
RUN curl -L -o phpnuxbill.zip https://github.com/DzikrRully/phpnuxbill/archive/refs/heads/master.zip && \
    unzip phpnuxbill.zip && \
    mv phpnuxbill-master/* /var/www/html/ && \
    rm -rf phpnuxbill.zip phpnuxbill-master

# Set appropriate permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Expose HTTP, HTTPS, and FreeRADIUS ports
EXPOSE 80 443 1812/udp 1813/udp

# Declare volumes for persistent data
VOLUME ["/var/www/html", "/var/lib/mysql"]

# Start all services with supervisor
CMD ["/usr/bin/supervisord", "-n"]
