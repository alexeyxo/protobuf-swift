//
//  CodedInputStreamTests.swift
//  ProtocolBuffers
//
//  Created by Alexey Khokhlov on 03.08.14.
//  Copyright (c) 2014 Alexey Khokhlov. All rights reserved.
//

import Foundation
import XCTest
import ProtocolBuffers
class CodedInputStreamTests: XCTestCase
{
    func bytes(from:Byte...) -> NSData
    {
        var returnData:NSMutableData = NSMutableData()
        var bytesArray = [Byte](count:Int(from.count), repeatedValue: 0)
        var i:Int = 0
        for index:Byte in from
        {
            bytesArray[i] = index
            i++
        }
        returnData.appendBytes(&bytesArray, length: bytesArray.count)
        return returnData
    }
    
    func testDecodeZigZag()
    {
        XCTAssertEqual(0, WireFormat.decodeZigZag32(0))
        XCTAssertEqual(-1, WireFormat.decodeZigZag32(1))
        XCTAssertEqual(1, WireFormat.decodeZigZag32(2))
        XCTAssertEqual(-2, WireFormat.decodeZigZag32(3))
        
        //    014-06-24 16:03:45.345 xctest[2274:30b] 1073741823 - 1073741823
        //    2014-06-24 16:03:45.346 xctest[2274:30b] -1073741824 - 3221225472
        
        XCTAssertTrue(0x3FFFFFFF == WireFormat.decodeZigZag32(0x7FFFFFFE))
        
//        XCTAssertEqual(0xFFFFFFFFC0000000, WireFormat.decodeZigZag32(0x7FFFFFFF))
        
        //  XCTAssertEqual((SInt32)0x7FFFFFFF, decodeZigZag32(0xFFFFFFFE));
        //  XCTAssertEqual((SInt32)0x80000000, decodeZigZag32(0xFFFFFFFF));
        
        XCTAssertEqual(0, WireFormat.decodeZigZag64(0))
        XCTAssertEqual(-1, WireFormat.decodeZigZag64(1))
        XCTAssertEqual(1, WireFormat.decodeZigZag64(2))
        XCTAssertEqual(-2, WireFormat.decodeZigZag64(3))
        XCTAssertEqual(0x000000003FFFFFFF, WireFormat.decodeZigZag64(0x000000007FFFFFFE))
//        XCTAssertEqual(0xFFFFFFFFC0000000, WireFormat.decodeZigZag64(0x000000007FFFFFFF))
        XCTAssertEqual(0x000000007FFFFFFF, WireFormat.decodeZigZag64(0x00000000FFFFFFFE))
//        XCTAssertEqual(0xFFFFFFFF80000000, WireFormat.decodeZigZag64(0x00000000FFFFFFFF))
//        XCTAssertEqual(0x7FFFFFFFFFFFFFFF, WireFormat.decodeZigZag64(0xFFFFFFFFFFFFFFFE))
//        XCTAssertEqual(0x8000000000000000, WireFormat.decodeZigZag64(0xFFFFFFFFFFFFFFFF))
    }
    
