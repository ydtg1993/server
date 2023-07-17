#!/bin/bash
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