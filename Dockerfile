FROM osrf/ros:jazzy-desktop-full

# Reasons of add packages
#   black: Pythonコード整形の為
#   sysstat: mpstatを実行する為
#   doxygen: doxygen生成の為
#   graphviz: doxygen生成の為
#   clang-format: C++解析の為
#   mesa-utils: glxinfo, glxgears, etc..を利用する為
#   libegl1-mesa:amd64: OpenGL利用のため
#   usbutils: コンテナ内からホストのUSBを確認する為
#   socat: 実機なし試験で必要な仮想シリアルポートを生成する為
#   iproute2: ネットワーク接続のデバッグのため
#   iputils-ping: ネットワーク接続のデバッグのため
#   pipx: Pythonツールのインストールに使用する為
#   ros-jazzy-rmw-cyclonedds-cpp: moveitを使用する為に追加
#   ros-jazzy-moveit-ros-planning-interface: moveit planningを使用する為に追加
#   ros-jazzy-moveit-visual-tools: moveit可視化ツールを使用する為に追加
#   ros-jazzy-moveit-msgs: moveitのメッセージ定義の為に追加
#   ros-jazzy-moveit-resources: moveitのリソースの為に追加
#   ros-jazzy-ros2-control: hwを制御する為に追加
#   ros-jazzy-ros2-controllers: hwを制御する為に追加
#   ros-jazzy-gripper-controllers: handを制御する為に追加
#   ros-jazzy-joint-state-publisher: URDFのチェックに使用する為に追加
#   ros-jazzy-joint-state-publisher-gui: URDFのチェックに使用する為に追加
#   ros-jazzy-octomap-rviz-plugins: 認識系のテストに利用する為に追加

ENV PIPX_HOME=/opt/pipx
ENV PIPX_BIN_DIR=/usr/local/bin

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    vim \
    wget \
    universal-ctags \
    gdb \
    xterm \
    bash-completion \
    xsel \
    black \
    sysstat \
    doxygen \
    graphviz \
    clang-format \
    mesa-utils \
    usbutils \
    socat \
    iproute2 \
    iputils-ping \
    pipx \
    ros-jazzy-rmw-cyclonedds-cpp \
    ros-jazzy-moveit-visual-tools \
    ros-jazzy-moveit-ros-planning-interface \
    ros-jazzy-moveit-msgs \
    ros-jazzy-moveit-resources \
    ros-jazzy-ros2-control \
    ros-jazzy-ros2-controllers \
    ros-jazzy-gripper-controllers \
    ros-jazzy-joint-state-publisher \
    ros-jazzy-joint-state-publisher-gui \
    ros-jazzy-octomap-rviz-plugins \
 && pipx install \
    pip-licenses \
    pylint \
    mypy \
    cpplint \
 && rm -rf /var/lib/apt/lists/*
# TODO:
#    scipy
#    trimesh
#    manifold3d==2.5.1 \
#    pymeshlab==2022.2.post4 \
#    pycollada==0.8
#    pandas
#    # flake8
#    # bpy \  # TODO:

RUN curl -fsSL https://deb.nodesource.com/setup_23.x -o nodesource_setup.sh \
 && bash nodesource_setup.sh \
 && rm nodesource_setup.sh \
 && apt-get install -y --no-install-recommends nodejs \
 && npm install -g @google/gemini-cli \
 && rm -rf /var/lib/apt/lists/*

# RUN curl -fsSL https://claude.ai/install.sh | bash

RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
 && rosdep update

ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
ENV GZ_VERSION=harmonic
