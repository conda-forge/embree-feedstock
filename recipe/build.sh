# Make build directory
mkdir build
cd build

# Specify location of TBB
export TBBROOT=${PREFIX}

if [ "${target_platform}" == "osx-arm64" ] || [ "${target_platform}" == "linux-aarch64" ]; then
    max_isa="NEON"
else
    max_isa="AVX2"
fi

# Configure
cmake ${CMAKE_ARGS} ../ \
      -DEMBREE_IGNORE_CMAKE_CXX_FLAGS=OFF \
      -DCMAKE_INSTALL_PREFIX=${PREFIX} \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DCMAKE_BUILD_TYPE=Release \
      -DEMBREE_TUTORIALS=OFF \
      -DEMBREE_MAX_ISA="${max_isa}" \
      -DEMBREE_ISPC_SUPPORT=OFF

# Compile
make -j ${CPU_COUNT}

# embree lacks unit tests

make install

# remove unnecessary embree-vars files
rm -rf ${PREFIX}/embree-vars.*
