FROM php:8.4-fpm

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 安装系统依赖和 PHP 扩展
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        libmagickwand-dev \
        unzip \
    ; \
    docker-php-ext-configure gd --with-freetype --with-jpeg; \
    docker-php-ext-install -j$(nproc) \
        gd \
        mysqli \
        pdo_mysql \
        zip \
        opcache \
    ; \
    # 安装 PECL 扩展（确保版本兼容 PHP 8.4）
    pecl install redis && docker-php-ext-enable redis; \
    pecl install imagick && docker-php-ext-enable imagick; \
    # Xdebug 可安装最新版本，如果 8.4 暂未支持，可注释掉或使用 alpha 版
    pecl install xdebug && docker-php-ext-enable xdebug; \
    # 清理
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

# 安装 composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"

# 备份容器内的PHP扩展包的所有配置文件
RUN cp -r /usr/local/etc/php/conf.d /usr/local/etc/php/conf.d.backup

COPY conf.d.backup.sh /usr/local/bin/conf.d.backup.sh
RUN chmod +x /usr/local/bin/conf.d.backup.sh

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/conf.d.backup.sh; exec php-fpm"]
