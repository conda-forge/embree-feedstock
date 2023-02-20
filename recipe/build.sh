# Make build directory
mkdir build
cd build

# Specify location of TBB
export TBBROOT=${PREFIX}

if [ "${target_platform}" == "osx-arm64" ]; then
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

# remove tutorial models (which embree installed even when EMBREE_TUTORIALS=off)
# this is easier than patching embree's cmake
rm -rf ${PREFIX}/bin/models
