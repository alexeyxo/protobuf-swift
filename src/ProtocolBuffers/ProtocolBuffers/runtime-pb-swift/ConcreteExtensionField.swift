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

func ==<T, ExtC where ExtC:ExtendableMessage>(lhs:ConcreteExtensionField<T, ExtC>, rhs:ConcreteExtensionField<T, ExtC>) -> Bool
{
    return true
}


final class ConcreteExtensionField<T, ExtC where ExtC:ExtendableMessage>:ExtensionField,Equatable
{
    var type:ExtensionType
    var fieldNumber:Int32
    var extendedClass:ExtC?
    var messageOrGroupClass:T?
    var defaultValue:Any
    var isRepeated:Bool = false
    var isPacked:Bool
    var isMessageSetWireFormat:Bool
    var nameOfExtension:String
    {
        get
        {
            return ""
        }
        
    }
   
    func initialize() -> ConcreteExtensionField {
        
        return ConcreteExtensionField(type: type, fieldNumber: fieldNumber, defaultValue: defaultValue, isRepeated: isRepeated, isPacked: isPacked, isMessageSetWireFormat: isMessageSetWireFormat)
    }
    
    init(type:ExtensionType,
        fieldNumber:Int32,
       defaultValue:Any,
         isRepeated:Bool,
           isPacked:Bool,
        isMessageSetWireFormat:Bool)
    {
        self.type = type
        self.fieldNumber = fieldNumber
        self.defaultValue = defaultValue
        self.isRepeated = isRepeated
        self.isPacked = isPacked
        self.isMessageSetWireFormat = isMessageSetWireFormat
    }
    
