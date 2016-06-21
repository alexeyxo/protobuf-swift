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

public enum ExtensionType : Int32 {
    case extensionTypeBool
    case extensionTypeFixed32
    case extensionTypeSFixed32
    case extensionTypeFloat
    case extensionTypeFixed64
    case extensionTypeSFixed64
    case extensionTypeDouble
    case extensionTypeInt32
    case extensionTypeInt64
    case extensionTypeSInt32
    case extensionTypeSInt64
    case extensionTypeUInt32
    case extensionTypeUInt64
    case extensionTypeBytes
    case extensionTypeString
    case extensionTypeMessage
    case extensionTypeGroup
    case extensionTypeEnum
}

public func ==(lhs:ConcreateExtensionField, rhs:ConcreateExtensionField) -> Bool
{
    return true
}

final public class ConcreateExtensionField:ExtensionField,Equatable
{
    internal var type:ExtensionType
    public var fieldNumber:Int32
    public var extendedClass:AnyClassType
    public var messageOrGroupClass:Any.Type
    var defaultValue:Any
    var isRepeated:Bool = false
    var isPacked:Bool
    var isMessageSetWireFormat:Bool
    public var nameOfExtension:String
    {
        get
        {
            return extendedClass.className()
        }
        
    }

    
    public init(type:ExtensionType,
        extendedClass:AnyClassType,
        fieldNumber:Int32,
       defaultValue:Any,
messageOrGroupClass:Any.Type,
         isRepeated:Bool,
           isPacked:Bool,
        isMessageSetWireFormat:Bool)
    {
        self.type = type
        self.fieldNumber = fieldNumber
        self.extendedClass = extendedClass
        self.messageOrGroupClass = messageOrGroupClass
        self.defaultValue = defaultValue
        self.isRepeated = isRepeated
        self.isPacked = isPacked
        self.isMessageSetWireFormat = isMessageSetWireFormat
    }
    
    public var wireType:WireFormat
    {
        get {
            if (isPacked) {
                return WireFormat.lengthDelimited
            }
            switch type
            {
            case .extensionTypeBool:     return WireFormat.varint
            case .extensionTypeFixed32:  return WireFormat.fixed32
            case .extensionTypeSFixed32: return WireFormat.fixed32
            case .extensionTypeFloat:    return WireFormat.fixed32
            case .extensionTypeFixed64:  return WireFormat.fixed64
            case .extensionTypeSFixed64: return WireFormat.fixed64
            case .extensionTypeDouble:   return WireFormat.fixed64
            case .extensionTypeInt32:    return WireFormat.varint
            case .extensionTypeInt64:    return WireFormat.varint
            case .extensionTypeSInt32:   return WireFormat.varint
            case .extensionTypeSInt64:   return WireFormat.varint
            case .extensionTypeUInt32:   return WireFormat.varint
            case .extensionTypeUInt64:   return WireFormat.varint
            case .extensionTypeBytes:    return WireFormat.lengthDelimited
            case .extensionTypeString:   return WireFormat.lengthDelimited
            case .extensionTypeMessage:  return WireFormat.lengthDelimited
            case .extensionTypeGroup:    return WireFormat.startGroup
            case .extensionTypeEnum:     return WireFormat.varint
            }
        }
       
    }
    
    func typeIsPrimitive(_ type:ExtensionType) ->Bool
    {
        switch type {
        case .extensionTypeBool, .extensionTypeFixed32, .extensionTypeSFixed32, .extensionTypeFloat, .extensionTypeFixed64, .extensionTypeSFixed64, .extensionTypeDouble, .extensionTypeInt32, .extensionTypeInt64, .extensionTypeSInt32, .extensionTypeSInt64, .extensionTypeUInt32, .extensionTypeUInt64, .extensionTypeBytes, .extensionTypeString, .extensionTypeEnum:
            return true
        default:
            return false
            
        }

    }
    
