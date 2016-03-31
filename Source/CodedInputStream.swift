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

let DEFAULT_RECURSION_LIMIT:Int32 = 64
let DEFAULT_SIZE_LIMIT:Int32 = 64 << 20  // 64MB
let BUFFER_SIZE:Int32 = 4096



public class CodedInputStream
{
    public var buffer:NSMutableData
    private var input:NSInputStream!
    private var bufferSize:Int32 = 0
    private var bufferSizeAfterLimit:Int32 = 0
    private var bufferPos:Int32 = 0
    private var lastTag:Int32 = 0
    private var totalBytesRetired:Int32 = 0
    private var currentLimit:Int32 = 0
    private var recursionDepth:Int32 = 0
    private var recursionLimit:Int32 = 0
    private var sizeLimit:Int32 = 0
    public init (data aData:NSData)
    {
        buffer = NSMutableData(data: aData)
        bufferSize = Int32(buffer.length)
        currentLimit = INT_MAX
        recursionLimit = DEFAULT_RECURSION_LIMIT
        sizeLimit = DEFAULT_SIZE_LIMIT
    }
    public init (inputStream aInputStream:NSInputStream)
    {
        buffer = NSMutableData(length: Int(BUFFER_SIZE))!
        bufferSize = 0
        input = aInputStream
        input!.open()
        
        //
        currentLimit = INT_MAX
        recursionLimit = DEFAULT_RECURSION_LIMIT
        sizeLimit = DEFAULT_SIZE_LIMIT
    }
    private func isAtEnd() throws -> Bool {
        
        if bufferPos == bufferSize
        {
            if !(try refillBuffer(false))
            {
                return true
            }
        }
        return false
    }
    
    private func refillBuffer(mustSucceed:Bool) throws -> Bool
    {
        guard bufferPos >= bufferSize else
        {
            throw ProtocolBuffersError.IllegalState("RefillBuffer called when buffer wasn't empty.")
        }
        
        if (totalBytesRetired + bufferSize == currentLimit) {
            guard !mustSucceed else
            {
                throw ProtocolBuffersError.InvalidProtocolBuffer("Truncated Message")
            }
            return false
        }
        
        totalBytesRetired += bufferSize
        
        bufferPos = 0
        
        bufferSize = 0
        
        
        if input != nil
        {
            let pointer = UnsafeMutablePointer<UInt8>(buffer.mutableBytes)
            bufferSize = Int32(input!.read(pointer, maxLength:buffer.length))
            
        }
        
        if bufferSize <= 0
        {
            bufferSize = 0
            
            guard !mustSucceed else
            {
                throw ProtocolBuffersError.InvalidProtocolBuffer("Truncated Message")
            }
            return false
        }
        else
        {
            recomputeBufferSizeAfterLimit()
            let totalBytesRead:Int32 = totalBytesRetired + bufferSize + bufferSizeAfterLimit
            
            guard totalBytesRead <= sizeLimit || totalBytesRead >= 0 else {
                throw ProtocolBuffersError.InvalidProtocolBuffer("Size Limit Exceeded")
            }
            return true
        }
    }
    
    
    public func readRawData(size:Int32) throws -> NSData {
        
        guard size >= 0 else {
            throw ProtocolBuffersError.InvalidProtocolBuffer("Negative Size")
        }
        
        if (totalBytesRetired + bufferPos + size > currentLimit) {
            try skipRawData(currentLimit - totalBytesRetired - bufferPos)
            throw ProtocolBuffersError.InvalidProtocolBuffer("Truncated Message")
        }
        
        if (size <= bufferSize - bufferPos) {
            let pointer = UnsafePointer<UInt8>(buffer.bytes)
            let data = NSData(bytes: pointer + Int(bufferPos), length: Int(size))
            bufferPos += size
            return data
        }
        else if (size < BUFFER_SIZE) {
            
            let bytes = NSMutableData(length: Int(size))!
            var pos:Int32 = bufferSize - bufferPos
            memcpy(bytes.mutableBytes, buffer.mutableBytes + Int(bufferPos), Int(pos))
            bufferPos = bufferSize
            
            try refillBuffer(true)
            
            while (size - pos > bufferSize)
            {
                memcpy(bytes.mutableBytes + Int(pos), buffer.mutableBytes, Int(bufferSize))
                pos += bufferSize
                bufferPos = bufferSize
                try refillBuffer(true)
            }
            
            memcpy(bytes.mutableBytes + Int(pos), buffer.mutableBytes, Int(size - pos))
            bufferPos = size - pos
            return bytes
            
        }
        else
        {
            
            let originalBufferPos:Int32 = bufferPos
            let originalBufferSize:Int32 = bufferSize
            
            totalBytesRetired += bufferSize
            bufferPos = 0
            bufferSize = 0
            
            var sizeLeft:Int32 = size - (originalBufferSize - originalBufferPos)
            var chunks:Array<NSData> = Array<NSData>()
            
            while (sizeLeft > 0) {
                let chunk = NSMutableData(length:Int(min(sizeLeft, BUFFER_SIZE)))!
                
                
                var pos:Int = 0
                while (pos < chunk.length) {
                    
                    var n:Int = 0
                    if input != nil {
                        
                        let pointer = UnsafeMutablePointer<UInt8>(chunk.mutableBytes)
                        n = input!.read(pointer + Int(pos), maxLength:chunk.length - Int(pos))
                    }
                    guard n > 0 else {
                        
                        throw ProtocolBuffersError.InvalidProtocolBuffer("Truncated Message")
                    }
                    totalBytesRetired += n
                    pos += n
                }
                sizeLeft -= chunk.length
                chunks.append(chunk)
            }
            
            
            let bytes = NSMutableData(length:Int(size))!
            var pos:Int = originalBufferSize - originalBufferPos
            memcpy(bytes.mutableBytes, buffer.mutableBytes + Int(originalBufferPos), pos)
            for chunk in chunks
            {
                memcpy(bytes.mutableBytes + pos, chunk.bytes, chunk.length)
                pos += chunk.length
            }
            
            return bytes
        }
    }

    
    
