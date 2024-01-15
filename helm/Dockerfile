FROM bitnami/jupyter-base-notebook:4.0.2-debian-11-r66

USER root

RUN apt update && \
    apt install -y wget vim bzip2 build-essential python3-dev libgl1-mesa-glx

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

USER 1001

COPY ./requirements.txt /tmp/$CONDA_ENV_NAME1_requirements.txt
RUN $CONDA_PATH/envs/$CONDA_ENV_NAME1/bin/pip install numpy==1.23.5
RUN $CONDA_PATH/envs/$CONDA_ENV_NAME1/bin/pip install mlflow
RUN $CONDA_PATH/envs/$CONDA_ENV_NAME1/bin/pip install -r /tmp/$CONDA_ENV_NAME1_requirements.txt
RUN python -m ipykernel install --user --name=$CONDA_ENV_NAME1 --display-name="$CONDA_ENV_NAME1"

RUN unset CONDA_ALWAYS_YES
