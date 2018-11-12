<?php
echo '<p>php环境搭建成功</p>';
try {
    new PDO('mysql:host=mydb;dbname=mysql', 'root', '123456');//host地址直接使用link指定的标签mydb
    echo '<p>mysql连接成功</p>';
} catch (Exception $e) {
    echo '<p>mysql连接失败 : '.$e->getMessage().'</p>';
} finally {

    try {
        $redis = new Redis();
        $res = $redis->connect('myredis', 6379);//地址直接使用link指定的标签myredis
        if (!$res) {
            throw new Exception('');
        }
        $redis->close();
        echo '<p>redis连接成功</p>';
    } catch (Exception $e) {
        echo '<p>redis连接失败 : '.$e->getMessage().'</p>';
    } finally {
        var_dump(phpinfo());
    }
}
