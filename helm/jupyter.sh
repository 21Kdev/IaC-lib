#!/bin/bash
cd /opt/bitnami/jupyterhub-singleuser
conda install conda=23.11.0 -y
conda init
source /opt/bitnami/jupyterhub-singleuser/.bashrc
# conda create --name myenv -y
# conda activate myenv

# conda install ipykernel -y
# python -m ipykernel install --user --name myenv --display-name "Custom Env"
conda env create -f env.yaml -y
# docker run --rm -u root --gpus all -it --name jupyter-test bitnami/jupyter-base-notebook:4.0.2-debian-11-r66 /bin/bash