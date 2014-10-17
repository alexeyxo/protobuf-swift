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

var DEFAULT_BUFFER_SIZE:Int32 = 4 * 1024

public class CodedOutputStream
{
    private var output:NSOutputStream!
    internal var buffer:RingBuffer
    
    public init (output aOutput:NSOutputStream!, data:[Byte])
    {
        output = aOutput
        buffer = RingBuffer(data:data)
    }
  
    public init(output aOutput:NSOutputStream!, bufferSize:Int32?)
    {
        var data = [Byte](count: Int(bufferSize!), repeatedValue: 0)
        output = aOutput
        buffer = RingBuffer(data: data)
    }
   
    public init(output:NSOutputStream?)
    {
        var data = [Byte](count: Int(DEFAULT_BUFFER_SIZE), repeatedValue: 0)
        self.output = output
        buffer = RingBuffer(data: data)
    }
    
    public init(data aData:[Byte])
    {
        buffer = RingBuffer(data: aData)
    }
    
    public func flush()
    {
        buffer.flushToOutputStream(output!)
    }
   
    public func writeRawByte(byte aByte:Byte)
    {
        while (!buffer.appendByte(byte: aByte))
        {
            flush()
        }
    }
    
    public func writeRawData(data:[Byte])
    {
        writeRawData(data, offset:0, length: Int32(data.count))
    
    }
    public func writeRawData(data:[Byte], var offset aOffset:Int32, var length aLength:Int32)
    {
        while (aLength > 0)
        {
            var written:Int32 = buffer.appendData(data, offset: aOffset, length: aLength)
            aOffset += Int32(written)
            aLength -= Int32(written)
            if (written == 0 && aLength > 0)
            {
                flush()
            }
        }
    }
    
  
    
    public func writeDoubleNoTag(value:Double)
    {
        var convertValue = value
        var returnValue:Int64 = 0
        WireFormat.convertTypes(convertValue: value, retValue: &returnValue)
        writeRawLittleEndian64(returnValue)
    }
    
    public func writeDouble(fieldNumber:Int32, value aValue:Double)
    {
        writeTag(fieldNumber, format: WireFormat.WireFormatFixed64)
        writeDoubleNoTag(aValue)
    }
    
    public func writeFloatNoTag(value:Float)
    {
        var convertValue = value
        var returnValue:Int32 = 0
        WireFormat.convertTypes(convertValue: convertValue, retValue: &returnValue)
        writeRawLittleEndian32(returnValue)
    }
    
    public func writeFloat(fieldNumber:Int32, value aValue:Float)
    {
        writeTag(fieldNumber, format: WireFormat.WireFormatFixed32)
        writeFloatNoTag(aValue)
    }
    
    public func writeUInt64NoTag(value:UInt64)
    {
        var retvalue:Int64 = 0
        WireFormat.convertTypes(convertValue: value, retValue: &retvalue)
        writeRawVarint64(retvalue)
    }
    
    public func writeUInt64(fieldNumber:Int32, value:UInt64)
    {
        writeTag(fieldNumber, format:WireFormat.WireFormatVarint)
        writeUInt64NoTag(value)
    }
    
    public func writeInt64NoTag(value:Int64)
    {
        writeRawVarint64(value)
    }
    
    public func writeInt64(fieldNumber:Int32, value aValue:Int64)
    {
        writeTag(fieldNumber, format: WireFormat.WireFormatVarint)
        writeInt64NoTag(aValue)
    }
    
    public func writeInt32NoTag(value:Int32)
    {
        if (value >= 0) {
            writeRawVarint32(value)
        } else {

            writeRawVarint64(Int64(value))
        }
    }
    
    public func writeInt32(fieldNumber:Int32, value:Int32)
    {
        writeTag(fieldNumber, format: WireFormat.WireFormatVarint)
        writeInt32NoTag(value)
    }
    
    public func writeFixed64NoTag(value:UInt64)
    {
        var retvalue:Int64 = 0
        WireFormat.convertTypes(convertValue: value, retValue: &retvalue)
        writeRawLittleEndian64(retvalue)
    }
    
