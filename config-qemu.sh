#!/bin/sh
QEMU_INSTALL=${WORKDIR}/install/qemu-rvv-install
./configure \
    --prefix=${QEMU_INSTALL} \
    --disable-tools \
    --disable-werror \
    --disable-smartcard \
    --enable-pie \
    --disable-vnc \
    --disable-curses \
    --disable-sdl \
    --disable-gtk \
    --disable-curl \
    --disable-bzip2 \
    --disable-vhost-user \
    --disable-zstd \
    --disable-iconv \
    --enable-virtfs \
    --target-list=riscv64-linux-user,riscv64-softmmu \
    --disable-qcow1