    public func skipRawData(size:Int32) throws
    {
        
        guard size >= 0 else {
            throw ProtocolBuffersError.InvalidProtocolBuffer("Negative Size")
        }
        
        if (totalBytesRetired + bufferPos + size > currentLimit) {
            
            try skipRawData(currentLimit - totalBytesRetired - bufferPos)
            throw ProtocolBuffersError.InvalidProtocolBuffer("Truncated Message")
        }
        
        if (size <= (bufferSize - bufferPos)) {
            bufferPos += size
        }
        else
        {
            var pos:Int32 = bufferSize - bufferPos
            totalBytesRetired += pos
            bufferPos = 0
            bufferSize = 0
            
            while (pos < size) {
                let data = NSMutableData(length: Int(size - pos))!
                
                var n:Int = 0
                
                if input == nil
                {
                    n = -1
                }
                else
                {
                    let pointer = UnsafeMutablePointer<UInt8>(data.mutableBytes)
                    n = input!.read(pointer, maxLength:Int(size - pos))
                }
                guard n > 0 else
                {
                    throw ProtocolBuffersError.InvalidProtocolBuffer("Truncated Message")
                }
                pos += n
                totalBytesRetired += n
            }
        }
    }
    
    public func readRawLittleEndian32() throws -> Int32
    {
        let b1:Int8 = try readRawByte()
        let b2:Int8 = try readRawByte()
        let b3:Int8 = try readRawByte()
        let b4:Int8 = try readRawByte()
        var result:Int32 = (Int32(b1) & 0xff)
        result |= ((Int32(b2) & 0xff) <<  8)
        result |= ((Int32(b3) & 0xff) << 16)
        result |= ((Int32(b4) & 0xff) << 24)
        return result
    }
    public  func readRawLittleEndian64() throws -> Int64
    {
        let b1:Int8 = try readRawByte()
        let b2:Int8 = try readRawByte()
        let b3:Int8 = try readRawByte()
        let b4:Int8 = try readRawByte()
        let b5:Int8 = try readRawByte()
        let b6:Int8 = try readRawByte()
        let b7:Int8 = try readRawByte()
        let b8:Int8 = try readRawByte()
        var result:Int64  = (Int64(b1) & 0xff)
        result |= ((Int64(b2) & 0xff) <<  8)
        result |= ((Int64(b3) & 0xff) << 16)
        result |= ((Int64(b4) & 0xff) << 24)
        result |= ((Int64(b5) & 0xff) << 32)
        result |= ((Int64(b6) & 0xff) << 40)
        result |= ((Int64(b7) & 0xff) << 48)
        result |= ((Int64(b8) & 0xff) << 56)
        
        return result
    }
    
