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

class CodedOutputStream
{
    var output:NSOutputStream?
    var buffer:RingBuffer
    
    init (output aOutput:NSOutputStream?, data:[Byte])
    {
        output = aOutput
        buffer = RingBuffer(data:data)
    }
  
    init(output aOutput:NSOutputStream?, bufferSize:Int32?)
    {
        var data = [Byte](count: Int(bufferSize!), repeatedValue: 0)
        output = aOutput
        buffer = RingBuffer(data: data)
    }
   
    init(output:NSOutputStream?)
    {
        var data = [Byte](count: Int(DEFAULT_BUFFER_SIZE), repeatedValue: 0)
        self.output = output
        buffer = RingBuffer(data: data)
    }
    
    init(data aData:[Byte]?)
    {
        buffer = RingBuffer(data: aData!)
    }
    
    func flush()
    {
        buffer.flushToOutputStream(output!)
    }
   
    func writeRawByte(byte aByte:Byte)
    {
        while (!buffer.appendByte(byte: aByte))
        {
            flush()
        }
    }
    
    func writeRawData(data:[Byte])
    {
        writeRawData(data, offset:0, length: Int32(data.count))
    
    }
    func writeRawData(data:[Byte], var offset aOffset:Int32, var length aLength:Int32)
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
    
  
    
    func writeDoubleNoTag(value:Double)
    {
        var convertValue = value
        var returnValue:Int64 = 0
        WireFormat.convertTypes(convertValue: value, retValue: &returnValue)
        writeRawLittleEndian64(returnValue)
    }
    
    func writeDouble(fieldNumber:Int32, value aValue:Double)
    {
        writeTag(fieldNumber, format: WireFormat.WireFormatFixed64)
        writeDoubleNoTag(aValue)
    }
    
    func writeFloatNoTag(value:Float)
    {
        var convertValue = value
        var returnValue:Int32 = 0
        WireFormat.convertTypes(convertValue: convertValue, retValue: &returnValue)
        writeRawLittleEndian32(returnValue)
    }
    
    func writeFloat(fieldNumber:Int32, value aValue:Float)
    {
        writeTag(fieldNumber, format: WireFormat.WireFormatFixed32)
        writeFloatNoTag(aValue)
    }
    
    func writeUInt64NoTag(value:Int64)
    {
        writeRawVarint64(value)
    }
    
    func writeUInt64(fieldNumber:Int32, value:Int64)
    {
        writeTag(fieldNumber, format:WireFormat.WireFormatVarint)
        writeUInt64NoTag(value)
    }
    
    func writeInt64NoTag(value:Int64)
    {
        writeRawVarint64(value)
    }
    
    func writeInt64(fieldNumber:Int32, value aValue:Int64)
    {
        writeTag(fieldNumber, format: WireFormat.WireFormatVarint)
        writeInt64NoTag(aValue)
    }
    
    func writeInt32NoTag(value:Int32)
    {
        if (value >= 0) {
            writeRawVarint32(value)
        } else {

            writeRawVarint64(Int64(value))
        }
    }
    
    func writeInt32(fieldNumber:Int32, value:Int32)
    {
        writeTag(fieldNumber, format: WireFormat.WireFormatVarint)
        writeInt32NoTag(value)
    }
    
    func writeFixed64NoTag(value:Int64)
    {
        writeRawLittleEndian64(value)
    }
    
    func writeFixed64(fieldNumber:Int32, value:Int64)
    {
        writeTag(fieldNumber, format: WireFormat.WireFormatFixed64)
        writeFixed64NoTag(value)
    }
    
    func writeFixed32NoTag(value:Int32)
    {
        writeRawLittleEndian32(value)
    }
    
    func writeFixed32(fieldNumber:Int32, value:Int32)
    {
        writeTag(fieldNumber, format:WireFormat.WireFormatFixed32)
        writeFixed32NoTag(value)
    }
    
    func writeBoolNoTag(value:Bool)
    {
        writeRawByte(byte: value ? 1 : 0)
    }
    
    func writeBool(fieldNumber:Int32, value:Bool)
    {
        writeTag(fieldNumber, format:WireFormat.WireFormatVarint)
        writeBoolNoTag(value)
    }
    
    func writeStringNoTag(value:String)
    {        
        var result:[Byte] = [Byte]()
        result += value.utf8
        writeRawVarint32(Int32(result.count))
        writeRawData(result)
    }
    
    func writeString(fieldNumber:Int32, value:String)
    {
        writeTag(fieldNumber, format: WireFormat.WireFormatLengthDelimited)
        writeStringNoTag(value)
    }
    
    func writeGroupNoTag(fieldNumber:Int32, value:Message)
    {
        value.writeToCodedOutputStream(self)
        writeTag(fieldNumber, format: WireFormat.WireFormatEndGroup)
    }
    
    func writeGroup(fieldNumber:Int32, value:Message)
    {
        writeTag(fieldNumber, format: WireFormat.WireFormatStartGroup)
        writeGroupNoTag(fieldNumber, value: value)
    }
    
