#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "${SCRIPT_DIR}/_env_setting.sh"
docker start $CONTAINER_NAME
# docker attach $CONTAINER_NAME
docker exec -it $CONTAINER_NAME /bin/bash
