FROM osrf/ros:humble-desktop-full

# Reasons of add packages
#   black: Pythonコード整形の為(pipx経由でインストール)
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
#   ros-humble-rmw-cyclonedds-cpp: moveitを使用する為に追加
#   ros-humble-moveit-ros-planning-interface: moveit planningを使用する為に追加
#   ros-humble-moveit-visual-tools: moveit可視化ツールを使用する為に追加
#   ros-humble-moveit-msgs: moveitのメッセージ定義の為に追加
#   ros-humble-moveit-resources: moveitのリソースの為に追加
#   ros-humble-ros2-control: hwを制御する為に追加
#   ros-humble-ros2-controllers: hwを制御する為に追加
#   ros-humble-gripper-controllers: handを制御する為に追加
#   ros-humble-joint-state-publisher: URDFのチェックに使用する為に追加
#   ros-humble-joint-state-publisher-gui: URDFのチェックに使用する為に追加
#   ros-humble-octomap-rviz-plugins: 認識系のテストに利用する為に追加

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
    sysstat \
    doxygen \
    graphviz \
    clang-format \
    mesa-utils \
    usbutils \
    socat \
    iproute2 \
    iputils-ping \
    python3-pip \
    pipx \
    ros-humble-rmw-cyclonedds-cpp \
    ros-humble-moveit-visual-tools \
    ros-humble-moveit-ros-planning-interface \
    ros-humble-moveit-msgs \
    ros-humble-moveit-resources \
    ros-humble-ros2-control \
    ros-humble-ros2-controllers \
    ros-humble-gripper-controllers \
    ros-humble-joint-state-publisher \
    ros-humble-joint-state-publisher-gui \
    ros-humble-octomap-rviz-plugins \
 && pipx install pip-licenses \
 && pipx install pylint \
 && pipx install mypy \
 && pipx install cpplint \
 && pipx install black \
 && pipx install flake8 \
 && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --no-cache-dir \
    scipy \
    trimesh \
    "manifold3d==2.5.1" \
    "pymeshlab==2022.2.post4" \
    "pycollada==0.8" \
    pandas

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
ENV GZ_VERSION=fortress
