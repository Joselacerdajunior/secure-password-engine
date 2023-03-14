FROM php:8.1-rc-apache

ARG uid=1000
ARG user=josel
ARG gitproject=https://github.com/Joselacerdajunior/secure-password-app.git
ARG gitprojectwget=https://github.com/Joselacerdajunior/secure-password-app/archive/9fe44f627f3cafebe1c7564e4e9715cc9b998664.zip
ARG gitprojectname=secure-password-app
ARG projectpath=/var/www/html/${gitprojectname}
ENV APACHE_DOCUMENT_ROOT=/var/www/html/${gitprojectname}/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    zip \
    unzip \
    vim \
    wget

RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd
RUN useradd -G www-data,root -u ${uid} -d /home/${user} ${user}
RUN mkdir -p /home/${user}/.composer && \
    chown -R ${user}:${user} /home/${user}

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

RUN wget ${gitprojectwget} -O ${gitprojectname}.zip && \
    unzip ${gitprojectname}.zip && \
    rm -rf ${gitprojectname}.zip && \
    mv ${gitprojectname}* ${gitprojectname} && \
    cd ${gitprojectname} && \
    cp .env.example .env && \
    composer install && \
    php artisan key:generate && \
    cd ../html && \
    cp -r ../${gitprojectname} ./ && \
    chmod -R 775 ${projectpath}


WORKDIR /var/www

USER ${user}