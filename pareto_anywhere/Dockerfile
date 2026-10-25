ARG BUILD_FROM

# Official Node.js 22 LTS (musl build). Pareto Anywhere >= 1.25 needs Node >= 22.12 / 20.19
# because it require()s ES modules (e.g. barnowl-mqtt). Alpine's packaged Node is too old.
FROM node:22-alpine AS node

FROM ${BUILD_FROM}

# Optional: a tag, branch or commit to check out after cloning (empty = default branch)
ARG PARETO_ANYWHERE_REF=""

# Node.js + npm from the official image (needs libstdc++/libgcc at runtime)
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN apk add --no-cache libstdc++ libgcc git \
 && ln -sf ../lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
 && ln -sf ../lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx \
 && node --version && npm --version

# reelyActive's recommended quick-start install
RUN apk add --no-cache --virtual .build-deps python3 make g++ \
 && git clone --recurse-submodules https://github.com/reelyactive/pareto-anywhere.git /opt/pareto-anywhere \
 && cd /opt/pareto-anywhere \
 && if [ -n "${PARETO_ANYWHERE_REF}" ]; then \
      git checkout "${PARETO_ANYWHERE_REF}" && git submodule update --init --recursive; \
    fi \
 && npm install --no-audit --no-fund \
 && npm cache clean --force \
 && apk del .build-deps

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
