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
                return false
        }
    }
    
    
    func typeSize(type:ExtensionType) -> Int32
    {
        switch (type) {
            case .ExtensionTypeBool: return 1
            case .ExtensionTypeFixed32, .ExtensionTypeSFixed32, .ExtensionTypeFloat: return 4
            case .ExtensionTypeFixed64,.ExtensionTypeSFixed64, .ExtensionTypeDouble: return 8
            default:
                return 0
        }
    }
    
    func  writeSingleValueIncludingTag(value:Any, output:CodedOutputStream)
    {
        switch type {

        case .ExtensionTypeBool:
            var downCastValue = value as! Bool
            output.writeBool(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeFixed32:
            var downCastValue = value as! UInt32
            output.writeFixed32(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeSFixed32:
             var downCastValue = value as! Int32
            output.writeSFixed32(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeFixed64:
            var downCastValue = value as! UInt64
            output.writeFixed64(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeSFixed64:
            var downCastValue = value as! Int64
            output.writeSFixed64(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeDouble:
            var downCastValue = value as! Double
            output.writeDouble(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeFloat:
            var downCastValue = value as! Float
            output.writeFloat(fieldNumber, value:downCastValue)
       
        case .ExtensionTypeInt32:
            var downCastValue = value as! Int32
            output.writeInt32(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeInt64:
            var downCastValue = value as! Int64
            output.writeInt64(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeSInt32:
            var downCastValue = value as! Int32
            output.writeSInt32(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeSInt64:
            var downCastValue = value as! Int64
            output.writeSInt64(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeUInt32:
            var downCastValue = value as! UInt32
            output.writeUInt32(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeUInt64:
            var downCastValue = value as! UInt64
            output.writeUInt64(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeBytes:
            var downCastValue = value as! NSData
            output.writeData(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeString:
            var downCastValue = value as! String
            output.writeString(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeEnum:
            var downCastValue = value as! Int32
            output.writeEnum(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeGroup:
            var downCastValue = value as! GeneratedMessage
            output.writeGroup(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeMessage where isMessageSetWireFormat == true:
            var downCastValue = value as! GeneratedMessage
            output.writeMessageSetExtension(fieldNumber, value:downCastValue)
        
        case .ExtensionTypeMessage where isMessageSetWireFormat == false:
            var downCastValue = value as! GeneratedMessage
            output.writeMessage(fieldNumber, value:downCastValue)
        
        default:
             NSException(name:"InternalError", reason:"", userInfo: nil).raise()
        }
    }
    
    func  writeSingleValueNoTag(value:Any, output:CodedOutputStream)
    {
        switch type {

        case .ExtensionTypeBool:
            var downCastValue = value as! Bool
            output.writeBoolNoTag(downCastValue)
            
        case .ExtensionTypeFixed32:
            var downCastValue = value as! UInt32
            output.writeFixed32NoTag(downCastValue)
        
        case .ExtensionTypeSFixed32:
            var downCastValue = value as! Int32
            output.writeSFixed32NoTag(downCastValue)
        
        case .ExtensionTypeInt32:
            var downCastValue = value as! Int32
            output.writeInt32NoTag(downCastValue)
            
        case .ExtensionTypeSInt32:
            var downCastValue = value as! Int32
            output.writeSInt32NoTag(downCastValue)
            
        case .ExtensionTypeEnum:
            var downCastValue = value as! Int32
            output.writeEnumNoTag(downCastValue)
            
        case .ExtensionTypeFixed64:
            var downCastValue = value as! UInt64
            output.writeFixed64NoTag(downCastValue)
            
        case .ExtensionTypeInt64:
            var downCastValue = value as! Int64
            output.writeInt64NoTag(downCastValue)
            
        case .ExtensionTypeSInt64:
            var downCastValue = value as! Int64
            output.writeSInt64NoTag(downCastValue)
        
        case .ExtensionTypeSFixed64:
            var downCastValue = value as! Int64
            output.writeSFixed64NoTag(downCastValue)
            
        case .ExtensionTypeDouble:
            var downCastValue = value as! Double
            output.writeDoubleNoTag(downCastValue)
            
        case .ExtensionTypeFloat:
            var downCastValue = value as! Float
            output.writeFloatNoTag(downCastValue)

        case .ExtensionTypeUInt32:
            var downCastValue = value as! UInt32
            output.writeUInt32NoTag(downCastValue)
        
        case .ExtensionTypeUInt64:
            var downCastValue = value as! UInt64
            output.writeUInt64NoTag(downCastValue)
        
        case .ExtensionTypeBytes:
            var downCastValue = value as! NSData
            output.writeDataNoTag(downCastValue)

        case .ExtensionTypeString:
            var downCastValue = value as! String
            output.writeStringNoTag(downCastValue)
        
        case .ExtensionTypeGroup:
            var downCastValue = value as! GeneratedMessage
            output.writeGroupNoTag(fieldNumber, value:downCastValue)

        case .ExtensionTypeMessage:
            var downCastValue = value as! GeneratedMessage
            output.writeMessageNoTag(downCastValue)
            
        default:
            NSException(name:"InternalError", reason:"", userInfo: nil).raise()
        }
    }
    
    func  computeSingleSerializedSizeIncludingTag(value:Any) -> Int32
    {
        switch type {
        
        case .ExtensionTypeBool:
            var downCastValue = value as! Bool
            return downCastValue.computeBoolSize(fieldNumber)

        case .ExtensionTypeFixed32:
            var downCastValue = value as! UInt32
            return downCastValue.computeFixed32Size(fieldNumber)
            
        case .ExtensionTypeSFixed32:
            var downCastValue = value as! Int32
            return downCastValue.computeSFixed32Size(fieldNumber)
            
        case .ExtensionTypeSInt32:
            var downCastValue = value as! Int32
            return downCastValue.computeSInt32Size(fieldNumber)
            
        case .ExtensionTypeInt32:
            var downCastValue = value as! Int32
            return downCastValue.computeInt32Size(fieldNumber)
            
        case .ExtensionTypeEnum:
            var downCastValue = value as! Int32
            return downCastValue.computeEnumSize(fieldNumber)
            
        case .ExtensionTypeFixed64:
            var downCastValue = value as! UInt64
            return downCastValue.computeFixed64Size(fieldNumber)
            
        case .ExtensionTypeSFixed64:
            var downCastValue = value as! Int64
            return downCastValue.computeSFixed64Size(fieldNumber)

        case .ExtensionTypeInt64:
            var downCastValue = value as! Int64
            return downCastValue.computeInt64Size(fieldNumber)
            
        case .ExtensionTypeSInt64:
            var downCastValue = value as! Int64
            return downCastValue.computeSInt64Size(fieldNumber)
            
        case .ExtensionTypeFloat:
            var downCastValue = value as! Float
            return downCastValue.computeFloatSize(fieldNumber)
            
        case .ExtensionTypeDouble:
            var downCastValue = value as! Double
             return downCastValue.computeDoubleSize(fieldNumber)
            
        case .ExtensionTypeUInt32:
            var downCastValue = value as! UInt32
            return downCastValue.computeUInt32Size(fieldNumber)
            
        case .ExtensionTypeUInt64:
            var downCastValue = value as! UInt64
           return downCastValue.computeUInt64Size(fieldNumber)
            
        case .ExtensionTypeBytes:
            var downCastValue = value as! NSData
            return downCastValue.computeDataSize(fieldNumber)
            
        case .ExtensionTypeString:
            var downCastValue = value as! String
            return downCastValue.computeStringSize(fieldNumber)
            
        case .ExtensionTypeGroup:
            var downCastValue = value as! GeneratedMessage
            return downCastValue.computeGroupSize(fieldNumber)
            
        case .ExtensionTypeMessage where isMessageSetWireFormat == true:
            var downCastValue = value as! GeneratedMessage
            return downCastValue.computeMessageSetExtensionSize(fieldNumber)
            
        case .ExtensionTypeMessage where isMessageSetWireFormat == false:
            var downCastValue = value as! GeneratedMessage
            return downCastValue.computeMessageSize(fieldNumber)
            
        default:
            NSException(name:"InternalError", reason:"", userInfo: nil).raise()
        }
        return 0
    }
    
    func  computeSingleSerializedSizeNoTag(value:Any) -> Int32
    {
        switch type {

        case .ExtensionTypeBool:
            var downCastValue = value as! Bool
            return downCastValue.computeBoolSizeNoTag()
            
        case .ExtensionTypeFixed32:
            var downCastValue = value as! UInt32
            return downCastValue.computeFixed32SizeNoTag()
            
        case .ExtensionTypeSFixed32:
            var downCastValue = value as! Int32
            return downCastValue.computeSFixed32SizeNoTag()
        
        case .ExtensionTypeInt32:
            var downCastValue = value as! Int32
            return downCastValue.computeInt32SizeNoTag()
        
        case .ExtensionTypeSInt32:
            var downCastValue = value as! Int32
            return downCastValue.computeSInt32SizeNoTag()
            
        case .ExtensionTypeEnum:
            var downCastValue = value as! Int32
            return downCastValue.computeEnumSizeNoTag()
            
        case .ExtensionTypeFixed64:
            var downCastValue = value as! UInt64
            return downCastValue.computeFixed64SizeNoTag()
            
        case .ExtensionTypeSFixed64:
            var downCastValue = value as! Int64
            return downCastValue.computeSFixed64SizeNoTag()
        
        case .ExtensionTypeInt64:
            var downCastValue = value as! Int64
            return downCastValue.computeInt64SizeNoTag()
            
        case .ExtensionTypeSInt64:
            var downCastValue = value as! Int64
            return downCastValue.computeSInt64SizeNoTag()
            
        case .ExtensionTypeFloat:
            var downCastValue = value as! Float
            return downCastValue.computeFloatSizeNoTag()
            
        case .ExtensionTypeDouble:
            var downCastValue = value as! Double
            return downCastValue.computeDoubleSizeNoTag()
            
        case .ExtensionTypeUInt32:
            var downCastValue = value as! UInt32
            return downCastValue.computeUInt32SizeNoTag()
            
        case .ExtensionTypeUInt64:
            var downCastValue = value as! UInt64
            return downCastValue.computeUInt64SizeNoTag()
            
        case .ExtensionTypeBytes:
            var downCastValue = value as! NSData
            return downCastValue.computeDataSizeNoTag()
            
        case .ExtensionTypeString:
            var downCastValue = value as! String
            return downCastValue.computeStringSizeNoTag()
            
        case .ExtensionTypeGroup:
            var downCastValue = value as! GeneratedMessage
            return downCastValue.computeGroupSizeNoTag()
            
        case .ExtensionTypeMessage:
            var downCastValue = value as! GeneratedMessage
            return downCastValue.computeMessageSizeNoTag()
            
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
    
    func writeRepeatedValuesIncludingTags<T>(values:Array<T>, output:CodedOutputStream) {
        if (isPacked) {
            output.writeTag(fieldNumber, format: WireFormat.WireFormatLengthDelimited)
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

    
    public func writeValueIncludingTagToCodedOutputStream(value:Any, output:CodedOutputStream)
    {
        
        if isRepeated
        {
            switch value
            {
            case let values as [Int32]:
                writeRepeatedValuesIncludingTags(values, output:output)
            case let values as [Int64]:
                writeRepeatedValuesIncludingTags(values, output:output)
            case let values as [UInt64]:
                writeRepeatedValuesIncludingTags(values, output:output)
            case let values as [UInt32]:
                writeRepeatedValuesIncludingTags(values, output:output)
            case let values as [Bool]:
                writeRepeatedValuesIncludingTags(values, output:output)
            case let values as [Float]:
                writeRepeatedValuesIncludingTags(values, output:output)
            case let values as [Double]:
                writeRepeatedValuesIncludingTags(values, output:output)
            case let values as [String]:
                writeRepeatedValuesIncludingTags(values, output:output)
            case let values as Array<NSData>:
                writeRepeatedValuesIncludingTags(values, output:output)
            case let values as [GeneratedMessage]:
                writeRepeatedValuesIncludingTags(values, output:output)
            default:
                break
            }
            
        }
        else
        {
            writeSingleValueIncludingTag(value, output:output)
        }
    }
    
    private func iterationRepetedValuesForDescription<T>(values:Array<T>, inout output:String, indent:String)
    {
        for singleValue in values
        {
            writeDescriptionOfSingleValue(singleValue, output: &output, indent: indent)
        }
    }
    
    public func writeDescriptionOf(value:Any, inout output:String, indent:String)
    {
  
        
        if isRepeated
        {
            switch value
            {
            case let values as [Int32]:
                iterationRepetedValuesForDescription(values, output: &output, indent: indent)
            case let values as [Int64]:
                iterationRepetedValuesForDescription(values, output: &output, indent: indent)
            case let values as [UInt64]:
                iterationRepetedValuesForDescription(values, output: &output, indent: indent)
            case let values as [UInt32]:
                iterationRepetedValuesForDescription(values, output: &output, indent: indent)
            case let values as [Bool]:
                iterationRepetedValuesForDescription(values, output: &output, indent: indent)
            case let values as [Float]:
                iterationRepetedValuesForDescription(values, output: &output, indent: indent)
            case let values as [Double]:
                iterationRepetedValuesForDescription(values, output: &output, indent: indent)
            case let values as [String]:
                iterationRepetedValuesForDescription(values, output: &output, indent: indent)
            case let values as Array<NSData>:
                iterationRepetedValuesForDescription(values, output: &output, indent: indent)
            case let values as [GeneratedMessage]:
                iterationRepetedValuesForDescription(values, output: &output, indent: indent)
            default:
                break
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
                var buider = mg.classBuilder()
                input.readGroup(fieldNumber, builder: buider, extensionRegistry: extensionRegistry)
                var mes = buider.build()
                return mes
            }
        case .ExtensionTypeMessage:
            if let mg = messageOrGroupClass as? GeneratedMessage.Type
            {
                var buider = mg.classBuilder()
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
        }
        else
        {
            var value = readSingleValueFromCodedInputStream(input, extensionRegistry:extensionRegistry)
            if (isRepeated) {
                builder.addExtension(self, value:value)
            } else {
                builder.setExtension(self, value:value)
            }
        }
    }
    

}