    public func writeFixed64(fieldNumber:Int32, value:UInt64)
    {
        writeTag(fieldNumber, format: WireFormat.WireFormatFixed64)
        writeFixed64NoTag(value)
    }
    
    public func writeFixed32NoTag(value:UInt32)
    {
        var retvalue:Int32 = 0
        WireFormat.convertTypes(convertValue: value, retValue: &retvalue)
        writeRawLittleEndian32(retvalue)
    }
    
    public func writeFixed32(fieldNumber:Int32, value:UInt32)
    {
        writeTag(fieldNumber, format:WireFormat.WireFormatFixed32)
        writeFixed32NoTag(value)
    }
    
    public func writeBoolNoTag(value:Bool)
    {
        writeRawByte(byte: value ? 1 : 0)
    }
    
    public func writeBool(fieldNumber:Int32, value:Bool)
    {
        writeTag(fieldNumber, format:WireFormat.WireFormatVarint)
        writeBoolNoTag(value)
    }
    
    public func writeStringNoTag(value:String)
    {        
        var result:[Byte] = [Byte]()
        result += value.utf8
        writeRawVarint32(Int32(result.count))
        writeRawData(result)
    }
    
    public func writeString(fieldNumber:Int32, value:String)
    {
        writeTag(fieldNumber, format: WireFormat.WireFormatLengthDelimited)
        writeStringNoTag(value)
    }
    
    public func writeGroupNoTag(fieldNumber:Int32, value:Message)
    {
        value.writeToCodedOutputStream(self)
        writeTag(fieldNumber, format: WireFormat.WireFormatEndGroup)
    }
    
    public func writeGroup(fieldNumber:Int32, value:Message)
    {
        writeTag(fieldNumber, format: WireFormat.WireFormatStartGroup)
        writeGroupNoTag(fieldNumber, value: value)
    }
    
    public func writeUnknownGroupNoTag(fieldNumber:Int32, value:UnknownFieldSet) {
        value.writeToCodedOutputStream(self)
        writeTag(fieldNumber, format:WireFormat.WireFormatEndGroup)
    }
    
    public func writeUnknownGroup(fieldNumber:Int32, value:UnknownFieldSet)
    {
        writeTag(fieldNumber, format:WireFormat.WireFormatStartGroup)
        writeUnknownGroupNoTag(fieldNumber, value:value)
    }
    
    public func writeMessageNoTag(value:Message)
    {
        writeRawVarint32(value.serializedSize())
        value.writeToCodedOutputStream(self)
    }
    
    public func writeMessage(fieldNumber:Int32, value:Message)
    {
        writeTag(fieldNumber, format: WireFormat.WireFormatLengthDelimited)
        writeMessageNoTag(value)
    }
    
    public func writeDataNoTag(data:[Byte]?)
    {
        writeRawVarint32(Int32(data!.count))
        writeRawData(data!)
    }
    
    public func writeData(fieldNumber:Int32, value:[Byte]?)
    {
        writeTag(fieldNumber, format: WireFormat.WireFormatLengthDelimited)
        writeDataNoTag(value)
    }
    
    public func writeUInt32NoTag(value:UInt32)
    {
        var retvalue:Int32 = 0
        WireFormat.convertTypes(convertValue: value, retValue: &retvalue)
        writeRawVarint32(retvalue)
    }
    
    public func writeUInt32(fieldNumber:Int32, value:UInt32)
    {
        writeTag(fieldNumber, format: WireFormat.WireFormatVarint)
        writeUInt32NoTag(value)
    }
    
    public func writeEnumNoTag(value:Int32)
    {
        writeRawVarint32(value)
    }
    
    public func writeEnum(fieldNumber:Int32, value:Int32)
    {
        writeTag(fieldNumber, format:WireFormat.WireFormatVarint)
        writeEnumNoTag(value)
    }
    
    public func writeSFixed32NoTag(value:Int32)
    {
        writeRawLittleEndian32(value)
    }
    
    public func writeSFixed32(fieldNumber:Int32, value:Int32)
    {
        writeTag(fieldNumber, format:WireFormat.WireFormatFixed32)
        writeSFixed32NoTag(value)
    }

