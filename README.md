# phpserver
docker php nginx server
# daemon use 
docker run -it --name mylnmp -d -v ~/projectName/www:/var/www:ro -v ~/projectName/nginx/config:/var/nginx/config:ro  -h hostname -p 80:80  leitaozhang/phpserver
### 2
docker run -it --name mylnmp --rm -v ~/projectName/www:/var/www:ro -v ~/projectName/nginx/config:/var/nginx/config:ro  -h hostname -p 80:80  leitaozhang/phpserver /bin/bash
### 3
php-fpm && nginx
