#!/usr/bin/env bash
envsubst < /src/shiny-auth0/.env.example > /src/shiny-auth0/.env

node bin/www
