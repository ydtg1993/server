<?php
echo '<p>php环境搭建成功</p>';
try {
    new PDO('mysql:host=mydb;dbname=mysql', 'root', '123456');
    echo '<p>mysql连接成功</p>';
} catch (Exception $e) {
    echo '<p>mysql连接失败 : '.$e->getMessage().'</p>';
} finally {

    try {
        $redis = new Redis();
        $res = $redis->connect('myredis', 6379);
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
