#!/usr/bin/env sh

set -ex

compiler_root=src/compiler

PATH=$PATH:$compiler_root

# we need this for bootstrapping
protoc -I$compiler_root $compiler_root/google/protobuf/{,swift-}descriptor.proto --cpp_out=$compiler_root

# build the swift generator
scripts/build.sh

# compile the swift descriptors into the runtime library
protoc -I$compiler_root $compiler_root/google/protobuf/{,swift-}descriptor.proto --swift_out=src/ProtocolBuffers/runtime-pb-swift/
