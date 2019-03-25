#!/usr/bin/env bash

## Mini-World Sawmill Installer
# This script installs the PiMediaSync application and sets 
# up all of the components (video and config) necessary to 
# run the installation. 
#
# Note, all ENV with 'export' are used by the PiMediaSync setup script

set -e
if [ "$(whoami)" != "root" ]; then
    echo "must be run as root."
    exit 1G
fi

HOMEDIR="${HOMEDIR:-/root}"
WORKDIR="${HOMEDIR}/sawmill"
SAWMILL_VERSION="${SAWMILL_VERSION:-0.2.0}"

# mini-world-sawmill repo uses git lfs, currently not available on RPI
# so, wget the files we want
rm -rf ${WORKDIR} # clear first
mkdir -p ${WORKDIR}/video
wget -P ${WORKDIR} https://raw.githubusercontent.com/limbicmedia/mini-world-sawmill-display/${SAWMILL_VERSION}/sawmill_config.py
wget -P ${WORKDIR}/video https://github.com/limbicmedia/mini-world-sawmill-display/raw/${SAWMILL_VERSION}/video/sawmill.mov

export PIHOSTNAME="miniworld-sawmill"

# Setup PiMediaSync application
SAWMILL_CONFIG_FILE="${SAWMILL_CONFIG_FILE:-sawmill_config.py}"
export APPLICATION_FLAGS="-c${WORKDIR}/${SAWMILL_CONFIG_FILE}"
export PIMEDIASYNC_VERSION="${PIMEDIASYNC_VERSION:-v1.0.0}"
wget -O - https://raw.githubusercontent.com/limbicmedia/PiMediaSync/${PIMEDIASYNC_VERSION}/scripts/install.sh | bash

# install video in location used by PiMediaSync
PIMEDIASYNC_DIR="${PIMEDIASYNC_DIR:-/opt/pimediasync}" # come from export in pimediasync setup
ln -s ${WORKDIR}/video ${PIMEDIASYNC_DIR}/video

echo "Installation Finished, reboot the device."
set +e