    func assertReadVarint(data:NSData, value:Int64)
    {
        var dataByte:[Byte] = [Byte](count: data.length, repeatedValue: 0)
        data.getBytes(&dataByte)
        
        var shift = WireFormat.logicalRightShift64(value: value, spaces: 31)
        if (shift == 0)
        {
            var input1:CodedInputStream = CodedInputStream(data:dataByte)
            var result = input1.readRawVarint32()
            XCTAssertTrue(Int32(value) == result, "")

        }

        var input2:CodedInputStream = CodedInputStream(data:dataByte)
        
        XCTAssertTrue(value == input2.readRawVarint64(), "")
    
        if (shift == 0)
        {
            var input3:CodedInputStream = CodedInputStream(inputStream:NSInputStream(data:data))
            XCTAssertTrue(Int32(value) == input3.readRawVarint32(), "")
        }
        
        var input4:CodedInputStream = CodedInputStream(inputStream:NSInputStream(data:data))
        var result4 = input4.readRawVarint64()
        XCTAssertTrue(value == result4, "");
    
    // Try different block sizes.
        for (var blockSize:Int32 = 1; blockSize <= 16; blockSize *= 2)
        {
            if (shift == 0)
            {
                var smallblock:SmallBlockInputStream = SmallBlockInputStream()
                smallblock.setup(data: data, blocksSize: blockSize)
                var inputs:CodedInputStream = CodedInputStream(inputStream:smallblock)
                var result2 = inputs.readRawVarint32()
                XCTAssertTrue(Int32(value) == result2, "")
            }
        
            var smallblock2:SmallBlockInputStream = SmallBlockInputStream()
            smallblock2.setup(data: data, blocksSize: blockSize)
            var inputs2:CodedInputStream = CodedInputStream(inputStream:smallblock2)
            XCTAssertTrue(value == inputs2.readRawVarint64(), "")

        }
    }
    
    func assertReadLittleEndian32(data:NSData, value:Int32)
    {
        var dataByte:[Byte] = [Byte](count: data.length/sizeof(Byte), repeatedValue: 0)
        data.getBytes(&dataByte)
        
        var input:CodedInputStream = CodedInputStream(data:dataByte)
        var readRes = input.readRawLittleEndian32();
        XCTAssertTrue(value == readRes, "");
        for (var blockSize:Int32 = 1; blockSize <= 16; blockSize *= 2)
        {
            var smallblock:SmallBlockInputStream = SmallBlockInputStream()
            smallblock.setup(data: data, blocksSize: blockSize)
            
            var input2:CodedInputStream = CodedInputStream(inputStream:smallblock)
            var readRes2 = input2.readRawLittleEndian32()
            println("\(readRes2)")
            XCTAssertTrue(value == readRes2, "")
        }
    }
    

    func assertReadLittleEndian64(data:NSData, value:Int64)
    {
        var dataByte:[Byte] = [Byte](count: data.length/sizeof(Byte), repeatedValue: 0)
        data.getBytes(&dataByte)
        
        var input:CodedInputStream = CodedInputStream(data:dataByte)
        XCTAssertTrue(value == input.readRawLittleEndian64(), "");
        for (var blockSize:Int32 = 1; blockSize <= 16; blockSize *= 2)
        {
            var smallblock:SmallBlockInputStream = SmallBlockInputStream()
            smallblock.setup(data: data, blocksSize: blockSize)
            
            var input2:CodedInputStream = CodedInputStream(inputStream:smallblock)
            
            XCTAssertTrue(value == input2.readRawLittleEndian64(), "")
        }
    }
    
    func assertReadVarintFailure(data:NSData)
    {
        var dataByte:[Byte] = [Byte](count: data.length, repeatedValue: 0)
        data.getBytes(&dataByte)
        
        var input:CodedInputStream = CodedInputStream(data:dataByte)
        input.readRawVarint32()
        var input2:CodedInputStream = CodedInputStream(data:dataByte)
        input2.readRawVarint64()
        
    
    }
    
    func atestReadLittleEndian()
    {
        assertReadLittleEndian32(bytes(0x78, 0x56, 0x34, 0x12), value:Int32(0x12345678))
        assertReadLittleEndian32(bytes(0xa1, 0xde, 0xbc, 0x11), value:0x11bcdea1)
    
        assertReadLittleEndian64(bytes(0xf0, 0xde, 0xbc, 0x9a, 0x78, 0x56, 0x34, 0x12), value:0x123456789abcdef0)
        assertReadLittleEndian64(bytes(0x78, 0x56, 0x34, 0x12, 0xf0, 0xde, 0xbc, 0x11), value:0x11bcdef012345678)
    
    }
    