    public func readTag() throws ->Int32
    {
        if (try isAtEnd())
        {
            lastTag = 0
            return 0
        }
        let tag = lastTag
        lastTag = try readRawVarint32()
        guard lastTag != 0 else
        {
            throw ProtocolBuffersError.InvalidProtocolBuffer("Invalid Tag: after tag \(tag)")
        }
        return lastTag
    }
    
    public func checkLastTagWas(value:Int32) throws
    {
        guard lastTag == value else
        {
            throw ProtocolBuffersError.InvalidProtocolBuffer("Invalid Tag: after tag \(lastTag)")
        }
    }
    
    public func skipField(tag:Int32) throws ->  Bool
    {
        let wireFormat = WireFormat.getTagWireType(tag)
        let format:WireFormat? = WireFormat(rawValue: wireFormat)
        
        guard let _ = format else {
            throw ProtocolBuffersError.InvalidProtocolBuffer("Invalid Wire Type")
        }
        switch format! {
        case .Varint:
            try readInt32()
            return true
        case .Fixed64:
            try readRawLittleEndian64()
            return true
        case .LengthDelimited:
            try skipRawData(try readRawVarint32())
            return true
        case .StartGroup:
            try skipMessage()
            try checkLastTagWas(WireFormat.EndGroup.makeTag(WireFormat.getTagFieldNumber(tag)))
            return true
        case .EndGroup:
            return false
        case .Fixed32:
            try readRawLittleEndian32()
            return true
        default:
            throw ProtocolBuffersError.InvalidProtocolBuffer("Invalid Wire Type")
        }
        
    }
    private func skipMessage() throws
    {
        while (true)
        {
            let tag:Int32 = try readTag()
            let fieldSkip = try skipField(tag)
            if tag == 0 || !fieldSkip
            {
                break
            }
        }
    }
    
    public func readDouble() throws -> Double
    {
        let convert:Int64 = try readRawLittleEndian64()
        var result:Double = 0.0
        result = WireFormat.convertTypes(convertValue: convert, defaultValue: result)
        return result
    }
    
    public func readFloat() throws -> Float
    {
        let convert:Int32 = try readRawLittleEndian32()
        var result:Float = 0.0
        result = WireFormat.convertTypes(convertValue: convert, defaultValue: result)
        return result
    }
    
    public func readUInt64() throws -> UInt64
    {
        var retvalue:UInt64 = 0
        retvalue = WireFormat.convertTypes(convertValue: try readRawVarint64(), defaultValue:retvalue)
        return retvalue
    }
    
    public func readInt64() throws -> Int64
    {
        return try readRawVarint64()
    }
    
    public func readInt32() throws -> Int32
    {
        
        return try readRawVarint32()
    }
    
    public func readFixed64() throws -> UInt64
    {
        var retvalue:UInt64 = 0
        retvalue = WireFormat.convertTypes(convertValue: try readRawLittleEndian64(), defaultValue:retvalue)
        return retvalue
    }
    
    public func readFixed32() throws -> UInt32
    {
        var retvalue:UInt32 = 0
        retvalue = WireFormat.convertTypes(convertValue: try readRawLittleEndian32(), defaultValue:retvalue)
        return retvalue
    }
    
    public func readBool() throws ->Bool
    {
        return try readRawVarint32() != 0
    }
    
    public func readRawByte() throws -> Int8
    {
        if (bufferPos == bufferSize)
        {
            try refillBuffer(true)
        }
        let pointer = UnsafeMutablePointer<Int8>(buffer.mutableBytes)
        let res = pointer[Int(bufferPos)]
        bufferPos+=1
        return res
    }
    
