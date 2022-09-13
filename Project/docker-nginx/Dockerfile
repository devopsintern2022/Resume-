FROM debian:11 AS first
WORKDIR /projectng
RUN apt-get update &&  apt-get install -y libpcre3 libpcre3-dev wget make autoconf automake checkinstall build-essential zlib1g zlib1g-dev libssl-dev g++ gcc 
RUN wget https://nginx.org/download/nginx-1.18.0.tar.gz && tar -xzvf nginx-1.18.0.tar.gz
WORKDIR /projectng/nginx-1.18.0
RUN ./configure --sbin-path=/usr/bin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/var/run/nginx.pid --with-http_ssl_module --error-log-path=/var/log/nginx/acces.log --http-log-path=/var/log/nginx/access.log --with-pcre && make && checkinstall -y --pkgname=ngpack --install=no --requires " libpcre3 (>= 2:8.39-13), libpcre3-dev (>= 2:8.39-13), zlib1g (>= 1:1.2.11.dfsg-2+deb11u1), zlib1g-dev (>= 1:1.2.11.dfsg-2+deb11u1), libssl-dev (>= 1.1.1n-0+deb11u3) "


FROM debian:11
WORKDIR /2pr 
EXPOSE 80
COPY --from=first  /projectng/nginx-1.18.0/ngpack_1.18.0-1_amd64.deb  /2pr
RUN  apt-get install -y dpkg && mkdir /var/log/nginx && touch /var/log/nginx/access.log && mkdir /etc/nginx && dpkg -i ngpack_1.18.0-1_amd64.deb && touch /var/run/nginx.pid 
COPY --from=first /projectng/nginx-1.18.0/conf/nginx.conf  /etc/nginx 
CMD ["nginx", "-g", "daemon off;"]