    func typeIsFixedSize(_ type:ExtensionType) -> Bool
    {
        switch (type) {
            case .extensionTypeBool,.extensionTypeFixed32,.extensionTypeSFixed32,.extensionTypeFloat,.extensionTypeFixed64,.extensionTypeSFixed64,.extensionTypeDouble: return true
            default:
                return false
        }
    }
    
    
    func typeSize(_ type:ExtensionType) -> Int32
    {
        switch type {
            case .extensionTypeBool: return 1
            case .extensionTypeFixed32, .extensionTypeSFixed32, .extensionTypeFloat: return 4
            case .extensionTypeFixed64,.extensionTypeSFixed64, .extensionTypeDouble: return 8
            default:
                return 0
        }
    }
    
    func  writeSingleValueIncludingTag(_ value:Any, output:CodedOutputStream) throws
    {
        switch type {

        case .extensionTypeBool:
            let downCastValue = value as! Bool
            try output.writeBool(fieldNumber, value:downCastValue)
        
        case .extensionTypeFixed32:
            let downCastValue = value as! UInt32
            try output.writeFixed32(fieldNumber, value:downCastValue)
        
        case .extensionTypeSFixed32:
             let downCastValue = value as! Int32
            try output.writeSFixed32(fieldNumber, value:downCastValue)
        
        case .extensionTypeFixed64:
            let downCastValue = value as! UInt64
            try output.writeFixed64(fieldNumber, value:downCastValue)
        
        case .extensionTypeSFixed64:
            let downCastValue = value as! Int64
            try output.writeSFixed64(fieldNumber, value:downCastValue)
        
        case .extensionTypeDouble:
            let downCastValue = value as! Double
            try output.writeDouble(fieldNumber, value:downCastValue)
        
        case .extensionTypeFloat:
            let downCastValue = value as! Float
            try output.writeFloat(fieldNumber, value:downCastValue)
       
        case .extensionTypeInt32:
            let downCastValue = value as! Int32
            try output.writeInt32(fieldNumber, value:downCastValue)
        
        case .extensionTypeInt64:
            let downCastValue = value as! Int64
            try output.writeInt64(fieldNumber, value:downCastValue)
        
        case .extensionTypeSInt32:
            let downCastValue = value as! Int32
            try output.writeSInt32(fieldNumber, value:downCastValue)
        
        case .extensionTypeSInt64:
            let downCastValue = value as! Int64
            try output.writeSInt64(fieldNumber, value:downCastValue)
        
        case .extensionTypeUInt32:
            let downCastValue = value as! UInt32
            try output.writeUInt32(fieldNumber, value:downCastValue)
        
        case .extensionTypeUInt64:
            let downCastValue = value as! UInt64
            try output.writeUInt64(fieldNumber, value:downCastValue)
        
        case .extensionTypeBytes:
            let downCastValue = value as! Data
            try output.writeData(fieldNumber, value:downCastValue)
        
        case .extensionTypeString:
            let downCastValue = value as! String
            try output.writeString(fieldNumber, value:downCastValue)
        
        case .extensionTypeEnum:
            let downCastValue = value as! Int32
            try output.writeEnum(fieldNumber, value:downCastValue)
        
        case .extensionTypeGroup:
            let downCastValue = value as! GeneratedMessage
            try output.writeGroup(fieldNumber, value:downCastValue)
        
        case .extensionTypeMessage where isMessageSetWireFormat == true:
            let downCastValue = value as! GeneratedMessage
            try output.writeMessageSetExtension(fieldNumber, value:downCastValue)
        
        case .extensionTypeMessage where isMessageSetWireFormat == false:
            let downCastValue = value as! GeneratedMessage
            try output.writeMessage(fieldNumber, value:downCastValue)
        
        default:
             throw ProtocolBuffersError.invalidProtocolBuffer("Invalid Extensions Type")
        }
    }
    