    public class func readRawVarint32(firstByte:UInt8, inputStream:NSInputStream) throws -> Int32
    {
        if ((Int32(firstByte) & 0x80) == 0) {
            return Int32(firstByte)
        }
        var result:Int32 = Int32(firstByte) & 0x7f
        var offset:Int32 = 7
        while offset < 32 {
            var b:UInt8 = UInt8()
            guard inputStream.read(&b, maxLength: 1) > 0 else {
                throw ProtocolBuffersError.InvalidProtocolBuffer("Truncated Message")
            }
            
            result |= (Int32(b) & 0x7f) << offset
            if ((b & 0x80) == 0) {
                return result
            }
            offset += 7
        }
        
        while offset < 64 {
            var b:UInt8 = UInt8()
            guard inputStream.read(&b, maxLength: 1) > 0 else {
                throw ProtocolBuffersError.InvalidProtocolBuffer("Truncated Message")
            }
            
            if ((b & 0x80) == 0) {
                return result
            }
            offset += 7
        }
        
        throw ProtocolBuffersError.InvalidProtocolBuffer("Truncated Message")
    }

    
    public func readRawVarint32() throws -> Int32
    {
        var tmp : Int8 = try readRawByte();
        if (tmp >= 0) {
            return Int32(tmp);
        }
        var result : Int32 = Int32(tmp) & 0x7f;
        tmp = try readRawByte()
        if (tmp >= 0) {
            result |= Int32(tmp) << 7;
        } else {
            result |= (Int32(tmp) & 0x7f) << 7;
            tmp = try readRawByte()
            if (tmp >= 0) {
                result |= Int32(tmp) << 14;
            } else {
                result |= (Int32(tmp) & 0x7f) << 14;
                tmp = try readRawByte()
                if (tmp >= 0) {
                    result |= Int32(tmp) << 21;
                } else {
                    result |= (Int32(tmp) & 0x7f) << 21;
                    tmp = try readRawByte()
                    result |= (Int32(tmp) << 28);
                    if (tmp < 0) {
                        // Discard upper 32 bits.
                        for _ in 0..<5 {
                            let byte = try readRawByte()
                            if (byte >= 0) {
                                return result;
                            }
                        }
                        
                        throw ProtocolBuffersError.InvalidProtocolBuffer("MalformedVarint")
                    }
                }
            }
        }
        return result;
    }
    
    public func readRawVarint64() throws -> Int64
    {
        var shift:Int64 = 0
        var result:Int64 = 0
        while (shift < 64) {
            let b = try readRawByte()
            result |= (Int64(b & 0x7F) << shift)
            if ((Int32(b) & 0x80) == 0) {
                return result
            }
            shift += 7
        }
        throw ProtocolBuffersError.InvalidProtocolBuffer("MalformedVarint")
    }
    
    public func readString() throws -> String
    {
        let size:Int32 = try readRawVarint32()
        if (size <= (bufferSize - bufferPos) && size > 0)
        {
            let result = String(bytesNoCopy: (buffer.mutableBytes + Int(bufferPos)), length: Int(size), encoding: NSUTF8StringEncoding, freeWhenDone: false)
            bufferPos += size
            return result!
        }
        else
        {
            let data = try readRawData(size)
            
            return String(data: data, encoding: NSUTF8StringEncoding)!
        }
    }
    
    public func readData() throws -> NSData
    {
        let size = try readRawVarint32()
        if (size < bufferSize - bufferPos && size > 0)
        {
            let data = NSData(bytes: buffer.bytes + Int(bufferPos), length: Int(size))
            bufferPos += size
            return data
        }
        else
        {
            return try readRawData(size)
        }
    }
    
    public func readUInt32() throws -> UInt32
    {
        
        let value:Int32 = try readRawVarint32()
        var retvalue:UInt32 = 0
        retvalue = WireFormat.convertTypes(convertValue: value, defaultValue:retvalue)
        return retvalue
    }
    
    public func readEnum() throws -> Int32 {
        return try readRawVarint32()
    }
    
    public func readSFixed32() throws -> Int32
    {
        return try readRawLittleEndian32()
    }
    
