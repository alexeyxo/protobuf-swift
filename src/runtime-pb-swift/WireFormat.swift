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

let LITTLE_ENDIAN_32_SIZE:Int32 = 4
let LITTLE_ENDIAN_64_SIZE:Int32 = 8

enum WireFormatMessage:Int32
{
    case WireFormatMessageSetItem = 1
    case WireFormatMessageSetTypeId = 2
    case WireFormatMessageSetMessage = 3
}

enum WireFormat:Int32
{
    case WireFormatVarint = 0
    case WireFormatFixed64 = 1
    case WireFormatLengthDelimited = 2
    case WireFormatStartGroup = 3
    case WireFormatEndGroup = 4
    case WireFormatFixed32 = 5
    case WireFormatTagTypeMask = 7
    
    func wireFormatMakeTag(fieldNumber:Int32) -> Int32
    {
        let res:Int32 = fieldNumber << WireFormatStartGroup.toRaw()
        return res | self.toRaw()
    }
    
    static func wireFormatGetTagWireType(tag:Int32) -> Int32
    {
        let res:Int32 = tag &  WireFormatTagTypeMask.toRaw()
        return res
    }
    
    static func wireFormatGetTagFieldNumber(tag:Int32) -> Int32
    {
        return WireFormat.logicalRightShift32(value: tag, spaces: WireFormatStartGroup.toRaw())
    }
    
    
    ///Utilies
    
    static func convertTypes<Type, ReturnType>(var convertValue value:Type, inout retValue:ReturnType)
    {
        memcpy(&retValue, &value, ByteCount(sizeof(Type)))
    }
    static func logicalRightShift32(var value aValue:Int32, spaces aSpaces:Int32) ->Int32
    {
        var result:UInt32 = 0
        convertTypes(convertValue: aValue, retValue: &result)
        var bytes:UInt32 = (result >> UInt32(aSpaces))
        var res:Int32 = 0
        convertTypes(convertValue: bytes, retValue: &res)
        return res
    }
    
    static func logicalRightShift64(var value aValue:Int64, spaces aSpaces:Int64) ->Int64
    {
        var result:UInt64 = 0
        convertTypes(convertValue: aValue, retValue: &result)
        var bytes:UInt64 = (result >> UInt64(aSpaces))
        var res:Int64 = 0
        convertTypes(convertValue: bytes, retValue: &res)
        return res
    }
    
    static func  decodeZigZag32(var n:Int32) -> Int32
    {
        return logicalRightShift32(value: n, spaces: 1) ^ -(n & 1)
    }
    static func encodeZigZag32(var n:Int32) -> Int32 {
        return (n << 1) ^ (n >> 31)
    }
    
    static func  decodeZigZag64(var n:Int64) -> Int64
    {
        return logicalRightShift64(value: n, spaces: 1) ^ -(n & 1)
    }
    static func encodeZigZag64(var n:Int64) -> Int64
    {
        return (n << 1) ^ (n >> 63)
    }
    
    static func computeDoubleSizeNoTag(value:Double) ->Int32
    {
        return LITTLE_ENDIAN_64_SIZE
    }
    
    static func  computeFloatSizeNoTag(value:Float) ->Int32
    {
        return LITTLE_ENDIAN_32_SIZE
    }
    
    static func computeSFixed64SizeNoTag(value:Int64) ->Int32
    {
        return LITTLE_ENDIAN_64_SIZE
    }
    
    static func  computeSFixed32SizeNoTag(value:Int32) ->Int32
    {
        return LITTLE_ENDIAN_32_SIZE
    }
    
    static func computeFixed64SizeNoTag(value:Int64) ->Int32
    {
        return LITTLE_ENDIAN_64_SIZE
    }
    
    static func  computeFixed32SizeNoTag(value:Int32) ->Int32
    {
        return LITTLE_ENDIAN_32_SIZE
    }
    
    
    static func computeUInt64SizeNoTag(value:Int64) -> Int32
    {
        return computeRawVarint64Size(value)
    }
    
