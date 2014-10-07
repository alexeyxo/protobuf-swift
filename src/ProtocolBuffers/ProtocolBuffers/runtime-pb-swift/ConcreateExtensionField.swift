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
    var messageOrGroupClass:Any.Type
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
                return WireFormat.WireFormatLengthDelimited
            }
            switch type
                {
            case .ExtensionTypeBool:     return WireFormat.WireFormatVarint
            case .ExtensionTypeFixed32:  return WireFormat.WireFormatFixed32
            case .ExtensionTypeSFixed32: return WireFormat.WireFormatFixed32
            case .ExtensionTypeFloat:    return WireFormat.WireFormatFixed32
            case .ExtensionTypeFixed64:  return WireFormat.WireFormatFixed64
            case .ExtensionTypeSFixed64: return WireFormat.WireFormatFixed64
            case .ExtensionTypeDouble:   return WireFormat.WireFormatFixed64
            case .ExtensionTypeInt32:    return WireFormat.WireFormatVarint
            case .ExtensionTypeInt64:    return WireFormat.WireFormatVarint
            case .ExtensionTypeSInt32:   return WireFormat.WireFormatVarint
            case .ExtensionTypeSInt64:   return WireFormat.WireFormatVarint
            case .ExtensionTypeUInt32:   return WireFormat.WireFormatVarint
            case .ExtensionTypeUInt64:   return WireFormat.WireFormatVarint
            case .ExtensionTypeBytes:    return WireFormat.WireFormatLengthDelimited
            case .ExtensionTypeString:   return WireFormat.WireFormatLengthDelimited
            case .ExtensionTypeMessage:  return WireFormat.WireFormatLengthDelimited
            case .ExtensionTypeGroup:    return WireFormat.WireFormatStartGroup
            case .ExtensionTypeEnum:     return WireFormat.WireFormatVarint
            default:
                NSException(name:"InternalError", reason:"", userInfo: nil).raise()
                
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
                return false;
        }
    }
    
    
    func typeSize(type:ExtensionType) -> Int32
    {
        switch (type) {
            case .ExtensionTypeBool: return 1;
            case .ExtensionTypeFixed32, .ExtensionTypeSFixed32, .ExtensionTypeFloat: return 4
            case .ExtensionTypeFixed64,.ExtensionTypeSFixed64, .ExtensionTypeDouble: return 8
            default:
                return 0;
        }
    }
    
    func  writeSingleValueIncludingTag(value:Any, output:CodedOutputStream)
    {
        switch type {

        case .ExtensionTypeBool:
            var downCastValue = value as Bool
            output.writeBool(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeFixed32:
            var downCastValue = value as UInt32
            output.writeFixed32(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeSFixed32:
             var downCastValue = value as Int32
            output.writeSFixed32(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeFixed64:
            var downCastValue = value as UInt64
            output.writeFixed64(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeSFixed64:
            var downCastValue = value as Int64
            output.writeSFixed64(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeDouble:
            var downCastValue = value as Double
            output.writeDouble(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeFloat:
            var downCastValue = value as Float
            output.writeFloat(fieldNumber, value:downCastValue)
       
        case .ExtensionTypeInt32:
            var downCastValue = value as Int32
            output.writeInt32(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeInt64:
            var downCastValue = value as Int64
            output.writeInt64(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeSInt32:
            var downCastValue = value as Int32
            output.writeSInt32(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeSInt64:
            var downCastValue = value as Int64
            output.writeSInt64(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeUInt32:
            var downCastValue = value as UInt32
            output.writeUInt32(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeUInt64:
            var downCastValue = value as UInt64
            output.writeUInt64(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeBytes:
            var downCastValue = value as [Byte]
            output.writeData(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeString:
            var downCastValue = value as String
            output.writeString(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeEnum:
            var downCastValue = value as Int32
            output.writeEnum(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeGroup:
            var downCastValue = value as GeneratedMessage
            output.writeGroup(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeMessage where isMessageSetWireFormat == true:
            var downCastValue = value as GeneratedMessage
            output.writeMessageSetExtension(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeMessage where isMessageSetWireFormat == false:
            var downCastValue = value as GeneratedMessage
            output.writeMessage(fieldNumber, value:downCastValue)
        
        default:
             NSException(name:"InternalError", reason:"", userInfo: nil).raise()
        }
    }
    
    func  writeSingleValueNoTag(value:Any, output:CodedOutputStream)
    {
        switch type {

        case .ExtensionTypeBool:
            var downCastValue = value as Bool
            output.writeBoolNoTag(downCastValue)
            
        case .ExtensionTypeFixed32:
            var downCastValue = value as UInt32
            output.writeFixed32NoTag(downCastValue)
        
        case .ExtensionTypeSFixed32:
            var downCastValue = value as Int32
            output.writeSFixed32NoTag(downCastValue)
        
        case .ExtensionTypeInt32:
            var downCastValue = value as Int32
            output.writeInt32NoTag(downCastValue)
            
        case .ExtensionTypeSInt32:
            var downCastValue = value as Int32
            output.writeSInt32NoTag(downCastValue)
            
        case .ExtensionTypeEnum:
            var downCastValue = value as Int32
            output.writeEnumNoTag(downCastValue)
            
        case .ExtensionTypeFixed64:
            var downCastValue = value as UInt64
            output.writeFixed64NoTag(downCastValue)
            
        case .ExtensionTypeInt64:
            var downCastValue = value as Int64
            output.writeInt64NoTag(downCastValue)
            
        case .ExtensionTypeSInt64:
            var downCastValue = value as Int64
            output.writeSInt64NoTag(downCastValue)
        
        case .ExtensionTypeSFixed64:
            var downCastValue = value as Int64
            output.writeSFixed64NoTag(downCastValue)
            
        case .ExtensionTypeDouble:
            var downCastValue = value as Double
            output.writeDoubleNoTag(downCastValue)
            
        case .ExtensionTypeFloat:
            var downCastValue = value as Float
            output.writeFloatNoTag(downCastValue)

        case .ExtensionTypeUInt32:
            var downCastValue = value as UInt32
            output.writeUInt32NoTag(downCastValue)
        
        case .ExtensionTypeUInt64:
            var downCastValue = value as UInt64
            output.writeUInt64NoTag(downCastValue)
        
        case .ExtensionTypeBytes:
            var downCastValue = value as [Byte]
            output.writeDataNoTag(downCastValue)

        case .ExtensionTypeString:
            var downCastValue = value as String
            output.writeStringNoTag(downCastValue)
        
        case .ExtensionTypeGroup:
            var downCastValue = value as GeneratedMessage
            output.writeGroupNoTag(fieldNumber, value:downCastValue)

        case .ExtensionTypeMessage:
            var downCastValue = value as GeneratedMessage
            output.writeMessageNoTag(downCastValue)
            
        default:
            NSException(name:"InternalError", reason:"", userInfo: nil).raise()
        }
    }
    
    func  computeSingleSerializedSizeIncludingTag(value:Any) -> Int32
    {
        switch type {
        
        case .ExtensionTypeBool:
            var downCastValue = value as Bool
            return WireFormat.computeBoolSize(fieldNumber, value:downCastValue)

        case .ExtensionTypeFixed32:
            var downCastValue = value as UInt32
            return WireFormat.computeFixed32Size(fieldNumber, value: downCastValue)
            
        case .ExtensionTypeSFixed32:
            var downCastValue = value as Int32
            return WireFormat.computeSFixed32Size(fieldNumber, value:downCastValue)
            
        case .ExtensionTypeSInt32:
            var downCastValue = value as Int32
            return WireFormat.computeSInt32Size(fieldNumber, value: downCastValue)
            
        case .ExtensionTypeInt32:
            var downCastValue = value as Int32
            return WireFormat.computeInt32Size(fieldNumber, value:downCastValue)
            
        case .ExtensionTypeEnum:
            var downCastValue = value as Int32
            return WireFormat.computeEnumSize(fieldNumber, value:downCastValue)
            
        case .ExtensionTypeFixed64:
            var downCastValue = value as UInt64
            return WireFormat.computeFixed64Size(fieldNumber, value: downCastValue)
            
        case .ExtensionTypeSFixed64:
            var downCastValue = value as Int64
            return WireFormat.computeSFixed64Size(fieldNumber, value:downCastValue)

        case .ExtensionTypeInt64:
            var downCastValue = value as Int64
            return WireFormat.computeInt64Size(fieldNumber, value:downCastValue)
            
        case .ExtensionTypeSInt64:
            var downCastValue = value as Int64
            return WireFormat.computeSInt64Size(fieldNumber, value:downCastValue)
            
        case .ExtensionTypeFloat:
            var downCastValue = value as Float
            return WireFormat.computeFloatSize(fieldNumber, value:downCastValue)
            
        case .ExtensionTypeDouble:
            var downCastValue = value as Double
             return WireFormat.computeDoubleSize(fieldNumber, value:downCastValue)
            
        case .ExtensionTypeUInt32:
            var downCastValue = value as UInt32
            return WireFormat.computeUInt32Size(fieldNumber, value:downCastValue)
            
        case .ExtensionTypeUInt64:
            var downCastValue = value as UInt64
           return WireFormat.computeUInt64Size(fieldNumber, value:downCastValue)
            
        case .ExtensionTypeBytes:
            var downCastValue = value as [Byte]
            return WireFormat.computeDataSize(fieldNumber, value:downCastValue)
            
        case .ExtensionTypeString:
            var downCastValue = value as String
            return WireFormat.computeStringSize(fieldNumber, value:downCastValue)
            
        case .ExtensionTypeGroup:
            var downCastValue = value as GeneratedMessage
            return WireFormat.computeGroupSizeNoTag(downCastValue)
            
        case .ExtensionTypeMessage where isMessageSetWireFormat == true:
            var downCastValue = value as GeneratedMessage
            return WireFormat.computeMessageSetExtensionSize(fieldNumber, value:downCastValue)
            
        case .ExtensionTypeMessage where isMessageSetWireFormat == false:
            var downCastValue = value as GeneratedMessage
            return WireFormat.computeMessageSize(fieldNumber, value:downCastValue)
            
        default:
            NSException(name:"InternalError", reason:"", userInfo: nil).raise()
        }
        return 0
    }
    
    func  computeSingleSerializedPrimitivesSizeNoTag(value:Any) -> Int32
    {
        switch type {

        case .ExtensionTypeBool:
            var downCastValue = value as Bool
            return WireFormat.computeBoolSizeNoTag(downCastValue)
            
        case .ExtensionTypeFixed32:
            var downCastValue = value as UInt32
            return WireFormat.computeFixed32SizeNoTag(downCastValue)
            
        case .ExtensionTypeSFixed32:
            var downCastValue = value as Int32
            return WireFormat.computeSFixed32SizeNoTag(downCastValue)
        
        case .ExtensionTypeInt32:
            var downCastValue = value as Int32
            return WireFormat.computeInt32SizeNoTag(downCastValue)
        
        case .ExtensionTypeSInt32:
            var downCastValue = value as Int32
            return WireFormat.computeSInt32SizeNoTag(downCastValue)
            
        case .ExtensionTypeEnum:
            var downCastValue = value as Int32
            return WireFormat.computeEnumSizeNoTag(downCastValue)
            
        case .ExtensionTypeFixed64:
            var downCastValue = value as UInt64
            return WireFormat.computeFixed64SizeNoTag(downCastValue)
            
        case .ExtensionTypeSFixed64:
            var downCastValue = value as Int64
            return WireFormat.computeSFixed64SizeNoTag(downCastValue)
        
        case .ExtensionTypeInt64:
            var downCastValue = value as Int64
            return WireFormat.computeInt64SizeNoTag(downCastValue)
            
        case .ExtensionTypeSInt64:
            var downCastValue = value as Int64
            return WireFormat.computeSInt64SizeNoTag(downCastValue)
            
        case .ExtensionTypeFloat:
            var downCastValue = value as Float
            return WireFormat.computeFloatSizeNoTag(downCastValue)
            
        case .ExtensionTypeDouble:
            var downCastValue = value as Double
            return WireFormat.computeDoubleSizeNoTag(downCastValue)
            
        case .ExtensionTypeUInt32:
            var downCastValue = value as UInt32
            return WireFormat.computeUInt32SizeNoTag(downCastValue)
            
        case .ExtensionTypeUInt64:
            var downCastValue = value as UInt64
            return WireFormat.computeUInt64SizeNoTag(downCastValue)
            
        case .ExtensionTypeBytes:
            var downCastValue = value as [Byte]
            return WireFormat.computeDataSizeNoTag(downCastValue)
            
        case .ExtensionTypeString:
            var downCastValue = value as String
            return WireFormat.computeStringSizeNoTag(downCastValue)
            
        case .ExtensionTypeGroup:
            var downCastValue = value as GeneratedMessage
            return WireFormat.computeGroupSizeNoTag(downCastValue)
            
        case .ExtensionTypeMessage:
            var downCastValue = value as GeneratedMessage
            return WireFormat.computeMessageSizeNoTag(downCastValue)
            
        default:
            NSException(name:"InternalError", reason:"", userInfo: nil).raise()
        }
        return 0
    }
    
    func writeDescriptionOfSingleValue(value:Any, inout output:String, indent:String)
    {

        if typeIsPrimitive(type)
        {
            output += "\(indent)\(value)\n"
        }
        else if let values = value as? GeneratedMessage
        {
            values.writeDescriptionTo(&output, indent: indent)
        }
        else
        {
            NSException(name:"InternalError", reason:"", userInfo: nil).raise()
        }
        
    }
    
    func writeRepeatedValuesIncludingTags(values:Array<Any>, output:CodedOutputStream) {
        if (isPacked) {
            output.writeTag(fieldNumber, format: WireFormat.WireFormatLengthDelimited)
            var dataSize:Int32 = 0;
            
            if (typeIsFixedSize(type))
            {
                dataSize = Int32(values.count) * typeSize(type)
            }
            else
            {
                for value in values
                {
                    dataSize += computeSingleSerializedPrimitivesSizeNoTag(value)
                }
            }
            output.writeRawVarint32(dataSize)
            for value in values
            {
                writeSingleValueNoTag(value, output: output)
            }
            
        }
        else
        {
            for value in values
            {
               writeSingleValueIncludingTag(value, output: output)
            }
        }
    }
    
    func computeRepeatedSerializedSizeIncludingTags(values:Array<Any>) -> Int32
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
                    size += computeSingleSerializedPrimitivesSizeNoTag(value)
                }
            }
            return size + WireFormat.computeTagSize(fieldNumber) + WireFormat.computeRawVarint32Size(size)

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
        if let values = value as? Array<Any>
        {
            return computeRepeatedSerializedSizeIncludingTags(values)
        }
        else
        {
            return computeSingleSerializedSizeIncludingTag(value)
        }
    }

    
    public func writeValueIncludingTagToCodedOutputStream(value:Any, output:CodedOutputStream)
    {
        if let values = value as? Array<Any>
        {
             writeRepeatedValuesIncludingTags(values, output:output)
        }
        else
        {
            writeSingleValueIncludingTag(value, output:output)
        }
    }
    
    public func writeDescriptionOf(value:Any, inout output:String, indent:String)
    {
        if let values = value as? Array<Any>
        {
            for singleValue in values
            {
                writeDescriptionOfSingleValue(singleValue, output: &output, indent: indent)
            }
        }
        else
        {
                writeDescriptionOfSingleValue(value, output:&output, indent:indent)
        }
    }
    
    func mergeMessageSetExtentionFromCodedInputStream(input:CodedInputStream, unknownFields:UnknownFieldSetBuilder)
    {
        NSException(name:"InternalError", reason:"", userInfo: nil).raise()
    }
    
    func readSingleValueFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Any
    {
        switch type {
        case .ExtensionTypeBool:
            return input.readBool()
        case .ExtensionTypeFixed32:
            return input.readFixed32()
        case .ExtensionTypeSFixed32:
            return input.readSFixed32()
        case .ExtensionTypeFixed64:
            return input.readFixed64()
        case .ExtensionTypeSFixed64:
            return input.readSFixed64()
        case .ExtensionTypeFloat:
            return input.readFloat()
        case .ExtensionTypeDouble:
            return input.readDouble()
        case .ExtensionTypeInt32:
            return input.readInt32()
        case .ExtensionTypeInt64:
            return input.readInt64()
        case .ExtensionTypeSInt32:
            return input.readSInt32()
        case .ExtensionTypeSInt64:
            return input.readSInt64()
        case .ExtensionTypeUInt32:
            return input.readUInt32()
        case .ExtensionTypeUInt64:
            return input.readUInt64()
        case .ExtensionTypeBytes:
            return input.readData()
        case .ExtensionTypeString:
            return input.readString()
        case .ExtensionTypeEnum:
            return input.readEnum()
        case .ExtensionTypeGroup:
            if let mg = messageOrGroupClass as? GeneratedMessage.Type
            {
                var buider = mg.buider()
                input.readGroup(fieldNumber, builder: buider, extensionRegistry: extensionRegistry)
                var mes = buider.build()
                return mes
            }
        case .ExtensionTypeMessage:
            if let mg = messageOrGroupClass as? GeneratedMessage.Type
            {
                var buider = mg.buider()
                input.readMessage(buider, extensionRegistry: extensionRegistry)
                var mes = buider.build()
                return mes
            }

        default:
            NSException(name:"InternalError", reason:"", userInfo: nil).raise()
    
        }
        return ""
    }
    
    public func mergeFromCodedInputStream(input:CodedInputStream, unknownFields:UnknownFieldSetBuilder, extensionRegistry:ExtensionRegistry, builder:ExtendableMessageBuilder, tag:Int32) {
        if (isPacked) {
            var length:Int32 = input.readRawVarint32()
            var limit:Int32 = input.pushLimit(length)
            while (input.bytesUntilLimit() > 0) {
                var value = readSingleValueFromCodedInputStream(input, extensionRegistry:extensionRegistry)
                builder.addExtension(self, value:value)
            }
            input.popLimit(limit)
        }
        else if isMessageSetWireFormat
        {
            mergeMessageSetExtentionFromCodedInputStream(input, unknownFields:unknownFields)
        } else {
            var value = readSingleValueFromCodedInputStream(input, extensionRegistry:extensionRegistry)
            if (isRepeated) {
                builder.addExtension(self, value:value)
            } else {
                builder.setExtension(self, value:value)
            }
        }
    }
    

}
