echo "Dist Root: ${DIST_ROOT}"
echo "LFS: ${LFS}"

if ! test $(whoami) == "distbuild" ; then
    echo "Must run as distbuild!"
    exit -1
fi

echo "Creating build environment..."
cd $DIST_ROOT

bash -e build_env/build_scripts/binutils-pass-1.sh
bash -e build_env/build_scripts/gcc-pass-1.sh
bash -e build_env/build_scripts/linux-headers.sh
bash -e build_env/build_scripts/glibc.sh

echo "Done."