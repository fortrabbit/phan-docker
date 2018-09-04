FROM php:7.2-cli-alpine

# Install composer
ARG COMPOSER_RELEASE="1.7.2"
ARG COMPOSER_SHA256="ec3428d049ae8877f7d102c2ee050dbd51a160fc2dde323f3e126a3b3846750e"
RUN cd /tmp &&\
   curl -O https://getcomposer.org/download/$COMPOSER_RELEASE/composer.phar &&\
   echo "$COMPOSER_SHA256  composer.phar" | sha256sum -c &&\
   mv composer.phar /usr/local/bin

# Install ast extension
ARG AST_RELEASE="0.1.6"
RUN apk --no-cache add build-base autoconf &&\
    pecl install ast-$AST_RELEASE &&\
    printf "extension=ast.so" > /usr/local/etc/php/conf.d/ast.ini &&\
    apk del build-base autoconf

# Install phan
ARG PHAN_RELEASE="1.0.1"
RUN set -eux &&\
    apk --no-cache add git &&\
    mkdir -p "/opt/" &&\
    cd "/opt/" &&\
    git clone -v --single-branch --depth 1 https://github.com/phan/phan.git --branch $PHAN_RELEASE &&\
    cd phan &&\
    php /usr/local/bin/composer.phar --prefer-dist --no-dev --ignore-platform-reqs --no-interaction install &&\
    rm -rf .git &&\
    apk del git

WORKDIR /mnt/src

CMD ["php", "/opt/phan/phan"]
