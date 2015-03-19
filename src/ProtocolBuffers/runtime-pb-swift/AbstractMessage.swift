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

public protocol Message:class,MessageInit
{
    var unknownFields:UnknownFieldSet{get}
    func serializedSize() -> Int32
    func isInitialized() -> Bool
    func writeToCodedOutputStream(output:CodedOutputStream)
    func writeToOutputStream(output:NSOutputStream)
    func data()-> NSData
    static func classBuilder()-> MessageBuilder
    func classBuilder()-> MessageBuilder
    
}

public protocol MessageBuilder: class
{
     var unknownFields:UnknownFieldSet{get set}
     func clear() -> Self
     func isInitialized()-> Bool
     func build() -> AbstractMessage
     func mergeUnknownFields(unknownField:UnknownFieldSet) ->Self
     func mergeFromCodedInputStream(input:CodedInputStream) -> Self
     func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Self
     func mergeFromData(data:NSData) -> Self
     func mergeFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Self
     func mergeFromInputStream(input:NSInputStream) -> Self
     func mergeFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) -> Self
}

public func == (lhs: AbstractMessage, rhs: AbstractMessage) -> Bool
{
    return true
}
public class AbstractMessage:Equatable, Hashable, Message {
    
    public var unknownFields:UnknownFieldSet
    required public init()
    {
        unknownFields = UnknownFieldSet(fields: Dictionary())
    }
    
 
    
    public func data() -> NSData
    {
        var ser_size = serializedSize()
        let data = NSMutableData(length: Int(ser_size))!
        var stream:CodedOutputStream = CodedOutputStream(data: data)
        writeToCodedOutputStream(stream)
        return stream.buffer.buffer
    }
    public func isInitialized() -> Bool
    {
        return false
    }
    public func serializedSize() -> Int32
    {
        return 0
    }
    
    public func writeDescriptionTo(inout output:String, indent:String)
    {
        NSException(name:"Override", reason:"", userInfo: nil).raise()
    }
    
    public func writeToCodedOutputStream(output: CodedOutputStream)
    {
         NSException(name:"Override", reason:"", userInfo: nil).raise()
    }
    
    public func writeToOutputStream(output: NSOutputStream)
    {
        var codedOutput:CodedOutputStream = CodedOutputStream(output:output)
        writeToCodedOutputStream(codedOutput)
        codedOutput.flush()
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
            return 0
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
    
    
    public func build() -> AbstractMessage {
        
        return AbstractMessage()
    }
    
    public func clone() -> Self
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
    
    public func mergeFromCodedInputStream(input:CodedInputStream) -> Self
    {
        return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    
    public func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Self
    {
        NSException(name:"ImproperSubclassing", reason:"", userInfo: nil).raise()
        return  self
    }

    
    public func mergeUnknownFields(unknownField:UnknownFieldSet) -> Self
    {
        var merged:UnknownFieldSet = UnknownFieldSet.builderWithUnknownFields(unknownFields).mergeUnknownFields(unknownField).build()
        unknownFields = merged
        return self
    }
    
    public func mergeFromData(data:NSData) -> Self
    {
        var input:CodedInputStream = CodedInputStream(data:data)
        mergeFromCodedInputStream(input)
        input.checkLastTagWas(0)
        return self
    }
    
    
    public func mergeFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Self
    {
        var input:CodedInputStream = CodedInputStream(data:data)
        mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry)
        input.checkLastTagWas(0)
        return self
    }
    
    public func mergeFromInputStream(input:NSInputStream) -> Self
    {
        var codedInput:CodedInputStream = CodedInputStream(inputStream: input)
        mergeFromCodedInputStream(codedInput)
        codedInput.checkLastTagWas(0)
        return self
    }
    public func mergeFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) -> Self
    {
        var codedInput:CodedInputStream = CodedInputStream(inputStream: input)
        mergeFromCodedInputStream(codedInput, extensionRegistry:extensionRegistry)
        codedInput.checkLastTagWas(0)
        return self
    }

}

