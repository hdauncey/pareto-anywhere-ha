#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

PARETO_DIR=/opt/pareto-anywhere
# /config inside the container = /addon_configs/<repo>_pareto_anywhere on the HA host (persistent, user-editable)
USER_CONFIG_DIR=/config
# Runtime config handed to Pareto Anywhere (rebuilt on every start)
RUNTIME_CONFIG_DIR=/tmp/pareto-config

cd "${PARETO_DIR}" || bashio::exit.nok "Pareto Anywhere not found in image"

# Seed the persistent folder with Pareto Anywhere's default files (never overwrite user edits)
mkdir -p "${USER_CONFIG_DIR}"
if [[ -d "${PARETO_DIR}/config" ]]; then
  cp -rn "${PARETO_DIR}/config/." "${USER_CONFIG_DIR}/" 2>/dev/null || true
fi
[[ -f "${USER_CONFIG_DIR}/enocean.json" ]] || echo '{}' > "${USER_CONFIG_DIR}/enocean.json"

# Build the runtime config folder: everything from the persistent folder (certificates etc.)...
rm -rf "${RUNTIME_CONFIG_DIR}"
mkdir -p "${RUNTIME_CONFIG_DIR}"
cp -r "${USER_CONFIG_DIR}/." "${RUNTIME_CONFIG_DIR}/"

# ...plus enocean.json merged from the file and the add-on Configuration tab (tab wins)
node /opt/enocean-profiles.js "${USER_CONFIG_DIR}/enocean.json" /data/options.json "${RUNTIME_CONFIG_DIR}/enocean.json" \
  || bashio::exit.nok "Could not build enocean.json (see errors above)"

export PARETO_ANYWHERE_CONFIG_PATH="${RUNTIME_CONFIG_DIR}"

bashio::log.info "Node.js $(node --version), Pareto Anywhere $(node -p "require('./package.json').version")"
bashio::log.info "Starting Pareto Anywhere (port 3001: web apps, APIs, Socket.IO, Aruba WebSocket on /aruba)..."
exec npm start
