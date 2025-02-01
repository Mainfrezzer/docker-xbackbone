# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.20

# set version label
ARG BUILD_DATE="01.02.2025"
ARG VERSION="3.8.1-v1-178"
ARG XBACKBONE_RELEASE="3.8.1"
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Mainfrezzer"

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    ssmtp \
    php83-ftp \
    php83-gd \
    php83-intl \
    php83-ldap \
    php83-mysqli \
    php83-pdo_mysql \
    php83-pdo_sqlite \
    php83-sqlite3 \
    php83-tokenizer && \
  echo "**** install xbackbone ****" && \
    mkdir -p /app/www/public && \
  if [ -z ${XBACKBONE_RELEASE+x} ]; then \
    XBACKBONE_RELEASE=$(curl -sX GET "https://api.github.com/repos/SergiX44/XBackBone/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -o \
    /tmp/xbackbone.zip -L \
    "https://github.com/SergiX44/XBackBone/releases/download/${XBACKBONE_RELEASE}/release-v${XBACKBONE_RELEASE}.zip" && \
  unzip -q -o /tmp/xbackbone.zip -d /app/www/public/ && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/* \
    $HOME/.cache

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config
