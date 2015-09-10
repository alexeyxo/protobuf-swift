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

var DEFAULT_BUFFER_SIZE:Int32 = 4 * 1024

public class CodedOutputStream
{
    private var output:NSOutputStream!
    internal var buffer:RingBuffer
    
    public init (output aOutput:NSOutputStream!, data:NSMutableData)
    {
        output = aOutput
        buffer = RingBuffer(data:data)
    }
  
    public init(output aOutput:NSOutputStream!, bufferSize:Int32)
    {
        let data = NSMutableData(length: Int(bufferSize))!
        output = aOutput
        buffer = RingBuffer(data: data)
    }
   
    public init(output:NSOutputStream)
    {
        let data = NSMutableData(length: Int(DEFAULT_BUFFER_SIZE))!
        self.output = output
        buffer = RingBuffer(data: data)
    }
    
    public init(data aData:NSMutableData)
    {
        buffer = RingBuffer(data: aData)
    }
    
    public func flush() throws
    {
        guard let output = output else {
            throw ProtocolBuffersError.OutOfSpace
        }
        buffer.flushToOutputStream(output)
    }
   
    public func writeRawByte(byte aByte:UInt8) throws
    {
        while (!buffer.appendByte(byte: aByte))
        {
            try flush()
        }
    }
    
    public func writeRawData(data:NSData) throws
    {
        try writeRawData(data, offset:0, length: Int32(data.length))
    }
    public func writeRawData(data:NSData, offset:Int32, length:Int32) throws
    {
        var aLength = length
        var aOffset = offset
        while (aLength > 0)
        {
            let written:Int32 = buffer.appendData(data, offset: aOffset, length: aLength)
            aOffset += Int32(written)
            aLength -= Int32(written)
            if (written == 0 || aLength > 0)
            {
                try flush()
            }
        }
    }
    
    public func writeDoubleNoTag(value:Double) throws
    {
        var returnValue:Int64 = 0
        WireFormat.convertTypes(convertValue: value, retValue: &returnValue)
        try writeRawLittleEndian64(returnValue)
    }
    
    public func writeDouble(fieldNumber:Int32, value aValue:Double) throws
    {
        try writeTag(fieldNumber, format: WireFormat.Fixed64)
        try writeDoubleNoTag(aValue)
    }
    
    public func writeFloatNoTag(value:Float) throws
    {
        let convertValue = value
        var returnValue:Int32 = 0
        WireFormat.convertTypes(convertValue: convertValue, retValue: &returnValue)
        try writeRawLittleEndian32(returnValue)
    }
    
    public func writeFloat(fieldNumber:Int32, value aValue:Float) throws
    {
        try writeTag(fieldNumber, format: WireFormat.Fixed32)
        try writeFloatNoTag(aValue)
    }
    
    public func writeUInt64NoTag(value:UInt64) throws
    {
        var retvalue:Int64 = 0
        WireFormat.convertTypes(convertValue: value, retValue: &retvalue)
        try writeRawVarint64(retvalue)
    }
    
    public func writeUInt64(fieldNumber:Int32, value:UInt64) throws
    {
        try writeTag(fieldNumber, format:WireFormat.Varint)
        try writeUInt64NoTag(value)
    }
    
    public func writeInt64NoTag(value:Int64) throws
    {
        try writeRawVarint64(value)
    }
    
    public func writeInt64(fieldNumber:Int32, value aValue:Int64) throws
    {
        try writeTag(fieldNumber, format: WireFormat.Varint)
        try writeInt64NoTag(aValue)
    }
    
    public func writeInt32NoTag(value:Int32) throws
    {
        if (value >= 0) {
            try writeRawVarint32(value)
        } else {

            try writeRawVarint64(Int64(value))
        }
    }
    
    public func writeInt32(fieldNumber:Int32, value:Int32) throws
    {
        try writeTag(fieldNumber, format: WireFormat.Varint)
        try writeInt32NoTag(value)
    }
    
    public func writeFixed64NoTag(value:UInt64) throws
    {
        var retvalue:Int64 = 0
        WireFormat.convertTypes(convertValue: value, retValue: &retvalue)
        try writeRawLittleEndian64(retvalue)
    }
    
