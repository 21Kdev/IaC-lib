#!/bin/sh
sudo lsof /dev/nvidia*

sudo rmmod nvidia_drm
sudo rmmod nvidia_modeset
sudo rmmod nvidia_uvm
sudo rmmod nvidia

sudo apt -y --purge remove *nvidia*
sudo apt -y autoremove
sudo apt -y autoclean