    var wireType:WireFormat
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
        switch (type) {
        case .ExtensionTypeBool:
            output.writeBool(fieldNumber, value:(value as Bool))
        case .ExtensionTypeFixed32:
            output.writeFixed32(fieldNumber, value:(value as Int32))
        case .ExtensionTypeSFixed32:
            output.writeSFixed32(fieldNumber, value:(value as Int32))
        case .ExtensionTypeFloat:
            output.writeFloat(fieldNumber, value:(value as Float))
        case .ExtensionTypeFixed64:
            output.writeFixed64(fieldNumber, value:(value as Int64))
        case .ExtensionTypeSFixed64:
            output.writeSFixed64(fieldNumber, value:(value as Int64))
        case .ExtensionTypeDouble:
            output.writeDouble(fieldNumber, value:(value as Double))
        case .ExtensionTypeInt32:
            output.writeInt32(fieldNumber, value:(value as Int32))
        case .ExtensionTypeInt64:
            output.writeInt64(fieldNumber, value:(value as Int64))
        case .ExtensionTypeSInt32:
            output.writeSInt32(fieldNumber, value:(value as Int32))
        case .ExtensionTypeSInt64:
            output.writeSInt64(fieldNumber, value:(value as Int64))
        case .ExtensionTypeUInt32:
            output.writeUInt32(fieldNumber, value:(value as UInt32))
        case .ExtensionTypeUInt64:
            output.writeUInt64(fieldNumber, value:(value as UInt64))
        case .ExtensionTypeBytes:
            output.writeData(fieldNumber, value:(value as [Byte]))
        case .ExtensionTypeString:
            output.writeString(fieldNumber, value:(value as String))
        case .ExtensionTypeEnum:
            output.writeEnum(fieldNumber, value:(value as Int32))
        case .ExtensionTypeGroup:
            output.writeGroup(fieldNumber, value:(value as AbstractMessage))
        case .ExtensionTypeMessage where isMessageSetWireFormat == true:
            output.writeMessageSetExtension(fieldNumber, value:(value as AbstractMessage))
        case .ExtensionTypeMessage where isMessageSetWireFormat == false:
            output.writeMessage(fieldNumber, value:(value as AbstractMessage))
        default:
             NSException(name:"InternalError", reason:"", userInfo: nil).raise()
        }
    }
    
    func  writeSingleValueNoTag(value:Any, output:CodedOutputStream)
    {
        switch (type) {
        case .ExtensionTypeBool:
            output.writeBoolNoTag((value as Bool))
        case .ExtensionTypeFixed32:
            output.writeFixed32NoTag((value as Int32))
        case .ExtensionTypeSFixed32:
            output.writeSFixed32NoTag((value as Int32))
        case .ExtensionTypeFloat:
            output.writeFloatNoTag((value as Float))
        case .ExtensionTypeFixed64:
            output.writeFixed64NoTag((value as Int64))
        case .ExtensionTypeSFixed64:
            output.writeSFixed64NoTag((value as Int64))
        case .ExtensionTypeDouble:
            output.writeDoubleNoTag((value as Double))
        case .ExtensionTypeInt32:
            output.writeInt32NoTag((value as Int32))
        case .ExtensionTypeInt64:
            output.writeInt64NoTag((value as Int64))
        case .ExtensionTypeSInt32:
            output.writeSInt32NoTag((value as Int32))
        case .ExtensionTypeSInt64:
            output.writeSInt64NoTag((value as Int64))
        case .ExtensionTypeUInt32:
            output.writeUInt32NoTag((value as UInt32))
        case .ExtensionTypeUInt64:
            output.writeUInt64NoTag((value as UInt64))
        case .ExtensionTypeBytes:
            output.writeDataNoTag((value as [Byte]))
        case .ExtensionTypeString:
            output.writeStringNoTag((value as String))
        case .ExtensionTypeEnum:
            output.writeEnumNoTag((value as Int32))
        case .ExtensionTypeGroup:
            output.writeGroupNoTag(fieldNumber, value:(value as AbstractMessage))
        case .ExtensionTypeMessage:
            output.writeMessageNoTag((value as AbstractMessage))
        default:
            NSException(name:"InternalError", reason:"", userInfo: nil).raise()
        }
    }
    
    func  computeSingleSerializedSizeIncludingTag(value:Any) -> Int32
    {
        switch (type) {
        case .ExtensionTypeBool:
            return WireFormat.computeBoolSize(fieldNumber, value:(value as Bool))
        case .ExtensionTypeFixed32:
            return WireFormat.computeFixed32Size(fieldNumber, value: (value as Int32))
        case .ExtensionTypeSFixed32:
            return WireFormat.computeSFixed32Size(fieldNumber, value: (value as Int32))
        case .ExtensionTypeFixed64:
            return WireFormat.computeFixed64Size(fieldNumber, value: (value as Int64))
        case .ExtensionTypeSFixed64:
            return WireFormat.computeSFixed64Size(fieldNumber, value: (value as Int64))
        case .ExtensionTypeFloat:
            return WireFormat.computeFloatSize(fieldNumber, value: (value as Float))
        case .ExtensionTypeDouble:
             return WireFormat.computeDoubleSize(fieldNumber, value: (value as Double))
        case .ExtensionTypeInt32:
            return WireFormat.computeInt32Size(fieldNumber, value: (value as Int32))
        case .ExtensionTypeInt64:
           return WireFormat.computeInt64Size(fieldNumber, value: (value as Int64))
        case .ExtensionTypeSInt32:
            return WireFormat.computeSInt32Size(fieldNumber, value: (value as Int32))
        case .ExtensionTypeSInt64:
            return WireFormat.computeSInt64Size(fieldNumber, value: (value as Int64))
        case .ExtensionTypeUInt32:
            return WireFormat.computeUInt32Size(fieldNumber, value: (value as UInt32))
        case .ExtensionTypeUInt64:
           return WireFormat.computeUInt64Size(fieldNumber, value: (value as UInt64))
        case .ExtensionTypeBytes:
            return WireFormat.computeDataSize(fieldNumber, value: (value as [Byte]))
        case .ExtensionTypeString:
            return WireFormat.computeStringSize(fieldNumber, value: (value as String))
        case .ExtensionTypeEnum:
            return WireFormat.computeEnumSize(fieldNumber, value: (value as Int32))
        case .ExtensionTypeGroup:
            return WireFormat.computeGroupSizeNoTag((value as AbstractMessage))
        case .ExtensionTypeMessage where isMessageSetWireFormat == true:
            return WireFormat.computeMessageSetExtensionSize(fieldNumber, value: (value as AbstractMessage))
            
        case .ExtensionTypeMessage where isMessageSetWireFormat == false:
            return WireFormat.computeMessageSize(fieldNumber, value: (value as AbstractMessage))
        default:
            NSException(name:"InternalError", reason:"", userInfo: nil).raise()
        }
        
        return 0
    }
    
    func  computeSingleSerializedPrimitivesSizeNoTag(value:Any) -> Int32
    {
        switch (type) {
        case .ExtensionTypeBool:
            return WireFormat.computeBoolSizeNoTag((value as Bool))
        case .ExtensionTypeFixed32:
            return WireFormat.computeFixed32SizeNoTag((value as Int32))
        case .ExtensionTypeSFixed32:
            return WireFormat.computeSFixed32SizeNoTag((value as Int32))
        case .ExtensionTypeFixed64:
            return WireFormat.computeFixed64SizeNoTag((value as Int64))
        case .ExtensionTypeSFixed64:
            return WireFormat.computeSFixed64Size(fieldNumber, value: (value as Int64))
        case .ExtensionTypeFloat:
            return WireFormat.computeFloatSizeNoTag((value as Float))
        case .ExtensionTypeDouble:
            return WireFormat.computeDoubleSizeNoTag((value as Double))
        case .ExtensionTypeInt32:
            return WireFormat.computeInt32SizeNoTag((value as Int32))
        case .ExtensionTypeInt64:
            return WireFormat.computeInt64SizeNoTag((value as Int64))
        case .ExtensionTypeSInt32:
            return WireFormat.computeSInt32SizeNoTag((value as Int32))
        case .ExtensionTypeSInt64:
            return WireFormat.computeSInt64SizeNoTag((value as Int64))
        case .ExtensionTypeUInt32:
            return WireFormat.computeUInt32SizeNoTag((value as UInt32))
        case .ExtensionTypeUInt64:
            return WireFormat.computeUInt64SizeNoTag((value as UInt64))
        case .ExtensionTypeBytes:
            return WireFormat.computeDataSizeNoTag((value as [Byte]))
        case .ExtensionTypeString:
            return WireFormat.computeStringSizeNoTag((value as String))
        case .ExtensionTypeEnum:
            return WireFormat.computeEnumSizeNoTag((value as Int32))
        case .ExtensionTypeGroup:
            return WireFormat.computeGroupSizeNoTag((value as AbstractMessage))
        case .ExtensionTypeMessage:
            return WireFormat.computeMessageSizeNoTag((value as AbstractMessage))
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
        else if let values = value as? AbstractMessage
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
    
    func computeSerializedSizeIncludingTag(value:Any) -> Int32
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

    
    func writeValueIncludingTagToCodedOutputStream(value:Any, output:CodedOutputStream)
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
    
    func writeDescriptionOf(value:Any, inout output:String, indent:String)
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
        
        
//        func readExtensionsGroup(input:CodedInputStream, extensionsRegistry:ExtensionRegistry) -> Message
//        {
//            var buider:MessageBuilder
//            let mg = messageOrGroupClass as AbstractMessage
//            buider = mg.buider()
//            input.readGroup(fieldNumber, builder: buider, extensionRegistry: extensionRegistry)
//            return buider.build()
//            
//        }
//        
//        func readExtensionsMesssage(input:CodedInputStream, extensionsRegistry:ExtensionRegistry) -> Message
//        {
//            var buider:MessageBuilder
//            let mg = messageOrGroupClass as AbstractMessage
//            buider = mg.buider()
//            input.readMessage(buider, extensionRegistry: extensionsRegistry)
//            return buider.build()
//        }

        
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
//        case .ExtensionTypeGroup:
//            return readExtensionsGroup(input, extensionRegistry)
//        case .ExtensionTypeMessage:
//            return readExtensionsMesssage(input, extensionRegistry)
        default:
            NSException(name:"InternalError", reason:"", userInfo: nil).raise()
    
        }
        return ""
    }
    
    func mergeFromCodedInputStream(input:CodedInputStream, unknownFields:UnknownFieldSetBuilder, extensionRegistry:ExtensionRegistry, builder:ExtendableMessageBuilder, tag:Int32) {
//        if (isPacked) {
//            var length:Int32 = input.readRawVarint32()
//            var limit:Int32 = input.pushLimit(length)
//            while (input.bytesUntilLimit() > 0) {
//                var value = readSingleValueFromCodedInputStream(input, extensionRegistry:extensionRegistry)
////                builder.addExtension(self, value:value)
//            }
//            input.popLimit(limit)
//        }
//        else if isMessageSetWireFormat
//        {
//            mergeMessageSetExtentionFromCodedInputStream(input, unknownFields:unknownFields)
//        } else {
//            var value = readSingleValueFromCodedInputStream(input, extensionRegistry:extensionRegistry)
//            if (isRepeated) {
//                builder.addExtension(self, value:value)
//            } else {
//                builder.setExtension(self, value:value)
//            }
//        }
    }
    

}
