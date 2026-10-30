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

if [[ -z "$NPROC" ]]; then
  NPROC=$(nproc)
fi

git clone https://github.com/google/perfetto && cd perfetto
tools/install-build-deps --no-dev-tools
gn gen out/build --args='is_debug=true is_clang=true is_hermetic_clang=false is_system_compiler=true'
ninja -C out/build/ trace_processor_shell perfetto_protozero_unittests perfetto_trace_processor_unittests -j$NPROC
out/build/perfetto_protozero_unittests --gtest_brief=1
out/build/perfetto_trace_processor_unittests --gtest_brief=1
