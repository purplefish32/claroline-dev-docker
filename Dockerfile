FROM ubuntu:16.04

MAINTAINER Donovan Tengblad

# Install packages
ENV DEBIAN_FRONTEND noninteractive

RUN echo "mysql-server-5.6 mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server-5.6 mysql-server/root_password_again password root" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/app-password-confirm password root" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/mysql/admin-pass password root" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/mysql/app-pass password root" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections

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
  ffmpeg \
  php \
  libapache2-mod-php \
  libav-tools \
  php-xml \
  php-mcrypt \
  php-mysql \
  php-curl \
  php-intl \
  npm \
  phpmyadmin \
  apache2-utils \
  php-mbstring \
  php-gettext

RUN npm cache clean -f \
  && npm install -g n \
  && n latest

RUN npm install frontail -g

COPY config/install.sh /usr/bin/install.sh
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/claroline.conf /etc/apache2/sites-available/
COPY config/cc/index.html /var/www/html/claroline/
COPY config/cc/app_dev.php /tmp
RUN a2enmod rewrite

RUN rm /var/www/html/index.html
COPY config/index.html /var/www/html/index.html

RUN echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf
RUN chmod +x /usr/bin/install.sh

CMD ["/usr/bin/install.sh"]
