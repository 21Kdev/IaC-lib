#!/bin/bash

# 권한이 필요한 작업을 수행하기 전에 권한 확인
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

echo "Installing NVIDIA driver..."
../common/install_nvidia.sh

echo "Installing Docker..."
./install_docker.sh

echo "Adding Docker permissions..."
./add_docker_permission.sh

echo "Installing NVIDIA Docker..."
./install_nvidia_docker.sh

echo "Installing Docker Compose..."
./install_docker_compose.sh

echo "All installations complete!"
