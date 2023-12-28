#!/bin/bash

# 포트 매핑을 위한 변수 초기화
PORT_MAPPING=""

# 14100부터 14200까지의 포트에 대한 매핑 생성
for i in {14100..14200}; do
    PORT_MAPPING+="-p $i:$i "
done

# Docker 컨테이너 실행
docker run --rm -itd $PORT_MAPPING dodo133/mlflow:0.1