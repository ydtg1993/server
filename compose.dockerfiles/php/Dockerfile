FROM php:7.4-fpm
MAINTAINER goozp "946818508@qq.com"

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y build-essential libssl-dev zlib1g-dev libpng-dev libjpeg-dev libfreetype6-dev libzip-dev libjpeg62-turbo-dev libpng-dev zip unzip curl libcurl4-openssl-dev libonig-dev vim

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
        && docker-php-ext-install -j$(nproc) gd \
        && docker-php-ext-install pdo_mysql \
        && docker-php-ext-install mysqli \
        && docker-php-ext-install zip \
        && docker-php-ext-install opcache

RUN pecl install redis && docker-php-ext-enable redis
RUN pecl install xdebug-3.1.6 && docker-php-ext-enable xdebug

# 安装 ImageMagick
RUN apt-get install -y libmagickwand-dev --no-install-recommends \
    && pecl install imagick \
    && docker-php-ext-enable imagick

# 安装 composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"

# 备份容器内的 PHP 配置文件
RUN cp -r /usr/local/etc/php/conf.d /usr/local/etc/php/conf.d.backup

RUN echo "" >> /usr/local/etc/php/php.ini
COPY conf.d.backup.sh /conf.d.backup.sh
RUN chmod +x /conf.d.backup.sh
ENTRYPOINT ["/bin/bash", "-c","/conf.d.backup.sh"]

RUN usermod -u 1000 www-data