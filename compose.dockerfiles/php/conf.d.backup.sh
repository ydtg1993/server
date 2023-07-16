#!/bin/bash

while true; do
  # 检查目录是否存在文件
  if [ "$(ls -A /usr/local/etc/php/conf.d.backup 2>/dev/null)" ] || [ ! "$(ls -A /usr/local/etc/php/conf.d 2>/dev/null)" ]; then
    # 执行命令
    cp -r /usr/local/etc/php/conf.d.backup/* /usr/local/etc/php/conf.d
    break
  else
    sleep 3
  fi
done
tail -f /dev/null