    func  writeSingleValueNoTag(_ value:Any, output:CodedOutputStream) throws
    {
        switch type {

        case .extensionTypeBool:
            let downCastValue = value as! Bool
            try output.writeBoolNoTag(downCastValue)
            
        case .extensionTypeFixed32:
            let downCastValue = value as! UInt32
            try output.writeFixed32NoTag(downCastValue)
        
        case .extensionTypeSFixed32:
            let downCastValue = value as! Int32
            try output.writeSFixed32NoTag(downCastValue)
        
        case .extensionTypeInt32:
            let downCastValue = value as! Int32
            try output.writeInt32NoTag(downCastValue)
            
        case .extensionTypeSInt32:
            let downCastValue = value as! Int32
            try output.writeSInt32NoTag(downCastValue)
            
        case .extensionTypeEnum:
            let downCastValue = value as! Int32
            try output.writeEnumNoTag(downCastValue)
            
        case .extensionTypeFixed64:
            let downCastValue = value as! UInt64
            try output.writeFixed64NoTag(downCastValue)
            
        case .extensionTypeInt64:
            let downCastValue = value as! Int64
            try output.writeInt64NoTag(downCastValue)
            
        case .extensionTypeSInt64:
            let downCastValue = value as! Int64
            try output.writeSInt64NoTag(downCastValue)
        
        case .extensionTypeSFixed64:
            let downCastValue = value as! Int64
            try output.writeSFixed64NoTag(downCastValue)
            
        case .extensionTypeDouble:
            let downCastValue = value as! Double
            try output.writeDoubleNoTag(downCastValue)
            
        case .extensionTypeFloat:
            let downCastValue = value as! Float
            try output.writeFloatNoTag(downCastValue)

        case .extensionTypeUInt32:
            let downCastValue = value as! UInt32
            try output.writeUInt32NoTag(downCastValue)
        
        case .extensionTypeUInt64:
            let downCastValue = value as! UInt64
            try output.writeUInt64NoTag(downCastValue)
        
        case .extensionTypeBytes:
            let downCastValue = value as! Data
            try output.writeDataNoTag(downCastValue)

        case .extensionTypeString:
            let downCastValue = value as! String
            try output.writeStringNoTag(downCastValue)
        
        case .extensionTypeGroup:
            let downCastValue = value as! GeneratedMessage
            try output.writeGroupNoTag(fieldNumber, value:downCastValue)

        case .extensionTypeMessage:
            let downCastValue = value as! GeneratedMessage
            try output.writeMessageNoTag(downCastValue)

        }
    }
    
    func  computeSingleSerializedSizeIncludingTag(_ value:Any) -> Int32
    {
        switch type {
        
        case .extensionTypeFixed32:
            let downCastValue = value as! UInt32
            return downCastValue.computeFixed32Size(fieldNumber)
            
        case .extensionTypeSFixed32:
            let downCastValue = value as! Int32
            return downCastValue.computeSFixed32Size(fieldNumber)
            
        case .extensionTypeSInt32:
            let downCastValue = value as! Int32
            return downCastValue.computeSInt32Size(fieldNumber)
            
        case .extensionTypeInt32:
            let downCastValue = value as! Int32
            return downCastValue.computeInt32Size(fieldNumber)
            
        case .extensionTypeEnum:
            let downCastValue = value as! Int32
            return downCastValue.computeEnumSize(fieldNumber)
            
        case .extensionTypeFixed64:
            let downCastValue = value as! UInt64
            return downCastValue.computeFixed64Size(fieldNumber)
            
        case .extensionTypeSFixed64:
            let downCastValue = value as! Int64
            return downCastValue.computeSFixed64Size(fieldNumber)

        case .extensionTypeInt64:
            let downCastValue = value as! Int64
            return downCastValue.computeInt64Size(fieldNumber)
            
        case .extensionTypeSInt64:
            let downCastValue = value as! Int64
            return downCastValue.computeSInt64Size(fieldNumber)
            
        case .extensionTypeFloat:
            let downCastValue = value as! Float
            return downCastValue.computeFloatSize(fieldNumber)
            
        case .extensionTypeDouble:
            let downCastValue = value as! Double
             return downCastValue.computeDoubleSize(fieldNumber)
            
        case .extensionTypeUInt32:
            let downCastValue = value as! UInt32
            return downCastValue.computeUInt32Size(fieldNumber)
            
        case .extensionTypeUInt64:
            let downCastValue = value as! UInt64
           return downCastValue.computeUInt64Size(fieldNumber)
            
        case .extensionTypeBytes:
            let downCastValue = value as! Data
            return downCastValue.computeDataSize(fieldNumber)
            
        case .extensionTypeString:
            let downCastValue = value as! String
            return downCastValue.computeStringSize(fieldNumber)
            
        case .extensionTypeGroup:
            let downCastValue = value as! GeneratedMessage
            return downCastValue.computeGroupSize(fieldNumber)
            
        case .extensionTypeMessage where isMessageSetWireFormat == true:
            let downCastValue = value as! GeneratedMessage
            return downCastValue.computeMessageSetExtensionSize(fieldNumber)
            
        case .extensionTypeMessage where isMessageSetWireFormat == false:
            let downCastValue = value as! GeneratedMessage
            return downCastValue.computeMessageSize(fieldNumber)
        case .extensionTypeBool:
            let downCastValue = value as! Bool
            return downCastValue.computeBoolSize(fieldNumber)
        default:
            return 0
        }
    }
    
