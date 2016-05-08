FROM ubuntu:16.04

MAINTAINER pozar
ENV MINECRAFT_VERSION 1.9.2

RUN apt-get update

#install basic applications
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  lsof \
  screen \
  rsync \
  zip \
  sudo \
  vim \
  jq \
  wget \
  cron \
  default-jre \
  nginx \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN useradd -M -s /bin/false --uid 1000 minecraft \
  && mkdir /data \
  && mkdir /map \
  && chown minecraft:minecraft /data /map

COPY install_msm.sh /tmp/install_msm.sh
COPY msm.conf /etc/msm.conf
COPY overviewer /etc/cron.d/overviewer
COPY nginx.conf /etc/nginx/nginx.conf
COPY overviewer.conf map.sh start.sh users /data/

RUN bash /tmp/install_msm.sh \
  && sudo msm server create world \
  && sudo -u minecraft echo -n "eula=true" > /data/servers/world/eula.txt \
  && chown minecraft:minecraft /data/servers/world/eula.txt

COPY server.properties /data/servers/world/server.properties
RUN chown minecraft:minecraft /data/servers/world/server.properties

RUN wget --no-check-certificate https://s3.amazonaws.com/Minecraft.Download/versions/${MINECRAFT_VERSION}/${MINECRAFT_VERSION}.jar -O /data/client.jar \
  && wget -O - http://overviewer.org/debian/overviewer.gpg.asc | apt-key add - \
  && echo "deb http://overviewer.org/debian ./" >> /etc/apt/sources.list \
  && apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  minecraft-overviewer \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

EXPOSE 25565 25575 80

VOLUME /data /map

WORKDIR /data

CMD [ "/data/start.sh" ]