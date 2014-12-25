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
            NSException(name:"ImproperSubclassing", reason:"", userInfo: nil).raise()
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
    public func checkInitialized()
    {
        let result = internalGetResult
        if (!result.isInitialized())
        {
            NSException(name:"UninitializedMessage", reason:"", userInfo: nil).raise()
        }
    }
    
    public func checkInitializedParsed()
    {
        let result = internalGetResult
        if (!result.isInitialized())
        {
            NSException(name:"InvalidProtocolBuffer", reason:"", userInfo: nil).raise()
        }
    }
    
    override public func isInitialized() -> Bool
    {
        return internalGetResult.isInitialized()
    }
    
    override public func mergeUnknownFields(unknownFields: UnknownFieldSet) -> Self
    {
        let result:GeneratedMessage = internalGetResult
        result.unknownFields = UnknownFieldSet.builderWithUnknownFields(result.unknownFields).mergeUnknownFields(unknownFields).build()
        return self
    }
    public func parseUnknownField(input:CodedInputStream ,unknownFields:UnknownFieldSetBuilder, extensionRegistry:ExtensionRegistry, tag:Int32) -> Bool {
        return unknownFields.mergeFieldFrom(tag, input:input)
    }
}

