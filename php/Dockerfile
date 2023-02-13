FROM --platform=linux php:7.4.24-apache
STOPSIGNAL SIGTERM
#RUN ["/bin/bash", "-c" ]
#CMD ["/bin/bash"]
#SHELL ["/bin/bash", "-c"]

RUN ["/bin/bash", "-c", "apt-get update 2>&1"]


#RUN apt-get update
#RUN apt-get install -y --no-install-recommends locales default-mysql-client
#RUN apt-get install -y --no-install-recommends bzip2 libbz2-dev libfreetype6-dev libjpeg62-turbo-dev
#RUN apt-get install -y --no-install-recommends libpng-dev libicu-dev libxml2-dev libxslt-dev
#RUN apt-get install -y --no-install-recommends libzip-dev libwebp-dev
#
#
#
#RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp
#RUN docker-php-ext-install -j$(nproc) bcmath bz2 calendar dba exif
#RUN docker-php-ext-install -j$(nproc)  fileinfo gd gettext intl pdo pdo_mysql mbstring
#RUN docker-php-ext-install -j$(nproc)  soap sockets opcache xmlrpc xsl zip
#
#
#CMD apt-get update && \
#    apt-get install -y libxml2-dev
#CMD docker-php-ext-install soap && docker-php-ext-enable soap
#
## Configuracao Locales e Timezone do container
#CMD ln -f -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
#    && printf 'pt_BR.UTF-8 UTF-8\n' >> /etc/locale.gen \
#    && printf 'pt_BR ISO-8859-1\n' >> /etc/locale.gen \
#    && locale-gen
#
## Instala Redis cache
#CMD pecl install redis-5.3.7 \
#    && docker-php-ext-enable redis
#
## Instala New Relic
#CMD apt-get update && apt-get install -y --no-install-recommends gnupg2
#CMD echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | tee /etc/apt/sources.list.d/newrelic.list
#CMD curl -L https://download.newrelic.com/548C16BF.gpg | apt-key add -
#CMD apt-get update && apt-get install -y --no-install-recommends newrelic-php5
#CMD NR_INSTALL_SILENT=1 newrelic-install install
#CMD sed -i -e '$anewrelic.distributed_tracing_enabled=true' \
#  $(php -r "echo(PHP_CONFIG_FILE_SCAN_DIR);")/newrelic.ini
#
## Instação do Composer
##CMD curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
#COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
## Configuracao apache
#ENV APACHE_DOCUMENT_ROOT /var/www/html/public
#CMD sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
#CMD sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
#CMD a2enmod rewrite proxy deflate headers expires alias ssl setenvif
#CMD echo "ServerName localhost" > /etc/apache2/conf-enabled/server-name.conf
#
## Limpeza
#CMD apt-get clean \
#    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#
#
## ======================================================================================================================
## Instalação da aplicação
## ======================================================================================================================
#WORKDIR /var/www/html/
#
## Configura timezone do container
#CMD ln -f -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
#
### Configurações (php.ini e vhost.conf)
##COPY containers/php.ini /usr/local/etc/php/conf.d/zzz-app.ini
##COPY containers/apache.conf /etc/apache2/conf-enabled/zzz-app.conf
##
### Copia os arquivos da aplicação
##COPY . .
#
## Configura permissões de diretórios
## reseta as permissões de arquivos (644) d diretórios (755)
## coloca o apache como dono dos diretórios /bootstrap/cache e /storage
#CMD find . -type d -print0 | xargs -0 chmod 755 \
#    && find . -type f -print0 | xargs -0 chmod 644 \
#    && chown -R www-data:www-data ./bootstrap/cache \
#    && chown -R www-data:www-data ./storage \
#    && chmod -R 775 ./bootstrap/cache \
#    && chmod -R 775 ./storage
#
## Executa o composer install
##CMD composer install --no-dev --no-plugins
##CMD composer install