FROM php:7.2-fpm
MAINTAINER goozp "946818508@qq.com"

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN echo "" >> /usr/local/etc/php/php.ini
RUN usermod -u 1000 www-data
