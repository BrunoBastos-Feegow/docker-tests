FROM php:7.4-apache

# ======================================================================================================================
# Instalação do PHP 7.4 com Apache e extensões
# todo: transformar uma imagem base do PHP para todas as aplicações Feegow
# ======================================================================================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    locales \
    default-mysql-client \
    bzip2 \
    libbz2-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libicu-dev \
    libxml2-dev \
    libxslt-dev \
    libzip-dev \
    libwebp-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-webp-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) \
        bcmath \
        bz2 \
        calendar \
        dba \
        exif \
        fileinfo \
        gd \
        gettext \
        intl \
        pdo \
        pdo_mysql \
        mbstring \
        soap \
        sockets \
        opcache \
        xmlrpc \
        xsl \
        zip

# Configuracao Locales e Timezone do container
RUN ln -f -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
    && printf 'pt_BR.UTF-8 UTF-8\n' >> /etc/locale.gen \
    && printf 'pt_BR ISO-8859-1\n' >> /etc/locale.gen \
    && locale-gen

# Instala Redis cache
RUN pecl install redis-5.3.7 \
    && docker-php-ext-enable redis

# Instala New Relic
RUN apt-get update && apt-get install -y --no-install-recommends gnupg2
RUN echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | tee /etc/apt/sources.list.d/newrelic.list
RUN curl -L https://download.newrelic.com/548C16BF.gpg | apt-key add -
RUN apt-get update && apt-get install -y --no-install-recommends newrelic-php5
RUN NR_INSTALL_SILENT=1 newrelic-install install
RUN sed -i -e '$anewrelic.distributed_tracing_enabled=true' \
  $(php -r "echo(PHP_CONFIG_FILE_SCAN_DIR);")/newrelic.ini

# Instação do Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configuracao apache
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
RUN a2enmod rewrite proxy deflate headers expires alias ssl setenvif
RUN echo "ServerName localhost" > /etc/apache2/conf-enabled/server-name.conf

# Limpeza
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# ======================================================================================================================
# Instalação da aplicação
# ======================================================================================================================
WORKDIR /var/www/html/

# Configura timezone do container
RUN ln -f -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

## Configurações (php.ini e vhost.conf)
#COPY containers/php.ini /usr/local/etc/php/conf.d/zzz-app.ini
#COPY containers/apache.conf /etc/apache2/conf-enabled/zzz-app.conf
#
## Copia os arquivos da aplicação
#COPY . .

# Configura permissões de diretórios
# reseta as permissões de arquivos (644) d diretórios (755)
# coloca o apache como dono dos diretórios /bootstrap/cache e /storage
RUN find . -type d -print0 | xargs -0 chmod 755 \
    && find . -type f -print0 | xargs -0 chmod 644 \
    && chown -R www-data:www-data ./bootstrap/cache \
    && chown -R www-data:www-data ./storage \
    && chmod -R 775 ./bootstrap/cache \
    && chmod -R 775 ./storage

# Executa o composer install
#RUN composer install --no-dev --no-plugins
RUN composer install