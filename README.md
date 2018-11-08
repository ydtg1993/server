# server
docker配置搭建php环境
配置目录server 放到服务器根目录

1.下载镜像
sudo docker pull php:7.2-fpm   冒号后选择版本
sudo docker pull nginx
sudo docker pull mysql
sudo docker pull redis

sudo docker images  查看已下载的所有镜像

2.下载完成镜像后运行容器
[-i 表示允许我们对容器进行操作
-t 表示在新容器内指定一个为终端
-d 表示容器在后台执行
/bin/bash 这将在容器内启动bash shell
-p 为容器和宿主机创建端口映射
--name 为容器指定一个名字
-v 将容器内路径挂载到宿主机路径
--privileged=true 给容器特权,在挂载目录后容器可以访问目录以下的文件或者目录]
sudo docker run --name mynginx -d -p 80:80 -v /server/www:/usr/share/nginx/html -v /server/nginx:/etc/nginx -v /server/logs/nginx.logs:/var/log/nginx --link myphp:myphp --privileged=true  nginx[-v语句冒号后是容器内的路径 我将nginx的网页项目目录 配置目录 日志目录分别挂载到了我事先准备好的/server目录下
]

sudo docker run -d -p 9000:9000 --name myphp -v /server/www:/var/www/html -v /server/php:/usr/local/etc/php --link mydb:mydb --privileged=true  php:7.2-fpm

sudo docker run --name mydb -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 -d -v /server/mysql:/var/lib mysql

查看所有容器
sudo docker ps  -a 
