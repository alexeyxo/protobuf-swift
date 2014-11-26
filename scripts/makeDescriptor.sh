#!/bin/sh
cd src/compiler/ && protoc google/protobuf/swift-descriptor.proto --cpp_out="./" && cd ..;
