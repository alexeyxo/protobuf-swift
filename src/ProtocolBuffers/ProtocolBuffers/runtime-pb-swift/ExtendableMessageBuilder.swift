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
public class ExtendableMessageBuilder:GeneratedMessageBuilder
{
    
    override public var unknowFields:UnknownFieldSet
    {
        get
        {
            return internalGetResult!.unknownFields
        }
        set (fields)
        {
            return internalGetResult!.unknownFields = fields
        }
            
    }
    
    override public func checkInitialized()
    {
        let result = internalGetResult?
        if (result != nil  && result!.isInitialized())
        {
            NSException(name:"UninitializedMessage", reason:"", userInfo: nil).raise()
        }
    }
    
    override public func checkInitializedParsed()
    {
        let result = internalGetResult?
        if (result != nil  && !result!.isInitialized())
        {
            NSException(name:"InvalidProtocolBuffer", reason:"", userInfo: nil).raise()
        }
    }
    
    override public func isInitialized() -> Bool
    {
        return internalGetResult!.isInitialized()
    }
    
    override public func mergeUnknownFields(unknownFields: UnknownFieldSet) -> Self
    {
        let result:GeneratedMessage = internalGetResult!
        result.unknownFields = UnknownFieldSet.builderWithUnknownFields(result.unknownFields).mergeUnknownFields(unknownFields).build()
        return self
    }
    
    override public func parseUnknownField(input:CodedInputStream ,unknownFields:UnknownFieldSetBuilder, extensionRegistry:ExtensionRegistry, tag:Int32) -> Bool {
        
//        var message = internalGetResult
//        var wireType = WireFormat.wireFormatGetTagWireType(tag);
//        var fieldNumber:Int32 = WireFormat.wireFormatGetTagFieldNumber(tag)
//        
//        var extensions = extensionRegistry.getExtension(message, fieldNumber: fieldNumber)
//
//         NSException(name:"InvalidProtocolBuffer", reason:"", userInfo: nil).raise()
//        
//        if (extensions != nil) {
//            if (extensions.wireType == wireType) {
//                extensions.mergeFromCodedInputStream(input, unknownFields:unknownFields, extensionRegistry:extensionRegistry, builder:self, tag:tag)
//                return true
//            }
//        }
//        return super.parseUnknownField(input, unknownFields: unknownFields, extensionRegistry: extensionRegistry, tag: tag)
        return false
    }
    
    
    
//    func getExtension(extensions:ExtensionField) -> ExtendableMessage
//    {
//        return internalGetResult!.getExtension(extensions)
//    }
////
////    
//    func hasExtension(extensions:ExtensionField) -> ExtendableMessage {
//        return internalGetResult!.hasExtension(extensions)
//    }
//

    
}