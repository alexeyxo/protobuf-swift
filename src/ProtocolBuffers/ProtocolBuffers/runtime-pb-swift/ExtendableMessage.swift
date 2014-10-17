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


typealias ExtensionsValueType = protocol<Hashable, Equatable>

public class ExtendableMessage : GeneratedMessage
{

    private var extensionMap:[Int32:Any] = [Int32:Any]()
    public var extensionRegistry:[Int32:ConcreateExtensionField] = [Int32:ConcreateExtensionField]()

    required public init()
    {
        super.init()
    }
    
    //Override
    override public class func className() -> String
    {
        return "ExtendableMessage"
    }
    override public func classMetaType() -> GeneratedMessage.Type
    {
        return ExtendableMessage.self
    }
    //
    
    public func isInitialized(object:Any) -> Bool
    {
        if let array = object as? Array<Any>
        {
            for child in array
            {
                if (!isInitialized(child))
                {
                    return false
                }
            }
        }
        else if  let mes = object as? ExtendableMessage
        {
            return mes.isInitialized()
        }
        return true
    }
    
    public func extensionsAreInitialized() -> Bool {
        return isInitialized(extensionMap.values)
    }
    
    internal func ensureExtensionIsRegistered(extensions:ConcreateExtensionField)
    {

        extensionRegistry[extensions.fieldNumber] = extensions
    }
    
    public func getExtension(extensions:ConcreateExtensionField) -> ConcreateExtensionField
    {
        ensureExtensionIsRegistered(extensions)
        return extensionRegistry[extensions.fieldNumber]!
    }
    public func hasExtension(extensions:ConcreateExtensionField) -> Bool
    {
        if let ext = extensionMap[extensions.fieldNumber]
        {
            return true
        }
        return false
    }
    public func writeExtensionsToCodedOutputStream(output:CodedOutputStream, startInclusive:Int32, endExclusive:Int32)
    {
        for fieldNumber in extensionMap.keys {
            if (fieldNumber >= startInclusive && fieldNumber < endExclusive) {
                let extensions = extensionRegistry[fieldNumber]!
                let value = extensionMap[fieldNumber]!
                extensions.writeValueIncludingTagToCodedOutputStream(value, output: output)
            }
        }
    }
    
    public func writeExtensionDescription(inout output:String, startInclusive:Int32 ,endExclusive:Int32, indent:String) {
        for fieldNumber in extensionMap.keys {
        
            if (fieldNumber >= startInclusive && fieldNumber < endExclusive) {
                let extensions = extensionRegistry[fieldNumber]!
                let value = extensionMap[fieldNumber]!
                extensions.writeDescriptionOf(value, output: &output, indent: indent)
                
            }
            
        }
    }
    
    public func isEqualExtensionsInOther(otherMessage:ExtendableMessage, startInclusive:Int32, endExclusive:Int32) -> Bool {

        for fieldNumber in extensionMap.keys {
            if (fieldNumber >= startInclusive && fieldNumber < endExclusive) {
                let value = extensionMap[fieldNumber]!
                let otherValue = otherMessage.extensionMap[fieldNumber]!
                return compare(value, rhs: otherValue)
            }
        }
        return true;
    }
    
    private func compare(lhs:Any, rhs:Any) -> Bool
    {
        switch (lhs,rhs)
        {
        case (let value as Int32, let value2 as Int32):
            return value == value2
        case (let value as Int64, let value2 as Int64):
            return value == value2
        case (let value as Double, let value2 as Double):
            return value == value2
        case (let value as Float, let value2 as Float):
            return value == value2
        case (let value as Bool, let value2 as Bool):
            return value == value2
        case (let value as String, let value2 as String):
            return value == value2
        case (let value as [Byte], let value2 as [Byte]):
            return value == value2
        case (let value as UInt32, let value2 as UInt32):
            return value == value2
        case (let value as UInt64, let value2 as UInt64):
            return value == value2
        case (let value as AbstractMessage, let value2 as AbstractMessage):
            return value == value2
        default:
            return false
        }
    }
    private func getHash(lhs:Any) -> Int!
    {
        switch lhs
        {
        case let value as Int32:
            return value.hashValue
        case let value as Int64:
            return value.hashValue
        case let value as Double:
            return value.hashValue
        case let value as Float:
            return value.hashValue
        case let value as Bool:
            return value.hashValue
        case let value as String:
            return value.hashValue
        case let value as [Byte]:
            return getHashBytes(value)
        case let value as UInt32:
            return value.hashValue
        case let value as UInt64:
            return value.hashValue
        case let value as AbstractMessage:
            return value.hashValue
        default:
            return nil
        }
    }
    private func getHashBytes(bytes:[Byte]) -> Int
    {
        var hashCode:Int = 0
        for value in bytes
        {
            hashCode = (hashCode &* 31) &+ getHash(value)!
        }
        return hashCode
    }
    