    public func writeSFixed64NoTag(value:Int64)
    {
        writeRawLittleEndian64(value)
    }
    
    public func writeSFixed64(fieldNumber:Int32, value:Int64)
    {
        writeTag(fieldNumber, format:WireFormat.WireFormatFixed64)
        writeSFixed64NoTag(value)
    }
    
    public func writeSInt32NoTag(value:Int32) {
        writeRawVarint32(WireFormat.encodeZigZag32(value));
    }
    
    public func writeSInt32(fieldNumber:Int32, value:Int32)
    {
        writeTag(fieldNumber, format:WireFormat.WireFormatVarint)
        writeSInt32NoTag(value)
    }
    
    public func writeSInt64NoTag(value:Int64) {
        writeRawVarint64(WireFormat.encodeZigZag64(value));
    }
    
    public func writeSInt64(fieldNumber:Int32, value:Int64)
    {
        writeTag(fieldNumber, format:WireFormat.WireFormatVarint)
        writeSInt64NoTag(value)
    }
    
    public func writeMessageSetExtension(fieldNumber:Int32, value:Message)
    {
        writeTag(WireFormatMessage.WireFormatMessageSetItem.rawValue, format:WireFormat.WireFormatStartGroup)
        writeUInt32(WireFormatMessage.WireFormatMessageSetTypeId.rawValue, value:UInt32(fieldNumber))
        writeMessage(WireFormatMessage.WireFormatMessageSetMessage.rawValue, value: value)
        writeTag(WireFormatMessage.WireFormatMessageSetItem.rawValue, format:WireFormat.WireFormatEndGroup)
    }
    
    public func writeRawMessageSetExtension(fieldNumber:Int32, value:[Byte]?)
    {
        writeTag(WireFormatMessage.WireFormatMessageSetItem.rawValue, format:WireFormat.WireFormatStartGroup)
        writeUInt32(WireFormatMessage.WireFormatMessageSetTypeId.rawValue, value:UInt32(fieldNumber))
        writeData( WireFormatMessage.WireFormatMessageSetMessage.rawValue, value: value!)
        writeTag(WireFormatMessage.WireFormatMessageSetItem.rawValue, format:WireFormat.WireFormatEndGroup)
    }
    
    public func writeTag(fieldNumber:Int32, format:WireFormat)
    {
        writeRawVarint32(format.wireFormatMakeTag(fieldNumber))
    }
    
    public func writeRawLittleEndian32(value:Int32)
    {
        writeRawByte(byte:Byte(value & 0xFF))
        writeRawByte(byte:Byte((value >> 8) & 0xFF))
        writeRawByte(byte:Byte((value >> 16) & 0xFF))
        writeRawByte(byte:Byte((value >> 24) & 0xFF))
    }
    
    public func writeRawLittleEndian64(value:Int64)
    {
        writeRawByte(byte:Byte(value & 0xFF))
        writeRawByte(byte:Byte((value >> 8) & 0xFF))
        writeRawByte(byte:Byte((value >> 16) & 0xFF))
        writeRawByte(byte:Byte((value >> 24) & 0xFF))
        writeRawByte(byte:Byte((value >> 32) & 0xFF))
        writeRawByte(byte:Byte((value >> 40) & 0xFF))
        writeRawByte(byte:Byte((value >> 48) & 0xFF))
        writeRawByte(byte:Byte((value >> 56) & 0xFF))
    }
    
    
    public func writeRawVarint32(var value:Int32) {
        while (true) {
            if ((value & ~0x7F) == 0) {
                writeRawByte(byte:Byte(value))
                break
            } else
            {
                writeRawByte(byte: Byte((value & 0x7F) | 0x80))
                value = WireFormat.logicalRightShift32(value: value, spaces: 7)
            }
        }
    }
    
    public func writeRawVarint64(var value:Int64) {
        while (true) {
            if ((value & ~0x7F) == 0) {
                writeRawByte(byte:Byte(value))
                break;
            } else {
                writeRawByte(byte: Byte((value & 0x7F) | 0x80))
                value = WireFormat.logicalRightShift64(value: value, spaces: 7)
            }
        }
    }
}