FROM python:3.5
MAINTAINER Paulus Schoutsen <Paulus@PaulusSchoutsen.nl>

LABEL org.freenas.interactive="false" 		\
      org.freenas.version="0.40.2"		\
      org.freenas.upgradeable="false"		\
      org.freenas.expose-ports-at-host="true"	\
      org.freenas.autostart="true"		\
#      org.freenas.capabilities-add="NET_BROADCAST" \
      org.freenas.web-ui-protocol="http"	\
      org.freenas.web-ui-port=8123		\
#      org.freenas.web-ui-path="web"		\
      org.freenas.port-mappings="8123:8123/tcp"			\
      org.freenas.volumes="[					\
          {							\
              \"name\": \"/config\",				\
              \"descr\": \"Config storage space\"		\
          },							\
      ]"							\
      org.freenas.settings="[ 					\
          {							\
              \"env\": \"TZ\",					\
              \"descr\": \"Home Assistant container Timezone\",		\
              \"optional\": true				\
          },							\
      ]"

# Uncomment any of the following lines to disable the installation.
#ENV INSTALL_TELLSTICK no
#ENV INSTALL_OPENALPR no
#ENV INSTALL_FFMPEG no
#ENV INSTALL_OPENZWAVE no
#ENV INSTALL_LIBCEC no
#ENV INSTALL_PHANTOMJS no

VOLUME /config

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy build scripts
COPY virtualization/Docker/ virtualization/Docker/
RUN virtualization/Docker/setup_docker_prereqs

# Install hass component dependencies
COPY requirements_all.txt requirements_all.txt
RUN pip3 install --no-cache-dir -r requirements_all.txt && \
    pip3 install --no-cache-dir mysqlclient psycopg2 uvloop

# Copy source
COPY . .

CMD [ "python", "-m", "homeassistant", "--config", "/config" ]
