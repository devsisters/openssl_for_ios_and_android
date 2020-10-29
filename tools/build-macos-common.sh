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

source ./build-common.sh

if [ -z ${api+x} ]; then 
  api="10.12"
fi
if [ -z ${arch+x} ]; then 
  arch=("x86_64")
fi
if [ -z ${sdk+x} ]; then 
  sdk=("macosx")
fi
if [ -z ${platform+x} ]; then 
  platform=("MacOSX")
fi

export PLATFORM_TYPE="macOS"
export MACOS_MIN_TARGET="$api"
export ARCHS=(${arch[@]})
export SDKS=(${sdk[@]})
export PLATFORMS=(${platform[@]})

function macos_get_build_host() {
  echo "x86_64-apple-macos"
}

function set_macos_cpu_feature() {
    local name=$1
    local arch=$2
    local macos_min_target=$3
    local sdk=$4
    export CC="xcrun -sdk ${sdk} clang -target "${arch}-apple-macos" -mmacosx-version-min=${macos_min_target} -Oz -Wno-ignored-optimization-argument -Wno-unused-function"
    export CXX="xcrun -sdk ${sdk} clang++ -target "${arch}-apple-macos" -mmacosx-version-min=${macos_min_target} -Oz -Wno-ignored-optimization-argument -Wno-unused-function"
    set +u
    export CFLAGS=
    export CXXFLAGS=
    export LDFLAGS=
    set -u
}

function macos_printf_global_params() {
    local arch=$1
    local type=$2
    local platform=$3
    local in_dir=$4
    local out_dir=$5
    echo -e "arch =             $arch"
    echo -e "type =             $type"
    echo -e "platform =         $platform"
    echo -e "PLATFORM_TYPE =    $PLATFORM_TYPE"
    echo -e "MACOS_MIN_TARGET = $MACOS_MIN_TARGET"
    echo -e "in_dir =           $in_dir"
    echo -e "out_dir =          $out_dir"
    echo -e "CC =               $CC"
    echo -e "CXX =              $CXX"
    echo -e "CFLAGS =           $CFLAGS"
    echo -e "CXXFLAGS =         $CXXFLAGS"
    echo -e "LDFLAGS =          $LDFLAGS"
}
