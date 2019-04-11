#!/usr/bin/env bash

set -e # Abort on error.

if [[ $(uname) == Darwin ]]; then
  export LIBRARY_SEARCH_VAR=DYLD_FALLBACK_LIBRARY_PATH
elif [[ $(uname) == Linux ]]; then
  export LIBRARY_SEARCH_VAR=LD_LIBRARY_PATH
fi

export PYTHON="$PYTHON"
export PYTHON_LDFLAGS="$PREFIX/lib"
export LDFLAGS="$LDFLAGS -L$PREFIX/lib -Wl,-rpath,$PREFIX/lib"
# The `ACCEPT_USE_OF_DEPRECATED_PROJ_API_H` is a temporary solution and won't work with proj4 7.
export CFLAGS="$CFLAGS -fPIC -I$PREFIX/include -DACCEPT_USE_OF_DEPRECATED_PROJ_API_H=1"
export CPPFLAGS="-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H=1 ${CPPFLAGS}"

mkdir ../build && cd ../build
cmake \
  -D CMAKE_INSTALL_PREFIX=$PREFIX \
  -D ENABLE_FORTRAN=0 \
  -D ENABLE_NETCDF=1 \
  -D ENABLE_METVIEW=1 \
  ${SRC_DIR}


make -j $CPU_COUNT
eval ${LIBRARY_SEARCH_VAR}=$PREFIX/lib

if [[ $(uname) == Linux ]]; then
    # Tell Linux where to find libGL.so.1 and other libs needed for Qt
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$BUILD_PREFIX/x86_64-conda_cos6-linux-gnu/sysroot/usr/lib64/
fi

ctest --output-on-failure -j $CPU_COUNT
make install

pip install --no-deps https://files.pythonhosted.org/packages/c3/dd/373caa06915dd8a8ec2f344a1a2711dfb6a035e4a7ed786eb364a7715771/Magics-1.0.6-py2.py3-none-any.whl

# Install activate/deactivate stripts
ACTIVATE_DIR=$PREFIX/etc/conda/activate.d
DEACTIVATE_DIR=$PREFIX/etc/conda/deactivate.d
cp $RECIPE_DIR/scripts/activate.sh $ACTIVATE_DIR/magics-activate.sh
cp $RECIPE_DIR/scripts/deactivate.sh $DEACTIVATE_DIR/magics-deactivate.sh