    public func writeFixed64(fieldNumber:Int32, value:UInt64) throws
    {
        try writeTag(fieldNumber, format: WireFormat.Fixed64)
        try writeFixed64NoTag(value)
    }
    
    public func writeFixed32NoTag(value:UInt32) throws
    {
        var retvalue:Int32 = 0
        WireFormat.convertTypes(convertValue: value, retValue: &retvalue)
        try writeRawLittleEndian32(retvalue)
    }
    
    public func writeFixed32(fieldNumber:Int32, value:UInt32) throws
    {
        try writeTag(fieldNumber, format:WireFormat.Fixed32)
        try writeFixed32NoTag(value)
    }
    
    public func writeBoolNoTag(value:Bool) throws
    {
        try writeRawByte(byte: value ? 1 : 0)
    }
    
    public func writeBool(fieldNumber:Int32, value:Bool) throws
    {
        try writeTag(fieldNumber, format:WireFormat.Varint)
        try writeBoolNoTag(value)
    }
    
    public func writeStringNoTag(value:String) throws
    {        
        let data = value.utf8ToNSData()
        try writeRawVarint32(Int32(data.length))
        try writeRawData(data)
    }
    
    public func writeString(fieldNumber:Int32, value:String) throws
    {
        try writeTag(fieldNumber, format: WireFormat.LengthDelimited)
        try writeStringNoTag(value)
    }
    
    public func writeGroupNoTag(fieldNumber:Int32, value:Message) throws
    {
        try value.writeToCodedOutputStream(self)
        try writeTag(fieldNumber, format: WireFormat.EndGroup)
    }
    
    public func writeGroup(fieldNumber:Int32, value:Message) throws
    {
        try writeTag(fieldNumber, format: WireFormat.StartGroup)
        try writeGroupNoTag(fieldNumber, value: value)
    }
    
    public func writeUnknownGroupNoTag(fieldNumber:Int32, value:UnknownFieldSet) throws
    {
        try value.writeToCodedOutputStream(self)
        try writeTag(fieldNumber, format:WireFormat.EndGroup)
    }
    
    public func writeUnknownGroup(fieldNumber:Int32, value:UnknownFieldSet) throws
    {
        try writeTag(fieldNumber, format:WireFormat.StartGroup)
        try writeUnknownGroupNoTag(fieldNumber, value:value)
    }
    
    public func writeMessageNoTag(value:Message) throws
    {
        try writeRawVarint32(value.serializedSize())
        try value.writeToCodedOutputStream(self)
    }
    
    public func writeMessage(fieldNumber:Int32, value:Message) throws
    {
        try writeTag(fieldNumber, format: WireFormat.LengthDelimited)
        try writeMessageNoTag(value)
    }
    
    public func writeDataNoTag(data:NSData) throws
    {
        try writeRawVarint32(Int32(data.length))
        try writeRawData(data)
    }
    
    public func writeData(fieldNumber:Int32, value:NSData) throws
    {
        try writeTag(fieldNumber, format: WireFormat.LengthDelimited)
        try writeDataNoTag(value)
    }
    
    public func writeUInt32NoTag(value:UInt32) throws
    {
        var retvalue:Int32 = 0
        WireFormat.convertTypes(convertValue: value, retValue: &retvalue)
        try writeRawVarint32(retvalue)
    }
    
    public func writeUInt32(fieldNumber:Int32, value:UInt32) throws
    {
        try writeTag(fieldNumber, format: WireFormat.Varint)
        try writeUInt32NoTag(value)
    }
    
    public func writeEnumNoTag(value:Int32) throws
    {
        try writeRawVarint32(value)
    }
    
    public func writeEnum(fieldNumber:Int32, value:Int32) throws
    {
        try writeTag(fieldNumber, format:WireFormat.Varint)
        try writeEnumNoTag(value)
    }
    
    public func writeSFixed32NoTag(value:Int32) throws
    {
        try writeRawLittleEndian32(value)
    }
    
    public func writeSFixed32(fieldNumber:Int32, value:Int32) throws
    {
        try writeTag(fieldNumber, format:WireFormat.Fixed32)
        try writeSFixed32NoTag(value)
    }

