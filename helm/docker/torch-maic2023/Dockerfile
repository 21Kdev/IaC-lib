FROM dodo133/jupyter-img:torch-maic2023-dev

USER root

# matplotlib dir
RUN mkdir -p /opt/bitnami/jupyterhub-singleuser/.cache/huggingface && \
    chmod -R 777 /opt/bitnami/jupyterhub-singleuser/.cache/huggingface
ENV HF_HOME /opt/bitnami/jupyterhub-singleuser/.cache/huggingface

USER 1001
