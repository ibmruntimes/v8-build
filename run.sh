#!/bin/bash

#  Copyright IBM Corp. and others 2025
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

MACHINE_ARCH=$(uname -m)

docker pull $DOCKER_REGISTRY/rt-nodejs-v8-$MACHINE_ARCH:latest

docker run \
  -e NPROC=$NPROC \
  -e BIN=$BIN \
  -e V8_BRANCH=$V8_BRANCH \
  -e V8_MODE=$V8_MODE \
  -v $CCACHE_DIR:/root/.ccache \
  -v /etc/rhsm:/etc/rhsm \
  -v /etc/pki/entitlement:/etc/pki/entitlement \
  -v /etc/pki/consumer:/etc/pki/consumer \
  $DOCKER_REGISTRY/rt-nodejs-v8-$MACHINE_ARCH

docker system prune -f
