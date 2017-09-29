#!/bin/bash

# main entrypoint of the docker container

export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

if [ $(id -u) -ne 0 ]; then
    echo 'Env variable PKCS11_CARD_DRIVER is set for root!'
    sudo='sudo'
fi

logger -p local0.info "Starting PC/SC Smartcard Service"
$sudo /usr/sbin/pcscd

#logger -p local0.info "Starting Safenet Token Monitor"
# not enabled - need to test out dbus support in docker container
#$sudo /usr/bin/SACSrv

# HAVEGE Entropy Service disabled - not so useful on system with clock and modern Linux kernel
#$sudo /usr/sbin/haveged

source /opt/venv/py3/bin/activate
printf 'entropy available: %s bytes\n' $(cat /proc/sys/kernel/random/entropy_avail)
exec bash

