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

public protocol GeneratedMessageProtocol: class, Message
{
    static func parseFromData(data:NSData) throws -> Self
    static func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Self
    static func parseFromInputStream(input:NSInputStream) throws -> Self
    static func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Self
    static func parseFromCodedInputStream(input:CodedInputStream) throws -> Self
    static func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Self
}

public class GeneratedMessage:AbstractMessage
{
    public var memoizedSerializedSize:Int32 = -1
    required public init()
    {
        super.init()
       self.unknownFields = UnknownFieldSet(fields: [:])
    }
    
    //Override
    public class func className() -> String
    {
        return "GeneratedMessage"
    }
    public func className() -> String
    {
        return "GeneratedMessage"
    }
    public func classMetaType() -> GeneratedMessage.Type
    {
        return GeneratedMessage.self
    }
    public override class func classBuilder() -> MessageBuilder
    {
        return GeneratedMessageBuilder()
    }
    public override func classBuilder() -> MessageBuilder
    {
        return GeneratedMessageBuilder()
    }
    //
}

public class GeneratedMessageBuilder:AbstractMessageBuilder
{
    public var internalGetResult:GeneratedMessage
    {
        get
        {
            return GeneratedMessage()
        }
        
    }
    
    override public var unknownFields:UnknownFieldSet
    {
        get
        {
            return internalGetResult.unknownFields
        }

        set (fields)
        {
            internalGetResult.unknownFields = fields
        }
        
    }
    public func checkInitialized() throws
    {
        let result = internalGetResult
        
        guard result.isInitialized() else
        {
            throw ProtocolBuffersError.InvalidProtocolBuffer("Uninitialized Message")
        }
    }
    
    public func checkInitializedParsed() throws
    {
        let result = internalGetResult
        guard result.isInitialized() else
        {
            throw ProtocolBuffersError.InvalidProtocolBuffer("Uninitialized Message")
        }
    }
    
    override public func isInitialized() -> Bool
    {
        return internalGetResult.isInitialized()
    }
    
    override public func mergeUnknownFields(unknownFields: UnknownFieldSet) throws -> Self
    {
        let result:GeneratedMessage = internalGetResult
        result.unknownFields = try UnknownFieldSet.builderWithUnknownFields(result.unknownFields).mergeUnknownFields(unknownFields).build()
        return self
    }
    public func parseUnknownField(input:CodedInputStream ,unknownFields:UnknownFieldSet.Builder, extensionRegistry:ExtensionRegistry, tag:Int32) throws -> Bool {
        return try unknownFields.mergeFieldFrom(tag, input:input)
    }
}

extension GeneratedMessage:CustomDebugStringConvertible
{
    public var debugDescription:String
        {
            return description
    }
}

extension GeneratedMessage:CustomStringConvertible
{
    public var description:String {
        get {
            var output:String = ""
            try! writeDescriptionTo(&output, indent:"")
            return output
        }
    }
}

extension GeneratedMessageBuilder:CustomDebugStringConvertible
{
    public var debugDescription:String
    {
            return internalGetResult.description
    }
}

