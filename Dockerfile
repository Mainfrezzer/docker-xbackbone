FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.13

# set version label
ARG BUILD_DATE
ARG VERSION
ARG XBACKBONE_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="gilbn"

RUN \
  echo "**** install build packages ****" && \
    apk add --no-cache --virtual=build-dependencies \
    composer && \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    curl \
    php7 \
    php7-sqlite3 \
    php7-mysqli \
    php7-pdo_mysql \
    php7-pdo_sqlite \
    php7-gd \
    php7-json \
    php7-fileinfo \
    php7-zip \
    php7-ftp \
    php7-ldap \
    php7-tokenizer \
    php7-intl && \
  echo "**** install xbackbone ****" && \
    mkdir -p /app/xbackbone && \
  if [ -z ${XBACKBONE_RELEASE+x} ]; then \
    XBACKBONE_RELEASE=$(curl -sX GET "https://api.github.com/repos/SergiX44/XBackBone/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -o \
    /tmp/xbackbone.zip -L \
    "https://github.com/SergiX44/XBackBone/releases/download/${XBACKBONE_RELEASE}/release-v${XBACKBONE_RELEASE}.zip" && \
  unzip -q -o /tmp/xbackbone.zip -d /app/xbackbone/ && \
  echo "**** cleanup ****" && \
  apk del --purge \
    build-dependencies && \
  rm -rf \
    /root/.cache \
    /tmp/*

# copy local files
COPY root/ /