    func  computeSingleSerializedSizeNoTag(_ value:Any) -> Int32
    {
        switch type {

        case .extensionTypeBool:
            let downCastValue = value as! Bool
            return downCastValue.computeBoolSizeNoTag()
            
        case .extensionTypeFixed32:
            let downCastValue = value as! UInt32
            return downCastValue.computeFixed32SizeNoTag()
            
        case .extensionTypeSFixed32:
            let downCastValue = value as! Int32
            return downCastValue.computeSFixed32SizeNoTag()
        
        case .extensionTypeInt32:
            let downCastValue = value as! Int32
            return downCastValue.computeInt32SizeNoTag()
        
        case .extensionTypeSInt32:
            let downCastValue = value as! Int32
            return downCastValue.computeSInt32SizeNoTag()
            
        case .extensionTypeEnum:
            let downCastValue = value as! Int32
            return downCastValue.computeEnumSizeNoTag()
            
        case .extensionTypeFixed64:
            let downCastValue = value as! UInt64
            return downCastValue.computeFixed64SizeNoTag()
            
        case .extensionTypeSFixed64:
            let downCastValue = value as! Int64
            return downCastValue.computeSFixed64SizeNoTag()
        
        case .extensionTypeInt64:
            let downCastValue = value as! Int64
            return downCastValue.computeInt64SizeNoTag()
            
        case .extensionTypeSInt64:
            let downCastValue = value as! Int64
            return downCastValue.computeSInt64SizeNoTag()
            
        case .extensionTypeFloat:
            let downCastValue = value as! Float
            return downCastValue.computeFloatSizeNoTag()
            
        case .extensionTypeDouble:
            let downCastValue = value as! Double
            return downCastValue.computeDoubleSizeNoTag()
            
        case .extensionTypeUInt32:
            let downCastValue = value as! UInt32
            return downCastValue.computeUInt32SizeNoTag()
            
        case .extensionTypeUInt64:
            let downCastValue = value as! UInt64
            return downCastValue.computeUInt64SizeNoTag()
            
        case .extensionTypeBytes:
            let downCastValue = value as! Data
            return downCastValue.computeDataSizeNoTag()
            
        case .extensionTypeString:
            let downCastValue = value as! String
            return downCastValue.computeStringSizeNoTag()
            
        case .extensionTypeGroup:
            let downCastValue = value as! GeneratedMessage
            return downCastValue.computeGroupSizeNoTag()
            
        case .extensionTypeMessage:
            let downCastValue = value as! GeneratedMessage
            return downCastValue.computeMessageSizeNoTag()
        }
    }
    
    func writeDescriptionOfSingleValue(_ value:Any, indent:String) throws -> String
    {
        var output = ""
        if typeIsPrimitive(type) {
            output += "\(indent)\(value)\n"
        }
        else if let values = value as? GeneratedMessage {
            output += try values.getDescription(indent)
        }
        else {
            throw ProtocolBuffersError.invalidProtocolBuffer("Invalid Extensions Type")
        }
        return output
    }
    
