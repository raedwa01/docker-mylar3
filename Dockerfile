FROM python:3.8.2-buster

ARG BUILD_DATE
ARG VERSION
LABEL build_version="Technically Possible version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="raedwa01"

RUN \
 echo "*** install system packages ***" && \
 curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
RUN /bin/bash -c "source $HOME/.bashrc;  nvm install 10.19.0"

RUN ln -s $HOME/.nvm/versions/node/v10.19.0/bin/node /usr/bin/node
RUN ln -s $HOME/.nvm/versions/node/v10.19.0/bin/npn /usr/bin/npm

RUN curl -o- https://raw.githubusercontent.com/mylar3/mylar3/master/requirements.txt >> requirements.txt

RUN \
 echo "*** install dependencies***" && \
   pip3 install -r requirements.txt && \
 git clone https://github.com/mylar3/mylar3.git /app/mylar && \
 rm requirements.txt && \
 rm -rf \
   /root/.cache \
   /tmp/*

# add local files
#COPY root/ /
#RUN chmod +x /app/mylar/init-scripts/init.d/ubuntu.init.d
#RUN ln -s /app/mylar/init-scripts/init.d/ubuntu.init.d /etc/init.d/mylar
#RUN adduser --system --no-create-home mylar
#RUN chown mylar:nogroup -R /app/mylar
#RUN update-rc.d mylar defaults


#ports and volumes
VOLUME /config /comics /downloads
EXPOSE 8090

#ENTRYPOINT systemctl enable mylar && systemctl start mylar && bash
ENTRYPOINT python3 /app/mylar/Mylar.py && bash


