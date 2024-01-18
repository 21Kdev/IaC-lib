FROM dodo133/jupyter-img:torch-maic2023-dev

USER root

# matplotlib dir
RUN mkdir -p /opt/bitnami/jupyterhub-singleuser/.cache/huggingface && \
    chmod -R 777 /opt/bitnami/jupyterhub-singleuser/.cache/huggingface
ENV HF_HOME /opt/bitnami/jupyterhub-singleuser/.cache/huggingface

RUN pip install papermill

# RUN apt-get update && \
#     apt-get install -y curl cron && \
#     curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
#     apt-get install -y nodejs

# RUN pip install jupyterlab_scheduler
# RUN jupyter labextension install jupyterlab_scheduler

USER 1001