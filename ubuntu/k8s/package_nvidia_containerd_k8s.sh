#!/bin/bash

# 권한이 필요한 작업을 수행하기 전에 권한 확인
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

echo "Installing NVIDIA driver..."
sh ../common/install_nvidia.sh

echo "Installing k8s..."
sh ./install_k8s.sh

echo "Installing helm..."
sh ./install_helm.sh

echo "Installing containerd_nvidia..."
sh ./containerd_nvidia.sh

echo "All installations complete!"
