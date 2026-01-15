### **Step by step instruction on Installing, Building and Testing AI stack on RISCV Qemu **  

This is built on Ubuntu 24.04.2 LTS. Some of the standard packages for example,  abseil and protobuf are incompatible with the version needed by other packages.  Kernel version 6.14.0-27-generic.  
  
##Before we begin the following environment variables need to be set.  

**WORKDIR** the base direcory of for all the packages and files that we need to build the install packages and  
**INSTALLDIR** where all the build packages are installed.  
For example,  
```
export WORKDIR=${PWD}
export INSTALLDIR=${WORKDIR}/install
mkdir ${INSTALLDIR}
```
Clone the repository
`git clone --recursive git@github.com:rajvishmips/riscv-ai-stack.git`

The following packages will be built for building the AI Stack  
1. [abseil](#abseil)
2. [protobuf](#protobuf)
3. [riscv-toolchain](#riscv-toolchain)
4. [llvm](#llvm)
5. [iree](#iree)  
   1. [iree-compiler for the host subsystem](#iree-build-for-host-x86)
   2. [iree-compiler for the riscv subsystem](#iree-build-for-rvv)
6. [onnx-mlir](#onnx-mlir)
7. [qemu](#qemu)

## Here are the steps to build and install each of the above packages.  
## Abseil  

```
cd ${WORKDIR}
mkdir -p abseil-cpp/build && cd abseil-cpp/build
ln -s ${WORKDIR}/config-abseil.sh .
sh config-abseil.sh
cmake --build . --target install
```
After the package is built, the components will be available at ${INSTALLDIR}/abseil

Add the abseil library path to LD_LIBRARY_PATH  
`export LD_LIBRARY_PATH=${INSTALLDIR}/abseil/lib`  

## Protobuf
```
cd ${WORKDIR}
mkdir -p protobuf/build && cd protobuf/build
ln -s ${WORKDIR}/config-protobuf.sh .
sh config-protobuf.sh
cmake --build . --target install
```

After the package is built, the components will be available at ${INSTALLDIR}/protobuf

Fix the PATH and LD_LIBRARY_PATH variable to add protobuf.  
```
export PATH=${PATH}:${INSTALLDIR}/protobuf/bin
export LD_LIBRARY_PATH=${INSTALLDIR}/protobuf/lib:${LD_LIBRARY_PATH}
```

## riscv-toolchain
```
cd ${WORKDIR}
cd riscv-gnu-toolchain
ln -s ${WORKDIR}/config-riscv-gnu-toolchain.sh .
sh config-riscv-gnu-toolchain.sh
make -j ${nproc} # replace nproc with the right number depending on the number cores and memory.  
```

After the package is built, the components will be available at ${INSTALLDIR}/riscv-gnu-toolchain

Fix the environment variables to add riscv-toolchain
```
export PATH=${PATH}:${INSTALLDIR}/riscv-gnu-toolchain/bin
export RISCV_TOOLCHAIN_ROOT=${INSTALLDIR}/riscv-gnu-toolchain
```

## llvm

The version of llvm is needs to be compatible with mlir. It is determined by downloading onnx-mlir package and the SHA for the llvm is located found by doing  
`cat onnx-mlir/third_party/stablehlo/build_tools/llvm_version.txt`  
The correct version is already checked in here and should work out of the box
```
cd ${WORKDIR}
mkdir -p llvm-project/build && cd llvm-project/build
ln -s ${WORKDIR}/config-llvm-project.sh .
sh config-llvm-project.sh
ninja -j ${nproc} # replace nproc with the right number depending on the number of cores and memory
ninja install
```

Fix the PATH variable to enable the right llvm  
`export PATH=${INSTALLDIR}/llvm-install/bin:${PATH}`  

## iree

We will build iree for both host (x86) and target systems (RVV). Before we build we will run the following commands to setup the build.
```
cd ${WORKDIR}/iree
./build_tools/riscv/riscv_bootstrap.sh
```
The two questions asked will be 
`Enter the riscv tools root path(press enter to use default`

Use a convenient path for the LLVM tools for RISCV. I use ${INSTALLDIR}/riscv_tools  

**Important:** ${INSTALLDIR} will not be expanded. You need to provide a full path. This PATH is important. This is used in building iree-riscv

You can choose to install qemu if you want.

### Iree build for host (x86)
Run the following commands to build the iree compiler and runtime for the host (x86)  
```
cd iree
ln -s ${WORKDIR}/config-iree-host.sh .
sh ./config-iree-host.sh
cmake --build ./build-x86 --target install
```

### Iree build for RVV 
Run the following commands to build the iree compiler and runtime for the host (RVV)
```
cd iree
ln -s ${WORKDIR}/config-iree-riscv.sh .
sh ./config-iree-riscv.sh
cmake --build ./build-rvv --target install
```
Before starting onnx move to a python virtual environment
```
python3 -m venv ${WQORKDIR}/venv
source ${WORKDIR}/venv/bin/activate
pip3 install onnx
```

## onnx-mlir
To build onnx-mlir use run the following commands
Make sure that the right version onnx-mlir is installed from [llvm](#llvm)
```
cd ${WORKDIR}
mkdir -p onnx-mlir/build && cd onnx-mlir/build  
ln -s ${WORKDIR}/config-onnx-mlir.sh .  
sh config-onnx-mlir.sh
ninja -j ${nproc} # replace nproc with the right number depending on the number cores and memory. 
ninja install
```
set the PATH for the onnx-mlir tools  
`export PATH=${PATH}:${INSTALLDIR}/onnx-mlir/bin`  


## qemu 
To build qemu run the following commands
```
cd ${WORKDIR}
cd qemu
ln -s ${WORKDIR}/config-qemu.sh . 
sh config-qemu.sh 
make -j ${nproc} # replace nproc with the right number depending on the number cores and memory. 
make install
```

#All the packages have been built and installed under ${INSTALLDIR} We can now go about testing the packages.















 




