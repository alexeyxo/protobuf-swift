// Protocol Buffers for Swift
//
// Copyright 2014 Alexey Khohklov(AlexeyXo).
// Copyright 2008 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License")
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation


public typealias ONEOF_NOT_SET = Int

public protocol MessageInit:class
{
    init()
}

public enum ProtocolBuffersError: ErrorType {
    case Obvious(String)
    //Streams
    case InvalidProtocolBuffer(String)
    case IllegalState(String)
    case IllegalArgument(String)
    case OutOfSpace
}

public protocol Message:class,MessageInit
{
    var unknownFields:UnknownFieldSet{get}
    func serializedSize() -> Int32
    func isInitialized() -> Bool
    func writeToCodedOutputStream(output:CodedOutputStream) throws
    func writeToOutputStream(output:NSOutputStream) throws
    func data() throws -> NSData
    static func classBuilder()-> MessageBuilder
    func classBuilder()-> MessageBuilder
    
}

public protocol MessageBuilder: class
{
     var unknownFields:UnknownFieldSet{get set}
     func clear() -> Self
     func isInitialized()-> Bool
     func build() throws -> AbstractMessage
     func mergeUnknownFields(unknownField:UnknownFieldSet) throws -> Self
     func mergeFromCodedInputStream(input:CodedInputStream) throws ->  Self
     func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Self
     func mergeFromData(data:NSData) throws -> Self
     func mergeFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Self
     func mergeFromInputStream(input:NSInputStream) throws -> Self
     func mergeFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Self
     //Delimited Encoding/Decoding
     func mergeDelimitedFromInputStream(input:NSInputStream) throws -> Self?
}

public func == (lhs: AbstractMessage, rhs: AbstractMessage) -> Bool
{
    return lhs.hashValue == rhs.hashValue
}
public class AbstractMessage:Hashable, Message {
    
    public var unknownFields:UnknownFieldSet
    required public init()
    {
        unknownFields = UnknownFieldSet(fields: Dictionary())
    }

    public func data() -> NSData
    {
        let ser_size = serializedSize()
        let data = NSMutableData(length: Int(ser_size))!
        let stream:CodedOutputStream = CodedOutputStream(data: data)
        do {
            try writeToCodedOutputStream(stream)
        }
        catch
        {
            
        }
        
        return stream.buffer.buffer
    }
    public func isInitialized() -> Bool {
        return false
    }
    public func serializedSize() -> Int32 {
        return 0
    }
    
    public func writeDescriptionTo(inout output:String, indent:String) throws {
        throw ProtocolBuffersError.Obvious("Override")
    }
    
    public func writeToCodedOutputStream(output: CodedOutputStream) throws {
        throw ProtocolBuffersError.Obvious("Override")
    }
    
    public func writeToOutputStream(output: NSOutputStream) throws
    {
        let codedOutput:CodedOutputStream = CodedOutputStream(output:output)
        try! writeToCodedOutputStream(codedOutput)
        try codedOutput.flush()
    }
    
    public func writeDelimitedToOutputStream(outputStream:NSOutputStream) throws
    {
        let serializedDataSize = serializedSize()
        let codedOutputStream = CodedOutputStream(output: outputStream)
        try codedOutputStream.writeRawVarint32(serializedDataSize)
        try writeToCodedOutputStream(codedOutputStream)
        try codedOutputStream.flush()
    }
    
    public class func classBuilder() -> MessageBuilder
    {
        return AbstractMessageBuilder()
    }
    
    public func classBuilder() -> MessageBuilder
    {
        return AbstractMessageBuilder()
    }
    
    public var hashValue: Int {
        get {
            return unknownFields.hashValue
        }
    }
    
}



public class AbstractMessageBuilder:MessageBuilder
{
    public var unknownFields:UnknownFieldSet
    public init()
    {
        unknownFields = UnknownFieldSet(fields:Dictionary())
    }
    
    
    public func build() throws -> AbstractMessage {
        
        return AbstractMessage()
    }
    
    public func clone() throws -> Self
    {
        return self
    }
    public func clear() -> Self
    {
        return self
    }
    
    public func isInitialized() -> Bool
    {
        return false
    }
    
    public func mergeFromCodedInputStream(input:CodedInputStream) throws ->  Self
    {
        return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    
    public func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws ->  Self
    {
        throw ProtocolBuffersError.Obvious("Override")
    }
    
    public func mergeUnknownFields(unknownField:UnknownFieldSet) throws ->  Self
    {
        let merged:UnknownFieldSet = try UnknownFieldSet.builderWithUnknownFields(unknownFields).mergeUnknownFields(unknownField).build()
        unknownFields = merged
        return self
    }
    
    public func mergeFromData(data:NSData) throws ->  Self
    {
        let input:CodedInputStream = CodedInputStream(data:data)
        try mergeFromCodedInputStream(input)
        try input.checkLastTagWas(0)
        return self
    }
    
    
    public func mergeFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws ->  Self
    {
        let input:CodedInputStream = CodedInputStream(data:data)
        try mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry)
        try input.checkLastTagWas(0)
        return self
    }
    
    public func mergeFromInputStream(input:NSInputStream) throws -> Self
    {
        let codedInput:CodedInputStream = CodedInputStream(inputStream: input)
        try mergeFromCodedInputStream(codedInput)
        try codedInput.checkLastTagWas(0)
        return self
    }
    public func mergeFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Self
    {
        let codedInput:CodedInputStream = CodedInputStream(inputStream: input)
        try mergeFromCodedInputStream(codedInput, extensionRegistry:extensionRegistry)
        try codedInput.checkLastTagWas(0)
        return self
    }
    
    //Delimited Encoding/Decoding
    public func mergeDelimitedFromInputStream(input: NSInputStream) throws -> Self? {
        var firstByte:UInt8 = 0
        if input.read(&firstByte, maxLength: 1) != 1
        {
            return nil
        }
        let rSize = try CodedInputStream.readRawVarint32(firstByte, inputStream: input)
        let data  = NSMutableData(length: Int(rSize))
        let pointer = UnsafeMutablePointer<UInt8>(data!.mutableBytes)
        input.read(pointer, maxLength: Int(rSize))
        return  try mergeFromData(data!)
    }

}

