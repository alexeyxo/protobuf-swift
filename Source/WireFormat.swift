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

let LITTLE_ENDIAN_32_SIZE:Int32 = 4
let LITTLE_ENDIAN_64_SIZE:Int32 = 8


public enum WireFormatMessage:Int32
{
    case SetItem = 1
    case SetTypeId = 2
    case SetMessage = 3
}

public enum WireFormat:Int32
{
    case Varint = 0
    case Fixed64 = 1
    case LengthDelimited = 2
    case StartGroup = 3
    case EndGroup = 4
    case Fixed32 = 5
    case TagTypeMask = 7
    
    public func makeTag(_ fieldNumber:Int32) -> Int32
    {
        let res:Int32 = fieldNumber << StartGroup.rawValue
        return res | self.rawValue
    }
    
    public static func getTagWireType(_ tag:Int32) -> Int32
    {
        return tag &  WireFormat.TagTypeMask.rawValue
    }
    
    public static func getTagFieldNumber(_ tag:Int32) -> Int32
    {
        return WireFormat.logicalRightShift32(value: tag ,spaces: StartGroup.rawValue)
    }
    
    
    ///Utilities
    
    public static func convertTypes<Type, ReturnType>(convertValue value:Type, defaultValue:ReturnType) -> ReturnType
    {
        var retValue = defaultValue
        var curValue = value
        memcpy(&retValue, &curValue, sizeof(Type))
        return retValue
    }
    
    public static func logicalRightShift32(value aValue:Int32, spaces aSpaces:Int32) ->Int32
    {
        var result:UInt32 = 0
        result = convertTypes(convertValue: aValue, defaultValue: result)
        let bytes:UInt32 = (result >> UInt32(aSpaces))
        var res:Int32 = 0
        res = convertTypes(convertValue: bytes, defaultValue: res)
        return res
    }
    
    public static func logicalRightShift64(value aValue:Int64, spaces aSpaces:Int64) ->Int64
    {
        var result:UInt64 = 0
        result = convertTypes(convertValue: aValue, defaultValue: result)
        let bytes:UInt64 = (result >> UInt64(aSpaces))
        var res:Int64 = 0
        res = convertTypes(convertValue: bytes, defaultValue: res)
        return res
    }
    public static func  decodeZigZag32(_ n:Int32) -> Int32
    {
        return logicalRightShift32(value: n, spaces: 1) ^ -(n & 1)
    }
    public static func encodeZigZag32(_ n:Int32) -> Int32 {
        return (n << 1) ^ (n >> 31)
    }
    
    public static func  decodeZigZag64(_ n:Int64) -> Int64
    {
        return logicalRightShift64(value: n, spaces: 1) ^ -(n & 1)
    }
    public static func encodeZigZag64(_ n:Int64) -> Int64
    {
        return (n << 1) ^ (n >> 63)
    }
    
}
public extension Int32
{
    func computeSFixed32SizeNoTag() ->Int32
    {
        return LITTLE_ENDIAN_32_SIZE
    }
   
    func computeInt32SizeNoTag() -> Int32
    {
        if (self >= 0)
        {
            return computeRawVarint32Size()
        }
        else
        {
            return 10
        }
    }
    
    func computeRawVarint32Size() -> Int32 {
        if ((self & (0xfffffff <<  7)) == 0)
        {
            return 1
        }
        if ((self & (0xfffffff << 14)) == 0)
        {
            return 2
        }
        if ((self & (0xfffffff << 21)) == 0)
        {
            return 3
        }
        if ((self & (0xfffffff << 28)) == 0)
        {
            return 4
        }
        
        return 5
    }
    
    func computeTagSize() ->Int32
    {
        return WireFormat.Varint.makeTag(self).computeRawVarint32Size()
    }
    
    func computeEnumSizeNoTag() -> Int32
    {
        return self.computeRawVarint32Size()
    }
    
