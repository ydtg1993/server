FROM mysql:8.0

# set timezome
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN chown -R 777 /var/lib/mysql
RUN chown -R 777 /var/lib/mysql-files
ADD my.cnf /etc/mysql/conf.d/my.cnf