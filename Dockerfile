FROM php:5.6-apache

MAINTAINER Donovan Tengblad

# Install packages
ENV DEBIAN_FRONTEND noninteractive

ENV CLAROLINE_VERSION 6.0.3

# Let www-data write
RUN usermod -u 1000 www-data

RUN apt-get update && apt-get install -y \
  vim \
  git \
  wget \
  curl \
  unzip \
  zip \
  xz-utils \
  mysql-client \
  xfonts-75dpi \
  libav-tools \
  #echo "ServerName localhost" >> /etc/apache2/apache2.conf \
    && cd /var/www/html \
    && wget "http://packages.claroline.net/releases/$CLAROLINE_VERSION/claroline-$CLAROLINE_VERSION-dev.tar.gz" \
    && tar -xzf "claroline-$CLAROLINE_VERSION-dev.tar.gz" \
    && mv "claroline-$CLAROLINE_VERSION-dev" claroline \
    && cd claroline \
    && chown -R www-data:www-data app/cache app/config app/logs app/sessions files web/uploads \
    && chmod -R 777 app/cache app/config app/logs app/sessions files web/uploads

# Install PDO MySQL
RUN docker-php-ext-install pdo pdo_mysql

# Install mcrypc
RUN apt-get update && apt-get install -y \
        libmcrypt-dev \
    && docker-php-ext-install -j$(nproc) mcrypt

# Install intl
RUN apt-get update && apt-get install -y \
        libicu-dev \
    && docker-php-ext-install -j$(nproc) intl

# Install zip
RUN apt-get update && apt-get install -y zlib1g-dev \
    && docker-php-ext-install zip

# Install gd
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng12-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

COPY config/php.ini /usr/local/etc/php/
COPY config/app_dev.php /var/www/html/claroline/web/
COPY config/parameters.yml /var/www/html/claroline/app/config/

# Install composer
RUN wget https://raw.githubusercontent.com/composer/getcomposer.org/master/web/installer \
    && php installer \
    && mv composer.phar /usr/local/bin/composer

# Install node
# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 5.10.1

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt

#Claroline installation script
COPY config/install.sh /var/www/html/claroline/install.sh
RUN chmod +x /var/www/html/claroline/install.sh

#Run composer
#RUN cd /var/www/html/claroline \
#    && composer sync-dev

#Create admin user
#RUN php app/console claroline:user:create -a John Doe admin admin jhon.doe@test.com

EXPOSE 80

# By default, simply start apache.
CMD /usr/sbin/apache2ctl -D FOREGROUND
