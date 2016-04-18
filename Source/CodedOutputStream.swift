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
    
    public func writeRawData(_ data:NSData) throws
    {
        try writeRawData(data, offset:0, length: Int32(data.length))
    }
    public func writeRawData(_ data:NSData, offset:Int32, length:Int32) throws
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
    
    public func writeDoubleNoTag(_ value:Double) throws
    {
        var returnValue:Int64 = 0
        returnValue = WireFormat.convertTypes(convertValue: value, defaultValue:returnValue)
        try writeRawLittleEndian64(returnValue)
    }
    
    public func writeDouble(_ fieldNumber:Int32, value aValue:Double) throws
    {
        try writeTag(fieldNumber, format: WireFormat.Fixed64)
        try writeDoubleNoTag(aValue)
    }
    
    public func writeFloatNoTag(_ value:Float) throws
    {
        var returnValue:Int32 = 0
        returnValue = WireFormat.convertTypes(convertValue: value, defaultValue:returnValue)
        try writeRawLittleEndian32(returnValue)
    }
    
    public func writeFloat(_ fieldNumber:Int32, value aValue:Float) throws
    {
        try writeTag(fieldNumber, format: WireFormat.Fixed32)
        try writeFloatNoTag(aValue)
    }
    
    public func writeUInt64NoTag(_ value:UInt64) throws
    {
        var retvalue:Int64 = 0
        retvalue = WireFormat.convertTypes(convertValue: value, defaultValue:retvalue)
        try writeRawVarint64(retvalue)
    }
    
    public func writeUInt64(_ fieldNumber:Int32, value:UInt64) throws
    {
        try writeTag(fieldNumber, format:WireFormat.Varint)
        try writeUInt64NoTag(value)
    }
    
    public func writeInt64NoTag(_ value:Int64) throws
    {
        try writeRawVarint64(value)
    }
    
    public func writeInt64(_ fieldNumber:Int32, value aValue:Int64) throws
    {
        try writeTag(fieldNumber, format: WireFormat.Varint)
        try writeInt64NoTag(aValue)
    }
    
    public func writeInt32NoTag(_ value:Int32) throws
    {
        if (value >= 0) {
            try writeRawVarint32(value)
        } else {

            try writeRawVarint64(Int64(value))
        }
    }
    
    public func writeInt32(_ fieldNumber:Int32, value:Int32) throws
    {
        try writeTag(fieldNumber, format: WireFormat.Varint)
        try writeInt32NoTag(value)
    }
    
    public func writeFixed64NoTag(_ value:UInt64) throws
    {
        var retvalue:Int64 = 0
        retvalue = WireFormat.convertTypes(convertValue: value, defaultValue:retvalue)
        try writeRawLittleEndian64(retvalue)
    }
    
    public func writeFixed64(_ fieldNumber:Int32, value:UInt64) throws
    {
        try writeTag(fieldNumber, format: WireFormat.Fixed64)
        try writeFixed64NoTag(value)
    }
    
    public func writeFixed32NoTag(_ value:UInt32) throws
    {
        var retvalue:Int32 = 0
        retvalue = WireFormat.convertTypes(convertValue: value, defaultValue:retvalue)
        try writeRawLittleEndian32(retvalue)
    }
    
    public func writeFixed32(_ fieldNumber:Int32, value:UInt32) throws
    {
        try writeTag(fieldNumber, format:WireFormat.Fixed32)
        try writeFixed32NoTag(value)
    }
    
    public func writeBoolNoTag(_ value:Bool) throws
    {
        try writeRawByte(byte: value ? 1 : 0)
    }
    
    public func writeBool(_ fieldNumber:Int32, value:Bool) throws
    {
        try writeTag(fieldNumber, format:WireFormat.Varint)
        try writeBoolNoTag(value)
    }
    
    public func writeStringNoTag(_ value:String) throws
    {        
        let data = value.utf8ToNSData()
        try writeRawVarint32(Int32(data.length))
        try writeRawData(data)
    }
    
    public func writeString(_ fieldNumber:Int32, value:String) throws
    {
        try writeTag(fieldNumber, format: WireFormat.LengthDelimited)
        try writeStringNoTag(value)
    }
    
    public func writeGroupNoTag(_ fieldNumber:Int32, value:Message) throws
    {
        try value.writeToCodedOutputStream(self)
        try writeTag(fieldNumber, format: WireFormat.EndGroup)
    }
    
    public func writeGroup(_ fieldNumber:Int32, value:Message) throws
    {
        try writeTag(fieldNumber, format: WireFormat.StartGroup)
        try writeGroupNoTag(fieldNumber, value: value)
    }
    
    public func writeUnknownGroupNoTag(_ fieldNumber:Int32, value:UnknownFieldSet) throws
    {
        try value.writeToCodedOutputStream(self)
        try writeTag(fieldNumber, format:WireFormat.EndGroup)
    }
    
    public func writeUnknownGroup(_ fieldNumber:Int32, value:UnknownFieldSet) throws
    {
        try writeTag(fieldNumber, format:WireFormat.StartGroup)
        try writeUnknownGroupNoTag(fieldNumber, value:value)
    }
    
    public func writeMessageNoTag(_ value:Message) throws
    {
        try writeRawVarint32(value.serializedSize())
        try value.writeToCodedOutputStream(self)
    }
    
    public func writeMessage(_ fieldNumber:Int32, value:Message) throws
    {
        try writeTag(fieldNumber, format: WireFormat.LengthDelimited)
        try writeMessageNoTag(value)
    }
    
    public func writeDataNoTag(_ data:NSData) throws
    {
        try writeRawVarint32(Int32(data.length))
        try writeRawData(data)
    }
    
    public func writeData(_ fieldNumber:Int32, value:NSData) throws
    {
        try writeTag(fieldNumber, format: WireFormat.LengthDelimited)
        try writeDataNoTag(value)
    }
    
    public func writeUInt32NoTag(_ value:UInt32) throws
    {
        var retvalue:Int32 = 0
        retvalue = WireFormat.convertTypes(convertValue: value, defaultValue:retvalue)
        try writeRawVarint32(retvalue)
    }
    
    public func writeUInt32(_ fieldNumber:Int32, value:UInt32) throws
    {
        try writeTag(fieldNumber, format: WireFormat.Varint)
        try writeUInt32NoTag(value)
    }
    
    public func writeEnumNoTag(_ value:Int32) throws
    {
        try writeRawVarint32(value)
    }
    
    public func writeEnum(_ fieldNumber:Int32, value:Int32) throws
    {
        try writeTag(fieldNumber, format:WireFormat.Varint)
        try writeEnumNoTag(value)
    }
    
    public func writeSFixed32NoTag(_ value:Int32) throws
    {
        try writeRawLittleEndian32(value)
    }
    
    public func writeSFixed32(_ fieldNumber:Int32, value:Int32) throws
    {
        try writeTag(fieldNumber, format:WireFormat.Fixed32)
        try writeSFixed32NoTag(value)
    }

    public func writeSFixed64NoTag(_ value:Int64) throws
    {
         try writeRawLittleEndian64(value)
    }
    
    public func writeSFixed64(_ fieldNumber:Int32, value:Int64) throws
    {
        try writeTag(fieldNumber, format:WireFormat.Fixed64)
        try writeSFixed64NoTag(value)
    }
    
    public func writeSInt32NoTag(_ value:Int32) throws
    {
        try writeRawVarint32(WireFormat.encodeZigZag32(value))
    }
    
    public func writeSInt32(_ fieldNumber:Int32, value:Int32) throws
    {
        try writeTag(fieldNumber, format:WireFormat.Varint)
        try writeSInt32NoTag(value)
    }
    
    public func writeSInt64NoTag(_ value:Int64) throws
    {
        try writeRawVarint64(WireFormat.encodeZigZag64(value))
    }
    
    public func writeSInt64(_ fieldNumber:Int32, value:Int64) throws
    {
        try writeTag(fieldNumber, format:WireFormat.Varint)
        try writeSInt64NoTag(value)
    }
    
    public func writeMessageSetExtension(_ fieldNumber:Int32, value:Message) throws
    {
        try writeTag(WireFormatMessage.SetItem.rawValue, format:WireFormat.StartGroup)
        try writeUInt32(WireFormatMessage.SetTypeId.rawValue, value:UInt32(fieldNumber))
        try writeMessage(WireFormatMessage.SetMessage.rawValue, value: value)
        try writeTag(WireFormatMessage.SetItem.rawValue, format:WireFormat.EndGroup)
    }
    
    public func writeRawMessageSetExtension(_ fieldNumber:Int32, value:NSData) throws
    {
        try writeTag(WireFormatMessage.SetItem.rawValue, format:WireFormat.StartGroup)
        try writeUInt32(WireFormatMessage.SetTypeId.rawValue, value:UInt32(fieldNumber))
        try writeData( WireFormatMessage.SetMessage.rawValue, value: value)
        try writeTag(WireFormatMessage.SetItem.rawValue, format:WireFormat.EndGroup)
    }
    
    public func writeTag(_ fieldNumber:Int32, format:WireFormat) throws
    {
        try writeRawVarint32(format.makeTag(fieldNumber))
    }
    
    public func writeRawLittleEndian32(_ value:Int32) throws
    {
        try writeRawByte(byte:UInt8(value & 0xFF))
        try writeRawByte(byte:UInt8((value >> 8) & 0xFF))
        try writeRawByte(byte:UInt8((value >> 16) & 0xFF))
        try writeRawByte(byte:UInt8((value >> 24) & 0xFF))
    }
    
    public func writeRawLittleEndian64(_ value:Int64) throws
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
    
    
    public func writeRawVarint32(_ value:Int32) throws {
        var valueToWrite = value
        while (true) {
            if ((valueToWrite & ~0x7F) == 0) {
                try writeRawByte(byte:UInt8(valueToWrite))
                break
            } else
            {
                try writeRawByte(byte: UInt8((valueToWrite & 0x7F) | 0x80))
                valueToWrite = WireFormat.logicalRightShift32(value:valueToWrite,spaces: 7)
            }
        }
    }
    
    public func writeRawVarint64(_ value:Int64) throws {
        var valueToWrite = value
        while (true) {
            if ((valueToWrite & ~0x7F) == 0) {
                try writeRawByte(byte:UInt8(valueToWrite))
                break
            } else {
                try writeRawByte(byte: UInt8((valueToWrite & 0x7F) | 0x80))
                valueToWrite = WireFormat.logicalRightShift64(value:valueToWrite, spaces: 7)
            }
        }
    }
}