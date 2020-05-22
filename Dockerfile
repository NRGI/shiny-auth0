FROM node:14.1.0

# Install dependencies and Download and install shiny server
RUN apt-get update && apt-get install -y  \
    curl \
    build-essential \
    python \
    python-setuptools \
    python-pip \
    gettext-base \
    && pip install --index-url=https://pypi.python.org/simple/ supervisor &&\
    cp /usr/bin/envsubst /usr/local/bin/envsubst &&\
    rm -f version.txt ss-latest.deb && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O -L https://github.com/papertrail/remote_syslog2/releases/download/v0.19/remote_syslog_linux_amd64.tar.gz \
    && tar -zxf remote_syslog_linux_amd64.tar.gz  \
    && cp remote_syslog/remote_syslog /usr/local/bin  \
    && rm -r remote_syslog_linux_amd64.tar.gz \
    && rm -r remote_syslog

RUN mkdir /var/log/supervisor/
# copy supervisord config
COPY docker/supervisord.conf /etc/supervisord.conf


COPY . /src/shiny-auth0/
RUN cd /src/shiny-auth0/ && \
    npm install

WORKDIR /src/shiny-auth0

RUN ["chmod", "+x", "/src/shiny-auth0/docker-entrypoint.sh"]

CMD ["/src/shiny-auth0/docker-entrypoint.sh"]