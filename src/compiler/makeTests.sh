protoc  google/protobuf/unittest*.proto --swift_out="./Tests";
protoc  google/protobuf/descriptor*.proto --swift_out="./Tests";
cp -f ./Tests/* ../ProtocolBuffers/ProtocolBuffersTests/pbTests/;
#cp -f ./Tests/Unittest* ../runtime/Tests/;
#cp -f ./Tests/Descriptor* ../runtime/Classes/;
