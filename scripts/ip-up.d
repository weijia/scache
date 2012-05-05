#! /bin/sh
# This file is public domain. No rights reserved.

#restart Smart Cache (if running)

if [ -x /etc/init.d/scache ]; then
   /etc/init.d/scache nice-restart
fi   
if [ -x /etc/init.d/scache-native ]; then
   /etc/init.d/scache-native nice-restart
fi   
