#!/bin/bash
#
# Copyright 2016 leenjewel
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# read -n1 -p "Press any key to continue..."

set -eu

source ./build-android-common.sh

if [ -z ${version+x} ]; then 
  version="2.1.12"
fi

TOOLS_ROOT=$(pwd)

SOURCE="$0"
while [ -h "$SOURCE" ]; do
    DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
pwd_path="$(cd -P "$(dirname "$SOURCE")" && pwd)"

echo pwd_path=${pwd_path}
echo TOOLS_ROOT=${TOOLS_ROOT}

LIB_NAME="libevent-$version"
LIB_DEST_DIR="${pwd_path}/../output/ios/libevent-universal"

init_log_color

echo "https://github.com/libevent/libevent/releases/download/release-${version}-stable/${LIB_NAME}-stable.tar.gz"

DEVELOPER=$(xcode-select -print-path)
rm -rf "${LIB_DEST_DIR}" "${LIB_NAME}"
[ -f "${LIB_NAME}-stable.tar.gz" ] || curl -LO "https://github.com/libevent/libevent/releases/download/release-${version}-stable/${LIB_NAME}-stable.tar.gz" >${LIB_NAME}-stable.tar.gz

set_android_toolchain_bin

function configure_make() {
    ARCH=$1
    ABI=$2
    ABI_TRIPLE=$3

    log_info "configure $ABI start..."

    if [ -d "${LIB_NAME}" ]; then
        rm -fr "${LIB_NAME}"
    fi
    tar xfz "${LIB_NAME}-stable.tar.gz"
    pushd .
    cd "${LIB_NAME}-stable"

    PREFIX_DIR="${pwd_path}/../output/android/libevent-${ABI}"
    if [ -d "${PREFIX_DIR}" ]; then
        rm -fr "${PREFIX_DIR}"
    fi
    mkdir -p "${PREFIX_DIR}"

    OUTPUT_ROOT=${TOOLS_ROOT}/../output/android/libevent-${ARCH}
    mkdir -p ${OUTPUT_ROOT}/log

    set_android_toolchain "libevent" "${ARCH}" "${ANDROID_API}"
    set_android_cpu_feature "libevent" "${ARCH}" "${ANDROID_API}"

    export ANDROID_NDK_HOME=${ANDROID_NDK_ROOT}
    echo ANDROID_NDK_HOME=${ANDROID_NDK_HOME}

    OPENSSL_OUT_DIR="${pwd_path}/../output/android/openssl-${ABI}"
    export PKG_CONFIG_PATH="${OPENSSL_OUT_DIR}/lib/pkgconfig"

    android_printf_global_params "$ARCH" "$ABI" "$ABI_TRIPLE" "$PREFIX_DIR" "$OUTPUT_ROOT"

    ./Configure --host=$(android_get_build_host "${ARCH}") --disable-shared --prefix="${PREFIX_DIR}"

    log_info "make $ARCH start..."

    make clean >"${OUTPUT_ROOT}/log/${ABI}.log"
    if make -j8 >>"${OUTPUT_ROOT}/log/${ABI}.log" 2>&1; then
        make install >>"${OUTPUT_ROOT}/log/${ABI}.log" 2>&1
    fi

    popd
}

log_info "${PLATFORM_TYPE} ${LIB_NAME} start..."

for ((i = 0; i < ${#ARCHS[@]}; i++)); do
    if [[ $# -eq 0 || "$1" == "${ARCHS[i]}" ]]; then
        configure_make "${ARCHS[i]}" "${ABIS[i]}" "${ARCHS[i]}-linux-android"
    fi
done

log_info "${PLATFORM_TYPE} ${LIB_NAME} end..."
