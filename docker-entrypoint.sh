#!bin/sh

### If /opt/html is empty then create Laravel project in /opt/html
if [ -d /opt/html ] ; then
    php8 /usr/bin/composer create-project laravel/laravel --prefer-dist --remove-vcs .
    chmod -R 777 /opt/html/storage
    echo "CREATED LARAVEL PROJECT"
fi

### Start php-fpm
echo "START PHP-FPM";
rc-service php-fpm8 start

### Start Nginx
echo "START NGINX";
nginx -g "daemon off;"