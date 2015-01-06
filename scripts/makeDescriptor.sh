#!/bin/sh
pwds=`pwd`
cd src/compiler/ && protoc google/protobuf/swift-descriptor.proto --cpp_out="./" && cd ..;
cd $pwds;
./scripts/build.sh && \
cd $pwds/src/compiler/ && protoc google/protobuf/swift-descriptor.proto --swift_out="./Descriptors";
cd $pwds/src/compiler/ && protoc google/protobuf/descriptor.proto --swift_out="./Descriptors";

cp -f ./Descriptors/Descriptor.pb.swift ../ProtocolBuffers/runtime-pb-swift/
cp -f ./Descriptors/SwiftDescriptor.pb.swift ../ProtocolBuffers/runtime-pb-swift/
