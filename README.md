##Protobuf Extensions And Services will be coming soon


##Protocol Buffers 2.6 for Swift
=================

An implementation of Protocol Buffers in Swift.

Protocol Buffers are a way of encoding structured data in an efficient yet extensible format.
This project is based on an implementation of Protocol Buffers from Google.  See the
[Google protobuf project][g-protobuf] for more information.

[g-protobuf]: https://developers.google.com/protocol-buffers/docs/overview


## How To Install Protobuf
1.Download `https://protobuf.googlecode.com/svn/rc/protobuf-2.6.0.tar.gz"`

2.`cd protobuf-2.6.0`

3.`./configure`

4.`make`

5.`sudo make install`

6.`git clone git@github.com:alexeyxo/protobuf-swift.git`

7.`./build.sh`

8.Add `/src/runtime-pb-swift/` folder in your project.



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
    let person = person.build()
    println("\(person)")

    person.data() //return [Byte]
    person.getNSDate() //Return NSData
```

### Credits

Developer
- Alexey Khokhlov

Google Protocol Buffers
- Cyrus Najmabadi, Sergey Martynov, Kenton Varda, Sanjay Ghemawat, Jeff Dean, and others