    static func computeInt64SizeNoTag(value:Int64) ->Int32
    {
        return computeRawVarint64Size(value)
    }
    
    static func computeInt32SizeNoTag(value:Int32) ->Int32
    {
        if (value >= 0)
        {
            return computeRawVarint32Size(value)
        }
        else
        {
            return 10;
        }
    }
    static func computeBoolSizeNoTag(value:Bool) -> Int32 {
        return 1
    }
    
    static func computeStringSizeNoTag(value:String) -> Int32 {
        let length:UInt32  = UInt32(value.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        return computeRawVarint32Size(Int32(length)) + Int32(length)
    }
    static func computeGroupSizeNoTag(value:Message) -> Int32
    {
        return value.serializedSize()
    }
    
    static func computeMessageSizeNoTag(value:Message) ->Int32
    {
        var size:Int32  = value.serializedSize()
        return computeRawVarint32Size(size) + size
    }
    static func computeDataSizeNoTag(value:[Byte]) ->Int32
    {
        return computeRawVarint32Size(Int32(value.count)) + Int32(value.count)
    }
    
    static func computeUInt32SizeNoTag(value:Int32) -> Int32
    {
        return computeRawVarint32Size(value)
    }
    
    static func computeEnumSizeNoTag(value:Int32) -> Int32
    {
        return computeRawVarint32Size(value)
    }
    
    static func computeSInt32SizeNoTag(value:Int32) -> Int32
    {
        return computeRawVarint32Size(encodeZigZag32(value))
    }
    
    static func computeSInt64SizeNoTag(value:Int64) -> Int32
    {
        return computeRawVarint64Size(encodeZigZag64(value))
    }
    
    
    static func computeDoubleSize(fieldNumber:Int32, value:Double) ->Int32
    {
        return computeTagSize(fieldNumber) + computeDoubleSizeNoTag(value)
    }
    
    static func computeFloatSize(fieldNumber:Int32, value:Float) ->Int32
    {
        return computeTagSize(fieldNumber) + computeFloatSizeNoTag(value)
    }
    
    static func computeUInt64Size(fieldNumber:Int32, value:Int64) ->Int32
    {
        return computeTagSize(fieldNumber) + computeUInt64SizeNoTag(value)
    }
    
    static func  computeInt64Size(fieldNumber:Int32, value:Int64) ->Int32
    {
        return computeTagSize(fieldNumber) + computeInt64SizeNoTag(value)
    }
    
    
    static func computeInt32Size(fieldNumber:Int32, value:Int32) ->Int32
    {
        return computeTagSize(fieldNumber) + computeInt32SizeNoTag(value)
    }
    
    
    static func computeFixed64Size(fieldNumber:Int32, value:Int64) ->Int32
    {
        return computeTagSize(fieldNumber) + computeFixed64SizeNoTag(value)
    }
    
    
    static func computeFixed32Size(fieldNumber:Int32, value:Int32) ->Int32
    {
        return computeTagSize(fieldNumber) + computeFixed32SizeNoTag(value)
    }
    
    
    static func computeBoolSize(fieldNumber:Int32, value:Bool) ->Int32
    {
        return computeTagSize(fieldNumber) + computeBoolSizeNoTag(value);
    }
    
    
    static func computeStringSize(fieldNumber:Int32, value:String) ->Int32
    {
        return computeTagSize(fieldNumber) + computeStringSizeNoTag(value);
    }
    
    static func computeGroupSize(fieldNumber:Int32, value:Message) ->Int32
    {
        return computeTagSize(fieldNumber) * 2 + computeGroupSizeNoTag(value);
    }
    
    static func computeUnknownGroupSizeNoTag(value:UnknownFieldSet) ->Int32
    {
        return value.serializedSize()
    }
    static func computeUnknownGroupSize(fieldNumber:Int32, value:UnknownFieldSet) ->Int32
    {
        return computeTagSize(fieldNumber) * 2 + computeUnknownGroupSizeNoTag(value);
    }
    
    static func computeMessageSize(fieldNumber:Int32, value:Message) ->Int32
    {
        return computeTagSize(fieldNumber) + computeMessageSizeNoTag(value);
    }
    
    
    static func computeDataSize(fieldNumber:Int32, value:[Byte]) -> Int32
    {
        return computeTagSize(fieldNumber) + computeDataSizeNoTag(value);
    }
    
    static func computeUInt32Size(fieldNumber:Int32, value:Int32) -> Int32 {
        return computeTagSize(fieldNumber) + computeUInt32SizeNoTag(value);
    }
    
    static func computeEnumSize(fieldNumber:Int32, value:Int32) ->Int32
    {
        return computeTagSize(fieldNumber) + computeEnumSizeNoTag(value);
    }
    
    
    static func computeSFixed32Size(fieldNumber:Int32, value:Int32) -> Int32
    {
        return computeTagSize(fieldNumber) + computeSFixed32SizeNoTag(value)
    }
    
    
    static func computeSFixed64Size(fieldNumber:Int32, value:Int64) -> Int32
    {
        return computeTagSize(fieldNumber) + computeSFixed64SizeNoTag(value);
    }
    
    
    static func computeSInt32Size(fieldNumber:Int32, value:Int32) ->Int32
    {
        return computeTagSize(fieldNumber) + computeSInt32SizeNoTag(value);
    }
    
    
    static func computeTagSize(fieldNumber:Int32) ->Int32
    {
        return computeRawVarint32Size(WireFormat.WireFormatVarint.wireFormatMakeTag(fieldNumber))
    }
    
    static func computeSInt64Size(fieldNumber:Int32, value:Int64) ->Int32
    {
        return computeTagSize(fieldNumber) + computeRawVarint64Size(encodeZigZag64(value));
    }
    
    
    static func computeRawVarint32Size(value:Int32) -> Int32 {
        if ((value & (0xfffffff <<  7)) == 0)
        {
            return 1
        }
        if ((value & (0xfffffff << 14)) == 0)
        {
            return 2
        }
        if ((value & (0xfffffff << 21)) == 0)
        {
            return 3
        }
        if ((value & (0xfffffff << 28)) == 0)
        {
            return 4
        }
        
        return 5;
    }
    
    
    static func computeRawVarint64Size(value:Int64) -> Int32
    {
        if ((value & (0xfffffffffffffff <<  7)) == 0){return 1}
        if ((value & (0xfffffffffffffff << 14)) == 0){return 2}
        if ((value & (0xfffffffffffffff << 21)) == 0){return 3}
        if ((value & (0xfffffffffffffff << 28)) == 0){return 4}
        if ((value & (0xfffffffffffffff << 35)) == 0){return 5}
        if ((value & (0xfffffffffffffff << 42)) == 0){return 6}
        if ((value & (0xfffffffffffffff << 49)) == 0){return 7}
        if ((value & (0xfffffffffffffff << 56)) == 0){return 8}
        if ((value & (0xfffffffffffffff << 63)) == 0){return 9}
        return 10;
    }
    
    static func computeMessageSetExtensionSize(fieldNumber:Int32,  value:Message) -> Int32
    {
        
        return computeTagSize(WireFormatMessage.WireFormatMessageSetItem.toRaw()) * 2 + computeUInt32Size(WireFormatMessage.WireFormatMessageSetTypeId.toRaw(), value: fieldNumber) + computeMessageSize(WireFormatMessage.WireFormatMessageSetMessage.toRaw(), value: value)
    }
    
    static func computeRawMessageSetExtensionSize(fieldNumber:Int32, value:[Byte]?) -> Int32
    {
        return computeTagSize(WireFormatMessage.WireFormatMessageSetItem.toRaw()) * 2 + computeUInt32Size(WireFormatMessage.WireFormatMessageSetTypeId.toRaw(), value: fieldNumber) + computeDataSize(WireFormatMessage.WireFormatMessageSetMessage.toRaw(), value: value!)
    }
    
}




