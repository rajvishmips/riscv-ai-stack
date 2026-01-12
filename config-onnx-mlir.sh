#!/bin/sh
#. ./config-check.sh
#
#git clone https://github.com/onnx/onnx-mlir.git
#git submodule update --init --recursive

#Each  ONNX-MLIR is built for a specific version of llvm
#If you are building ONNX-MLIR - you need to install a specific version of llvm
# To get the version of LLVM take a look at
# onnx-mlir/third_party/stablehlo/build_tools/llvm_version.txt
# and build a version of llvm

#The current head of llvm has 42a8ff877d47131ecb1280a1cc7e5e3c3bca6952
#cat onnx-mlir/third_party/stablehlo/build_tools/llvm_version.txt
#Make sure that you build and install the right version of abseil ( we need both statiic and dynamic libraries). Make sure that the LD_LIBRARY_PATH points there

MLIR_DIR=${WORKDIR}/llvm-project/build/lib/cmake/mlir
ONNX_MLIR_INSTALL=${INSTALLDIR}/onnx-mlir
cmake ..\
    -G Ninja \
    -DMLIR_DIR=${MLIR_DIR} \
    -DCMAKE_INSTALL_PREFIX=${ONNX_MLIR_INSTALL} \
    -DCMAKE_PREFIX_PATH=${INSTALLDIR}/abseil \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DONNX_MLIR_ENABLE_STABLEHLO=OFF \
    -DCMAKE_BUILD_TYPE=Release 
    

