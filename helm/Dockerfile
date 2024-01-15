FROM bitnami/jupyter-base-notebook:4.0.2-debian-11-r66

# Switch to root user for initial setup
USER root

# Install necessary system packages
RUN apt update && \
    apt install -y wget vim bzip2 build-essential python3-dev libgl1-mesa-glx

# Allow user 1001 to use sudo without a password
# RUN echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# # Ensure the user 1001 has proper permissions
# RUN mkdir -p /opt/bitnami/jupyterhub-singleuser/.local/share/jupyter/runtime && \
#     chown -R 1001:1001 /opt/bitnami/jupyterhub-singleuser && \
#     chmod -R 775 /opt/bitnami/jupyterhub-singleuser

# Continue with your previous installations as root
WORKDIR /home/maic-player/workspace

# matplotlib dir
RUN mkdir -p /opt/matplotlib_cache && \
    chmod -R 777 /opt/matplotlib_cache
ENV MPLCONFIGDIR /opt/matplotlib_cache

RUN export CONDA_ALWAYS_YES="true"
RUN conda install -c conda-forge ipykernel
ENV CONDA_PATH=/opt/bitnami/miniconda
ENV CONDA_ENV_NAME1=torch-maic2023
ENV PATH=$CONDA_PATH/envs/$CONDA_ENV_NAME1/bin:$PATH

RUN conda create -n $CONDA_ENV_NAME1 -c pytorch -c nvidia -c conda-forge -c defaults python=3.9.18
# RUN echo "source activate $CONDA_ENV_NAME1" > ~/.bashrc

# Switch to user 1001 for any further actions
USER 1001

# Continue with Python package installations
COPY ./requirements.txt /tmp/$CONDA_ENV_NAME1_requirements.txt
RUN $CONDA_PATH/envs/$CONDA_ENV_NAME1/bin/pip install numpy==1.23.5
RUN $CONDA_PATH/envs/$CONDA_ENV_NAME1/bin/pip install mlflow
RUN $CONDA_PATH/envs/$CONDA_ENV_NAME1/bin/pip install -r /tmp/$CONDA_ENV_NAME1_requirements.txt
RUN python -m ipykernel install --user --name=$CONDA_ENV_NAME1 --display-name="$CONDA_ENV_NAME1"

# Cleanup and settings
RUN unset CONDA_ALWAYS_YES

# RUN rm -rf /opt/bitnami/miniconda/
# RUN wget -P /tmp/ https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh && \
#     bash /tmp/Miniconda3-py38_4.12.0-Linux-x86_64.sh -b -p $CONDA_PATH && \
#     rm /tmp/Miniconda3-py38_4.12.0-Linux-x86_64.sh
# ENV PATH="$CONDA_PATH/bin:$PATH"
# RUN conda install -y --file /tmp/requirements.txt
# COPY ./env.yml /tmp/env.yml
# RUN conda env create -f /tmp/env.yml
