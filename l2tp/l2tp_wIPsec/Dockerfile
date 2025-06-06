#FROM ghcr.io/linuxserver/baseimage-alpine:arm64v8-3.21
FROM ghcr.io/linuxserver/baseimage-alpine:3.21

ENV LANG C.UTF-8

RUN apk update && apk add --no-cache \
    bash \
    xl2tpd \
    strongswan \
    iproute2 \
    iputils \
    curl \
    iptables \
    net-tools \
    && rm -rf /var/cache/apk/*

RUN mkdir -p /app

COPY --chown=root:root scripts/deploy_configs.sh /app/deploy_configs.sh
COPY --chown=root:root scripts/ppp_manager.sh /app/ppp_manager.sh
COPY --chown=root:root scripts/ppp_setup.sh /app/ppp_setup.sh

RUN chown -R root:root /app
RUN chmod 751 /app/deploy_configs.sh
RUN chmod 751 /app/ppp_manager.sh
RUN chmod 751 /app/ppp_setup.sh

WORKDIR /app

VOLUME /lib/modules

# l2tp
EXPOSE 1701/udp
# ipsec/strongswan
EXPOSE 500/udp
EXPOSE 4500/udp

# Set entrypoint to start ppp_manager
ENTRYPOINT ["/app/ppp_manager.sh"]