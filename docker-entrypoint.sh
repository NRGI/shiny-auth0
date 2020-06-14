#!/usr/bin/env bash
envsubst < /src/shiny-auth0/.env.example > /src/shiny-auth0/.env
# setting papertrail credentials in the config file for rsyslog
envsubst < /src/shiny-auth0/docker/log_files.yml > /etc/log_files.yml

# starting supervisor
supervisord -c /etc/supervisord.conf
