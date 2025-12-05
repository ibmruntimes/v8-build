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

RHEL_VERSION="8.10"
CLANG_VERSION="19.1.7"
RUST_VERSION="1.84.1"

if [[ -z "$NPROC" ]] ; then
  NPROC=$(nproc)
fi
if [[ -z "$BIN" ]] ; then
  echo "BIN is not specified, exiting!"
  exit 1
fi

# Pin subscription-manager release to match container OS version
subscription-manager release --set="$RHEL_VERSION"

# Install the toolchain
dnf -y install llvm-toolset-$CLANG_VERSION rust-toolset-$RUST_VERSION
cargo install bindgen-cli

# Print the compiler versions
clang++ --version
rustc --version

# Run the final script
bash ./$BIN.sh