    func testReadVarint()
    {
        assertReadVarint(bytes(0x00), value:0)
        assertReadVarint(bytes(0x01), value:1)
        assertReadVarint(bytes(0x7f), value:127)
        var rvalue14882:Int64 = (0x22 << 0)
        rvalue14882 |= (0x74 << 7)
        assertReadVarint(bytes(0xa2, 0x74), value:rvalue14882)
    // 2961488830
      
        var rvalue2961488830:Int64 = (0x3e << 0)
        rvalue2961488830 |= (0x77 << 7)
        rvalue2961488830 |= (0x12 << 14)
        rvalue2961488830 |= (0x04 << 21)
        rvalue2961488830 |= (0x0b << 28)
        assertReadVarint(bytes(0xbe, 0xf7, 0x92, 0x84, 0x0b), value:rvalue2961488830)
    
    // 64-bit
    // 7256456126
        var rvalue:Int64 = (0x3e << 0)
        rvalue |= (0x77 << 7)
        rvalue |= (0x12 << 14)
        rvalue |= (0x04 << 21)
        rvalue |= (0x1b << 28)
        assertReadVarint(bytes(0xbe, 0xf7, 0x92, 0x84, 0x1b), value:rvalue)
    //
       
        var rvalue41256202580718336:Int64 = (0x00 << 0)
        rvalue41256202580718336 |= (0x66 << 7)
        rvalue41256202580718336 |= (0x6b << 14)
        rvalue41256202580718336 |= (0x1c << 21)
        rvalue41256202580718336 |= (0x43 << 28)
        rvalue41256202580718336 |= (0x49 << 35)
        rvalue41256202580718336 |= (0x24 << 42)
        rvalue41256202580718336 |= (0x49 << 49)
        assertReadVarint(bytes(0x80, 0xe6, 0xeb, 0x9c, 0xc3, 0xc9, 0xa4, 0x49), value:rvalue41256202580718336)
        
    // 11964378330978735131
        
        var rvalue11964378330978735131:Int64 = (0x1b << 0)
        rvalue11964378330978735131 |= (0x28 << 7)
        rvalue11964378330978735131 |= (0x79 << 14)
        rvalue11964378330978735131 |= (0x42 << 21)
        rvalue11964378330978735131 |= (0x3b << 28)
        rvalue11964378330978735131 |= (0x56 << 35)
        rvalue11964378330978735131 |= (0x00 << 42)
        rvalue11964378330978735131 |= (0x05 << 49)
        rvalue11964378330978735131 |= (0x26 << 56)
        rvalue11964378330978735131 |= (0x01 << 63)
        assertReadVarint(bytes(0x9b, 0xa8, 0xf9, 0xc2, 0xbb, 0xd6, 0x80, 0x85, 0xa6, 0x01), value:rvalue11964378330978735131)
    
//     Failures
//        assertReadVarintFailure(bytes(0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x00))
//        assertReadVarintFailure(bytes(0x80))
    }
    
    func testReadMaliciouslyLargeBlob()
    {
        var rawOutput:NSOutputStream = NSOutputStream.outputStreamToMemory()
        rawOutput.open()
        var output:CodedOutputStream = CodedOutputStream(output: rawOutput)
    
        var tag:Int32 = WireFormat.WireFormatLengthDelimited.wireFormatMakeTag(1)
        output.writeRawVarint32(tag)
        output.writeRawVarint32(0x7FFFFFFF)
        var bytes:[Byte] = [Byte](count: 32, repeatedValue: 0)
        output.writeRawData(bytes)
        output.flush()
    
        var data:NSData = rawOutput.propertyForKey(NSStreamDataWrittenToMemoryStreamKey) as NSData
        var bytes2:[Byte] = [Byte](count: data.length, repeatedValue: 0)
        data.getBytes(&bytes2)
        var input:CodedInputStream = CodedInputStream(data: bytes2)
        XCTAssertTrue(tag == input.readTag(), "")
    
//        XCTAssertThrows([input readData], @"");
    }

    
}