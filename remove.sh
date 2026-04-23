#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "${SCRIPT_DIR}/_env_setting.sh"
docker rm -f $CONTAINER_NAME || true
docker rmi   $IMG_TAG        || true
