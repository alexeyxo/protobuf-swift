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
    private func isAtEnd() ->Bool {
        return ((bufferPos == bufferSize) && !refillBuffer(false))
    }
    
    private func refillBuffer(mustSucceed:Bool) -> Bool
    {
        if bufferPos < bufferSize
        {
            NSException(name:"IllegalState", reason:"refillBuffer called when buffer wasn't empty.", userInfo: nil).raise()
        }
        
        if (totalBytesRetired + bufferSize == currentLimit) {
            if (mustSucceed) {
                NSException(name:"InvalidProtocolBuffer:", reason:"truncatedMessage", userInfo: nil).raise()
                
            }
            else
            {
                return false
            }
        }
        
        totalBytesRetired += bufferSize
        
        bufferPos = 0
        
        bufferSize = 0
        
        
        if input != nil
        {
            var pointer = UnsafeMutablePointer<UInt8>(buffer.mutableBytes)
            bufferSize = Int32(input!.read(pointer, maxLength:buffer.length))
            
        }
        
        if bufferSize <= 0
        {
            bufferSize = 0
            if mustSucceed
            {
                NSException(name:"InvalidProtocolBuffer:", reason:"truncatedMessage", userInfo: nil).raise()
            }
            else
            {
                return false
            }
        }
        else
        {
            recomputeBufferSizeAfterLimit()
            var totalBytesRead:Int32 = totalBytesRetired + bufferSize + bufferSizeAfterLimit
            if (totalBytesRead > sizeLimit || totalBytesRead < 0)
            {
                NSException(name:"InvalidProtocolBuffer:", reason:"sizeLimitExceeded", userInfo: nil).raise()
            }
            return true
        }
        
        return false
    }
    
    
    public func readRawData(size:Int32) -> NSData {
        if (size < 0) {
            NSException(name:"InvalidProtocolBuffer", reason:"negativeSize", userInfo: nil).raise()
            
        }
        
        if (totalBytesRetired + bufferPos + size > currentLimit) {
            skipRawData(currentLimit - totalBytesRetired - bufferPos)
            NSException(name:"InvalidProtocolBuffer", reason:"truncatedMessage", userInfo: nil).raise()
        }
        
        if (size <= bufferSize - bufferPos) {
            var pointer = UnsafePointer<UInt8>(buffer.bytes)
            var data = NSData(bytes: pointer + Int(bufferPos), length: Int(size))
            bufferPos += size
            return data
        }
        else if (size < BUFFER_SIZE) {
            
            var bytes = NSMutableData(length: Int(size))!
            var pos:Int32 = bufferSize - bufferPos
            memcpy(bytes.mutableBytes, buffer.mutableBytes + Int(bufferPos), Int(pos))
            bufferPos = bufferSize
            
            refillBuffer(true)
            
            while (size - pos > bufferSize)
            {
                memcpy(bytes.mutableBytes + Int(pos), buffer.mutableBytes, Int(bufferSize))
                pos += bufferSize
                bufferPos = bufferSize
                refillBuffer(true)
            }
            
            memcpy(bytes.mutableBytes + Int(pos), buffer.mutableBytes, Int(size - pos))
            bufferPos = size - pos
            return bytes
            
        }
        else
        {
            
            var originalBufferPos:Int32 = bufferPos
            var originalBufferSize:Int32 = bufferSize
            
            totalBytesRetired += bufferSize
            bufferPos = 0
            bufferSize = 0
            
            var sizeLeft:Int32 = size - (originalBufferSize - originalBufferPos)
            var chunks:Array<NSData> = Array<NSData>()
            
            while (sizeLeft > 0) {
                var chunk = NSMutableData(length:Int(min(sizeLeft, BUFFER_SIZE)))!
                
                
                var pos:Int = 0
                while (pos < chunk.length) {
                    
                    var n:Int = 0
                    if input != nil {
                        
                        var pointer = UnsafeMutablePointer<UInt8>(chunk.mutableBytes)
                        n = input!.read(pointer + Int(pos), maxLength:chunk.length - Int(pos))
                    }
                    if (n <= 0) {
                        NSException(name:"InvalidProtocolBuffer", reason:"truncatedMessage", userInfo: nil).raise()
                    }
                    totalBytesRetired += n
                    pos += n
                }
                sizeLeft -= chunk.length
                chunks.append(chunk)
            }
            
            
            var bytes = NSMutableData(length:Int(size))!
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

    
    
    public func skipRawData(var size:Int32)
    {
        
        if (size < 0) {
            NSException(name:"InvalidProtocolBuffer", reason:"negativeSize", userInfo: nil).raise()
        }
        
        if (totalBytesRetired + bufferPos + size > currentLimit) {
            
            skipRawData(currentLimit - totalBytesRetired - bufferPos)
            NSException(name:"InvalidProtocolBuffer", reason:"truncatedMessage", userInfo: nil).raise()
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
                var data = NSMutableData(length: Int(size - pos))!
                
                var n:Int = 0
                
                if input == nil
                {
                    n = -1
                }
                else
                {
                    var pointer = UnsafeMutablePointer<UInt8>(data.mutableBytes)
                    n = input!.read(pointer, maxLength:Int(size - pos))
                }
                if (n <= 0) {
                    NSException(name:"InvalidProtocolBuffer", reason:"truncatedMessage", userInfo: nil).raise()
                }
                pos += n
                totalBytesRetired += n
            }
        }
    }
    
    public func readRawLittleEndian32() -> Int32
    {
        var b1:UInt8 = readRawByte()
        var b2:UInt8 = readRawByte()
        var b3:UInt8 = readRawByte()
        var b4:UInt8 = readRawByte()
        var result:Int32 = (Int32(b1) & 0xff)
        result |= ((Int32(b2) & 0xff) <<  8)
        result |= ((Int32(b3) & 0xff) << 16)
        result |= ((Int32(b4) & 0xff) << 24)
        return result
    }
    public  func readRawLittleEndian64() -> Int64
    {
        var b1:UInt8 = readRawByte()
        var b2:UInt8 = readRawByte()
        var b3:UInt8 = readRawByte()
        var b4:UInt8 = readRawByte()
        var b5:UInt8 = readRawByte()
        var b6:UInt8 = readRawByte()
        var b7:UInt8 = readRawByte()
        var b8:UInt8 = readRawByte()
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
    
    
    public func readTag()->Int32
    {
        if (isAtEnd())
        {
            lastTag = 0
            return 0
        }
        var tag = lastTag
        lastTag = readRawVarint32()
        if lastTag == 0
        {
            NSException(name:"InvalidProtocolBuffer", reason:"Invalid Tag: after tag \(tag)", userInfo: nil).raise()
        }
        return lastTag
    }
    
    public func checkLastTagWas(value:Int32)
    {
        if lastTag != value
        {
            NSException(name:"InvalidProtocolBuffer", reason:"Invalid Tag: last tag \(lastTag)", userInfo: nil).raise()
        }
    }
    
    public func skipField(tag:Int32) -> Bool
    {
        var wireFormat = WireFormat.wireFormatGetTagWireType(tag)
        if (WireFormat(rawValue:wireFormat) == WireFormat.WireFormatVarint)
        {
            readInt32()
            return true
        }
        else if (WireFormat(rawValue:wireFormat) == WireFormat.WireFormatFixed64)
        {
            readRawLittleEndian64()
            return true
        }
        else if (WireFormat(rawValue:wireFormat) == WireFormat.WireFormatLengthDelimited)
        {
            skipRawData(readRawVarint32())
            return true
        }
        else if (WireFormat(rawValue:wireFormat) == WireFormat.WireFormatStartGroup)
        {
            skipMessage()
            checkLastTagWas(WireFormat.WireFormatEndGroup.wireFormatMakeTag(WireFormat.wireFormatGetTagFieldNumber(tag)))
            return true
        }
        else if (WireFormat(rawValue:wireFormat) == WireFormat.WireFormatEndGroup)
        {
            return false
        }
        else if (WireFormat(rawValue:wireFormat) == WireFormat.WireFormatFixed32)
        {
            readRawLittleEndian32()
            return true
        }
        else
        {
            NSException(name:"InvalidProtocolBuffer", reason:"Invalid Wire Type", userInfo: nil).raise()
        }
        
        return false
        
    }
    private func skipMessage()
    {
        while (true)
        {
            var tag:Int32 = readTag()
            if tag == 0 || !skipField(tag)
            {
                break
            }
        }
    }
    
    public func readDouble() -> Double
    {
        var convert:Int64 = readRawLittleEndian64()
        var result:Double = 0
        WireFormat.convertTypes(convertValue: convert, retValue: &result)
        return result
    }
    
    public func readFloat() -> Float
    {
        var convert:Int32 = readRawLittleEndian32()
        var result:Float = 0
        WireFormat.convertTypes(convertValue: convert, retValue: &result)
        return result
    }
    
    public func readUInt64() -> UInt64
    {
        var retvalue:UInt64 = 0
        WireFormat.convertTypes(convertValue: readRawVarint64(), retValue: &retvalue)
        return retvalue
    }
    
    public func readInt64() -> Int64
    {
        return readRawVarint64()
    }
    
    public func readInt32() -> Int32
    {
        
        return readRawVarint32()
    }
    
    public func readFixed64() -> UInt64
    {
        var retvalue:UInt64 = 0
        WireFormat.convertTypes(convertValue: readRawLittleEndian64(), retValue: &retvalue)
        return retvalue
    }
    
    public func readFixed32() -> UInt32
    {
        var retvalue:UInt32 = 0
        WireFormat.convertTypes(convertValue: readRawLittleEndian32(), retValue: &retvalue)
        return retvalue
    }
    
    public func readBool() ->Bool
    {
        return readRawVarint32() != 0
    }
    
    public func readRawByte() ->UInt8
    {
        if (bufferPos == bufferSize)
        {
            refillBuffer(true)
        }
        var pointer = UnsafeMutablePointer<UInt8>(buffer.mutableBytes)
        var res = pointer[Int(bufferPos++)]
        return res
    }
    
    public func readRawVarint32() -> Int32
    {
        //C++ protobuf varints
        var b:UInt8 = readRawByte()
        var result:Int32 = Int32(b)
        if (b & 0x80) == 0 {
            return result
        }
        result -= 0x80
        b = readRawByte()
        result += Int32(b) <<  7
        if (b & 0x80) == 0 {
            return result
        }
        result -= (0x80 << 7)
        b = readRawByte()
        result += Int32(b) << 14
        if (b & 0x80) == 0 {
            return result
        }
        result -= Int32(0x80 << 14)
        b = readRawByte()
        result += Int32(b) << 21
        if (b & 0x80) == 0 {
            return result
        }
        result -= Int32(0x80 << 21)
        b = readRawByte()
        result += Int32(b) << 28
        if (b & 0x80) == 0 {
            return result
        }
        for i in 1..<5 {
            b = readRawByte()
            if (Int32(b) & 0x80) == 0 {
                return result
            }
        }
        NSException(name:"InvalidProtocolBuffer", reason:"malformedVarint", userInfo: nil).raise()
        return result
    }
    
    public func readRawVarint64() -> Int64
    {
        var shift:Int64 = 0
        var result:Int64 = 0
        while (shift < 64) {
            var b = readRawByte()
            result |= (Int64(b & 0x7F) << shift)
            if ((Int32(b) & 0x80) == 0) {
                return result
            }
            shift += 7
        }
         NSException(name:"InvalidProtocolBuffer", reason:"malformedVarint", userInfo: nil).raise()
        return 0
    }
    
    
    
    
    
    
    public func readString() -> String
    {
        var size:Int32 = readRawVarint32()
        if (size <= (bufferSize - bufferPos) && size > 0)
        {
            var result:String = NSString(bytes: (buffer.mutableBytes + Int(bufferPos)), length: Int(size), encoding:  NSUTF8StringEncoding)! as String
            bufferPos += size
            return result
        }
        else
        {
            let data = readRawData(size)
            return NSString(data: data, encoding: NSUTF8StringEncoding)! as String
        }
    }
    
    public func readData() -> NSData
    {
        let size = readRawVarint32()
        if (size < bufferSize - bufferPos && size > 0)
        {
            var data = NSData(bytes: buffer.bytes + Int(bufferPos), length: Int(size))
            bufferPos += size
            return data
        }
        else
        {
            return readRawData(size)
        }
    }
    
    public func readUInt32() -> UInt32
    {
        
        var value:Int32 = readRawVarint32()
        var retvalue:UInt32 = 0
        WireFormat.convertTypes(convertValue: value, retValue: &retvalue)
        return retvalue
    }
    
    public func readEnum() ->Int32 {
        return readRawVarint32()
    }
    
    public func readSFixed32() ->Int32
    {
        return readRawLittleEndian32()
    }
    
    public func readSFixed64() ->Int64
    {
        return readRawLittleEndian64()
    }
    public func readSInt32() ->Int32 {
        return WireFormat.decodeZigZag32(readRawVarint32())
    }
    
    public func readSInt64() ->Int64
    {
        return WireFormat.decodeZigZag64(readRawVarint64())
    }
    public func setRecursionLimit(limit:Int32) -> Int32 {
        if (limit < 0) {
            NSException(name:"IllegalArgument", reason:"Recursion limit cannot be negative", userInfo: nil).raise()
        }
        var oldLimit:Int32 = recursionLimit
        recursionLimit = limit
        return oldLimit
    }
    public func setSizeLimit(limit:Int32) -> Int32
    {
        if (limit < 0) {
            NSException(name:"IllegalArgument", reason:" Size limit cannot be negative", userInfo: nil).raise()
        }
        var oldLimit:Int32 = sizeLimit
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
        var bufferEnd:Int32 = totalBytesRetired + bufferSize
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
    
    public func pushLimit(var byteLimit:Int32) -> Int32
    {
        if (byteLimit < 0)
        {
            NSException(name:"InvalidProtocolBuffer", reason:"negativeSize", userInfo: nil).raise()
        }
        byteLimit += totalBytesRetired + bufferPos
        var oldLimit = currentLimit
        if (byteLimit > oldLimit) {
            NSException(name:"InvalidProtocolBuffer", reason:"truncatedMessage", userInfo: nil).raise()
        }
        currentLimit = byteLimit
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
        
        var currentAbsolutePosition:Int32 = totalBytesRetired + bufferPos
        return currentLimit - currentAbsolutePosition
    }
    
    
    public func readGroup(fieldNumber:Int32, builder:MessageBuilder, extensionRegistry:ExtensionRegistry)
    {
        if (recursionDepth >= recursionLimit) {
            NSException(name:"InvalidProtocolBuffer", reason:"Recursion Limit Exceeded", userInfo: nil).raise()
        }
        ++recursionDepth
        builder.mergeFromCodedInputStream(self, extensionRegistry:extensionRegistry)
        checkLastTagWas(WireFormat.WireFormatEndGroup.wireFormatMakeTag(fieldNumber))
        --recursionDepth
    }
    public func readUnknownGroup(fieldNumber:Int32, builder:UnknownFieldSetBuilder)
    {
        if (recursionDepth >= recursionLimit) {
            NSException(name:"InvalidProtocolBuffer", reason:"Recursion Limit Exceeded", userInfo: nil).raise()
        }
        ++recursionDepth
        builder.mergeFromCodedInputStream(self)
        checkLastTagWas(WireFormat.WireFormatEndGroup.wireFormatMakeTag(fieldNumber))
        --recursionDepth
    }

    public func readMessage(builder:MessageBuilder, extensionRegistry:ExtensionRegistry) {
        var length = readRawVarint32()
        if (recursionDepth >= recursionLimit) {
                NSException(name:"InvalidProtocolBuffer", reason:"Recursion Limit Exceeded", userInfo: nil).raise()
        }
        var oldLimit =  pushLimit(length)
        ++recursionDepth
        builder.mergeFromCodedInputStream(self, extensionRegistry:extensionRegistry)
        checkLastTagWas(0)
        --recursionDepth
        popLimit(oldLimit)
    }
    
}


