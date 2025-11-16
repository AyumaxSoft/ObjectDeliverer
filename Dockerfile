# Unreal Engine 5.6.0 slim イメージを使用
FROM ghcr.io/epicgames/unreal-engine:dev-slim-5.6.0

# rootユーザーとして作業
USER root

# 作業ディレクトリを設定
WORKDIR /project

# プロジェクトファイルをコンテナにコピー
COPY . /project

# 必要なディレクトリを作成して権限を設定
RUN mkdir -p /project/Packaged && \
    mkdir -p /project/Plugins/ObjectDeliverer/Intermediate && \
    mkdir -p /project/Intermediate && \
    mkdir -p /project/Binaries && \
    mkdir -p /project/Saved && \
    chown -R ue4:ue4 /project && \
    chmod -R 755 /project

# ue4ユーザーに切り替え
USER ue4

# プロジェクトをビルド・パッケージ（シンプルな設定で）
RUN /home/ue4/UnrealEngine/Engine/Build/BatchFiles/RunUAT.sh \
    BuildCookRun \
    -project=/project/ObjectDelivererTest.uproject \
    -noP4 \
    -platform=Linux \
    -clientconfig=Shipping \
    -cook \
    -allmaps \
    -build \
    -stage \
    -pak \
    -archive \
    -archivedirectory=/project/Packaged

# rootに戻す
USER root

# ビルド成果物を出力用ボリュームにコピーするためのエントリポイント
CMD ["cp", "-r", "/project/Packaged", "/output/"]