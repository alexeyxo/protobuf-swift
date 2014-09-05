protoc  --plugin=/usr/local/bin/protoc-gen-objc google/protobuf/unittest* --swift_out="./Tests";
protoc  --plugin=/usr/local/bin/protoc-gen-objc google/protobuf/descriptor* --swift_out="./Tests";
cp -f ./Tests/Unittest* ../runtime/Tests/;
cp -f ./Tests/Descriptor* ../runtime/Classes/;
