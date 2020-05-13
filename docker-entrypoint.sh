#!/usr/bin/env bash
envsubst < /src/shiny-auth0/.env.example > /src/shiny-auth0/.env

# starting supervisor
supervisord -c /etc/supervisord.conf
