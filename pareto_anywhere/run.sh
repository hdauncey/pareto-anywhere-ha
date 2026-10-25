#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

cd /opt/pareto-anywhere || bashio::exit.nok "Pareto Anywhere not found in image"
bashio::log.info "Node.js $(node --version), Pareto Anywhere $(node -p "require('./package.json').version")"
bashio::log.info "Starting Pareto Anywhere (port 3001: web apps, APIs, Socket.IO, Aruba WebSocket on /aruba)..."
exec npm start