    func writeRepeatedValuesIncludingTags<T>(_ values:Array<T>, output:CodedOutputStream) throws {
        if (isPacked) {
            try output.writeTag(fieldNumber, format: WireFormat.lengthDelimited)
            var dataSize:Int32 = 0
            
            if (typeIsFixedSize(type))
            {
                dataSize = Int32(values.count) * typeSize(type)
            }
            else
            {
                for value in values
                {
                    dataSize += computeSingleSerializedSizeNoTag(value)
                }
            }
            try output.writeRawVarint32(dataSize)
            for value in values
            {
                try writeSingleValueNoTag(value, output: output)
            }
            
        }
        else
        {
            for value in values
            {
               try writeSingleValueIncludingTag(value, output: output)
            }
        }
    }
    
    func computeRepeatedSerializedSizeIncludingTags<T>(_ values:Array<T>) -> Int32
    {
        if (isPacked) {
            var size:Int32 = 0
            if (typeIsFixedSize(type)) {
                size = Int32(values.count) * typeSize(type)
            }
            else
            {
                for value in values
                {
                    size += computeSingleSerializedSizeNoTag(value)
                }
            }
            return size + fieldNumber.computeTagSize() + size.computeRawVarint32Size()

        }
        else
        {
            var size:Int32 = 0
            for value in values
            {
                size += computeSingleSerializedSizeIncludingTag(value)
            }
            return size
        }
    }
    
    public func computeSerializedSizeIncludingTag(_ value:Any) -> Int32
    {
        if isRepeated
        {
            switch value
            {
            case let values as [Int32]:
                return computeRepeatedSerializedSizeIncludingTags(values)
            case let values as [Int64]:
                return computeRepeatedSerializedSizeIncludingTags(values)
            case let values as [UInt64]:
                return computeRepeatedSerializedSizeIncludingTags(values)
            case let values as [UInt32]:
                return computeRepeatedSerializedSizeIncludingTags(values)
            case let values as [Float]:
                return computeRepeatedSerializedSizeIncludingTags(values)
            case let values as [Double]:
                return computeRepeatedSerializedSizeIncludingTags(values)
            case let values as [Bool]:
                return computeRepeatedSerializedSizeIncludingTags(values)
            case let values as [String]:
                return computeRepeatedSerializedSizeIncludingTags(values)
            case let values as Array<Data>:
                return computeRepeatedSerializedSizeIncludingTags(values)
            case let values as [GeneratedMessage]:
                return computeRepeatedSerializedSizeIncludingTags(values)
            default:
                return 0
            }
        }
        else
        {
            return computeSingleSerializedSizeIncludingTag(value)
        }
    }

    
    public func writeValueIncludingTagToCodedOutputStream(_ value:Any, output:CodedOutputStream) throws
    {
        
        if isRepeated
        {
            switch value
            {
            case let values as [Int32]:
                try writeRepeatedValuesIncludingTags(values, output:output)
            case let values as [Int64]:
                try writeRepeatedValuesIncludingTags(values, output:output)
            case let values as [UInt64]:
                try writeRepeatedValuesIncludingTags(values, output:output)
            case let values as [UInt32]:
                try writeRepeatedValuesIncludingTags(values, output:output)
            case let values as [Bool]:
                try writeRepeatedValuesIncludingTags(values, output:output)
            case let values as [Float]:
                try writeRepeatedValuesIncludingTags(values, output:output)
            case let values as [Double]:
                try writeRepeatedValuesIncludingTags(values, output:output)
            case let values as [String]:
                try writeRepeatedValuesIncludingTags(values, output:output)
            case let values as Array<Data>:
                try writeRepeatedValuesIncludingTags(values, output:output)
            case let values as [GeneratedMessage]:
                try writeRepeatedValuesIncludingTags(values, output:output)
            default:
                break
            }
            
        }
        else
        {
            try writeSingleValueIncludingTag(value, output:output)
        }
    }
    
    private func iterationRepetedValuesForDescription<T>(_ values:Array<T>, indent:String) throws -> String
    {
        var output = ""
        for singleValue in values
        {
            output += try writeDescriptionOfSingleValue(singleValue, indent: indent)
        }
        return output
    }
    
