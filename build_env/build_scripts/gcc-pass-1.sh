echo
echo "GCC Pass 1"
echo
sleep 1

cd $LFS/sources
tar -xf gcc-12.2.0.tar.xz
cd gcc-12.2.0
tar -xf $LFS/sources/mpfr-4.1.0.tar.xz
mv -v mpfr-4.1.0 mpfr
tar -xf $LFS/sources/gmp-6.2.1.tar.xz
mv -v gmp-6.2.1 gmp
tar -xf $LFS/sources/mpc-1.2.1.tar.gz
mv -v mpc-1.2.1 mpc

sed -e '/m64=/s/lib64/lib' \
        -i.orig gcc/config/i386/t-linux64

mkdir -v build
cd build

time {
    ../configure    --target=$LFS_TGT           \
                    --prefix=$LFS/tools         \
                    --with-glibc-version=2.36   \
                    --with-sysroot=$LFS         \
                    --with-newlib               \
                    --without-headers           \
                    --disable-nls               \
                    --disable-shared            \
                    --disable-multilib          \
                    --disable-decimal-float     \
                    --disable-threads           \
                    --disable-libatomic         \
                    --disable-libgomp           \
                    --disable-libquadmath       \
                    --disable-libssp            \
                    --disable-libvtv            \
                    --disable-libstdcxx         \
                    --enable-languages=c,c++

    make && make install
}
    cd $LFS/sources
    rm -rf ./gcc*.t
    cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
        'dirname $($LFS_TGT-gcc -print-libgcc-file-name)' /install-tools/include/limits.h

