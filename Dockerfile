FROM centos
MAINTAINER leitao

ENV PATH $PATH:/usr/local/bin

RUN echo 'export LC_ALL=C' >> ~/.bashrc && source ~/.bashrc && rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && yum -y install epel-release && yum -y update && yum install -y /usr/bin/applydeltarpm  wget gcc gcc-c++ ncurses ncurses-devel bison libgcrypt perl automake autoconf libtool make  libxml2 libxml2-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel curl curl-devel php-mcrypt libmcrypt libmcrypt-devel openssl-devel gd mcrypt mhash libicu-devel && yum clean all
 
#拷贝文件
COPY file_tar/ /usr/local/src/

RUN cd /usr/local/src/nginx-files && ls | xargs -n1 tar xzvf && cd /usr/local/src/php-files && ls | xargs -n1 tar xzvf && mkdir -p /var/nginx && mkdir -p /var/www &&  mkdir -p /tmp/nginx_logs && groupadd www && useradd -r -g www www && cd /usr/local/src/nginx-files/nginx-1.10.3 && ./configure --prefix=/usr/local/nginx --user=www --group=www --with-http_ssl_module --with-http_v2_module --with-http_gzip_static_module --with-ipv6 --with-poll_module --with-select_module --with-pcre=/usr/local/src/nginx-files/pcre-8.40 --with-zlib=/usr/local/src/nginx-files/zlib-1.2.11 --with-openssl=/usr/local/src/nginx-files/openssl-1.1.0e && make && make install && cd /usr/local/src/php-files/php-5.6.36 && ./configure  --prefix=/usr/local/php56 --enable-fpm --enable-pcntl --with-mysql=mysqlnd --with-mcrypt --enable-bcmath --with-curl --with-gd --enable-gd-native-ttf --with-freetype-dir --enable-intl --with-mysql-sock=/tmp/mysqld.sock --enable-mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-libxml-dir=/usr/lib64 --with-mhash --enable-sockets --with-png-dir=/usr/lib64 --with-jpeg-dir=/usr/lib64 --with-zlib --enable-opcache --enable-zip --enable-mbstring --with-openssl --with-pcre-regex && make && make install && mv /usr/local/src/phpunit-5.7.27.phar /usr/local/bin/phpunit && ln -s /usr/local/php56/bin/php /usr/local/bin/php  && ln -s /usr/local/nginx/sbin/nginx /usr/local/bin/nginx  && ln -s /usr/local/php56/sbin/php-fpm /usr/local/bin/php-fpm  && ln -s /usr/local/php56/bin/php-config /usr/bin/php-config && chmod +x /usr/local/bin/phpunit && cd /usr/local/src/php-files/redis-4.0.2 && /usr/local/php56/bin/phpize && ./configure --with-php-config=/usr/bin/php-config && make && make install  && cd /usr/local/src/php-files/libmemcached-1.0.18 && ./configure && make && make install && cd /usr/local/src/php-files/memcached-2.2.0  && /usr/local/php56/bin/phpize && ./configure --with-php-config=/usr/bin/php-config --disable-memcached-sasl && make && make install && cd /usr/local/src/php-files/memcache-2.2.7 && /usr/local/php56/bin/phpize && ./configure --with-php-config=/usr/bin/php-config && make && make install && cd /usr/local/src/php-files/apcu-4.0.10 && /usr/local/php56/bin/phpize && ./configure --with-php-config=/usr/bin/php-config && make && make install && rm -rf /usr/local/src/nginx-files/* && rm -rf /usr/local/src/php-files/* && echo "#!/bin/bash" > /usr/local/bin/lnmp &&  echo "/usr/local/bin/php-fpm" >> /usr/local/bin/lnmp &&   echo "/usr/local/bin/nginx -g 'daemon off;'" >> /usr/local/bin/lnmp && chmod +x /usr/local/bin/lnmp

COPY nginx/nginx.conf /usr/local/nginx/conf
COPY php/php.ini /usr/local/php56/lib
COPY php/php-fpm.conf /usr/local/php56/etc


CMD [ "/usr/local/bin/lnmp" ] 

EXPOSE 80 443


