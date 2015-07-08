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
    override public func className() -> String
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
        switch object
        {
        case let array as Array<Any>:
            for child in array
            {
                if (!isInitialized(child))
                {
                    return false
                }
            }
        case let array as Array<GeneratedMessage>:
            for child in array
            {
                if (!isInitialized(child))
                {
                    return false
                }
            }
        case let message as GeneratedMessage:
            return message.isInitialized()
        default:
            return true
        }
        
        return true
    }
    
    public func extensionsAreInitialized() -> Bool {
        let arr = Array(extensionMap.values)
        return isInitialized(arr)
    }
    
    internal func ensureExtensionIsRegistered(extensions:ConcreateExtensionField)
    {

        extensionRegistry[extensions.fieldNumber] = extensions
    }
    
    public func getExtension(extensions:ConcreateExtensionField) -> Any
    {
        ensureExtensionIsRegistered(extensions)
        if let value = extensionMap[extensions.fieldNumber]
        {
            return value
        }
        return extensions.defaultValue
    }
    public func hasExtension(extensions:ConcreateExtensionField) -> Bool
    {
        guard (extensionMap[extensions.fieldNumber] != nil) else
        {
            return false
        }
        return true
    }
    public func writeExtensionsToCodedOutputStream(output:CodedOutputStream, startInclusive:Int32, endExclusive:Int32) throws
    {
        var keys = Array(extensionMap.keys)
        keys.sortInPlace { $0 < $1 }
        for fieldNumber in keys {
            if (fieldNumber >= startInclusive && fieldNumber < endExclusive) {
                let extensions = extensionRegistry[fieldNumber]!
                let value = extensionMap[fieldNumber]!
                try extensions.writeValueIncludingTagToCodedOutputStream(value, output: output)
            }
        }
    }
    
    public func writeExtensionDescription(inout output:String, startInclusive:Int32 ,endExclusive:Int32, indent:String) throws {
        var keys = Array(extensionMap.keys)
        keys.sortInPlace { $0 < $1 }
        for fieldNumber in keys {
            if (fieldNumber >= startInclusive && fieldNumber < endExclusive) {
                let extensions = extensionRegistry[fieldNumber]!
                let value = extensionMap[fieldNumber]!
                try extensions.writeDescriptionOf(value, output: &output, indent: indent)
                
            }
            
        }
    }
    
    public func isEqualExtensionsInOther(otherMessage:ExtendableMessage, startInclusive:Int32, endExclusive:Int32) -> Bool {

        var keys = Array(extensionMap.keys)
        keys.sortInPlace { $0 < $1 }
        for fieldNumber in keys {
            if (fieldNumber >= startInclusive && fieldNumber < endExclusive) {
                let value = extensionMap[fieldNumber]!
                let otherValue = otherMessage.extensionMap[fieldNumber]!
                return compare(value, rhs: otherValue)
            }
        }
        return true
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
        case (let value as NSData, let value2 as NSData):
            return value == value2
        case (let value as UInt32, let value2 as UInt32):
            return value == value2
        case (let value as UInt64, let value2 as UInt64):
            return value == value2
        case (let value as GeneratedMessage, let value2 as GeneratedMessage):
            return value == value2
        case (let value as [Int32], let value2 as [Int32]):
            return value == value2
        case (let value as [Int64], let value2 as [Int64]):
            return value == value2
        case (let value as [Double], let value2 as [Double]):
            return value == value2
        case (let value as [Float], let value2 as [Float]):
            return value == value2
        case (let value as [Bool], let value2 as [Bool]):
            return value == value2
        case (let value as [String], let value2 as [String]):
            return value == value2
        case (let value as Array<NSData>, let value2 as Array<NSData>):
            return value == value2
        case (let value as [UInt32], let value2 as [UInt32]):
            return value == value2
        case (let value as [UInt64], let value2 as [UInt64]):
            return value == value2
        case (let value as [GeneratedMessage], let value2 as [GeneratedMessage]):
            return value == value2
        default:
            return false
        }
    }
    
    private func getHash<T>(lhs:T) -> Int!
    {
        switch lhs
        {
        case let value as Int32:
            return getHashValue(value)
        case let value as Int64:
            return getHashValue(value)
        case let value as UInt32:
            return getHashValue(value)
        case let value as UInt64:
            return getHashValue(value)
        case let value as Float:
            return getHashValue(value)
        case let value as Double:
            return getHashValue(value)
        case let value as Bool:
            return getHashValue(value)
        case let value as String:
            return getHashValue(value)
        case let value as GeneratedMessage:
            return getHashValue(value)
        case let value as NSData:
            return value.hashValue
        case let value as [Int32]:
            return getHashValueRepeated(value)
        case let value as [Int64]:
            return getHashValueRepeated(value)
        case let value as [UInt32]:
            return getHashValueRepeated(value)
        case let value as [UInt64]:
            return getHashValueRepeated(value)
        case let value as [Float]:
            return getHashValueRepeated(value)
        case let value as [Double]:
            return getHashValueRepeated(value)
        case let value as [Bool]:
            return getHashValueRepeated(value)
        case let value as [String]:
            return getHashValueRepeated(value)
        case let value as Array<NSData>:
            return getHashValueRepeated(value)
        case let value as [GeneratedMessage]:
            return getHashValueRepeated(value)
        default:
            return nil
        }
    }

    private func getHashValueRepeated<T where T:CollectionType, T.Generator.Element:protocol<Hashable,Equatable>>(lhs:T) -> Int!
    {
        var hashCode:Int = 0
        for vv in lhs
        {
            hashCode = (hashCode &* 31) &+ vv.hashValue
        }
        return hashCode
    }
    
    private func getHashValue<T where T:protocol<Hashable,Equatable>>(lhs:T) -> Int!
    {
        return lhs.hashValue
    }
    
    public func hashExtensionsFrom(startInclusive:Int32, endExclusive:Int32) -> Int {
        var hashCode:Int = 0
        var keys = Array(extensionMap.keys)
        keys.sortInPlace { $0 < $1 }
        for fieldNumber in keys {
            if (fieldNumber >= startInclusive && fieldNumber < endExclusive) {
                let value = extensionMap[fieldNumber]!
                hashCode = (hashCode &* 31) &+ getHash(value)!

            }
        }
        return hashCode
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
            return ExtendableMessage()
        }
        
    }
    
    
    override public func checkInitialized() throws
    {
        let result = internalGetResult
        if (!result.isInitialized())
        {
            throw ProtocolBuffersError.InvalidProtocolBuffer("Uninitialized Message")
        }
    }
    
    override public func checkInitializedParsed() throws
    {
        let result = internalGetResult
        if (!result.isInitialized())
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
    
    override public func parseUnknownField(input:CodedInputStream ,unknownFields:UnknownFieldSet.Builder, extensionRegistry:ExtensionRegistry, tag:Int32) throws -> Bool {
        
        let message = internalGetResult
        let wireType = WireFormat.getTagWireType(tag)
        let fieldNumber:Int32 = WireFormat.getTagFieldNumber(tag)
        
        let extensions = extensionRegistry.getExtension(message.classMetaType(), fieldNumber: fieldNumber)
        
        if extensions != nil {
            if extensions!.wireType.rawValue == wireType {
                try extensions!.mergeFromCodedInputStream(input, unknownFields:unknownFields, extensionRegistry:extensionRegistry, builder:self, tag:tag)
                return true
            }
        }
        return try super.parseUnknownField(input, unknownFields: unknownFields, extensionRegistry: extensionRegistry, tag: tag)
    }
    public func getExtension(extensions:ConcreateExtensionField) -> Any
    {
        return internalGetResult.getExtension(extensions)
    }
    public func hasExtension(extensions:ConcreateExtensionField) -> Bool {
        return internalGetResult.hasExtension(extensions)
    }
    
    public func  setExtension(extensions:ConcreateExtensionField, value:Any) throws -> Self  {
        let message = internalGetResult
        message.ensureExtensionIsRegistered(extensions)
        guard !extensions.isRepeated  else {
            throw ProtocolBuffersError.IllegalArgument("Must call addExtension() for repeated types.")
        }
        message.extensionMap[extensions.fieldNumber] = value
        return self
    }
    
    public func addExtension<T>(extensions:ConcreateExtensionField, value:T) throws -> ExtendableMessageBuilder {
        
        let message = internalGetResult
        message.ensureExtensionIsRegistered(extensions)
        
        guard extensions.isRepeated else
        {
            throw ProtocolBuffersError.IllegalArgument("Must call addExtension() for repeated types.")
        }        
        let fieldNumber = extensions.fieldNumber
        if let val = value as? GeneratedMessage
        {
            var list:[GeneratedMessage]! = message.extensionMap[fieldNumber] as? [GeneratedMessage] ?? []
            list.append(val)
            message.extensionMap[fieldNumber] = list
        }
        else
        {
            var list:[T]! = message.extensionMap[fieldNumber] as? [T] ?? []
            list.append(value)
            message.extensionMap[fieldNumber] = list
        }
        
        return self
    }
    
    public func setExtension<T>(extensions:ConcreateExtensionField, index:Int32, value:T) throws -> Self {
        let message = internalGetResult
        message.ensureExtensionIsRegistered(extensions)
        guard extensions.isRepeated else {
            throw ProtocolBuffersError.IllegalArgument("Must call setExtension() for singular types.")
        }
        let fieldNumber = extensions.fieldNumber
        if let val = value as? GeneratedMessage
        {
            var list:[GeneratedMessage]! = message.extensionMap[fieldNumber] as? [GeneratedMessage] ?? []
            list[Int(index)] = val
            message.extensionMap[fieldNumber] = list
        }
        else
        {
            var list:[T]! = message.extensionMap[fieldNumber] as? [T] ?? []
            list[Int(index)] = value
            message.extensionMap[fieldNumber] = list
        }
        return self
    }

    
    public func  clearExtension(extensions:ConcreateExtensionField) -> Self {
        let message = internalGetResult
        message.ensureExtensionIsRegistered(extensions)
        message.extensionMap.removeValueForKey(extensions.fieldNumber)
        return self
    }

    private func mergeRepeatedExtensionFields<T where T:CollectionType>(otherList:T, var extensionMap:[Int32:Any], fieldNumber:Int32) -> [T.Generator.Element]
    {
        var list:[T.Generator.Element]! = extensionMap[fieldNumber] as? [T.Generator.Element] ?? []
        list! += otherList
        return list!

    }
    
    public func mergeExtensionFields(other:ExtendableMessage) throws {
        let thisMessage = internalGetResult
        guard thisMessage.className() == other.className() else {
            throw ProtocolBuffersError.IllegalArgument("Cannot merge extensions from a different type")
        }
        if other.extensionMap.count > 0 {
            var registry = other.extensionRegistry
            for fieldNumber in other.extensionMap.keys {
                let thisField = registry[fieldNumber]!
                
                let value = other.extensionMap[fieldNumber]!
                if thisField.isRepeated {
                    switch value
                    {
                    case let values as [Int32]:
                        thisMessage.extensionMap[fieldNumber] = mergeRepeatedExtensionFields(values, extensionMap: thisMessage.extensionMap, fieldNumber: fieldNumber)
                    case let values as [Int64]:
                        thisMessage.extensionMap[fieldNumber] = mergeRepeatedExtensionFields(values, extensionMap: thisMessage.extensionMap, fieldNumber: fieldNumber)
                    case let values as [UInt64]:
                        thisMessage.extensionMap[fieldNumber] = mergeRepeatedExtensionFields(values, extensionMap: thisMessage.extensionMap, fieldNumber: fieldNumber)
                    case let values as [UInt32]:
                        thisMessage.extensionMap[fieldNumber] = mergeRepeatedExtensionFields(values, extensionMap: thisMessage.extensionMap, fieldNumber: fieldNumber)
                    case let values as [Bool]:
                        thisMessage.extensionMap[fieldNumber] = mergeRepeatedExtensionFields(values, extensionMap: thisMessage.extensionMap, fieldNumber: fieldNumber)
                    case let values as [Float]:
                        thisMessage.extensionMap[fieldNumber] = mergeRepeatedExtensionFields(values, extensionMap: thisMessage.extensionMap, fieldNumber: fieldNumber)
                    case let values as [Double]:
                        thisMessage.extensionMap[fieldNumber] = mergeRepeatedExtensionFields(values, extensionMap: thisMessage.extensionMap, fieldNumber: fieldNumber)
                    case let values as [String]:
                        thisMessage.extensionMap[fieldNumber] = mergeRepeatedExtensionFields(values, extensionMap: thisMessage.extensionMap, fieldNumber: fieldNumber)
                    case let values as Array<NSData>:
                        thisMessage.extensionMap[fieldNumber] = mergeRepeatedExtensionFields(values, extensionMap: thisMessage.extensionMap, fieldNumber: fieldNumber)
                    case let values as [GeneratedMessage]:
                        thisMessage.extensionMap[fieldNumber] = mergeRepeatedExtensionFields(values, extensionMap: thisMessage.extensionMap, fieldNumber: fieldNumber)
                    default:
                        break
                    }
                }
                else
                {
                    thisMessage.extensionMap[fieldNumber] = value
                }
                
            }
        }
    }

}


