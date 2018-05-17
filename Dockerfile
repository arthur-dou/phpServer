FROM centos
MAINTAINER leitao
#换成阿里云的源
RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
COPY Centos-7.repo /etc/yum.repos.d/CentOS-Base.repo
RUN yum makecache

ENV DEPS  /usr/bin/applydeltarpm  wget gcc gcc-c++ ncurses ncurses-devel bison libgcrypt perl automake autoconf libtool make  libxml2 libxml2-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel curl curl-devel php-mcrypt libmcrypt libmcrypt-devel openssl-devel gd mcrypt mhash libicu-devel
#设置环境变量

ENV PATH $PATH:/usr/local/bin
 
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
RUN yum -y install epel-release
RUN yum -y update
#安装扩展
RUN yum install -y $DEPS && yum clean all

#建立目录
RUN mkdir -p /usr/local/src/nginx-files && mkdir -p /usr/local/src/php-files && mkdir -p /var/nginx && mkdir -p /var/www &&  mkdir -p /tmp/nginx_logs

#拷贝文件
ADD zlib-1.2.11.tar.gz /usr/local/src/nginx-files
ADD pcre-8.40.tar.gz /usr/local/src/nginx-files
ADD openssl-1.1.0e.tar.gz /usr/local/src/nginx-files
ADD nginx-1.10.3.tar.gz /usr/local/src/nginx-files
ADD php-5.6.36.tar.gz /usr/local/src/php-files
ADD libmemcached-1.0.18.tar.gz /usr/local/src/php-files
ADD memcached-2.2.0.tgz /usr/local/src/php-files
ADD redis-4.0.2.tgz /usr/local/src/php-files

#安装nginx
RUN groupadd www && useradd -r -g www www && cd /usr/local/src/nginx-files/nginx-1.10.3 && ./configure --prefix=/usr/local/nginx --user=www --group=www --with-http_ssl_module --with-http_v2_module --with-http_gzip_static_module --with-ipv6 --with-poll_module --with-select_module --with-pcre=/usr/local/src/nginx-files/pcre-8.40 --with-zlib=/usr/local/src/nginx-files/zlib-1.2.11 --with-openssl=/usr/local/src/nginx-files/openssl-1.1.0e && make && make install
COPY nginx/nginx.conf /usr/local/nginx/conf
#安装 php5.6
RUN  cd /usr/local/src/php-files/php-5.6.36 && ./configure  --prefix=/usr/local/php56 --enable-fpm --enable-pcntl --with-mysql=mysqlnd --with-mcrypt --enable-bcmath --with-curl --with-gd --enable-gd-native-ttf --with-freetype-dir --enable-intl --with-mysql-sock=/tmp/mysqld.sock --enable-mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-libxml-dir=/usr/lib64 --with-mhash --enable-sockets --with-png-dir=/usr/lib64 --with-jpeg-dir=/usr/lib64 --with-zlib --enable-opcache --enable-zip --enable-mbstring --with-openssl --with-pcre-regex && make && make install

COPY php/php.ini /usr/local/php56/lib
COPY php/php-fpm.conf /usr/local/php56/etc
#安装php unit
COPY phpunit-5.7.27.phar /usr/local/bin/phpunit
#建立软链接
RUN ln -s /usr/local/php56/bin/php /usr/local/bin/php  && ln -s /usr/local/nginx/sbin/nginx /usr/local/bin/nginx  && ln -s /usr/local/php56/sbin/php-fpm /usr/local/bin/php-fpm  && ln -s /usr/local/php56/bin/php-config /usr/bin/php-config && chmod +x /usr/local/bin/phpunit

#安装redis和memcached扩展
RUN cd /usr/local/src/php-files/redis-4.0.2 && /usr/local/php56/bin/phpize && ./configure --with-php-config=/usr/bin/php-config && make && make install && cd /usr/local/src/php-files/libmemcached-1.0.18 && ./configure && make && make install && cd /usr/local/src/php-files/memcached-2.2.0 && ./configure --with-php-config=/usr/bin/php-config && make && make install


RUN rm -rf /usr/local/src/nginx-files/* && rm -rf /usr/local/src/php-files/*

RUN echo "#!/bin/bash" > /usr/local/bin/lnmp &&  echo "/usr/local/bin/php-fpm" >> /usr/local/bin/lnmp &&   echo "/usr/local/bin/nginx -g 'daemon off;'" >> /usr/local/bin/lnmp && chmod +x /usr/local/bin/lnmp



CMD [ "/usr/local/bin/lnmp" ] 

#-g 'daemon off;' 
#sudo docker run -it --name mylnmp --rm -v ~/wiwidework/wiwidesvn:/var/www:ro -v ~/wiwidework/nginx/config:/var/nginx/config:ro  -h zzhang -p 80:80  phpserver
#/dev/shm/php56-cgi.sock
#/usr/local/nginx/sbin/nginx & /usr/local/php56/sbin/php-fpm & /bin/bash
#   extension=/usr/local/php56/lib/php/extensions/no-debug-non-zts-20131226/redis.so
  # extension=/usr/local/php56/lib/php/extensions/no-debug-non-zts-20131226/memcached.so

EXPOSE 80 443