    public func readSFixed64() throws -> Int64
    {
        return try readRawLittleEndian64()
    }
    public func readSInt32() throws -> Int32 {
        return WireFormat.decodeZigZag32(try readRawVarint32())
    }
    
    public func readSInt64() throws -> Int64
    {
        return WireFormat.decodeZigZag64(try readRawVarint64())
    }
    public func setRecursionLimit(limit:Int32) throws -> Int32 {
        
        guard limit >= 0 else {
            throw ProtocolBuffersError.IllegalArgument("Recursion limit cannot be negative")
        }
        let oldLimit:Int32 = recursionLimit
        recursionLimit = limit
        return oldLimit
    }
    public func setSizeLimit(limit:Int32) throws -> Int32
    {
        guard limit >= 0 else {
            throw ProtocolBuffersError.IllegalArgument("Recursion limit cannot be negative")
        }
        let oldLimit:Int32 = sizeLimit
        sizeLimit = limit
        return oldLimit
    }
    
    private func resetSizeCounter()
    {
        totalBytesRetired = 0
    }
    
    private func recomputeBufferSizeAfterLimit()
    {
        bufferSize += bufferSizeAfterLimit
        let bufferEnd:Int32 = totalBytesRetired + bufferSize
        if (bufferEnd > currentLimit)
        {
            bufferSizeAfterLimit = bufferEnd - currentLimit
            bufferSize -= bufferSizeAfterLimit
        }
        else
        {
            bufferSizeAfterLimit = 0
        }
    }
    
    public func pushLimit(byteLimit:Int32) throws -> Int32
    {
        guard byteLimit >= 0 else {
            throw ProtocolBuffersError.InvalidProtocolBuffer("Negative Size")
        }
        let newByteLimit = byteLimit + totalBytesRetired + bufferPos
        let oldLimit = currentLimit
        guard newByteLimit <= oldLimit else {
            throw ProtocolBuffersError.InvalidProtocolBuffer("MalformedVarint")
        }
        currentLimit = newByteLimit
        recomputeBufferSizeAfterLimit()
        return oldLimit
    }
    
    
    
    public func popLimit(oldLimit:Int32)
    {
        currentLimit = oldLimit
        recomputeBufferSizeAfterLimit()
    }
    
    public func bytesUntilLimit() ->Int32
    {
        if (currentLimit == INT_MAX)
        {
            return -1
        }
        
        let currentAbsolutePosition:Int32 = totalBytesRetired + bufferPos
        return currentLimit - currentAbsolutePosition
    }
    
    
    public func readGroup(fieldNumber:Int32, builder:MessageBuilder, extensionRegistry:ExtensionRegistry) throws
    {
        
        guard recursionDepth < recursionLimit else {
            throw ProtocolBuffersError.InvalidProtocolBuffer("Recursion Limit Exceeded")
        }
        recursionDepth+=1
        try builder.mergeFromCodedInputStream(self, extensionRegistry:extensionRegistry)
        try checkLastTagWas(WireFormat.EndGroup.makeTag(fieldNumber))
        recursionDepth-=1
    }
    public func readUnknownGroup(fieldNumber:Int32, builder:UnknownFieldSet.Builder) throws
    {
        guard recursionDepth < recursionLimit else {
            throw ProtocolBuffersError.InvalidProtocolBuffer("Recursion Limit Exceeded")
        }
        recursionDepth+=1
        try builder.mergeFromCodedInputStream(self)
        try checkLastTagWas(WireFormat.EndGroup.makeTag(fieldNumber))
        recursionDepth-=1
    }

    public func readMessage(builder:MessageBuilder, extensionRegistry:ExtensionRegistry) throws {
        let length = try readRawVarint32()
        guard recursionDepth < recursionLimit else {
            throw ProtocolBuffersError.InvalidProtocolBuffer("Recursion Limit Exceeded")
        }
        let oldLimit =  try pushLimit(length)
        recursionDepth+=1
        try builder.mergeFromCodedInputStream(self, extensionRegistry:extensionRegistry)
        try checkLastTagWas(0)
        recursionDepth-=1
        popLimit(oldLimit)
    }
    
}