    public func getDescription(_ value:Any, indent:String) throws -> String
    {
  
        var output = ""
        if isRepeated
        {
            switch value
            {
            case let values as [Int32]:
                output += try iterationRepetedValuesForDescription(values, indent: indent)
            case let values as [Int64]:
                output += try iterationRepetedValuesForDescription(values, indent: indent)
            case let values as [UInt64]:
                output += try iterationRepetedValuesForDescription(values, indent: indent)
            case let values as [UInt32]:
                output += try iterationRepetedValuesForDescription(values, indent: indent)
            case let values as [Bool]:
                output += try iterationRepetedValuesForDescription(values, indent: indent)
            case let values as [Float]:
                output += try iterationRepetedValuesForDescription(values, indent: indent)
            case let values as [Double]:
                output += try iterationRepetedValuesForDescription(values, indent: indent)
            case let values as [String]:
                output += try iterationRepetedValuesForDescription(values, indent: indent)
            case let values as Array<Data>:
                output += try iterationRepetedValuesForDescription(values, indent: indent)
            case let values as [GeneratedMessage]:
                output += try iterationRepetedValuesForDescription(values, indent: indent)
            default:
                break
            }

        }
        else
        {
            output += try writeDescriptionOfSingleValue(value, indent:indent)
        }
        return output
    }
    
  
    
    func mergeMessageSetExtentionFromCodedInputStream(_ input:CodedInputStream, unknownFields:UnknownFieldSet.Builder) throws
    {
         throw ProtocolBuffersError.illegalState("Method Not Supported")
    }
    
    func readSingleValueFromCodedInputStream(_ input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Any
    {
        switch type {
        case .extensionTypeBool:
            return try input.readBool()
        case .extensionTypeFixed32:
            return try input.readFixed32()
        case .extensionTypeSFixed32:
            return try input.readSFixed32()
        case .extensionTypeFixed64:
            return try input.readFixed64()
        case .extensionTypeSFixed64:
            return try input.readSFixed64()
        case .extensionTypeFloat:
            return try input.readFloat()
        case .extensionTypeDouble:
            return try input.readDouble()
        case .extensionTypeInt32:
            return try input.readInt32()
        case .extensionTypeInt64:
            return try input.readInt64()
        case .extensionTypeSInt32:
            return try input.readSInt32()
        case .extensionTypeSInt64:
            return try input.readSInt64()
        case .extensionTypeUInt32:
            return try input.readUInt32()
        case .extensionTypeUInt64:
            return try input.readUInt64()
        case .extensionTypeBytes:
            return try input.readData()
        case .extensionTypeString:
            return try input.readString()
        case .extensionTypeEnum:
            return try input.readEnum()
        case .extensionTypeGroup:
            if let mg = messageOrGroupClass as? GeneratedMessage.Type
            {
                let buider = mg.classBuilder()
                try input.readGroup(fieldNumber, builder: buider, extensionRegistry: extensionRegistry)
                let mes = try buider.build()
                return mes
            }
        case .extensionTypeMessage:
            if let mg = messageOrGroupClass as? GeneratedMessage.Type
            {
                let buider = mg.classBuilder()
                try input.readMessage(buider, extensionRegistry: extensionRegistry)
                let mes = try buider.build()
                return mes
            }
        }
        return ""
    }
    
    public func mergeFromCodedInputStream(_ input:CodedInputStream, unknownFields:UnknownFieldSet.Builder, extensionRegistry:ExtensionRegistry, builder:ExtendableMessageBuilder, tag:Int32) throws {
        if (isPacked) {
            let length:Int32 = try input.readRawVarint32()
            let limit:Int32 = try input.pushLimit(length)
            while (input.bytesUntilLimit() > 0) {
                let value = try readSingleValueFromCodedInputStream(input, extensionRegistry:extensionRegistry)
                try builder.addExtension(self, value:value)
            }
            input.popLimit(limit)
        }
        else if isMessageSetWireFormat
        {
            try mergeMessageSetExtentionFromCodedInputStream(input, unknownFields:unknownFields)
        }
        else
        {
            let value = try readSingleValueFromCodedInputStream(input, extensionRegistry:extensionRegistry)
            if (isRepeated) {
                try builder.addExtension(self, value:value)
            } else {
                try builder.setExtension(self, value:value)
            }
        }
    }
    

}
