# Load environment variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/.env" ]; then
    source "$SCRIPT_DIR/.env"
elif [ -f "$HOME/.env" ]; then
    source "$HOME/.env"
else
    echo "Error: .env file not found!"
    exit 1
fi

# Expand variables
AC_INSTALL_PREFIX=$(eval echo "$AC_INSTALL_PREFIX")
CC_COMPILER=$(eval echo "$CC_COMPILER")
CXX_COMPILER=$(eval echo "$CXX_COMPILER")

# Ensure we're in the build directory
cd "$AC_CODE_DIR" || exit 1
mkdir -p build
cd build || exit 1

echo "Building AzerothCore with $BUILD_CORES cores..."
echo "Install prefix: $AC_INSTALL_PREFIX"

cmake ../ \
    -DCMAKE_INSTALL_PREFIX="$AC_INSTALL_PREFIX" \
    -DCMAKE_C_COMPILER=/usr/bin/clang \
    -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
    -DWITH_WARNINGS=1 \
    -DTOOLS_BUILD=all \
    -DSCRIPTS=static \
    -DMODULES=static &&
make -j"$BUILD_CORES" &&
make install

if [ $? -eq 0 ]; then
    echo ""
    echo "Build completed successfully!"
    echo "Servers installed to: $AC_INSTALL_PREFIX"
else
    echo ""
    echo "Build failed!"
    exit 1
fi
