# alpine-laravel
Laravel on Alpine Docker Container !!  

DockerHub  
https://hub.docker.com/r/thideki/alpine-laravel

# Environment  
Alpine: latest  
PHP: 8.1  
npm: latest  
node.js: latest  
Composer: latest  
Laravel(php artisan --version): latest  
Nginx: latest  

# Image Building
    docker build ./ -t alpine-laravel  

# Docker Run
    docker run -it --name alpine-laravel-docker -p 8080:80 alpine-laravel  

If /opt/html is empty then create Laravel project in /opt/html  
See docker-entrypoint.sh for details  

# Access Laravel welcome page
http://localhost:8080/
