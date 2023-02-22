#Look at https://www.howtogeek.com/devops/how-to-use-an-nvidia-gpu-with-docker-containers/ for adding nvidia support once gpu is installed

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
    p7zip

#Install mokuro2pdf
RUN gem install prawn
RUN gem install mini_magick

#Add a user
RUN adduser --home /home/mokuro -u 99 --gid 100 mokuro --disabled-password
USER mokuro

#Install mokuro
RUN pip3 install --upgrade pip

RUN pip3 install mokuro

#Define mount volume
VOLUME ["/manga"]

# Metadata.
LABEL \
      org.label-schema.name="Mokuro" \
      org.label-schema.description="Docker container for Mokuro and Mokuro2Pdf" \
      org.label-schema.version="$DOCKER_IMAGE_VERSION" \
      org.label-schema.vcs-url="https://github.com/Gin-no-kami/docker-mokuro/" \
      org.label-schema.schema-version="1.0"