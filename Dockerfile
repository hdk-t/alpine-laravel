FROM alpine:3

RUN apk update
RUN mkdir /opt/html
WORKDIR /opt/html

### Alias setting
RUN echo -e "alias ll='ls -aFl'\nalias php='php81'\nalias composer='php81 /usr/bin/composer'"> ~/.bashrc

### Environment
ENV TZ=Japan
ENV DEBIAN_FRONTEND=noninteractive

### Install basic middleware
RUN apk add bash make gcc g++ curl zip git openssl tzdata libc6-compat
RUN apk add --no-cache libc6-compat && ln -s /lib/libc.musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2

### Install openrc
RUN apk add openrc
RUN sed -i 's/#rc_sys=""/rc_sys="lxc"/g' /etc/rc.conf
RUN echo 'rc_provide="loopback net"' >> /etc/rc.conf
RUN sed -i 's/^#\(rc_logger="YES"\)$/\1/' /etc/rc.conf
RUN sed -i '/tty/d' /etc/inittab 
RUN sed -i 's/hostname $opts/# hostname $opts/g' /etc/init.d/hostname
RUN sed -i 's/mount -t tmpfs/# mount -t tmpfs/g' /lib/rc/sh/init.sh 
RUN sed -i 's/\tcgroup_add_service/#cgroup_add_service/g' /lib/rc/sh/openrc-run.sh
RUN rc-status
RUN touch /run/openrc/softlevel

### Install PHP middleware
RUN apk add php81 php81-curl php81-mbstring php81-dom php81-fpm php81-openssl php81-phar php81-sockets php81-tokenizer php81-xml php81-xmlwriter php81-fileinfo php81-session
RUN sed -i /etc/php81/php-fpm.d/www.conf -e "s|listen = 127.0.0.1:9000|listen = /var/run/php-fpm81/php-fpm.sock|g"
RUN sed -i /etc/php81/php-fpm.d/www.conf -e "s|;listen.mode = 0660|listen.mode = 0666|g"

### Install Composer (See https://getcomposer.org/download/) 
RUN php81 -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php81 -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php81 composer-setup.php
RUN php81 -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/bin/composer

### Install node.js middleware
RUN apk add npm

### Install Nginx
RUN apk add nginx
RUN cp /usr/share/zoneinfo/Japan /etc/localtime
COPY default.conf /etc/nginx/http.d/
COPY fastcgi-php.conf /etc/nginx/
RUN chmod 644 /etc/nginx/fastcgi-php.conf

### Copy docker-entrypoint.sh
COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh

EXPOSE 80
STOPSIGNAL SIGQUIT

### PID1 measures(k8s compatible)
RUN apk add --update --repository http://dl-1.alpinelinux.org/alpine/edge/community/ tini
ENTRYPOINT ["tini", "--"]

### Start Process
CMD ["bash", "docker-entrypoint.sh"]