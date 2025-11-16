@echo off

echo Starting UniversalSerial Linux Shipping build...

REM 出力ディレクトリを作成
set OUTPUT_DIR=%cd%\LinuxPackaged
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

REM Dockerイメージをビルド
echo Building Docker image...
docker build -t universalserial-linux-build .

REM コンテナを実行してビルド
echo Running build in container...
docker run --rm -v "%OUTPUT_DIR%:/output" universalserial-linux-build

echo Build completed! Output is in: %OUTPUT_DIR%