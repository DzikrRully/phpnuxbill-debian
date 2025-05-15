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
    libapache2-mod-php \
    unzip \
    curl \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache rewrite module
RUN a2enmod rewrite

# Set working directory to Apache root
WORKDIR /var/www/html

# Download and install PHPNuxBill (replace with latest URL or use git clone)
RUN curl -L -o phpnuxbill.zip https://github.com/phpnuxbill/phpnuxbill/archive/refs/heads/master.zip && \
    unzip phpnuxbill.zip && \
    mv phpnuxbill-master/* /var/www/html/ && \
    rm -rf phpnuxbill.zip phpnuxbill-master

# Expose HTTP port
EXPOSE 80

# Start Apache in foreground
CMD ["apachectl", "-D", "FOREGROUND"]
