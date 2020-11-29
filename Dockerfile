FROM php:7.4.10-fpm

ENV DEBIAN_FRONTEND="noninteractive"
ENV COMPOSER_ALLOW_SUPERUSER=1

RUN apt-get update; \
    apt-get install -y --no-install-recommends \
        sudo wget netcat libcurl4-openssl-dev curl git unzip libzip-dev zlib1g-dev libpng-dev apt-utils \
        iputils-ping golang; \
    apt-get clean; rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*;

RUN docker-php-ext-install pdo pdo_mysql curl opcache zip gd

RUN echo "[global]" >> /usr/local/etc/php/zz-docker.conf.dist; \
    echo "daemonize = no" >> /usr/local/etc/php/zz-docker.conf.dist; \
    echo "[www]" >> /usr/local/etc/php/zz-docker.conf.dist; \
    echo "listen = 127.0.0.1:9000" >> /usr/local/etc/php/zz-docker.conf.dist; \
    echo "request_terminate_timeout = 300" >> /usr/local/etc/php/zz-docker.conf.dist;

#ENV COMPOSER_AUTH='{"http-basic": {"xxx.com": {"username": "yyy", "password": "zzz"}}}'
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir "/usr/local/bin" --filename composer; \
    usermod -u 2000 www-data; adduser www-data sudo; echo "www-data ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers;

RUN apt-get update && apt-get install -y --no-install-recommends supervisor nginx zlib1g-dev libicu-dev python3 python3-pip; \
    apt-get clean; rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*;
RUN docker-php-ext-configure intl && \
    docker-php-ext-install intl pdo_mysql opcache -j$(nproc) && \
    pecl install apcu && docker-php-ext-enable apcu
WORKDIR /code
VOLUME /code
COPY ./templates/ /code/templates/
RUN cp templates/supervisord.conf /etc/supervisor/supervisord.conf; \
    cp templates/nginx.conf /etc/nginx/nginx.conf; \
    cp templates/nginx-server-php.conf /etc/nginx/snippets/nginx-server-php.conf; \
    cp templates/php.ini /usr/local/etc/php/conf.d/zzz.ini;
COPY . /code

CMD ["/code/entrypoint.sh"]
