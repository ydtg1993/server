<h1 align="center">docker 灵活的构建php环境</h1>

            使用docker搭建灵活的线上php环境 有时候你可能不太需要一些别人已经集成了的包或者镜像 
            我们就可以使用以下方式自己动手逐一构建自己所需要的环境结构 并在最后实现一键自动化部署 
            一步一步点亮docker技能树
                                                ##         .
                                          ## ## ##        ==
                                       ## ## ## ## ##    ===
                                   /"""""""""""""""""\___/ ===
                              ~~~ {~~ ~~~~ ~~~ ~~~~ ~~~ ~ /  ===- ~~~
                                   \______ o           __/
                                     \    \         __/
                                      \____\_______/



<h3 align="center">阶段一 使用docker逐一构建</h3>
<p align="center">☆ 首先拉取项目 放到服务器任意目录（到后面你也可以构建自己风格的环境结构）</p>

#### 1. 下载镜像

<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker%20pull%20php:7.2--fpm-lightgrey" alt="php"> `冒号后选择版本`

<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker%20pull%20nginx-lightgrey" alt="nginx">

<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker%20pull%20mysql:5.7-lightgrey" alt="mysql"> `不需要本地数据库可忽略`

<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker%20pull%20redis:3.2-lightgrey" alt="redis"> `不需要本地redis可忽略`

<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker%20images-lightgrey" alt="images"> `查看已下载的所有镜像`

#### 2. 下载完成镜像后运行容器 [以下采用--link方式创建容器 注意创建顺序]
    注：
    -i 表示允许我们对容器进行操作
    -t 表示在新容器内指定一个为终端
    -d 表示容器在后台执行
    /bin/bash 这将在容器内启动bash shell
    -p 为容器和宿主机创建端口映射
    --name 为容器指定一个名字
    -v 将容器内路径挂载到宿主机路径
    --privileged=true 给容器特权,在挂载目录后容器可以访问目录以下的文件或者目录
    --link可以用来链接2个容器，使得源容器（被链接的容器）和接收容器（主动去链接的容器）之间可以通过别名通信，解除了容器之间通信对容器IP的依赖
    
    
<p align="center">
<img src="https://img.shields.io/badge/mysql%E5%AE%B9%E5%99%A8-docker-blue?labelColor=important&style=for-the-badge&logo=mysql&logoWidth=40" alt="启动mysql容器">
</p>
<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker%20run%20----name%20mydb%20--p%203306:3306%20--e%20MYSQL__ROOT__PASSWORD=123456%20--d%20mysql:5.7-lightgrey" alt="启动mysql容器命令">

    注：-MYSQL_ROOT_PASSWORD=123456 给mysql设置初始密码
    如果不需要搭建本地数据库直接下一步


<p align="center">
<img src="https://img.shields.io/badge/redis%E5%AE%B9%E5%99%A8-docker-blue?labelColor=lightgrey&style=for-the-badge&logo=redis&logoWidth=40" alt="启动redis容器">
</p> 
<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker%20run%20----name%20myredis%20--p%206379:6379%20--d%20redis:3.2-lightgrey" alt="启动redis容器命令">

    注: 如果不需要搭建本地redis直接下一步

<p align="center">
<img src="https://img.shields.io/badge/php%E5%AE%B9%E5%99%A8-docker-blue?labelColor=success&style=for-the-badge&logo=php&logoWidth=40" alt="启动php容器">
</p>
<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker%20run%20--d%20--p%209000:9000%20----name%20myphp%20--v%20/server/www:/var/www/html%20--v%20/server/php:/usr/local/etc/php%20----link%20mydb:mydb%20----link%20myredis:myredis%20----privileged=true%20%20php:7.2--fpm-lightgrey" alt="启动php容器命令">

    注： 如果不需要搭建本地数据库或者redis可以省去--link mydb:mydb --link myredis:myredis
    注意-v 挂载一个空文件夹是会覆盖容器中的内容,所以配置文件要事先准备好

<p align="center">
<img src="https://img.shields.io/badge/nginx%E5%AE%B9%E5%99%A8-docker-blue?labelColor=orange&style=for-the-badge&logo=nginx&logoWidth=40" alt="启动nginx容器">
</p>
<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker%20run%20----name%20mynginx%20--d%20--p%2080:80%20--v%20/server/www:/usr/share/nginx/html%20--v%20/server/nginx:/etc/nginx%20--v%20/server/logs/nginx.logs:/var/log/nginx%20----link%20myphp:myphp%20----privileged=true%20%20nginx-lightgrey" alt="启动nginx容器命令">
    
    注：
    -v语句冒号后是容器内的路径 我将nginx的网页项目目录 配置目录 日志目录分别挂载到了我事先准备好的/server目录下
    --link myphp:myphp 将nginx容器和php容器连接 通过别名myphp就不再需要去指定myphp容器的ip了 


<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker%20ps%20--a-lightgrey" alt="查看所有容器">  `查看所有容器运行成功 这里环境也就基本搭建完成了`

###### 挂载目录后就可以不用进入容器中修改配置，直接在对应挂载目录下改配置文件 修改nginx配置到 /server/nginx/conf.d/Default.conf
![default.conf](https://github.com/ydtg1993/server/blob/master/image/nginx_default_explain.PNG)
    
    
#### 3. PHP扩展库安装

`首先进入容器`

<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker%20exec%20--ti%20myphp%20%20/bin/bash-lightgrey" alt="进入容器"> 

`安装pdo_mysql扩展`

<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker--php--ext--install%20pdo%20pdo__mysql-lightgrey" alt="pdo_mysql扩展">

`安装redis扩展`

<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker--php--ext--install%20redis-lightgrey" alt="redis扩展">

    注: 此时报错提示redis.so 因为一些扩展并不包含在 PHP 源码文件中

###### 方法一：

`解压已经下载好的redis扩展包`

<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-tar%20zxvf%20/server/php__lib/redis--4.1.0.tgz-lightgrey" alt="解压">

`将扩展放到容器中 再执行安装`

<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker%20cp%20/server/php__lib/redis--4.1.0%20myphp:/usr/src/php/ext/redis-lightgrey" alt="拷贝">
 
 ###### 方法二：
 
    注: 
    官方推荐使用 PECL（PHP 的扩展库仓库，通过 PEAR 打包）。用 pecl install 安装扩展，然后再用官方提供的 docker-php-ext-enable 
    快捷脚本来启用扩展
 
`pecl安装redis`

<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-pecl%20install%20redis%20&&%20docker--php--ext--enable%20redis-lightgrey" alt="pecl安装">

`装完扩展 exit退出容器 重启容器`

<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker%20restart%20myphp-lightgrey" alt="重启容器">


<p align="center">其它常用命令</p>

`停止所有容器`

<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker%20stop%20$(docker%20ps%20--q)-lightgrey" alt="停止所有容器">

`删除所有容器` 

<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker%20rm%20$(docker%20ps%20--aq)-lightgrey" alt="删除所有容器">

`删除所有镜像` 

<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker%20rmi%20$(docker%20images%20--q)-lightgrey" alt="删除所有镜像">

`查看容器配置信息` 

<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker%20inspect%20myphp-lightgrey" alt="查看容器配置信息">

###### 构筑自己的目录结构
    你也可以构建自己所要的server目录结构 首先要知道挂载一个空文件夹会清空容器中文件夹下所有内容 所以应该先拷贝再挂载
    例如: 创建一个临时容器 sudo docker run --name mynginx -p 80:80 -it -d nginx
    进入到容器中查自己所要的配置文件目录地址 例如: /etc/nginx 退出容器 
    拷贝容器中所要的目录结构到宿主机 例如: docker cp mydb:/etc/nginx /server/nginx
    删除容器 创建新容器时就可以挂载该目录了 此后对nginx的配置文件的修改就可以直接在宿主机上快捷操作
    docker run --name mynginx -d -p 80:80 -v /server/nginx:/etc/nginx --link myphp:myphp --privileged=true  nginx
   
   
<h3 align="center">阶段二 docker-compose自动化构建</h3>

    完成以上步骤你就已经初步了解了docker的基本容器操作
    docker-compose是编排容器的。例如，你有一个php镜像，一个mysql镜像，一个nginx镜像。如果没有docker-compose，
    那么每次启动的时候，你需要敲各个容器的启动参数，环境变量，容器命名，指定不同容器的链接参数等等一系列的操作，
    相当繁琐。而用了docker-compose之后，你就可以把这些命令一次性写在docker-compose.yml文件中，以后每次启动
    这一整个环境（含3个容器）的时候，你只要敲一个docker-compose up命令就ok了

 ####  1. 安装docker-compose
<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-curl%20--L%20%22https%3A%2F%2Fgithub.com%2Fdocker%2Fcompose%2Freleases%2Flatest%2Fdownload%2Fdocker--compose--%24(uname%20--s)--%24(uname%20--m)%22%20--o%20%2Fusr%2Flocal%2Fbin%2Fdocker--compose%20-lightgrey" alt="安装docker-compose">    
 <img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-chmod%20+x%20/usr/local/bin/docker--compose-lightgrey" alt="授权">   

<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker--compose%20----version-lightgrey" alt="查看版本信息">  `查看版本信息`  

#### 2. 一键部署环境
    /server/compose/docker-compose.yml已经配置好了 直接输入命令即可
    

<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-cd%20/server/compose-lightgrey" alt="进入目录">    
<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker--compose%20up%20--d-lightgrey" alt="运行脚本">

![docker_yml](https://github.com/ydtg1993/server/blob/master/image/docker_yml_explain.PNG)

    对比上面运行容器命令来看docker_yml的配置结构和语义就一目了然了 
   
   
<h3 align="center">阶段三 dokcer-compose和dockerfile 完整构建</h3>

    用了docker-compose实现一键式操作 但问题是PHP的扩展库还是得自己单独装 所以这里需要用到Dockerfile来构建自定义容器镜像
    实现真正的一键完成
    
    目录:
       server -|                     
              -| compose.dockerfiles  -| docker-compose.yml
                                      -| mysql -| Dockerfile 这里设置我们自定的dockerfile来构建mysql镜像          
                                       |           
                                      -| nginx -| Dockerfile 这里设置我们自定的dockerfile来构建nginx镜像
                                       |          
                                      -| php -| Dockerfile 这里设置我们自定的dockerfile来构建php镜像
                                       |       
                                      -| redis -| Dockerfile 这里设置我们自定的dockerfile来构建redis镜像
                                              
                                              
    
![dockerfile](https://github.com/ydtg1993/server/blob/master/image/docker_file_explain.PNG)
   
    自定义php的dockerfile构建自定义镜像同时安装扩展  完成了所有dockerfile配置后 docker-compose.yml文件就不需要
    再用官方镜像image:php-fpm:7.2 而是直接build：./php 直接引用目录配置好的Dockerfile
    最后提示: 镜像一旦创建了下次docker-compose会直接取已有镜像而不会build创建 若你修改了Dockerfile配置请记得删除之前镜像
       

<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-cd%20/server/compose.dockerfiles-lightgrey" alt="进入目录">    
<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker--compose%20up%20--d-lightgrey" alt="运行脚本">
    
    
<h1 align="center">以上就是docker所有的环境配置方式</h1>
    
----------------------------------------------------
### 其他补充
<h3 align="center">问题1</h3>

    当你用docker-compose自动化部署后想要更换其中一个容器
    假设场景 在自动部署环境后发现nginx容器没有开启443端口
    
#### 1. 查询自动化部署的容器组环境所在网段

`查询所有网段命令`

<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker%20network%20ls-lightgrey" alt="查询所有网段命令">

`查询nginx所在网段 找到HostConfig.NetworkMode下所对应值 例如:composedockerfiles_default`

<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker%20inspect%20mynginx-lightgrey" alt="查询nginx所在网段">

#### 2. 先删除nginx容器

<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker%20stop%20mynginx%20&&%20docker%20rm%20mynginx-lightgrey" alt="删除容器nginx">

#### 3. 重启一个新的nginx容器 并且桥接相同网段 

`在原来的基础上-p加上新端口443 并且使用网段桥接 --net=composedockerfiles_default`

<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker%20run%20----name%20mynginx%20--d%20--p%2080:80%20--p%20443:443%20--v%20/server/www:/usr/share/nginx/html%20--v%20/server/nginx:/etc/nginx%20--v%20/server/logs/nginx.logs:/var/log/nginx%20----link%20myphp:myphp%20----net=composedockerfiles__default%20----privileged=true%20nginx-lightgrey" alt="新nginx容器">

    
<h3 align="center">问题2</h3>

    当你在宿主机上需要用cli模式运行php

<img src="https://img.shields.io/badge/%E5%91%BD%E4%BB%A4-docker%20exec%20--i%20myphp%20/bin/bash%20--c%20'/usr/local/bin/php%20/var/www/html/blog/public/index.php'-lightgrey" alt="执行命令">




    

    
    
    
