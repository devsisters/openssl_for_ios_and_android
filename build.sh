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
set -e

# build every targets
BASEDIR=$(dirname "$0")
pushd "$BASEDIR/tools"
./build-ios-openssl.sh \
  && ./build-ios-libevent.sh \
  && ./build-ios-nghttp2.sh \
  && ./build-ios-curl.sh \
  && ./build-macos-openssl.sh \
  && ./build-macos-libevent.sh \
  && ./build-macos-nghttp2.sh \
  && ./build-macos-curl.sh \
  && ./build-android-xxhash.sh \
  && ./build-android-zstd.sh \
  && ./build-android-lz4.sh \
  && ./build-android-openssl.sh \
  && ./build-android-libevent.sh \
  && ./build-android-nghttp2.sh \
  && ./build-android-curl.sh
popd

