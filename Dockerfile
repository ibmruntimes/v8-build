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

FROM registry.access.redhat.com/ubi8/ubi:latest

WORKDIR /home

# Pre reqs
RUN dnf -y install \
    rustfmt \
    tzdata \
    vim \
    curl \
    wget \
    xz \
    git \
    python3.11 \
    make \
    cmake \
    glib2-devel

# Extra packages (optional)
RUN dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN dnf -y install ccache

# Set timezone
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime

# Python dependencies
RUN alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1
RUN alternatives --set python3 /usr/bin/python3.11
RUN python3 -m ensurepip
RUN pip3 install httplib2==0.22.0 six requests filecheck

# Clone depot_tools and add it to your path
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git

# Set environment variables
ENV CC=clang
ENV CXX=clang++
ENV PATH=$PATH:/home/depot_tools/
ENV VPYTHON_BYPASS="manually managed python not supported by chrome operations"
ENV RUSTC_BOOTSTRAP=1

# Copy the bin folder
COPY ./bin/ /home

ENTRYPOINT ["/home/entry_point.sh"]