    public func hashExtensionsFrom(startInclusive:Int32, endExclusive:Int32) -> Int {
        var hashCode:Int = 0
        for fieldNumber in extensionMap.keys {
            if (fieldNumber >= startInclusive && fieldNumber < endExclusive) {
                let value = extensionMap[fieldNumber]!
                hashCode = (hashCode &* 31) &+ getHash(value)!

            }
        }
        return hashCode;
    }
    
    
    public func extensionsSerializedSize() ->Int32 {
        var size:Int32 = 0
        for fieldNumber in extensionMap.keys {
            let extensions = extensionRegistry[fieldNumber]!
            let value = extensionMap[fieldNumber]!
            size += extensions.computeSerializedSizeIncludingTag(value)
        }
        return size
    }
    
}

public class ExtendableMessageBuilder:GeneratedMessageBuilder
{
    override public var internalGetResult:ExtendableMessage {
        get
        {
            NSException(name:"ImproperSubclassing", reason:"", userInfo: nil).raise()
            return ExtendableMessage()
        }
        
    }
    
//    override public var unknownFields:UnknownFieldSet {
//        get
//        {
//            return internalGetResult.unknownFields
//        }
//        set (fields)
//        {
//            return internalGetResult.unknownFields = fields
//        }
//        
//    }
    
    override public func checkInitialized()
    {
        let result = internalGetResult
        if (!result.isInitialized())
        {
            NSException(name:"UninitializedMessage", reason:"", userInfo: nil).raise()
        }
    }
    
    override public func checkInitializedParsed()
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
    
    override public func parseUnknownField(input:CodedInputStream ,unknownFields:UnknownFieldSetBuilder, extensionRegistry:ExtensionRegistry, tag:Int32) -> Bool {
        
        var message = internalGetResult
        var wireType = WireFormat.wireFormatGetTagWireType(tag);
        var fieldNumber:Int32 = WireFormat.wireFormatGetTagFieldNumber(tag)
        
        var extensions = extensionRegistry.getExtension(message.classMetaType(), fieldNumber: fieldNumber)
        
        if extensions != nil {
            if extensions!.wireType.rawValue == wireType {
                extensions!.mergeFromCodedInputStream(input, unknownFields:unknownFields, extensionRegistry:extensionRegistry, builder:self, tag:tag)
                return true
            }
        }
        return super.parseUnknownField(input, unknownFields: unknownFields, extensionRegistry: extensionRegistry, tag: tag)
    }
    public func getExtension(extensions:ConcreateExtensionField) -> ConcreateExtensionField
    {
        return internalGetResult.getExtension(extensions)
    }
    public func hasExtension(extensions:ConcreateExtensionField) -> Bool {
        return internalGetResult.hasExtension(extensions)
    }
    
    public func  setExtension(extensions:ConcreateExtensionField, value:Any) -> Self  {
        var message = internalGetResult
        message.ensureExtensionIsRegistered(extensions)
        if (extensions.isRepeated) {
            NSException(name:"IllegalArgument", reason:"Must call addExtension() for repeated types.", userInfo: nil).raise()
        }
        message.extensionMap[extensions.fieldNumber] = value
        return self
    }
    
    public func addExtension(extensions:ConcreateExtensionField, value:Any) -> ExtendableMessageBuilder {
        
        var message = internalGetResult
        message.ensureExtensionIsRegistered(extensions)
    
        if (!extensions.isRepeated) {
            NSException(name:"IllegalArgument", reason:"Must call setExtension() for singular types.", userInfo: nil).raise()
        }

        var fieldNumber = extensions.fieldNumber
        var list = message.extensionMap[fieldNumber] as Array<Any>!
        if list == nil {
            list = [Any]()
            message.extensionMap[fieldNumber] = list
        }
        list.append(value)
        return self;
    }
    
    public func setExtension(extensions:ConcreateExtensionField, index:Int32, value:Any) -> Self {
        var message = internalGetResult
        message.ensureExtensionIsRegistered(extensions)
        if (!extensions.isRepeated) {
             NSException(name:"IllegalArgument", reason:"Must call setExtension() for singular types.", userInfo: nil).raise()
        }
        var fieldNumber = extensions.fieldNumber
        var list = message.extensionMap[fieldNumber] as Array<Any>!
        if list == nil
        {
            list = [Any]()
            message.extensionMap[fieldNumber] = list
        }
        list[Int(index)] = value
        return self
    }
    
    public func  clearExtension(extensions:ConcreateExtensionField) -> Self {
        var message = internalGetResult
        message.ensureExtensionIsRegistered(extensions)
        message.extensionMap.removeValueForKey(extensions.fieldNumber)
        return self
    }
    public func mergeExtensionFields(other:ExtendableMessage) {
        var thisMessage = internalGetResult
        if (thisMessage !== other) {
            NSException(name:"IllegalArgument", reason:"Cannot merge extensions from a different type", userInfo: nil).raise()
        }
        
        if other.extensionMap.count > 0 {
            var registry = other.extensionRegistry
            for fieldNumber in other.extensionMap.keys {
                var thisField = registry[fieldNumber]!
                var value = other.extensionMap[fieldNumber]
                if thisField.isRepeated {
                    var list = thisMessage.extensionMap[fieldNumber] as Array<Any>!
                    if list == nil
                    {
                        list = [Any]()
                        thisMessage.extensionMap[fieldNumber] = list
                    }
                    list.append(value)
                }
                else {
                    thisMessage.extensionMap[fieldNumber] = value
                }
            }
        }
    }

}


