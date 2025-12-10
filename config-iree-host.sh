#!/bin/sh
export IREE_INSTALL=${INSTALLDIR}/iree-install-x86
IREE_BUILD_HOST=./build-x86
cmake -GNinja -B ${IREE_BUILD_HOST} \
	-DCMAKE_C_COMPILER=clang \
	-DCMAKE_CXX_COMPILER=clang++ \
	-DCMAKE_INSTALL_PREFIX=${IREE_INSTALL} \
    -DCMAKE_C_FLAGS="$CMAKE_C_FLAGS -Wno-error=c2y-extensions -Wno-pedantic" \
    -DCMAKE_CXX_FLAGS="$CMAKE_C_FLAGS -Wno-error=c2y-extensions -Wno-pedantic" \
	-DCMAKE_BUILD_TYPE=RelWithDebInfo  

# cmake --build ./build --target install

