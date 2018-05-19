# docker 链接
docker  pull leitaozhang/phpserver（ https://hub.docker.com/r/leitaozhang/phpserver/ ）

# 第一步
docker run --name mymemcache -p 11211:11211 -d memcached memcached -m 64

# 第二步
docker run --name mysql -p 3306:3306 -v ~/docker/mysql/datadir:/var/lib/mysql -v ~/docker/mysql/config:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=root -d mysql:5.7.22

# 第三步
docker run --name mylnmp -d -p 80:80 --link mymemcache --link mysql -v ~/PhpstormProjects:/var/www:ro  -v ~/docker/nginx/config:/var/nginx/config:ro  leitaozhang/phpserver

# 每个网站配置单独的配置文件 如为 localhost 域名配置（放到~/docker/nginx/config/localhost.conf） 输入：
---
``` nginx 
server {
	listen       80;
	server_name   localhost ;
	access_log   /tmp/nginx_logs/localhost.access.log  main;
	root /var/www/localhost/;
	index  index.php index.html index.htm;
	location ~ \.php$ {
		fastcgi_pass   unix:/dev/shm/php56-cgi.sock;
		fastcgi_index  index.php;
		fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
		include        fastcgi_params;
	}
 }
 
 ---
 可以根据不同需求而定制
