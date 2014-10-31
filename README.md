#Protocol Buffers for Swift

[![Platform](http://img.shields.io/badge/platform-ios%20%7C%20osx-green.svg)](https://github.com/alexeyxo/protobuf-swift)
[![Release](http://img.shields.io/github/tag/alexeyxo/protobuf-swift.svg)](https://github.com/alexeyxo/protobuf-swift/releases/tag/v1.0)

An implementation of Protocol Buffers in Swift.

Protocol Buffers are a way of encoding structured data in an efficient yet extensible format.
This project is based on an implementation of Protocol Buffers from Google.  See the
[Google protobuf project][g-protobuf] for more information.

[g-protobuf]: https://developers.google.com/protocol-buffers/docs/overview

####Required Protocol Buffers 2.6

## How To Install Protobuf
1.`ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

2.`brew install automake`

3.`brew install libtool`

4.`brew instal protobuf`

5.`git clone git@github.com:alexeyxo/protobuf-swift.git`

6.`./build.sh`

7.Add `./src/ProtocolBuffers/ProtocolBuffers.xcodeproj` in your project.



## Compile ".proto" files.
`protoc  person.proto --swift_out="./"`

## Example
```
message Person {
    required int32 id = 1;
    required string name = 2;
    optional string email = 3;
}
```

```
    let personBuilder = Person.builder()
    personBuilder.id = 123
    personBuilder.name = "Bob"
    personBuilder.email = "bob@example.com"
    let person = personBuilder.build()
    println("\(person)")

    person.data() //return [Byte]
    person.getNSData() //Return NSData
```

## Using Oneof
```
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

```
    var sm = SampleMessage.builder()
    sm.name = "Alex"
    sm.id = 123
    println(ss.build()) //->  id: 123
```

## Nested Types

```
message SearchResponse {
    message Result {
        required string url = 1;
        optional string title = 2;
        repeated string snippets = 3;
    }
    repeated Result result = 1;
}
```

```
    var builderResult = SearchResponse.Result.builder()
    builderResult.url = "http://protobuf.axo.io"
    builderResult.title = "Protocol Bufers Apple Swift"
    var searchRespons = SearchResponse.builder()
    searchRespons.result += [builderResult.build()]
    println(searchRespons.build())
```

### Credits

Developer
- Alexey Khokhlov

Google Protocol Buffers
- Cyrus Najmabadi, Sergey Martynov, Kenton Varda, Sanjay Ghemawat, Jeff Dean, and others
