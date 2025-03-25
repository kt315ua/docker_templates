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
RUN sed -i 's|.*enable\-dbus=.*$|enable\-dbus=no|' /etc/avahi/avahi-daemon.conf && \
    sed -i 's|.*enable\-reflector=.*|enable\-reflector=yes|' /etc/avahi/avahi-daemon.conf && \
    sed -i 's|.*reflect\-ipv=.*|reflect\-ipv=no|' /etc/avahi/avahi-daemon.conf && \
    sed -i 's|.*reflect\-filters=|reflect\-filters=|' /etc/avahi/avahi-daemon.conf && \
    sed -i 's|^use\-ipv6=.*$|use\-ipv6=no|' /etc/avahi/avahi-daemon.conf

# CUPS CONFIG
RUN sed -i 's|Listen localhost:631|Listen 0.0.0.0:631|' /etc/cups/cupsd.conf && \
    sed -i 's|Browsing Off|Browsing On|' /etc/cups/cupsd.conf && \
    sed -i 's|<Location \/>|<Location \/>\n  Allow All|' /etc/cups/cupsd.conf && \
    sed -i 's|<Location \/admin>|<Location \/admin>\n  Allow All\n  Require user @SYSTEM|' /etc/cups/cupsd.conf && \
    sed -i 's|<Location \/admin\/conf>|<Location \/admin\/conf>\n  Allow All|' /etc/cups/cupsd.conf && \
    echo "ServerAlias *" >> /etc/cups/cupsd.conf && \
    echo "DefaultEncryption Never" >> /etc/cups/cupsd.conf

#RUN sed -i 's|Browsing On|Browsing Off|' /etc/cups/cupsd.conf && \
    #sed -i 's|.*BrowseLocalProtocols.*dnssd.*$|BrowseLocalProtocols none|' /etc/cups/cupsd.conf

#RUN sed -i 's|.*BrowseRemoteProtocols.*dnssd.*$|BrowseRemoteProtocols none|' /etc/cups/cups-browsed.conf

# Backup for future restore if user do not provide own configs
RUN cp -rp /etc/cups /etc/cups-backup
VOLUME [ "/etc/cups" ]

COPY scripts/entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
