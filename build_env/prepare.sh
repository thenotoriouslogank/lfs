#!/bin/bash

DIST_ROOT=/indigo/lfs
LFS=/indigo/lfs/build_env/build_root

# Confirm environment variables are set
echo "Dist Root: ${DIST_ROOT:?}"
echo "LFS: ${LFS:?}"

# Create necessary directory for source files
mkdir -p $LFS/sources

# 
for f in $(cat $DIST_ROOT/build_env/build_env_list)
do
    bn=$(basename $f)
    if ! test -f $LFS/sources/$bn ; then
        wget $f -O $LFS/sources/$bn
    fi
done;

mkdir -pv $LFS/{bin,etc,lib,sbin,usr,var,lib64,tools}

if ! test $(id -u distbuild) ; then

# Add user and group for distribution builder user
groupadd distbuild
useradd -s /bin/bash -g distbuild -m -k /dev/null distbuild
passwd distbuild

# Creates the home directory and subdirectories for our new user; sets home
chown -v distbuild $LFS/{usr,lib,var,etc,bin,sbin,tools,lib64,sources}

dbhome=$(eval echo "~distbuild")

cat > $dbhome/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > $dbhome/.bashrc << EOF
set +h
umask 022
DIST_ROOT=$DIST_ROOT
LFS=$LFS
EOF

cat >> $dbhome/.bashrc << "EOF"
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export DIST_ROOT LFS LC_ALL LFS_TGT PATH CONFIG_SITE
export MAKEFLAGS="-j$(nproc)"
EOF

fi

