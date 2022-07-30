# alpine-laravel9
Laravel9 on Alpine Docker Container !!  

DockerHub  


# Environment  
Alpine: latest  
PHP: 8.0  
npm: latest  
node.js: latest  
Composer: latest  
Laravel(php artisan --version): latest  
Nginx: latest  

# Image Building
    docker build ./ -t alpine-laravel9:init  

# Docker Run
If /opt/html is empty then create Laravel project in /opt/html  
See docker-entrypoint.sh for details  

    docker run -it --name alpine-laravel9 -p 8080:80 alpine-laravel9:init  
