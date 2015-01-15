#!/bin/sh
cd src/compiler;
rm -f ./Tests/*;
protoc  google/protobuf/unittest*.proto --swift_out="./Tests";
# protoc  google/protobuf/descriptor*.proto --swift_out="./Tests";
cp -f ./Tests/* ../ProtocolBuffers/ProtocolBuffersTests/pbTests/;
cd ../ProtocolBuffers/ProtocolBuffersTests
protoc google/protobuf/Perfomance.proto  --swift_out="./"
#cp -f ./Tests/Unittest* ../runtime/Tests/;
#cp -f ./Tests/Descriptor* ../runtime/Classes/;
cd ../../;
cd compiler;
rm -f ./Tests/*;
