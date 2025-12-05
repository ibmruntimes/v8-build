# Disclaimer
[V8](https://v8.dev/) is a community supported project. Our team at IBM maintains currency of the latest V8 releases to be used by Node.js on IBM Power and IBM zSystems. The official list of Node.js platforms, along with their respective toolchains, can be found at:
https://github.com/nodejs/node/blob/master/BUILDING.md

We do not provide official support on V8 if it is used outside the realm of Node.js. V8 is built and tested using the minimum compiler versions currently supported by Node.js (current versions are detailed in the above link). We do not support any other compiler versions or toolchain.

# Contributing to V8 (PPC64 & s390x)
We welcome contributions to the PPC64 and s390x ports of V8. However, due to the high maintenance cost and the rapid pace of upstream changes, major features or platform‑specific additions will only be accepted if they come with a clear, long‑term maintenance plan.

Before merging such changes, contributors must:
- Commit to ongoing maintenance of their code as V8 evolves.
- Set up and run their own automated test pipeline (ideally daily) that validates the feature on the relevant architecture(s).
- Be available to respond quickly to breakages, regressions, or upstream changes affecting their code.

If a contributor becomes unresponsive, fails to maintain their code, or their feature remains broken for an extended period, that code may be removed without notice to keep the ports stable and maintainable.
