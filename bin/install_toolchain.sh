#!/bin/bash

#  Copyright IBM Corp. and others 2026
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

RHEL_VERSION="8.10"
CLANG_VERSION="21.1.8"
RUST_VERSION="1.92.0"

# Pin subscription-manager release to match container OS version
subscription-manager release --set="$RHEL_VERSION"

# Install the LLVM toolchain
dnf -y install llvm-toolset-$CLANG_VERSION python3.12-clang-$CLANG_VERSION rust-toolset-$RUST_VERSION bindgen-cli

# Build Ninja
git clone https://github.com/ninja-build/ninja.git && cd ninja
git checkout release && ./configure.py --bootstrap
mv ninja /usr/bin
cd ..

# Build GN
git clone https://gn.googlesource.com/gn && cd gn
python3 build/gen.py && ninja -C out gn
mv out/gn /usr/bin
cd ..
