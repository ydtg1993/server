#!/bin/bash

sleep 10
if [ "$(ls -A /usr/local/etc/php/conf.d.backup)" ]; then
  cp -r /usr/local/etc/php/conf.d.backup/* /usr/local/etc/php/conf.d
fi
