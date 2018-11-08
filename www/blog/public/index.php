<?php
echo '<p>php环境搭建成功</p>';

try {
    new PDO('mysql:host=mydb;dbname=mysql', 'root', '1234567');
    echo '<p>mysql服务已开启</p>';
} catch (Exception $e) {
    echo '<p>mysql扩展未装</p>';
} finally {

    try {
        $redis = new Redis();
        $res = @$redis->connect('myredis', 6379);
        if (!$res) {
            throw new Exception('<p>redis扩展未装</p>');
        }
        $redis->close();
        echo '<p>redis服务已开启</p>';
    } catch (Exception $e) {
        echo '<p>redis扩展未装</p>';
    } finally {
        var_dump(phpinfo());
    }
}