    func computeSInt32SizeNoTag() -> Int32
    {
        return  WireFormat.encodeZigZag32(self).computeRawVarint32Size()
    }
    
    func computeInt32Size(_ fieldNumber:Int32) ->Int32
    {
        return fieldNumber.computeTagSize() + computeInt32SizeNoTag()
    }
 
    func computeEnumSize(_ fieldNumber:Int32) ->Int32
    {
        return fieldNumber.computeTagSize() + computeEnumSizeNoTag()
    }

    func computeSFixed32Size(_ fieldNumber:Int32) -> Int32
    {
        return fieldNumber.computeTagSize() + computeSFixed32SizeNoTag()
    }
    
    func computeSInt32Size(_ fieldNumber:Int32) ->Int32
    {
        return fieldNumber.computeTagSize() + computeSInt32SizeNoTag()
    }
    
}

public extension Int64
{
    func computeInt64SizeNoTag() -> Int32
    {
        return computeRawVarint64Size()
    }
    
    func computeRawVarint64Size() -> Int32
    {
        if ((self & (0xfffffffffffffff <<  7)) == 0){return 1}
        if ((self & (0xfffffffffffffff << 14)) == 0){return 2}
        if ((self & (0xfffffffffffffff << 21)) == 0){return 3}
        if ((self & (0xfffffffffffffff << 28)) == 0){return 4}
        if ((self & (0xfffffffffffffff << 35)) == 0){return 5}
        if ((self & (0xfffffffffffffff << 42)) == 0){return 6}
        if ((self & (0xfffffffffffffff << 49)) == 0){return 7}
        if ((self & (0xfffffffffffffff << 56)) == 0){return 8}
        if ((self & (0xfffffffffffffff << 63)) == 0){return 9}
        return 10
    }
    
    func computeSInt64SizeNoTag() -> Int32
    {
        return WireFormat.encodeZigZag64(self).computeRawVarint64Size()
    }
    
    func computeInt64Size(_ fieldNumber:Int32) -> Int32
    {
        return fieldNumber.computeTagSize() + computeInt64SizeNoTag()
    }
    
    func computeSFixed64SizeNoTag() -> Int32
    {
        return LITTLE_ENDIAN_64_SIZE
    }
    
    func computeSFixed64Size(_ fieldNumber:Int32) -> Int32
    {
        return fieldNumber.computeTagSize() + computeSFixed64SizeNoTag()
    }
    
    func computeSInt64Size(_ fieldNumber:Int32) ->Int32
    {
        return fieldNumber.computeTagSize() + WireFormat.encodeZigZag64(self).computeRawVarint64Size()
    }


}

public extension Double
{
    func computeDoubleSizeNoTag() ->Int32
    {
        return LITTLE_ENDIAN_64_SIZE
    }
    
    func computeDoubleSize(_ fieldNumber:Int32) ->Int32
    {
        return fieldNumber.computeTagSize() + self.computeDoubleSizeNoTag()
    }
}
public extension Float
{
    func  computeFloatSizeNoTag() ->Int32
    {
        return LITTLE_ENDIAN_32_SIZE
    }
    func computeFloatSize(_ fieldNumber:Int32) ->Int32
    {
        return fieldNumber.computeTagSize() + self.computeFloatSizeNoTag()
    }

}

public extension UInt64
{
    func computeFixed64SizeNoTag() ->Int32
    {
        return LITTLE_ENDIAN_64_SIZE
    }
    
    func computeUInt64SizeNoTag() -> Int32
    {
        var retvalue:Int64 = 0
        retvalue = WireFormat.convertTypes(convertValue: self, defaultValue:retvalue)
        return retvalue.computeRawVarint64Size()
    }
    
    func computeUInt64Size(_ fieldNumber:Int32) ->Int32
    {
        return fieldNumber.computeTagSize() + computeUInt64SizeNoTag()
    }
    
