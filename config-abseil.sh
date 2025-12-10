#!/bin/sh
#. ./config-check.sh
ABSL_INSTALL=${INSTALLDIR}/abseil
cmake -S .. \
	-B .    \
	-G Ninja \
	-DCMAKE_POSITION_INDEPENDENT_CODE=ON \
	-DBUILD_SHARED_LIBS=ON \
	-DCMAKE_BUILD_TYPE=Release    \
	-DCMAKE_INSTALL_PREFIX=${ABSL_INSTALL} 
