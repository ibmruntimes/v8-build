# Disclaimer
[V8](https://v8.dev/) is a community supported project. Our team at IBM maintains currency of the latest V8 releases to be used by Node.js on IBM Power and IBM zSystems. The official list of Node.js platforms, along with their respective toolchains, can be found at:
https://github.com/nodejs/node/blob/master/BUILDING.md

We do not provide official support on V8 if it is used outside the realm of Node.js. V8 is built and tested using the minimum compiler versions currently supported by Node.js (current versions are detailed in the above link). We do not support any other compiler versions or toolchain.

# Contributing to V8 (PowerPC & s390x)
We welcome contributions to the PowerPC and s390x ports of V8. However, due to the high maintenance cost and the rapid pace of upstream changes, major features or platform‑specific additions will only be accepted if they come with a clear, long‑term maintenance plan.

Before merging such changes, contributors must:
- Commit to ongoing maintenance of their code as V8 evolves.
- Set up and run their own automated test pipeline (ideally daily) that validates the feature on the relevant architecture(s).
- Be available to respond quickly to breakages, regressions, or upstream changes affecting their code.

If a contributor becomes unresponsive, fails to maintain their code, or their feature remains broken for an extended period, that code may be removed without notice to keep the ports stable and maintainable.

# Building and testing V8 using Docker
Docker images are used for building and testing V8 for ppc64le and s390x running Linux.

We have 2 types of images. The `base` image provides the base configuration with the necessary development toolchains installed to build V8. The `test` image, built upon the base, is used to clone, build and test V8 commits by the Jenkins CI/CD pipeline.

You can run the following to create a base image and use it for development purposes:
```
make DOCKER_TARGET_LINK=your_docker_repo base-img
```

Run this to create all the images which also includes testing images used by Jenkins:
```
make DOCKER_TARGET_LINK=your_docker_repo build-all-images
```
