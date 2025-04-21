#!/bin/bash -ex

ctrl_c() {
    echo -e "\nTerminating cupsd..."
    killall cupsd
    echo -e "\nScript aborted by user."
    exit 0
}

trap ctrl_c INT

if [ -z "${CUPSADMIN}" ]; then
    echo "Error: variable CUPSADMIN not configured."
    exit 1
fi

if [ $(grep -ci ${CUPSADMIN} /etc/shadow) -eq 0 ]; then
    useradd -r -G lpadmin -M ${CUPSADMIN}

    # update CUPS creds
    echo "${CUPSADMIN}:************** | chpasswd"
    set +x
    echo ${CUPSADMIN}:${CUPSPASSWORD} | chpasswd
    set -x

    # update TZ
    ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime
fi

# restore default cups config in case user does not have any
if [ ! -f /etc/cups/cupsd.conf ]; then
    cp -rpn /etc/cups-backup/* /etc/cups/
fi

# Fixups
## Unknown directive IdleExitTimeout on line 32 of /etc/cups/cupsd.conf.
sed -i "/IdleExitTimeout/d" /etc/cups/cupsd.conf

# Tune ulimit for Avahi and Cups services
ulimit -n 65535

service dbus start
sleep 1 # Give a time for service warmup
/usr/sbin/avahi-daemon -f /etc/avahi/avahi-daemon.conf >> /var/log/avahi.log 2>&1 &
sleep 1 # Give a time for service warmup
#ulimit -n 65535 && /usr/sbin/cupsd -c /etc/cups/cupsd.conf &
service cups start

set +x
while true; do
    if ! pgrep cupsd > /dev/null; then
        echo "cupsd is not running! Exiting..."
        exit 1
    fi
    sleep 5
done
