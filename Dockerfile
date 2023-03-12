FROM php:8.1-rc-apache

ARG uid=1000
ARG user=admin
ARG gitproject=https://github.com/Joselacerdajunior/secure-password.git
ARG gitprojectname=secure-password
ARG gitprojectnamepath=secure-password/secure-password-app

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    zip \
    unzip \
    vim

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd -G www-data,root -u ${uid} -d /home/${user} ${user}

RUN mkdir -p /home/${user}/.composer && \
    chown -R ${user}:${user} /home/${user}

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

USER root

RUN cd /var/www && \
    git clone ${gitproject} && \
    mv /var/www/${gitprojectnamepath} /var/www/html && \
    cd /var/www/html

USER ${user}

RUN composer install

RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 774 /var/www/html

WORKDIR /var/www