#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

bashio::log.info "Starting Pareto Anywhere (port 3001: web apps, APIs, Socket.IO, Aruba WebSocket on /aruba)..."
cd /opt/pareto-anywhere || bashio::exit.nok "Pareto Anywhere not found in image"
exec npm start
