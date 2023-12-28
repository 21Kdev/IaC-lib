#!/bin/bash

docker build --tag dodo133/mlflow:0.1 . --platform=linux/amd64
docker push dodo133/mlflow:0.1
