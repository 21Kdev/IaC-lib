#!/bin/bash

# 권한이 필요한 작업을 수행하기 전에 권한 확인
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

ORIGINAL_USER=$(getent passwd $SUDO_USER | cut -d: -f1)

sudo usermod -aG docker ${ORIGINAL_USER}