    func writeUnknownGroupNoTag(fieldNumber:Int32, value:UnknownFieldSet) {
        value.writeToCodedOutputStream(self)
        writeTag(fieldNumber, format:WireFormat.WireFormatEndGroup)
    }
    func writeUnknownGroup(fieldNumber:Int32, value:UnknownFieldSet)
    {
        writeTag(fieldNumber, format:WireFormat.WireFormatStartGroup)
        writeUnknownGroupNoTag(fieldNumber, value:value)
    }
    
    func writeMessageNoTag(value:Message)
    {
        writeRawVarint32(value.serializedSize())
        value.writeToCodedOutputStream(self)
    }
    
    func writeMessage(fieldNumber:Int32, value:Message)
    {
        writeTag(fieldNumber, format: WireFormat.WireFormatLengthDelimited)
        writeMessageNoTag(value)
    }
    
    func writeDataNoTag(data:[Byte]?)
    {
        writeRawVarint32(Int32(data!.count))
        writeRawData(data!)
    }
    
    func writeData(fieldNumber:Int32, value:[Byte]?)
    {
        writeTag(fieldNumber, format: WireFormat.WireFormatLengthDelimited)
        writeDataNoTag(value)
    }
    
    func writeUInt32NoTag(value:Int32)
    {
        writeRawVarint32(value)
    }
    
    func writeUInt32(fieldNumber:Int32, value:Int32)
    {
        writeTag(fieldNumber, format: WireFormat.WireFormatVarint)
        writeUInt32NoTag(value)
    }
    
    func writeEnumNoTag(value:Int32)
    {
        writeRawVarint32(value)
    }
    
    func writeEnum(fieldNumber:Int32, value:Int32)
    {
        writeTag(fieldNumber, format:WireFormat.WireFormatVarint)
        writeEnumNoTag(value)
    }
    
    func writeSFixed32NoTag(value:Int32)
    {
        writeRawLittleEndian32(value)
    }
    
    func writeSFixed32(fieldNumber:Int32, value:Int32)
    {
        writeTag(fieldNumber, format:WireFormat.WireFormatFixed32)
        writeSFixed32NoTag(value)
    }

    func writeSFixed64NoTag(value:Int64)
    {
        writeRawLittleEndian64(value)
    }
    
    func writeSFixed64(fieldNumber:Int32, value:Int64)
    {
        writeTag(fieldNumber, format:WireFormat.WireFormatFixed64)
        writeSFixed64NoTag(value)
    }
    
    func writeSInt32NoTag(value:Int32) {
        writeRawVarint32(WireFormat.encodeZigZag32(value));
    }
    
    func writeSInt32(fieldNumber:Int32, value:Int32)
    {
        writeTag(fieldNumber, format:WireFormat.WireFormatVarint)
        writeSInt32NoTag(value)
    }
    
    func writeSInt64NoTag(value:Int64) {
        writeRawVarint64(WireFormat.encodeZigZag64(value));
    }
    
    func writeSInt64(fieldNumber:Int32, value:Int64)
    {
        writeTag(fieldNumber, format:WireFormat.WireFormatVarint)
        writeSInt64NoTag(value)
    }
    
    func writeMessageSetExtension(fieldNumber:Int32, value:Message)
    {
        writeTag(WireFormatMessage.WireFormatMessageSetItem.toRaw(), format:WireFormat.WireFormatStartGroup)
        writeUInt32(WireFormatMessage.WireFormatMessageSetTypeId.toRaw(), value:fieldNumber)
        writeMessage(WireFormatMessage.WireFormatMessageSetMessage.toRaw(), value: value)
        writeTag(WireFormatMessage.WireFormatMessageSetItem.toRaw(), format:WireFormat.WireFormatEndGroup)
    }
    
    func writeRawMessageSetExtension(fieldNumber:Int32, value:[Byte]?)
    {
        writeTag(WireFormatMessage.WireFormatMessageSetItem.toRaw(), format:WireFormat.WireFormatStartGroup)
        writeUInt32(WireFormatMessage.WireFormatMessageSetTypeId.toRaw(), value:fieldNumber)
        writeData( WireFormatMessage.WireFormatMessageSetMessage.toRaw(), value: value!)
        writeTag(WireFormatMessage.WireFormatMessageSetItem.toRaw(), format:WireFormat.WireFormatEndGroup)
    }
    
    func writeTag(fieldNumber:Int32, format:WireFormat)
    {
        writeRawVarint32(format.wireFormatMakeTag(fieldNumber))
    }
    
    func writeRawLittleEndian32(value:Int32)
    {
        writeRawByte(byte:Byte(value & 0xFF))
        writeRawByte(byte:Byte((value >> 8) & 0xFF))
        writeRawByte(byte:Byte((value >> 16) & 0xFF))
        writeRawByte(byte:Byte((value >> 24) & 0xFF))
    }
    
    func writeRawLittleEndian64(value:Int64)
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
    
    
    func writeRawVarint32(var value:Int32) {
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
    
    func writeRawVarint64(var value:Int64) {
        while (true) {
            if ((value & ~0x7F) == 0) {
                writeRawByte(byte:Byte(value))
                return;
            } else {
                writeRawByte(byte: Byte((value & 0x7F) | 0x80))
                value = WireFormat.logicalRightShift64(value: value, spaces: 7)
            }
        }
    }
}