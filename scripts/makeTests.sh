cd src/compiler
protoc  google/protobuf/unittest*.proto --swift_out="./Tests";
protoc  google/protobuf/descriptor*.proto --swift_out="./Tests";
cp -f ./Tests/* ../ProtocolBuffers/ProtocolBuffersTests/pbTests/;
cd ../ProtocolBuffers/ProtocolBuffersTests
protoc Perfomance.proto --swift_out="./"
#cp -f ./Tests/Unittest* ../runtime/Tests/;
#cp -f ./Tests/Descriptor* ../runtime/Classes/;
