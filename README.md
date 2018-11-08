# server
docker配置搭建php环境

###  0.配置拉取server 放到服务器根目录

#### 1.下载镜像
`sudo docker pull php:7.2-fpm`   冒号后选择版本

`sudo docker pull nginx`

`sudo docker pull mysql:5.7`

`sudo docker pull redis:3.2`

`sudo docker images`  查看已下载的所有镜像

#### 2.下载完成镜像后运行容器[以下采用--link方式创建容器 注意创建顺序]

    -i 表示允许我们对容器进行操作
    -t 表示在新容器内指定一个为终端
    -d 表示容器在后台执行
    /bin/bash 这将在容器内启动bash shell
    -p 为容器和宿主机创建端口映射
    --name 为容器指定一个名字
    -v 将容器内路径挂载到宿主机路径
    --privileged=true 给容器特权,在挂载目录后容器可以访问目录以下的文件或者目录
    --link可以用来链接2个容器，使得源容器（被链接的容器）和接收容器（主动去链接的容器）之间可以互相通信，解除了容器之间通信对容器IP的依赖
 [运行mysql容器]

`sudo docker run --name mydb -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 -d -v /server/mysql:/var/lib mysql`

    -MYSQL_ROOT_PASSWORD=123456 给mysql设置初始密码
    
 [运行redis容器]

`sudo docker run --name myredis -p 6379:6379 -d redis` 
    
 [运行php容器]

`sudo docker run -d -p 9000:9000 --name myphp -v /server/www:/var/www/html -v /server/php:/usr/local/etc/php --link mydb:mydb --link myredis:myredis --privileged=true  php:7.2-fpm`

[运行nginx容器] 

`sudo docker run --name mynginx -d -p 80:80 -v /server/www:/usr/share/nginx/html -v /server/nginx:/etc/nginx -v /server/logs/nginx.logs:/var/log/nginx --link myphp:myphp --privileged=true  nginx`

    -v语句冒号后是容器内的路径 我将nginx的网页项目目录 配置目录 日志目录分别挂载到了我事先准备好的/server目录下

    
#### 查看所有容器
`sudo docker ps  -a` 

###### 挂载目录后就可以不用进入容器中修改配置，直接在对应挂载目录下改配置文件 修改nginx下的 /server/nginx/conf.d/Default.conf

    server {
    listen       80;
    server_name  localhost;

    location / {
        root   /usr/share/nginx/html/blog/public;  ##/usr/share/nginx/html是工作目录 我的项目是blog根据自己的项目入口文件路径指定
        index  index.html index.htm index.php;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    location ~ \.php$ {
      fastcgi_pass   myphp:9000; ##容器与容器之间建立连接必须指定对方ip 使用命令sudo docker inspect myphp可以看到最下面IPAddress参数就是该容器ip 我们在创建容器时已经通过--link的方式创建容器，我们可以使用被Link容器的别名进行访问，而不是通过IP，解除了对IP的依赖
      fastcgi_index  index.php;
      fastcgi_param  SCRIPT_FILENAME  /var/www/html/blog/public$fastcgi_script_name; ## Myphp和mynginx的工作目录不同Ngnix是/usr/share/nginx/htmlPhp是/var/www/html 所以在创建容器时我已经将两个目录都挂载到宿主机相同目录上了/server/www 但这里不能使用宿主机的公共目录
      include        fastcgi_params;
    }
    
    }
    
#### Php扩展库安装

进入容器
`sudo docker exec -ti myphp  /bin/bash`
`docker-php-ext-install pdo pdo_mysql` 安装pdo_mysql扩展
`docker-php-ext-install  xdebug`

[如果报错提示xdebug不存在就下载对应版本xdebug扩展包 并将其放到php容器扩展包目录下 然后在执行命令]

`sudo docker cp /server/php_lib/xdebug-2.6.1 myphp:/usr/src/php/ext/xdebug`

`docker-php-ext-install  xdebug`

