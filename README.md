# 拉去 docker镜像  
docker  pull leitaozhang/phpserver 

# 第一步 运行一个memcache
docker run --name mymemcache -p 11211:11211 -d memcached memcached -m 64

# 第二步 运行一个mysql
docker run --name mysql -p 3306:3306 -v ~/docker/mysql/datadir:/var/lib/mysql -v ~/docker/mysql/config:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=root -d mysql:5.7.22

# 第三步 启动 nginx和php5.6 、 7.1 、7.3
docker run --name mylnmp -d -p 80:80 --link mymemcache --link mysql -v ~/PhpstormProjects:/var/www:ro  -v ~/docker/nginx/config:/var/nginx/config:ro  leitaozhang/phpserver


### 每个网站配置单独的配置文件 如为 localhost 域名配置（放到~/docker/nginx/config/localhost.conf） 输入：

--- 配置php5.6版本---
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
 ```
 ---或则配置php7.1版本---
 ``` nginx 
server {
	listen       80;
	server_name   localhost ;
	access_log   /tmp/nginx_logs/localhost.access.log  main;
	root /var/www/localhost/;
	index  index.php index.html index.htm;
	location ~ \.php$ {
		fastcgi_pass   unix:/dev/shm/php71-cgi.sock;
		fastcgi_index  index.php;
		fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
		include        fastcgi_params;
	}
 }
 ```
  ---或则配置php7.3版本---
 ``` nginx 
server {
	listen       80;
	server_name   localhost ;
	access_log   /tmp/nginx_logs/localhost.access.log  main;
	root /var/www/localhost/;
	index  index.php index.html index.htm;
	location ~ \.php$ {
		fastcgi_pass   unix:/dev/shm/php73-cgi.sock;
		fastcgi_index  index.php;
		fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
		include        fastcgi_params;
	}
 }
 ```
 可以根据不同需求而定制
