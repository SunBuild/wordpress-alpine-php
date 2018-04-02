#!/bin/sh

#set -e
#!/bin/bash

if [ ! -d "/var/www" ]; then
  mkdir -p /var/www
fi


if [ ! -d "/var/www/.git" ]; then
  git clone "$GIT_REPO" /var/www
else
  git -C /var/www pull
fi


echo "Starting SSH ..."
rc-service sshd start

echo "Starting Apache httpd -D FOREGROUND ..."
apachectl start -D FOREGROUND
