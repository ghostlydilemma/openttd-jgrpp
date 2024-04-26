FROM golang:1.22 AS openttd-admin
RUN go install github.com/sdassow/openttd-admin@d16c9d5

FROM ubuntu:24.04

ARG PATCH_VERSION="0.53.0"
ARG OPENGFX_VERSION="7.1"

# Copy over openttd-admin and add basic wrapper
COPY --from=openttd-admin /go/bin/openttd-admin /usr/local/bin/openttd-admin
ADD rcon.sh /usr/local/bin/rcon

ADD prepare.sh /tmp/prepare.sh
ADD cleanup.sh /tmp/cleanup.sh
ADD buildconfig /tmp/buildconfig
ADD --chown=1000:1000 openttd.sh /openttd.sh

RUN chmod +x /tmp/prepare.sh /tmp/cleanup.sh /openttd.sh /usr/local/bin/rcon
RUN /tmp/prepare.sh \
    && /tmp/cleanup.sh

VOLUME /home/openttd/.local/share/openttd/

EXPOSE 3979/tcp
EXPOSE 3979/udp

STOPSIGNAL 3
ENTRYPOINT [ "/usr/bin/dumb-init", "--rewrite", "15:3", "--rewrite", "9:3", "--" ]
CMD [ "/openttd.sh" ]
