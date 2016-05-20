FROM ubuntu:16.04

MAINTAINER Donovan Tengblad

# Install packages
ENV DEBIAN_FRONTEND noninteractive

# Let www-data write
#RUN usermod -u 1000 www-data

RUN apt-get update && apt-get install -y \
  vim \
  git \
  wget \
  curl \
  apache2 \
  unzip \
  zip \
  xz-utils \
  mysql-client \
  mysql-server \
  xfonts-75dpi \
  libav-tools \
  php \
  libapache2-mod-php \
  php-mcrypt \
  php-mysql \
