#git clone https://github.com/llvm/llvm-project.git
#cd  llvm-project/build && cd llvm-project/build
#ln -s  config-llvm-project.sh llvm-project/build
# . ./setup.sh
#Set the RISCV tool chain PATH
#ninja -j24
#ninja install

#!/bin/sh

export LLVM_INSTALL=${INSTALLDIR}/llvm-install
cmake -G Ninja \
    ../llvm \
   -DLLVM_ENABLE_PROJECTS="mlir;clang" \
   -DLLVM_ENABLE_RUNTIMES="openmp" \
	-DLLVM_TARGETS_TO_BUILD="RISCV;X86" \
   -DCMAKE_BUILD_TYPE=Release \
   -DLLVM_ENABLE_ASSERTIONS=ON \
   -DLLVM_ENABLE_RTTI=ON \
   -DLLVM_ENABLE_LIBEDIT=OFF \
  	-DCMAKE_INSTALL_PREFIX=${LLVM_INSTALL}