    func computeFixed64Size(_ fieldNumber:Int32) ->Int32
    {
        return fieldNumber.computeTagSize() + computeFixed64SizeNoTag()
    }

}

public extension UInt32
{
    func computeFixed32SizeNoTag() ->Int32
    {
        return LITTLE_ENDIAN_32_SIZE
    }
    
    func computeUInt32SizeNoTag() -> Int32
    {
        var retvalue:Int32 = 0
        retvalue = WireFormat.convertTypes(convertValue: self, defaultValue: retvalue)
        return retvalue.computeRawVarint32Size()
    }
    
    func computeFixed32Size(_ fieldNumber:Int32) ->Int32
    {
        return fieldNumber.computeTagSize() + computeFixed32SizeNoTag()
    }
    func computeUInt32Size(_ fieldNumber:Int32) -> Int32 {
        return fieldNumber.computeTagSize() + computeUInt32SizeNoTag()
    }
}

public extension Bool
{
    func computeBoolSizeNoTag() -> Int32 {
        return 1
    }
    func computeBoolSize(_ fieldNumber:Int32) ->Int32
    {
        return fieldNumber.computeTagSize() + computeBoolSizeNoTag()
    }
}

public extension String
{
    func computeStringSizeNoTag() -> Int32 {
        let length:UInt32  = UInt32(self.lengthOfBytes(using: NSUTF8StringEncoding))
        return Int32(length).computeRawVarint32Size() + Int32(length)
    }
    
    func computeStringSize(_ fieldNumber:Int32) ->Int32
    {
        return fieldNumber.computeTagSize() + computeStringSizeNoTag()
    }
    func utf8ToNSData()-> NSData
    {
        let bytes = [UInt8]() + self.utf8
        let data = NSData(bytes: bytes, length:bytes.count)
        return data
    }
}

public extension AbstractMessage
{
    func computeGroupSizeNoTag() -> Int32
    {
        return self.serializedSize()
    }
    
    func computeMessageSizeNoTag() ->Int32
    {
        let size:Int32  = self.serializedSize()
        return size.computeRawVarint32Size() + size
    }
    
    func computeGroupSize(_ fieldNumber:Int32) ->Int32
    {
        return fieldNumber.computeTagSize() * 2 + computeGroupSizeNoTag()
    }
    
    func computeMessageSize(_ fieldNumber:Int32) ->Int32
    {
        return fieldNumber.computeTagSize() + computeMessageSizeNoTag()
    }
    
    func computeMessageSetExtensionSize(_ fieldNumber:Int32) -> Int32
    {
        return WireFormatMessage.SetItem.rawValue.computeTagSize() * 2 + UInt32(fieldNumber).computeUInt32Size(WireFormatMessage.SetTypeId.rawValue) + computeMessageSize(WireFormatMessage.SetMessage.rawValue)
    }
}

public extension NSData
{
    func computeDataSizeNoTag() -> Int32
    {
        return Int32(self.length).computeRawVarint32Size() + Int32(self.length)
    }
    
    func computeDataSize(_ fieldNumber:Int32) -> Int32
    {
        return fieldNumber.computeTagSize() + computeDataSizeNoTag()
    }
    
    func computeRawMessageSetExtensionSize(_ fieldNumber:Int32) -> Int32
    {
        return WireFormatMessage.SetItem.rawValue.computeTagSize() * 2 + UInt32(fieldNumber).computeUInt32Size(WireFormatMessage.SetTypeId.rawValue) + computeDataSize(WireFormatMessage.SetMessage.rawValue)
    }

}

public extension UnknownFieldSet
{
    func computeUnknownGroupSizeNoTag() ->Int32
    {
        return serializedSize()
    }
    func computeUnknownGroupSize(_ fieldNumber:Int32) ->Int32
    {
        return fieldNumber.computeTagSize() * 2 + computeUnknownGroupSizeNoTag()
    }
}





