FROM php:7.2-fpm
MAINTAINER goozp "946818508@qq.com"

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
        && docker-php-ext-install zip \
        && docker-php-ext-install pdo_mysql \
        && docker-php-ext-install opcache \
        && docker-php-ext-install mysqli

RUN pecl install redis && docker-php-ext-enable redis \
	&& pecl install xdebug && docker-php-ext-enable xdebug

RUN echo "" >> /usr/local/etc/php/php.ini
RUN usermod -u 1000 www-data
