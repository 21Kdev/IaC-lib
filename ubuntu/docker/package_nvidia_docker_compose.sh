#!/bin/sh

# 권한이 필요한 작업을 수행하기 전에 권한 확인
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

echo "Installing NVIDIA driver..."
sh ../common/install_nvidia.sh

echo "Installing Docker..."
sh ./install_docker.sh

echo "Adding Docker permissions..."
sh ./add_docker_permission.sh

echo "Installing NVIDIA Docker..."
sh ./install_nvidia_docker.sh

echo "Installing Docker Compose..."
sh ./install_docker_compose.sh

echo "All installations complete!"
