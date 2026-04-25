#!/bin/bash
#这个脚本的设计目的，是解决挂载php扩展配置空目录覆盖容器默认配置的问题
#当宿主机的 server/php/conf.d 目录为空或尚不存在时，容器内 PHP 原生的 conf.d
# 目录会被完全覆盖为空，导致所有扩展的 .ini 文件丢失（如 gd.ini、mysqli.ini等），PHP 无法加载这些扩展，服务启动就会异常。
backup_flag_file="/.backup_done"
if [ ! -f "$backup_flag_file" ]; then
  while true; do
    # 检查目录是否存在文件
    if [ "$(ls -A /usr/local/etc/php/conf.d.backup 2>/dev/null)" ] || [ ! "$(ls -A /usr/local/etc/php/conf.d 2>/dev/null)" ]; then
      # 执行命令
      cp -r /usr/local/etc/php/conf.d.backup/* /usr/local/etc/php/conf.d
      touch "$backup_flag_file"
      break
    else
      sleep 3
    fi
  done
fi
php-fpm