#!/usr/bin/env sh

set -ex

compiler_root=plugin/compiler

PATH=$PATH:$compiler_root

# compile the unit tests into the runtime library's fixture directory
protoc -I$compiler_root $compiler_root/google/protobuf/unittest*.proto --swift_out=plugin/Tests/pbTests/
protoc -I$compiler_root $compiler_root/tests/**/*.proto --swift_out=plugin/Tests/pbTests/

# compile the performance proto into the runtime
protoc -I$compiler_root $compiler_root/google/protobuf/performance.proto  --swift_out=plugin/Tests
