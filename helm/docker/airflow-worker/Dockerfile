FROM bitnami/airflow-worker:2.8.0-debian-11-r1

USER root

# RUN pip install --no-cache-dir papermill
RUN /opt/bitnami/airflow/venv/bin/pip install --no-cache-dir apache-airflow-providers-papermill

USER 1001