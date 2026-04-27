#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "${SCRIPT_DIR}/_env_setting.sh"
docker start $CONTAINER_NAME
docker exec -e DISPLAY -it $CONTAINER_NAME /ros_entrypoint.sh bash
