#Protocol Buffers for Swift

[![Build Status](https://travis-ci.org/alexeyxo/protobuf-swift.svg?branch=master)](https://travis-ci.org/alexeyxo/protobuf-swift) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Version](http://img.shields.io/cocoapods/v/ProtocolBuffers-Swift.svg)](http://cocoapods.org/?q=ProtocolBuffers-Swift) [![Platform](http://img.shields.io/cocoapods/p/ProtocolBuffers-Swift.svg)](http://cocoapods.org/?q=ProtocolBuffers)

An implementation of Protocol Buffers in Swift.

Protocol Buffers are a way of encoding structured data in an efficient yet extensible format. This project is based on an implementation of Protocol Buffers from Google. See the [Google protobuf project](https://developers.google.com/protocol-buffers/docs/overview) for more information.

####Required Protocol Buffers 2.6

##How To Install Protobuf


1.`ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

2.`brew install automake`

3.`brew install libtool`

4.`brew install protobuf`

5.`git clone git@github.com:alexeyxo/protobuf-swift.git`

6.`./scripts/build.sh`

7.Add `./src/ProtocolBuffers/ProtocolBuffers.xcodeproj` in your project.

##<img src="https://cloud.githubusercontent.com/assets/432536/5252404/443d64f4-7952-11e4-9d26-fc5cc664cb61.png" width="22" height="22"> Installation via [Carthage](https://github.com/Carthage/Carthage)

Cartfile:
```
github "alexeyxo/protobuf-swift"
```

##Compile ".proto" files.

```sh
protoc  person.proto --swift_out="./"
```

##Serializing

```protobuf
message Person {
    required int32 id = 1;
    required string name = 2;
    optional string email = 3;
}
```

```swift
let personBuilder = Person.builder()
personBuilder.id = 123
personBuilder.name = "Bob"
personBuilder.email = "bob@example.com"
let person = personBuilder.build()
println("\(person)")

person.data() //return NSData
```

##Chaining


```protobuf
message Perfomance
{
  required int32 ints = 1;
  required int64 ints64 = 2;
  required double doubles = 3;
  required float floats  = 4;
  optional string str  = 5;
  optional bytes bytes  = 6;
  optional string description = 7;
}
```

```swift
var originalBuilder = ProtoPerfomance.builder()
originalBuilder.setInts(Int32(32))
               .setInts64(Int64(64))
               .setDoubles(Double(12.12))
               .setFloats(Float(123.123))
               .setStr("string")
let original = originalBuilder.build()
```

##Deserializing

```swift
var person = Person.parseFromData(bytes) // from NSData
```

##Using Oneof


```protobuf
message SubMessage {
    optional string str = 1;
}

message SampleMessage {
  oneof test_oneof {
     string name = 4;
     int32 id = 5;
     SubMessage mes = 6;
  }
}
```

```swift
var sm = SampleMessage.builder()
sm.name = "Alex"
sm.id = 123
println(ss.build()) //->  id: 123
```

##Nested Types


```protobuf
message SearchResponse {
    message Result {
        required string url = 1;
        optional string title = 2;
        repeated string snippets = 3;
    }
    repeated Result result = 1;
}
```

```swift
var builderResult = SearchResponse.Result.builder()
builderResult.url = "http://protobuf.axo.io"
builderResult.title = "Protocol Bufers Apple Swift"
var searchRespons = SearchResponse.builder()
searchRespons.result += [builderResult.build()]
println(searchRespons.build())
```

##Packages

```protobuf
package FooBar;
message Perfomance
{
  required int32 ints = 1;
  required int64 ints64 = 2;
  required double doubles = 3;
  required float floats  = 4;
  optional string str  = 5;
  optional bytes bytes  = 6;
  optional string description = 7;
}
```

```swift
public extension FooBar {
  ...
  final public class Perfomance : GeneratedMessage, GeneratedMessageProtocol {
    ...
  }

}

```

##Custom Options

```protobuf
enum AccessControl {
  InternalEntities = 0;
  PublicEntities = 1;
}
message SwiftFileOptions {

  optional string class_prefix = 1;
  optional AccessControl entities_access_control = 2 [default = InternalEntities];
  optional bool compile_for_framework = 3 [default = true];
}
```

At now protobuf-swift's compiler is supporting three custom options(file options).

1.	Class Prefix
2.	Access Control
3.	Compile for framework

If you have use custom options, you need to add:

```protobuf
import 'google/protobuf/swift-descriptor.proto';
```

in your `.proto` files.

###Class prefix

This option needs to generate class names with prefix.

Example:

```protobuf
import 'google/protobuf/swift-descriptor.proto';

option (.google.protobuf.swift_file_options).class_prefix = "Proto";

message NameWithPrefix
{
  optional string str = 1;
}
```

Generated class has a name:

```swift
final internal class ProtoNameWithPrefix : GeneratedMessage
```

###Access control

```protobuf
option (.google.protobuf.swift_file_options).entities_access_control = PublicEntities;
```

All generated classes marks as `internal` by default. If you want mark as `public`, you can use `entities_access_control` option.

```protobuf
option (.google.protobuf.swift_file_options).entities_access_control = PublicEntities;

message MessageWithCustomOption
{
  optional string str = 1;
}
```

Generated class and all fields are marked a `public`:

```swift
final public class MessageWithCustomOption : GeneratedMessage
```

###Compile for framework

```protobuf
option (.google.protobuf.swift_file_options).compile_for_framework = false;
```

This option deletes the string `import ProtocolBuffers` of the generated files.

####If you will need some other options, write me. I will add them.

Credits
=======

Developer - Alexey Khokhlov

Google Protocol Buffers - Cyrus Najmabadi, Sergey Martynov, Kenton Varda, Sanjay Ghemawat, Jeff Dean, and others
