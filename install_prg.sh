#!/bin/bash
set -e

# Install claude
curl -fsSL https://claude.ai/install.sh | bash

# Install VirtualGL
FILE=/home/$USER/_app/virtualgl_3.1_amd64.deb
if [ -f ${FILE} ]; then
    dpkg -i ${FILE}
fi
