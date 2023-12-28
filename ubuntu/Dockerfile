FROM ubuntu:20.04

USER root

WORKDIR /home/root/workspace

ADD ./common/ ./common/
ADD ./k8s/ ./k8s/

RUN sh ./common/install_nvidia.sh
# RUN sh ./k8s/install_k8s.sh
# RUN sh ./k8s/containerd_nvidia.sh

EXPOSE 14100

CMD ["/bin/bash"]