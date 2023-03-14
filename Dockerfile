FROM php:8.1-rc-apache

ARG UID=1000
ARG USER=josel
ARG GIT_GIT=https://github.com/Joselacerdajunior/secure-password-app.git
ARG GIT_WGET_PATH=https://github.com/Joselacerdajunior/secure-password-app/archive/9fe44f627f3cafebe1c7564e4e9715cc9b998664.zip
ARG PROJECT_NAME=secure-password-app
ARG PROJECT_PATH=/var/www/html/${PROJECT_NAME}

ENV APACHE_DOCUMENT_ROOT=/var/www/html/${PROJECT_NAME}/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    zip \
    unzip \
    vim \
    wget

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install \
    pdo_mysql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd

RUN useradd -G www-data,root -u ${UID} -d /home/${USER} ${USER} && \
    mkdir -p /home/${USER}/.composer && \
    chown -R ${USER}:${USER} /home/${USER}

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

RUN wget ${GIT_WGET_PATH} -O ${PROJECT_NAME}.zip && \
    unzip ${PROJECT_NAME}.zip && \
    rm -rf ${PROJECT_NAME}.zip && \
    mv ${PROJECT_NAME}* ${PROJECT_NAME} && \
    cd ${PROJECT_NAME} && \
    cp .env.example .env && \
    composer install && \
    php artisan key:generate && \
    cd ../html && \
    cp -r ../${PROJECT_NAME} ./ && \
    chmod -R 775 ${PROJECT_PATH}

WORKDIR /var/www

USER ${USER}