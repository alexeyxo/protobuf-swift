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
    case ExtensionTypeBool
    case ExtensionTypeFixed32
    case ExtensionTypeSFixed32
    case ExtensionTypeFloat
    case ExtensionTypeFixed64
    case ExtensionTypeSFixed64
    case ExtensionTypeDouble
    case ExtensionTypeInt32
    case ExtensionTypeInt64
    case ExtensionTypeSInt32
    case ExtensionTypeSInt64
    case ExtensionTypeUInt32
    case ExtensionTypeUInt64
    case ExtensionTypeBytes
    case ExtensionTypeString
    case ExtensionTypeMessage
    case ExtensionTypeGroup
    case ExtensionTypeEnum
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
                return WireFormat.LengthDelimited
            }
            switch type
            {
            case .ExtensionTypeBool:     return WireFormat.Varint
            case .ExtensionTypeFixed32:  return WireFormat.Fixed32
            case .ExtensionTypeSFixed32: return WireFormat.Fixed32
            case .ExtensionTypeFloat:    return WireFormat.Fixed32
            case .ExtensionTypeFixed64:  return WireFormat.Fixed64
            case .ExtensionTypeSFixed64: return WireFormat.Fixed64
            case .ExtensionTypeDouble:   return WireFormat.Fixed64
            case .ExtensionTypeInt32:    return WireFormat.Varint
            case .ExtensionTypeInt64:    return WireFormat.Varint
            case .ExtensionTypeSInt32:   return WireFormat.Varint
            case .ExtensionTypeSInt64:   return WireFormat.Varint
            case .ExtensionTypeUInt32:   return WireFormat.Varint
            case .ExtensionTypeUInt64:   return WireFormat.Varint
            case .ExtensionTypeBytes:    return WireFormat.LengthDelimited
            case .ExtensionTypeString:   return WireFormat.LengthDelimited
            case .ExtensionTypeMessage:  return WireFormat.LengthDelimited
            case .ExtensionTypeGroup:    return WireFormat.StartGroup
            case .ExtensionTypeEnum:     return WireFormat.Varint
            }
        }
       
    }
    
    func typeIsPrimitive(type:ExtensionType) ->Bool
    {
        switch type {
        case .ExtensionTypeBool, .ExtensionTypeFixed32, .ExtensionTypeSFixed32, .ExtensionTypeFloat, .ExtensionTypeFixed64, .ExtensionTypeSFixed64, .ExtensionTypeDouble, .ExtensionTypeInt32, .ExtensionTypeInt64, .ExtensionTypeSInt32, .ExtensionTypeSInt64, .ExtensionTypeUInt32, .ExtensionTypeUInt64, .ExtensionTypeBytes, .ExtensionTypeString, .ExtensionTypeEnum:
            return true
        default:
            return false
            
        }

    }
    
    func typeIsFixedSize(type:ExtensionType) -> Bool
    {
        switch (type) {
            case .ExtensionTypeBool,.ExtensionTypeFixed32,.ExtensionTypeSFixed32,.ExtensionTypeFloat,.ExtensionTypeFixed64,.ExtensionTypeSFixed64,.ExtensionTypeDouble: return true
            default:
                return false
        }
    }
    
    
    func typeSize(type:ExtensionType) -> Int32
    {
        switch type {
            case .ExtensionTypeBool: return 1
            case .ExtensionTypeFixed32, .ExtensionTypeSFixed32, .ExtensionTypeFloat: return 4
            case .ExtensionTypeFixed64,.ExtensionTypeSFixed64, .ExtensionTypeDouble: return 8
            default:
                return 0
        }
    }
    
    func  writeSingleValueIncludingTag(value:Any, output:CodedOutputStream) throws
    {
        switch type {

        case .ExtensionTypeBool:
            let downCastValue = value as! Bool
            try output.writeBool(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeFixed32:
            let downCastValue = value as! UInt32
            try output.writeFixed32(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeSFixed32:
             let downCastValue = value as! Int32
            try output.writeSFixed32(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeFixed64:
            let downCastValue = value as! UInt64
            try output.writeFixed64(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeSFixed64:
            let downCastValue = value as! Int64
            try output.writeSFixed64(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeDouble:
            let downCastValue = value as! Double
            try output.writeDouble(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeFloat:
            let downCastValue = value as! Float
            try output.writeFloat(fieldNumber, value:downCastValue)
       
        case .ExtensionTypeInt32:
            let downCastValue = value as! Int32
            try output.writeInt32(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeInt64:
            let downCastValue = value as! Int64
            try output.writeInt64(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeSInt32:
            let downCastValue = value as! Int32
            try output.writeSInt32(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeSInt64:
            let downCastValue = value as! Int64
            try output.writeSInt64(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeUInt32:
            let downCastValue = value as! UInt32
            try output.writeUInt32(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeUInt64:
            let downCastValue = value as! UInt64
            try output.writeUInt64(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeBytes:
            let downCastValue = value as! NSData
            try output.writeData(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeString:
            let downCastValue = value as! String
            try output.writeString(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeEnum:
            let downCastValue = value as! Int32
            try output.writeEnum(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeGroup:
            let downCastValue = value as! GeneratedMessage
            try output.writeGroup(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeMessage where isMessageSetWireFormat == true:
            let downCastValue = value as! GeneratedMessage
            try output.writeMessageSetExtension(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeMessage where isMessageSetWireFormat == false:
            let downCastValue = value as! GeneratedMessage
            try output.writeMessage(fieldNumber, value:downCastValue)
        
        default:
             throw ProtocolBuffersError.InvalidProtocolBuffer("Invalid Extensions Type")
        }
    }
    
    func  writeSingleValueNoTag(value:Any, output:CodedOutputStream) throws
    {
        switch type {

        case .ExtensionTypeBool:
            let downCastValue = value as! Bool
            try output.writeBoolNoTag(downCastValue)
            
        case .ExtensionTypeFixed32:
            let downCastValue = value as! UInt32
            try output.writeFixed32NoTag(downCastValue)
        
        case .ExtensionTypeSFixed32:
            let downCastValue = value as! Int32
            try output.writeSFixed32NoTag(downCastValue)
        
        case .ExtensionTypeInt32:
            let downCastValue = value as! Int32
            try output.writeInt32NoTag(downCastValue)
            
        case .ExtensionTypeSInt32:
            let downCastValue = value as! Int32
            try output.writeSInt32NoTag(downCastValue)
            
        case .ExtensionTypeEnum:
            let downCastValue = value as! Int32
            try output.writeEnumNoTag(downCastValue)
            
        case .ExtensionTypeFixed64:
            let downCastValue = value as! UInt64
            try output.writeFixed64NoTag(downCastValue)
            
        case .ExtensionTypeInt64:
            let downCastValue = value as! Int64
            try output.writeInt64NoTag(downCastValue)
            
        case .ExtensionTypeSInt64:
            let downCastValue = value as! Int64
            try output.writeSInt64NoTag(downCastValue)
        
        case .ExtensionTypeSFixed64:
            let downCastValue = value as! Int64
            try output.writeSFixed64NoTag(downCastValue)
            
        case .ExtensionTypeDouble:
            let downCastValue = value as! Double
            try output.writeDoubleNoTag(downCastValue)
            
        case .ExtensionTypeFloat:
            let downCastValue = value as! Float
            try output.writeFloatNoTag(downCastValue)

        case .ExtensionTypeUInt32:
            let downCastValue = value as! UInt32
            try output.writeUInt32NoTag(downCastValue)
        
        case .ExtensionTypeUInt64:
            let downCastValue = value as! UInt64
            try output.writeUInt64NoTag(downCastValue)
        
        case .ExtensionTypeBytes:
            let downCastValue = value as! NSData
            try output.writeDataNoTag(downCastValue)

        case .ExtensionTypeString:
            let downCastValue = value as! String
            try output.writeStringNoTag(downCastValue)
        
        case .ExtensionTypeGroup:
            let downCastValue = value as! GeneratedMessage
            try output.writeGroupNoTag(fieldNumber, value:downCastValue)

        case .ExtensionTypeMessage:
            let downCastValue = value as! GeneratedMessage
            try output.writeMessageNoTag(downCastValue)

        }
    }
    
    func  computeSingleSerializedSizeIncludingTag(value:Any) -> Int32
    {
        switch type {
        
        case .ExtensionTypeFixed32:
            let downCastValue = value as! UInt32
            return downCastValue.computeFixed32Size(fieldNumber)
            
        case .ExtensionTypeSFixed32:
            let downCastValue = value as! Int32
            return downCastValue.computeSFixed32Size(fieldNumber)
            
        case .ExtensionTypeSInt32:
            let downCastValue = value as! Int32
            return downCastValue.computeSInt32Size(fieldNumber)
            
        case .ExtensionTypeInt32:
            let downCastValue = value as! Int32
            return downCastValue.computeInt32Size(fieldNumber)
            
        case .ExtensionTypeEnum:
            let downCastValue = value as! Int32
            return downCastValue.computeEnumSize(fieldNumber)
            
        case .ExtensionTypeFixed64:
            let downCastValue = value as! UInt64
            return downCastValue.computeFixed64Size(fieldNumber)
            
        case .ExtensionTypeSFixed64:
            let downCastValue = value as! Int64
            return downCastValue.computeSFixed64Size(fieldNumber)

        case .ExtensionTypeInt64:
            let downCastValue = value as! Int64
            return downCastValue.computeInt64Size(fieldNumber)
            
        case .ExtensionTypeSInt64:
            let downCastValue = value as! Int64
            return downCastValue.computeSInt64Size(fieldNumber)
            
        case .ExtensionTypeFloat:
            let downCastValue = value as! Float
            return downCastValue.computeFloatSize(fieldNumber)
            
        case .ExtensionTypeDouble:
            let downCastValue = value as! Double
             return downCastValue.computeDoubleSize(fieldNumber)
            
        case .ExtensionTypeUInt32:
            let downCastValue = value as! UInt32
            return downCastValue.computeUInt32Size(fieldNumber)
            
        case .ExtensionTypeUInt64:
            let downCastValue = value as! UInt64
           return downCastValue.computeUInt64Size(fieldNumber)
            
        case .ExtensionTypeBytes:
            let downCastValue = value as! NSData
            return downCastValue.computeDataSize(fieldNumber)
            
        case .ExtensionTypeString:
            let downCastValue = value as! String
            return downCastValue.computeStringSize(fieldNumber)
            
        case .ExtensionTypeGroup:
            let downCastValue = value as! GeneratedMessage
            return downCastValue.computeGroupSize(fieldNumber)
            
        case .ExtensionTypeMessage where isMessageSetWireFormat == true:
            let downCastValue = value as! GeneratedMessage
            return downCastValue.computeMessageSetExtensionSize(fieldNumber)
            
        case .ExtensionTypeMessage where isMessageSetWireFormat == false:
            let downCastValue = value as! GeneratedMessage
            return downCastValue.computeMessageSize(fieldNumber)
        case .ExtensionTypeBool:
            let downCastValue = value as! Bool
            return downCastValue.computeBoolSize(fieldNumber)
        default:
            return 0
        }
    }
    
    func  computeSingleSerializedSizeNoTag(value:Any) -> Int32
    {
        switch type {

        case .ExtensionTypeBool:
            let downCastValue = value as! Bool
            return downCastValue.computeBoolSizeNoTag()
            
        case .ExtensionTypeFixed32:
            let downCastValue = value as! UInt32
            return downCastValue.computeFixed32SizeNoTag()
            
        case .ExtensionTypeSFixed32:
            let downCastValue = value as! Int32
            return downCastValue.computeSFixed32SizeNoTag()
        
        case .ExtensionTypeInt32:
            let downCastValue = value as! Int32
            return downCastValue.computeInt32SizeNoTag()
        
        case .ExtensionTypeSInt32:
            let downCastValue = value as! Int32
            return downCastValue.computeSInt32SizeNoTag()
            
        case .ExtensionTypeEnum:
            let downCastValue = value as! Int32
            return downCastValue.computeEnumSizeNoTag()
            
        case .ExtensionTypeFixed64:
            let downCastValue = value as! UInt64
            return downCastValue.computeFixed64SizeNoTag()
            
        case .ExtensionTypeSFixed64:
            let downCastValue = value as! Int64
            return downCastValue.computeSFixed64SizeNoTag()
        
        case .ExtensionTypeInt64:
            let downCastValue = value as! Int64
            return downCastValue.computeInt64SizeNoTag()
            
        case .ExtensionTypeSInt64:
            let downCastValue = value as! Int64
            return downCastValue.computeSInt64SizeNoTag()
            
        case .ExtensionTypeFloat:
            let downCastValue = value as! Float
            return downCastValue.computeFloatSizeNoTag()
            
        case .ExtensionTypeDouble:
            let downCastValue = value as! Double
            return downCastValue.computeDoubleSizeNoTag()
            
        case .ExtensionTypeUInt32:
            let downCastValue = value as! UInt32
            return downCastValue.computeUInt32SizeNoTag()
            
        case .ExtensionTypeUInt64:
            let downCastValue = value as! UInt64
            return downCastValue.computeUInt64SizeNoTag()
            
        case .ExtensionTypeBytes:
            let downCastValue = value as! NSData
            return downCastValue.computeDataSizeNoTag()
            
        case .ExtensionTypeString:
            let downCastValue = value as! String
            return downCastValue.computeStringSizeNoTag()
            
        case .ExtensionTypeGroup:
            let downCastValue = value as! GeneratedMessage
            return downCastValue.computeGroupSizeNoTag()
            
        case .ExtensionTypeMessage:
            let downCastValue = value as! GeneratedMessage
            return downCastValue.computeMessageSizeNoTag()
        }
    }
    
    func writeDescriptionOfSingleValue(value:Any, indent:String) throws -> String
    {
        var output = ""
        if typeIsPrimitive(type) {
            output += "\(indent)\(value)\n"
        }
        else if let values = value as? GeneratedMessage {
            output += try values.getDescription(indent)
        }
        else {
            throw ProtocolBuffersError.InvalidProtocolBuffer("Invalid Extensions Type")
        }
        return output
    }
    
    func writeRepeatedValuesIncludingTags<T>(values:Array<T>, output:CodedOutputStream) throws {
        if (isPacked) {
            try output.writeTag(fieldNumber, format: WireFormat.LengthDelimited)
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
    
    func computeRepeatedSerializedSizeIncludingTags<T>(values:Array<T>) -> Int32
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
    
    public func computeSerializedSizeIncludingTag(value:Any) -> Int32
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
            case let values as Array<NSData>:
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

    
    public func writeValueIncludingTagToCodedOutputStream(value:Any, output:CodedOutputStream) throws
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
            case let values as Array<NSData>:
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
    
    private func iterationRepetedValuesForDescription<T>(values:Array<T>, indent:String) throws -> String
    {
        var output = ""
        for singleValue in values
        {
            output += try writeDescriptionOfSingleValue(singleValue, indent: indent)
        }
        return output
    }
    
    public func getDescription(value:Any, indent:String) throws -> String
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
            case let values as Array<NSData>:
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
    
  
    
    func mergeMessageSetExtentionFromCodedInputStream(input:CodedInputStream, unknownFields:UnknownFieldSet.Builder) throws
    {
         throw ProtocolBuffersError.IllegalState("Method Not Supported")
    }
    
    func readSingleValueFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Any
    {
        switch type {
        case .ExtensionTypeBool:
            return try input.readBool()
        case .ExtensionTypeFixed32:
            return try input.readFixed32()
        case .ExtensionTypeSFixed32:
            return try input.readSFixed32()
        case .ExtensionTypeFixed64:
            return try input.readFixed64()
        case .ExtensionTypeSFixed64:
            return try input.readSFixed64()
        case .ExtensionTypeFloat:
            return try input.readFloat()
        case .ExtensionTypeDouble:
            return try input.readDouble()
        case .ExtensionTypeInt32:
            return try input.readInt32()
        case .ExtensionTypeInt64:
            return try input.readInt64()
        case .ExtensionTypeSInt32:
            return try input.readSInt32()
        case .ExtensionTypeSInt64:
            return try input.readSInt64()
        case .ExtensionTypeUInt32:
            return try input.readUInt32()
        case .ExtensionTypeUInt64:
            return try input.readUInt64()
        case .ExtensionTypeBytes:
            return try input.readData()
        case .ExtensionTypeString:
            return try input.readString()
        case .ExtensionTypeEnum:
            return try input.readEnum()
        case .ExtensionTypeGroup:
            if let mg = messageOrGroupClass as? GeneratedMessage.Type
            {
                let buider = mg.classBuilder()
                try input.readGroup(fieldNumber, builder: buider, extensionRegistry: extensionRegistry)
                let mes = try buider.build()
                return mes
            }
        case .ExtensionTypeMessage:
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
    
    public func mergeFromCodedInputStream(input:CodedInputStream, unknownFields:UnknownFieldSet.Builder, extensionRegistry:ExtensionRegistry, builder:ExtendableMessageBuilder, tag:Int32) throws {
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
