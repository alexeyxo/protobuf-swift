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
internal class RingBuffer
{
    internal var buffer:NSMutableData
    var position:Int32 = 0
    var tail:Int32 = 0
    
    init(data:NSMutableData)
    {
        buffer = NSMutableData(data: data)
    }
    func freeSpace() ->UInt32
    {
        var res:UInt32 = 0
        
        if position < tail
        {
            res = UInt32(tail - position)
        }
        else
        {
            let dataLength = buffer.length
            res = UInt32((Int32(dataLength) - position) + tail)
        }
        
        if tail != 0
        {
            res -=  1
        }
        return res
    }
    
    func appendByte(byte aByte:UInt8) -> Bool
    {
        if freeSpace() < 1
        {
            return false
        }
        let pointer = UnsafeMutablePointer<UInt8>(buffer.mutableBytes)
        let bpointer = UnsafeMutableBufferPointer(start: pointer, count: buffer.length)
        bpointer[Int(position)] = aByte
        position+=1
        return true
    }
    
    func appendData(input:NSData, offset:Int32, length:Int32) -> Int32
    {
        var totalWritten:Int32 = 0
        var aLength = length
        var aOffset = offset
        if (position >= tail)
        {
            totalWritten = min(Int32(buffer.length) - Int32(position), Int32(aLength))
            memcpy(buffer.mutableBytes + Int(position), input.bytes + Int(aOffset), Int(totalWritten))
            position += totalWritten
            if totalWritten == aLength
            {
                return aLength
            }
            aLength -= Int32(totalWritten)
            aOffset += Int32(totalWritten)
            
        }
        
        let freeSpaces:UInt32 = freeSpace()
        
        if freeSpaces == 0
        {
            return totalWritten
        }
        
        if (position == Int32(buffer.length)) {
            position = 0
        }
        
        let written:Int32 = min(Int32(freeSpaces), aLength)
        memcpy(buffer.mutableBytes + Int(position), input.bytes + Int(aOffset), Int(written))
        position += written
        totalWritten += written
        
        return totalWritten
    }
    
    func flushToOutputStream(stream:NSOutputStream) ->Int32
    {
        var totalWritten:Int32 = 0
        
        let data = buffer
        let pointer = UnsafeMutablePointer<UInt8>(data.mutableBytes)
        if tail > position
        {
            
            let written:Int = stream.write(pointer + Int(tail), maxLength:Int(buffer.length - Int(tail)))
            if written <= 0
            {
                return totalWritten
            }
            totalWritten+=Int32(written)
            tail += Int32(written)
            if (tail == Int32(buffer.length)) {
                tail = 0
            }
        }
        
        if (tail < position) {
            
            let written:Int = stream.write(pointer + Int(tail), maxLength:Int(position - tail))
            if (written <= 0)
            {
                return totalWritten
            }
            totalWritten += Int32(written)
            tail += Int32(written)
        }
        
        if (tail == position) {
            tail = 0
            position = 0
        }
        
        if (position == Int32(buffer.length) && tail > 0) {
            position = 0
        }
        
        if (tail == Int32(buffer.length)) {
            tail = 0
        }
        
        return totalWritten
    }
    
    
}
