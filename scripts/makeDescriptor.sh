#!/bin/sh
cd src/ && protoc compiler/swift-descriptor.proto --cpp_out="./" && cd ..;
