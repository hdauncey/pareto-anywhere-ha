ARG BUILD_FROM
FROM ${BUILD_FROM}

ARG PARETO_ANYWHERE_REF=master

RUN apk add --no-cache nodejs npm \
 && apk add --no-cache --virtual .build-deps git python3 make g++ \
 && git clone --depth 1 --branch "${PARETO_ANYWHERE_REF}" \
      --recurse-submodules --shallow-submodules \
      https://github.com/reelyactive/pareto-anywhere.git /opt/pareto-anywhere \
 && cd /opt/pareto-anywhere && npm install --no-audit --no-fund \
 && rm -rf /opt/pareto-anywhere/.git \
 && npm cache clean --force \
 && apk del .build-deps

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
