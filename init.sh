#!/bin/bash
set -e
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "${SCRIPT_DIR}"
source _env_setting.sh

function createhardlink() {
    if [ $# -ne 2 ]; then
        echo "[error] wrong number of arguments."
        echo "  usage : createhardlink <src_file_path> <target_file_path>"
        return 1
    fi
    src_file_path=$1
    target_file_path=$2
    target_dir_path=${target_file_path%/*}

    if [ "${target_dir_path}" != "${target_file_path}" ]; then
        if [ ! -d "${target_dir_path}" ]; then
            mkdir -p "${target_dir_path}"
        fi
    fi
    ln -f "${src_file_path}" "${target_file_path}"
}
mkdir -p ${MOUNT_DIR_PATH}
createhardlink ~/_dotfiles/.bashrc              ${MOUNT_DIR_PATH}/.bashrc
createhardlink ~/_dotfiles/.bashrc_env          ${MOUNT_DIR_PATH}/.bashrc_env
createhardlink ~/_dotfiles/.gdbinit             ${MOUNT_DIR_PATH}/.gdbinit
createhardlink ~/_dotfiles/.inputrc             ${MOUNT_DIR_PATH}/.inputrc
createhardlink ~/_dotfiles/.tigrc               ${MOUNT_DIR_PATH}/.tigrc
createhardlink ~/_dotfiles/.tmux.conf           ${MOUNT_DIR_PATH}/.tmux.conf
createhardlink ~/_dotfiles/.vimrc               ${MOUNT_DIR_PATH}/.vimrc
createhardlink ~/_dotfiles/.ai_agents/AGENTS.md ${MOUNT_DIR_PATH}/.gemini/GEMINI.md
createhardlink ~/_dotfiles/.ai_agents/AGENTS.md ${MOUNT_DIR_PATH}/.claude/CLAUDE.md
cp -rf ~/.vim ${MOUNT_DIR_PATH}/.
echo ${CONTAINER_NAME} > ${MOUNT_DIR_PATH}/.dockercontainer
FILE=/home/$USER/_app/virtualgl_3.1_amd64.deb
if [ -f ${FILE} ]; then
    mkdir -p ${MOUNT_DIR_PATH}/_app
    \cp -f ${FILE} ${MOUNT_DIR_PATH}/_app/.
fi
\cp -f ./install_prg.sh ${MOUNT_DIR_PATH}/.

user_groups="$(id --real --groups $USER)"
add_groups=$(for t in $user_groups; do echo "--group-add=$t"; done)

echo "---- remove old images and containers"
docker stop $CONTAINER_NAME || true
docker rm   $CONTAINER_NAME || true
docker rmi  $IMG_TAG         || true

echo "---- building a new image"
docker build --debug -t $IMG_TAG .

echo "---- creating a new container"
docker create -it\
    --user="$(id -u $USER):$(id -g $USER)"\
    $add_groups\
    --env="DISPLAY"\
    --env="USER"\
    --env=QT_X11_NO_MITSHM=1\
    --workdir="/home/$USER"\
    --volume="$MOUNT_DIR_PATH:/home/$USER"\
    --volume="/home/$USER/.Xauthority:/home/$USER/.Xauthority"\
    --volume="/etc/group:/etc/group:ro"\
    --volume="/etc/passwd:/etc/passwd:ro"\
    --volume="/etc/shadow:/etc/shadow:ro"\
    --volume="/etc/sudoers.d:/etc/sudoers.d:ro"\
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw"\
    --net=host\
    --name $CONTAINER_NAME\
    $IMG_TAG\
    bash
    # --gpus='"all","capabilities=compute,graphics,utility,compat32,video,display"'\
    # --device="/dev/ttyUSB0:/dev/ttyUSB0"\
    # --device="/dev/video0:/dev/video0:mwr"\
    # --device="/dev/video1:/dev/video1:mwr"\
    # --device="/dev/video2:/dev/video2:mwr"\
    # --device="/dev/video3:/dev/video3:mwr"\
    # --device="/dev/video4:/dev/video4:mwr"\
    # --device="/dev/video5:/dev/video5:mwr"\

echo "---- running a new container"
docker start $CONTAINER_NAME

echo "---- executing commands in the container"
docker exec -it $CONTAINER_NAME /home/$USER/install_prg.sh

echo "---- attach the container"
docker exec -e DISPLAY -it $CONTAINER_NAME /ros_entrypoint.sh bash