    public func writeSFixed64NoTag(value:Int64) throws
    {
         try writeRawLittleEndian64(value)
    }
    
    public func writeSFixed64(fieldNumber:Int32, value:Int64) throws
    {
        try writeTag(fieldNumber, format:WireFormat.Fixed64)
        try writeSFixed64NoTag(value)
    }
    
    public func writeSInt32NoTag(value:Int32) throws
    {
        try writeRawVarint32(WireFormat.encodeZigZag32(value))
    }
    
    public func writeSInt32(fieldNumber:Int32, value:Int32) throws
    {
        try writeTag(fieldNumber, format:WireFormat.Varint)
        try writeSInt32NoTag(value)
    }
    
    public func writeSInt64NoTag(value:Int64) throws
    {
        try writeRawVarint64(WireFormat.encodeZigZag64(value))
    }
    
    public func writeSInt64(fieldNumber:Int32, value:Int64) throws
    {
        try writeTag(fieldNumber, format:WireFormat.Varint)
        try writeSInt64NoTag(value)
    }
    
    public func writeMessageSetExtension(fieldNumber:Int32, value:Message) throws
    {
        try writeTag(WireFormatMessage.SetItem.rawValue, format:WireFormat.StartGroup)
        try writeUInt32(WireFormatMessage.SetTypeId.rawValue, value:UInt32(fieldNumber))
        try writeMessage(WireFormatMessage.SetMessage.rawValue, value: value)
        try writeTag(WireFormatMessage.SetItem.rawValue, format:WireFormat.EndGroup)
    }
    
    public func writeRawMessageSetExtension(fieldNumber:Int32, value:NSData) throws
    {
        try writeTag(WireFormatMessage.SetItem.rawValue, format:WireFormat.StartGroup)
        try writeUInt32(WireFormatMessage.SetTypeId.rawValue, value:UInt32(fieldNumber))
        try writeData( WireFormatMessage.SetMessage.rawValue, value: value)
        try writeTag(WireFormatMessage.SetItem.rawValue, format:WireFormat.EndGroup)
    }
    
    public func writeTag(fieldNumber:Int32, format:WireFormat) throws
    {
        try writeRawVarint32(format.makeTag(fieldNumber))
    }
    
    public func writeRawLittleEndian32(value:Int32) throws
    {
        try writeRawByte(byte:UInt8(value & 0xFF))
        try writeRawByte(byte:UInt8((value >> 8) & 0xFF))
        try writeRawByte(byte:UInt8((value >> 16) & 0xFF))
        try writeRawByte(byte:UInt8((value >> 24) & 0xFF))
    }
    
    public func writeRawLittleEndian64(value:Int64) throws
    {
        try writeRawByte(byte:UInt8(value & 0xFF))
        try writeRawByte(byte:UInt8((value >> 8) & 0xFF))
        try writeRawByte(byte:UInt8((value >> 16) & 0xFF))
        try writeRawByte(byte:UInt8((value >> 24) & 0xFF))
        try writeRawByte(byte:UInt8((value >> 32) & 0xFF))
        try writeRawByte(byte:UInt8((value >> 40) & 0xFF))
        try writeRawByte(byte:UInt8((value >> 48) & 0xFF))
        try writeRawByte(byte:UInt8((value >> 56) & 0xFF))
    }
    
    
    public func writeRawVarint32(var value:Int32) throws {
        while (true) {
            if ((value & ~0x7F) == 0) {
                try writeRawByte(byte:UInt8(value))
                break
            } else
            {
                try writeRawByte(byte: UInt8((value & 0x7F) | 0x80))
                value = WireFormat.logicalRightShift32(value:value,spaces: 7)
            }
        }
    }
    
    public func writeRawVarint64(var value:Int64) throws {
        while (true) {
            if ((value & ~0x7F) == 0) {
                try writeRawByte(byte:UInt8(value))
                break
            } else {
                try writeRawByte(byte: UInt8((value & 0x7F) | 0x80))
                value = WireFormat.logicalRightShift64(value:value, spaces: 7)
            }
        }
    }
}