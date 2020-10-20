#!/usr/bin/env bash

set -eox

#run from root of project
docker build -t gooniyandi-backend .

docker run -d -p 3000:3000 gooniyandi-backend:latest