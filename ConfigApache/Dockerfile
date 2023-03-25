FROM php:8.1-rc-apache

ARG UID
ARG USER
ARG GITHUB_PROJECT_URL
ARG GIT_WGET_PATH
ARG GITHUB_PROJECT_NAME
ARG PROJECT_PATH

ENV APACHE_DOCUMENT_ROOT=/var/www/html/${GITHUB_PROJECT_NAME}/public
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

#RUN wget ${GIT_WGET_PATH} -O ${GITHUB_PROJECT_NAME}.zip && \
#    unzip ${GITHUB_PROJECT_NAME}.zip && \
#    rm -rf ${GITHUB_PROJECT_NAME}.zip && \
#    mv ${GITHUB_PROJECT_NAME}* ${GITHUB_PROJECT_NAME} && \
#    cd ${GITHUB_PROJECT_NAME} && \
#    cp .env.example .env && \
#    composer install && \
#    php artisan key:generate && \
#    cd ../html && \
#    rm -rf ../${GITHUB_PROJECT_NAME} && \
#    cp -r ../${GITHUB_PROJECT_NAME} ./ && \
#    chmod -R 775 ${PROJECT_PATH}
	

RUN cd html && \
	git clone ${GITHUB_PROJECT_URL} && \
    cd ${GITHUB_PROJECT_NAME} && \
	git pull && \
	git config --global --add safe.directory /var/www/html/${GITHUB_PROJECT_NAME} && \
	git config --global pull.ff only && \
    cp .env.example .env && \
    composer install && \
    php artisan key:generate && \
    chmod -R 775 ${PROJECT_PATH}

WORKDIR /var/www/html

USER ${USER}