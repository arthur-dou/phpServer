# phpserver
docker php nginx server
# one step
docker run --name mymemcache -p 11211:11211 -d memcached memcached -m 64
# two step
docker run --name mysql -p 3306:3306 -v ~/docker/mysql/datadir:/var/lib/mysql -v ~/docker/mysql/config:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=root -d mysql:5.7.22
# three step
docker run --name mylnmp -d -p 80:80 --link mymemcache --link mysql -v ~/PhpstormProjects:/var/www:ro  -v ~/docker/nginx/config:/var/nginx/config:ro  leitaozhang/phpserver
