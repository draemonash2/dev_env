# 開発用Docker環境構築リポジトリ

Dockerコンテナ上に開発環境を構築するためのリポジトリ。

## 構成

| ファイル | 説明 |
|---|---|
| `Dockerfile` | Docker イメージ定義 |
| `_env_setting.sh` | イメージ名・コンテナ名等の共通変数定義 |
| `init.sh` | イメージビルド・コンテナ作成・起動（初回のみ実行） |
| `attach.sh` | 既存コンテナへのアタッチ（2回目以降） |
| `remove.sh` | コンテナ・イメージの削除 |
| `install_prg.sh` | コンテナ内で実行する追加インストールスクリプト |

## 前提条件

- Docker がインストール済みであること
- `~/_dotfiles/` に以下のドットファイルが存在すること
  - `.bashrc`, `.bashrc_env`, `.gdbinit`, `.inputrc`, `.tigrc`, `.tmux.conf`, `.vimrc`
  - `.ai_agents/AGENTS.md`（Gemini / Claude の共通設定）

## 手順

### 初回構築

1. `_env_setting.sh`を編集する。
    - Dockerイメージ名、Dockerコンテナ名などを編集する。
1. DockerイメージビルドおよびDockerコンテナ作成を行う。

    ```bash
    cd /path/to/ros2_jazzy/docker
    ./init.sh
    ```

    - 以下の処理を自動で実行する。
        1. `~/_dotfiles/` 配下のドットファイルを `../mount/` へハードリンク
        1. 既存のコンテナ・イメージを削除
        1. Docker イメージをビルド
        1. コンテナを作成・起動
        1. コンテナ内で `install_prg.sh` を実行（Claude CLI・VirtualGL のインストール）
        1. コンテナにアタッチ

### 2回目以降

1. コンテナを起動してアタッチする。

    ```bash
    ./attach.sh
    ```


### 環境削除

1. コンテナとイメージを削除する。  
（`../mount/` ディレクトリは削除されない）

    ```bash
    ./remove.sh
    ```
