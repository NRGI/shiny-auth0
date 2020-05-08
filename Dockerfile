FROM node:14.1.0

# Install dependencies and Download and install shiny server
RUN apt-get update && apt-get install -y  \
    build-essential \
    gettext-base && \
    cp /usr/bin/envsubst /usr/local/bin/envsubst &&\
    rm -f version.txt ss-latest.deb && \
    rm -rf /var/lib/apt/lists/*

COPY . /src/shiny-auth0/
RUN cd /src/shiny-auth0/ && \
    npm install

WORKDIR /src/shiny-auth0

RUN ["chmod", "+x", "/src/shiny-auth0/docker-entrypoint.sh"]

CMD ["/src/shiny-auth0/docker-entrypoint.sh"]