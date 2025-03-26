FROM debian:stable-slim

LABEL maintainer="https://github.com/kt315ua/docker_templates"
LABEL version="1.0"
LABEL description="This is a CUPS server container"

ENV LANG C.UTF-8

# ENV variables
ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y \
    apt-utils \
    usbutils \
    cups \
    cups-filters \
    printer-driver-all \
    printer-driver-cups-pdf \
    printer-driver-foo2zjs \
    foomatic-db-compressed-ppds \
    openprinting-ppds \
    hpijs-ppds \
    hp-ppd \
    hplip \
    avahi-daemon \
    avahi-utils \
    libnss-mdns \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Expose SMB printer sharing
EXPOSE 137/udp 139/tcp 445/tcp

# Expose IPP printer sharing
EXPOSE 631/tcp

# Expose avahi advertisement
EXPOSE 5353/udp

# Backend config file changes
# AVAHI CONFIG
RUN sed -i 's|^use\-ipv6=.*$|use\-ipv6=no|' /etc/avahi/avahi-daemon.conf && \
    sed -i 's|.*allow\-interfaces=.*|allow\-interfaces=eth0,lo|' /etc/avahi/avahi-daemon.conf && \
    sed -i 's|.*enable\-dbus=.*$|enable\-dbus=yes|' /etc/avahi/avahi-daemon.conf && \
    sed -i 's|.*enable\-wide\-area=.*|enable\-wide\-area=no|' /etc/avahi/avahi-daemon.conf && \
    sed -i 's|.*publish\-addresses=.*|publish\-addresses=yes|' /etc/avahi/avahi-daemon.conf && \
    sed -i 's|.*publish\-hinfo=.*|publish\-hinfo=yes|' /etc/avahi/avahi-daemon.conf && \
    sed -i 's|.*publish\-workstation=.*|publish\-workstation=yes|' /etc/avahi/avahi-daemon.conf && \
    sed -i 's|.*enable\-reflector=.*|enable\-reflector=yes|' /etc/avahi/avahi-daemon.conf && \
    sed -i 's|.*reflect\-ipv=.*|reflect\-ipv=no|' /etc/avahi/avahi-daemon.conf && \
    sed -i 's|.*reflect\-filters=|reflect\-filters=|' /etc/avahi/avahi-daemon.conf && \
    sed -i 's|.*rlimit-nofile=.*|rlimit-nofile=65535|' /etc/avahi/avahi-daemon.conf

# CUPS CONFIG
## General settings
RUN sed -i 's|MaxLogSize.*|MaxLogSize 32m|' /etc/cups/cupsd.conf && \
    sed -i 's|Listen localhost:631|Listen 0.0.0.0:631|' /etc/cups/cupsd.conf && \
    sed -i 's|Browsing No|Browsing Yes|' /etc/cups/cupsd.conf && \
    sed -i 's|BrowseLocalProtocols.*|BrowseLocalProtocols dnssd|' /etc/cups/cupsd.conf

## Access settings / Security
RUN sed -i 's|<Location \/>|<Location \/>\n  Allow All|' /etc/cups/cupsd.conf && \
    sed -i 's|<Location \/admin>|<Location \/admin>\n  Allow All\n  Require user @SYSTEM|' /etc/cups/cupsd.conf && \
    sed -i 's|<Location \/admin\/conf>|<Location \/admin\/conf>\n  Allow All|' /etc/cups/cupsd.conf

# WORKAROUND for CUPS remote printing
# "SpliX Cannot open job" -> (/usr/lib/cups/filter/rastertoqpdl) with status 4.
# Source: https://forum.mojefedora.cz/t/cups-a-remote-printing-v-f20/7362
COPY scripts/ML-2160-Series-Rem-Print-Only.ppd /usr/share/ppd/custom/ML-2160-Series-Rem-Print-Only.ppd
COPY scripts/rastertosame /etc/cups/rastertosame
RUN chmod +x /etc/cups/rastertosame
RUN ln -s /etc/cups/rastertosame /usr/lib/cups/filter/rastertosame

# Backup for future restore if user do not provide own configs
RUN cp -rp /etc/cups /etc/cups-backup
VOLUME [ "/etc/cups" ]

COPY scripts/entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
