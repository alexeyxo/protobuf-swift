#!/usr/bin/env sh

set -ex

compiler_root=plugin/compiler

PATH=$PATH:$compiler_root

# we need this for bootstrapping
protoc -I$compiler_root $compiler_root/google/protobuf/{,swift-}descriptor.proto --cpp_out=$compiler_root
# build the swift generator
scripts/build.sh

# compile the swift descriptors and utils into the runtime library
protoc -I$compiler_root $compiler_root/google/protobuf/{,swift-}descriptor.proto --swift_out=Source/
# protoc -I$compiler_root $compiler_root/google/protobuf/plugin.proto --swift_out=Source/
# protoc -I$compiler_root $compiler_root/google/protobuf/Utilities/*.proto --swift_out=Source/
protoc -I$compiler_root $compiler_root/google/protobuf/api.proto --swift_out=Source/
protoc -I$compiler_root $compiler_root/google/protobuf/any.proto --swift_out=Source/
protoc -I$compiler_root $compiler_root/google/protobuf/duration.proto --swift_out=Source/
protoc -I$compiler_root $compiler_root/google/protobuf/empty.proto --swift_out=Source/
protoc -I$compiler_root $compiler_root/google/protobuf/field_mask.proto --swift_out=Source/
protoc -I$compiler_root $compiler_root/google/protobuf/source_context.proto --swift_out=Source/
protoc -I$compiler_root $compiler_root/google/protobuf/struct.proto --swift_out=Source/
protoc -I$compiler_root $compiler_root/google/protobuf/timestamp.proto --swift_out=Source/
protoc -I$compiler_root $compiler_root/google/protobuf/type.proto --swift_out=Source/
protoc -I$compiler_root $compiler_root/google/protobuf/wrappers.proto --swift_out=Source/
