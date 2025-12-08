if [[ -z "$V8_BRANCH" ]]; then
  echo "V8_BRANCH is not specified, exiting!"
  exit 1
fi
if [[ -z "$V8_MODE" ]]; then
  echo "V8_MODE is not specified, exiting!"
  exit 1
fi

# Build gn
# Use a platform specific `ninja` binary
cd /home/gn &&
  python3 build/gen.py && ninja -C out &&
  cp out/gn /bin/gn &&
  chmod +x /bin/gn && cd /home

# Set path to gn depending on architecture, install any dependencies
MACHINE_ARCH=
if [ $(uname -m) == "s390x" ]; then
  MACHINE_ARCH="s390x"
elif [ $(uname -m) == "ppc64le" ]; then
  MACHINE_ARCH="ppc64"
else
  echo "We only build on s390x and ppc64le, exiting!"
  exit 1
fi

if [[ ! -f /home/$MACHINE_ARCH/$V8_MODE.gn ]]; then
  echo "gn args file for '$V8_MODE' mode not found, exiting!"
  exit 1
fi

# Build and test V8
echo "===================================="
echo "Architecture is:" $MACHINE_ARCH
echo "Mode is:" $V8_MODE
echo "Parallel Build/Test (-j):" $NPROC
echo "===================================="

# Fetch latest v8
DEPOT_TOOLS_BOOTSTRAP_PYTHON3=0 fetch v8
cd v8

# Identify Beta and Stable branches
git branch -at |
  /bin/grep branch-heads |
  /bin/grep -o '/[0-9.]*\.[0-9]*' |
  sed s/^.// |
  sort -nr >v8-branches.txt

V8_BETA_BRANCH=$(sed '1q;d' v8-branches.txt)
V8_STABLE_BRANCH=$(sed '2q;d' v8-branches.txt)

# Checkout a branch
CHECKOUT=$V8_BRANCH
if [ "$V8_BRANCH" != "main" ]; then
  if [ "$V8_BRANCH" == "beta" ]; then
    CHECKOUT=branch-heads/$V8_BETA_BRANCH
  elif [ "$V8_BRANCH" == "stable" ]; then
    CHECKOUT=branch-heads/$V8_STABLE_BRANCH
  fi
fi

echo "===================================="
echo "Checkout $CHECKOUT"
echo "===================================="

git checkout $CHECKOUT
if [ "$CHECKOUT" != "main" ]; then
  DEPOT_TOOLS_BOOTSTRAP_PYTHON3=0 gclient sync
fi

# Copy args required for gn, build
cp /home/cc_wrapper.sh /bin && chmod +x /bin/cc_wrapper.sh
mkdir -p out/$MACHINE_ARCH
cp /home/$MACHINE_ARCH/$V8_MODE.gn out/$MACHINE_ARCH/args.gn
gn gen /home/v8/out/$MACHINE_ARCH
ninja -C /home/v8/out/$MACHINE_ARCH -j $NPROC

# Run the tests
python3 tools/run-tests.py -j $NPROC --time --progress=dots --timeout=240 --no-presubmit \
  --outdir=out/$MACHINE_ARCH --variants=exhaustive
