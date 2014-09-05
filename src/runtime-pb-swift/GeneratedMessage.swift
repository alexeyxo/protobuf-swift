// Protocol Buffers for Swift
//
// Copyright 2014 Alexey Khohklov(AlexeyXo).
// Copyright 2008 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
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
class GeneratedMessage:AbstractMessage
{
    var memoizedSerializedSize:Int32 = -1
    override init()
    {
        super.init()
       self.unknownFields = UnknownFieldSet(fields: [:])
    }
}



class GeneratedMessageBuilder:AbstractMessageBuilder
{
    var internalGetResult:GeneratedMessage?
    {
        get
        {
            NSException(name:"ImproperSubclassing", reason:"", userInfo: nil).raise()
            return nil
        }
        
    }
    
    var unknowFields:UnknownFieldSet
    {
        get
        {
            return internalGetResult!.unknownFields
        }

        set (fields)
        {
            internalGetResult!.unknownFields = fields
        }
        
    }
    func checkInitialized()
    {
        let result = internalGetResult?
        if (result != nil  && !result!.isInitialized())
        {
            NSException(name:"UninitializedMessage", reason:"", userInfo: nil).raise()
        }
    }
    
    func checkInitializedParsed()
    {
        let result = internalGetResult?
        if (result != nil  && !result!.isInitialized())
        {
            NSException(name:"InvalidProtocolBuffer", reason:"", userInfo: nil).raise()
        }
    }
    
    override func isInitialized() -> Bool
    {
        return internalGetResult!.isInitialized()
    }
    
    override func mergeUnknownFields(unknownFields: UnknownFieldSet) -> Self
    {
        let result:GeneratedMessage = internalGetResult!
        result.unknownFields = UnknownFieldSet.builderWithUnknownFields(result.unknownFields).mergeUnknownFields(unknownFields).build()
        return self
    }
    func parseUnknownField(input:CodedInputStream ,unknownFields:UnknownFieldSetBuilder, extensionRegistry:ExtensionRegistry, tag:Int32) -> Bool {
        return unknownFields.mergeFieldFrom(tag, input:input)
    }
}

