FROM node:lts-bullseye

RUN apt-get -yy update && apt-get -yy dist-upgrade && apt-get -yy autoremove && apt-get -yy autoclean
RUN apt-get -yy install openssh-server vim nload net-tools dnsutils htop git build-essential curl wget tar gzip

RUN mkdir -p /init-scripts/
ADD node/*.sh /init-scripts/
ADD scripts/*.sh /init-scripts/
ADD .env /init-scripts/
ADD *.sh /init-scripts/

WORKDIR /init-scripts

EXPOSE 22

CMD ["/init-scripts/run.sh"]
