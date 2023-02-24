FROM ubuntu:latest

ARG DOCKER_IMAGE_VERSION=v1.0

ARG DEBIAN_FRONTEND=noninteractive

#Base packages needed
RUN apt-get update && apt-get install -y \
    build-essential \
    python3 \
    python3-pip \
    python3-opencv \
    ruby-full \
    imagemagick \
    python3-venv \
    p7zip-full \
    wget \
    locales && \
    #Install mokuro2pdf
    gem install prawn && \
    gem install mini_magick

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen

#Add a user
RUN adduser --home /home/mokuro -u 99 --gid 100 mokuro --disabled-password
USER mokuro

#Install mokuro
RUN pip3 install --upgrade pip && \
    pip3 install mokuro

RUN cd /home/mokuro && \
    wget https://github.com/kha-white/mokuro/archive/refs/tags/v0.1.6.zip && \
    7z x v0.1.6.zip && \ 
    rm v0.1.6.zip && \
    ls -al mokuro-0.1.6/tests/data/volumes/vol1 && \
    rm -rf mokuro-0.1.6/tests/data/volumes/_ocr vol1.html && \
    python3 /home/mokuro/.local/bin/mokuro --disable_confirmation --parent_dir mokuro-0.1.6/tests/data/volumes/ && \
    rm -rf mokuro-0.1.6


ENV LC_ALL en_US.UTF-8 
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en

ADD addOCR.sh /home/mokuro/addOCR.sh

#Define mount volume
VOLUME ["/manga"]

# Metadata.
LABEL \
      org.label-schema.name="Mokuro" \
      org.label-schema.description="Docker container for Mokuro and Mokuro2Pdf" \
      org.label-schema.version="$DOCKER_IMAGE_VERSION" \
      org.label-schema.vcs-url="https://github.com/Gin-no-kami/docker-mokuro/" \
      org.label-schema.schema-version="1.0"