FROM ubuntu:16.04

MAINTAINER Donovan Tengblad

# Install packages
ENV DEBIAN_FRONTEND noninteractive

# Let www-data write
#RUN usermod -u 1000 www-data

RUN apt-get update && apt-get install -y \
  supervisor \
  vim \
  git \
  wget \
  curl \
  apache2 \
  unzip \
  zip \
  xz-utils \
  php-zip \
  mysql-client \
  mysql-server \
  xfonts-75dpi \
  libav-tools \
  php \
  libapache2-mod-php \
  php-xml \
  php-mcrypt \
  php-mysql \
  npm

RUN npm cache clean -f \
  && npm install -g n \
  && n latest

COPY config/install.sh /usr/bin/install.sh
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN chmod +x /usr/bin/install.sh

CMD ["/usr/bin/install.sh"]
