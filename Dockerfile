FROM php:8.1-rc-apache

ARG uid=1000
ARG user=admin
ARG gitproject=https://github.com/Joselacerdajunior/secure-password-app.git
ARG gitprojectwget=https://github.com/Joselacerdajunior/secure-password-app/archive/9fe44f627f3cafebe1c7564e4e9715cc9b998664.zip
ARG gitprojectname=secure-password-app

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
    php artisan key:generate

USER ${user}








#RUN chown -R www-data:www-data /var/www/html && \
#    chmod -R 774 /var/www/html
#RUN chown -R www-data:www-data /var/www && \
#    chmod -R 777 /var/www
#RUN chown -R www-data:www-data /var && \
#    chmod -R 775 /var
#RUN git clone ${gitproject}

    #cd html && \
    #cp -rp ../${gitprojectname} ./


#RUN mv ./.git* ../ && \
#    mv ./.env* ../ && \
#    mv ./.editor* ../ && \
#    mv ./* ../

#RUN cd .. && \
#    rmdir ${gitprojectname} && \
#    cp .env.example .env && \
#    composer install && \
#    php artisan key:generate





#Go to the following locations and change the root folder, into a local folder in your Desktop.
#   a) /etc/apache2/sites-available/000-default.conf
#         Change "DocumentRoot /var/www/html"
#
#   b) /etc/apache2/apache2.conf
#         Find "<Directory /var/www/html/>
#                 Options Indexes FollowSymLinks
#                 AllowOverride None
#                 Require all granted
#               </Directory>"
#         And change "/var/www/html"