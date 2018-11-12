# docker灵活的搭建php环境
    使用docker搭建灵活的线上php环境 有时候不太需要一些别人已经集成了的包或者镜像 
    我们就可以使用以下方式逐一构建自己所需要的环境结构

####  1.git拉取[server](https://github.com/ydtg1993/server.git)项目 放到服务器根目录

#### 2.下载镜像
`sudo docker pull php:7.2-fpm`   冒号后选择版本

`sudo docker pull nginx`

`sudo docker pull mysql:8.0` 不需要本地数据库可忽略

`sudo docker pull redis:3.2` 不需要本地redis可忽略

`sudo docker images`  查看已下载的所有镜像

#### 3.下载完成镜像后运行容器 [以下采用--link方式创建容器 注意创建顺序]
    注：
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

`sudo docker run --name mydb -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 -d mysql:8.0`

    注：-MYSQL_ROOT_PASSWORD=123456 给mysql设置初始密码
    如果不需要搭建本地数据库直接下一步


 [运行redis容器]

`sudo docker run --name myredis -p 6379:6379 -d redis:3.2` 

    注:如果不需要搭建本地redis直接下一步

 [运行php容器]

`sudo docker run -d -p 9000:9000 --name myphp -v /server/www:/var/www/html -v /server/php:/usr/local/etc/php --link mydb:mydb --link myredis:myredis --privileged=true  php:7.2-fpm`

    注：如果不需要搭建本地数据库或者redis可以省去--link mydb:mydb --link myredis:myredis


[运行nginx容器] 

`sudo docker run --name mynginx -d -p 80:80 -v /server/www:/usr/share/nginx/html -v /server/nginx:/etc/nginx -v /server/logs/nginx.logs:/var/log/nginx --link myphp:myphp --privileged=true  nginx`
    
    注：
    -v语句冒号后是容器内的路径 我将nginx的网页项目目录 配置目录 日志目录分别挂载到了我事先准备好的/server目录下
    --link myphp:myphp 将nginx容器和php容器连接 通过别名myphp就不再需要去指定myphp容器的ip了 


#### 查看所有容器运行成功 这里环境也就基本搭建完成了
`sudo docker ps  -a` 

###### 挂载目录后就可以不用进入容器中修改配置，直接在对应挂载目录下改配置文件 修改nginx配置到 /server/nginx/conf.d/Default.conf
    注：
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
      fastcgi_pass   myphp:9000; 
      ## 容器与容器之间建立连接必须指定对方ip 使用命令sudo docker inspect myphp可以看到最下面IPAddress参数就是该容器ip 
      ## 我们在创建容器时已经通过--link的方式创建容器，我们可以使用被Link容器的别名进行访问，而不是通过IP，解除了对IP的依赖
      fastcgi_index  index.php;
      fastcgi_param  SCRIPT_FILENAME  /var/www/html/blog/public$fastcgi_script_name; 
      ## Myphp和mynginx的工作目录不同Nginx是/usr/share/nginx/html
      ## PHP是/var/www/html 所以在创建容器时我已经将两个目录都挂载到宿主机相同目录上了/server/www 但这里不能使用宿主机的公共挂载目录
      include        fastcgi_params;
    }
    
    }
    
#### 4.PHP扩展库安装

`sudo docker exec -ti myphp  /bin/bash`  进入容器

`docker-php-ext-install pdo pdo_mysql`  安装pdo_mysql扩展

`docker-php-ext-install  redis`

[如果报错提示redis不存在就下载对应版本redis扩展包 并将其放到php容器扩展包目录下 然后在执行命令]

`tar zxvf /server/php_lib/redis-4.1.0.tgz`

`sudo docker cp /server/php_lib/redis-4.1.0 myphp:/usr/src/php/ext/redis`

    注：
    直接将扩展包放到容器ext目录里可能会报错Error: No such container:path: myphp:/usr/src/php/ext
    你可以多开一个服务器窗口 进入php容器中执行docker-php-ext-install  redis此时报错error: /usr/src/php/ext/redis does not exist
    然后在你的第一个服务器窗口执行上条命令就成功了


`docker restart myphp`  退出容器 重启容器

#### 其它命令
`docker stop $(docker ps -q)`  停止所有容器

`docker rm $(docker ps -aq)`  删除所有容器

`docker inspect myphp`  查看容器配置信息

### 构筑自己的目录结构
    你也可以构建自己所要的server目录结构
    创建一个临时容器 sudo docker run -it mysql:8.0
    然后进入到容器中查看自己所要的目录地址 例如:/etc/mysql/conf.d 退出容器 
    拷贝容器中所要的目录结构 例如:sudo docker cp mydb:/etc/mysql/conf.d /server/mysql
    删除容器 创建新容器sudo docker run --name mydb -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 -v /server/mysql:/etc/mysql -d mysql:8.0
