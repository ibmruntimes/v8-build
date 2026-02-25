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

# This wrapper is only needed when `treat_warnings_as_errors = true` is set.
# You can avoid using it if you disable that flag in your GN args file.
# TODO: Re-evaluate this list when upgrading Clang.

# Libc++ only supports Clang 20 and later.
extra_flags="-Wno-#warnings"

# Check if we are building third party libs.
is_third_party=false
for arg in "$@"; do
  case "$arg" in
  *third_party/*)
    is_third_party=true
    break
    ;;
  esac
done

MACHINE_ARCH=$(uname -m)

if [ "$is_third_party" = true ]; then
  if [ "$MACHINE_ARCH" = "ppc64le" ]; then
    # Needed to silence abseil, simdutf errors on conversion between vector types.
    extra_flags="$extra_flags -Wno-deprecate-lax-vec-conv-all"
    # Needed to silence fuzztest errors on conversion between vector types.
    extra_flags="$extra_flags -Wno-deprecated-altivec-src-compat"
  elif [ "$MACHINE_ARCH" = "s390x" ]; then
    :
  else
    echo "We only build on s390x and ppc64le, exiting!"
    exit 1
  fi
fi

# Forward everything through ccache with the extra flags.
exec ccache "$@" $extra_flags
