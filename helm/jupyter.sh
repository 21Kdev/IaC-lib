#!/bin/bash
apt update && apt install -y wget vim
# rm -rf /opt/bitnami/miniconda
# wget -P /tmp/ https://anaconda.org/anaconda/conda/4.12.0/download/osx-arm64/conda-4.12.0-py39hca03da5_0.tar.bz2
# wget -P /tmp/ https://repo.anaconda.com/archive/Anaconda3-2023.09-0-Linux-x86_64.sh
# http://repo.continuum.io/pkgs/main/osx-arm64/conda-4.12.0-py38hca03da5_0.tar.bz2
# bash /tmp/Anaconda3-2023.09-0-Linux-x86_64.sh -b -p /opt/bitnami/conda/
# export PATH=/opt/bitnami/conda/bin:$PATH
# echo "export PATH=/opt/bitnami/conda/bin:$PATH" >> ~/.bashrc
# conda install gcc_linux-64
# conda env create -f /tmp/env.yml
# conda create -n base_env python=3.8 -y
# conda update --all -y
# conda --no-plugins install --force-reinstall conda=4.12.0 -y
# sed -i -e 's#:/opt/bitnami/miniconda/bin:#:#' -e 's#=\/opt/bitnami/miniconda/bin:#=#' ~/.bashrc
# cd /opt/bitnami/jupyterhub-singleuser
# conda install conda=23.11.0 -y
# conda init
# source /opt/bitnami/jupyterhub-singleuser/.bashrc
# conda create --name myenv -y
# conda activate myenv

# conda install ipykernel -y
# python -m ipykernel install --user --name myenv --display-name "Custom Env"
# docker run --rm -u root --gpus all -it --name jupyter-test bitnami/jupyter-base-notebook:4.0.2-debian-11-r66 /bin/bash

############
apt update && apt install -y wget vim bzip2 build-essential python3-dev
rm -rf /opt/bitnami/miniconda/
wget -P /tmp/ https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh
bash /tmp/Miniconda3-py38_4.12.0-Linux-x86_64.s -b -p /opt/bitnami/conda/
export PATH=/opt/bitnami/conda/bin:$PATH
echo "export PATH=/opt/bitnami/conda/bin:$PATH" >> ~/.bashrc
