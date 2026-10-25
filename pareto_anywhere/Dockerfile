ARG BUILD_FROM
FROM ${BUILD_FROM}

# Optional: a tag, branch or commit to check out after cloning (empty = default branch)
ARG PARETO_ANYWHERE_REF=""

# git stays installed so the repository can be inspected from inside the container
RUN apk add --no-cache nodejs npm git \
 && apk add --no-cache --virtual .build-deps python3 make g++

# reelyActive's recommended quick-start install
RUN git clone --recurse-submodules https://github.com/reelyactive/pareto-anywhere.git /opt/pareto-anywhere \
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
