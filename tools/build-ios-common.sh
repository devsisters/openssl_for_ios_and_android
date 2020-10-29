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
  api="8.0"
fi
if [ -z ${arch+x} ]; then 
  arch=("arm64" "arm64e" "armv7" "x86_64")
fi
if [ -z ${sdk+x} ]; then 
  sdk=("iphoneos" "iphoneos" "iphoneos" "iphonesimulator")
fi
if [ -z ${platform+x} ]; then 
  platform=("iPhoneOS" "iPhoneOS" "iphoneos" "iPhoneSimulator")
fi

export PLATFORM_TYPE="iOS"
export IOS_MIN_TARGET="$api"
export ARCHS=(${arch[@]})
export SDKS=(${sdk[@]})
export PLATFORMS=(${platform[@]})

function ios_get_build_host() {
    local arch=$1
    case ${arch} in
    armv7)
        echo "armv7-apple-ios"
        ;;
    arm64)
        echo "aarch64-apple-ios"
        ;;
    arm64e)
        echo "aarch64-apple-ios"
        ;;
    x86)
        echo "x86-apple-ios"
        ;;
    x86_64)
        echo "x86_64-apple-ios"
        ;;
    esac
}

function set_ios_cpu_feature() {
    local name=$1
    local arch=$2
    local ios_min_target=$3
    local sdk=$4
    export CC="xcrun -sdk ${sdk} clang -target "${arch}-apple-ios" -Oz -miphoneos-version-min=${ios_min_target} -Wno-ignored-optimization-argument -Wno-unused-function"
    export CXX="xcrun -sdk ${sdk} clang++ -target "${arch}-apple-ios" -Oz -miphoneos-version-min=${ios_min_target} -Wno-ignored-optimization-argument -Wno-unused-function"
    export CFLAGS=
    export CXXFLAGS=
    export LDFLAGS=
}

function ios_printf_global_params() {
    local arch=$1
    local type=$2
    local platform=$3
    local in_dir=$4
    local out_dir=$5
    echo -e "arch =           $arch"
    echo -e "type =           $type"
    echo -e "platform =       $platform"
    echo -e "PLATFORM_TYPE =  $PLATFORM_TYPE"
    echo -e "IOS_MIN_TARGET = $IOS_MIN_TARGET"
    echo -e "in_dir =         $in_dir"
    echo -e "out_dir =        $out_dir"
    echo -e "CC =             $CC"
    echo -e "CXX =            $CXX"
    echo -e "CFLAGS =         $CFLAGS"
    echo -e "CXXFLAGS =       $CXXFLAGS"
    echo -e "LDFLAGS =        $LDFLAGS"
}
