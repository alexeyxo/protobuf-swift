//
//  CodedOuputStreamTests.swift
//  ProtocolBuffers
//
//  Created by Alexey Khokhlov on 25.07.14.
//  Copyright (c) 2014 Alexey Khokhlov. All rights reserved.
//

import Foundation
import XCTest
import ProtocolBuffers
internal class CodedOuputStreamTests: XCTestCase
{
    func openMemoryStream() ->NSOutputStream {
        var stream:NSOutputStream = NSOutputStream.outputStreamToMemory()
        stream.open()
        return stream
    }
    
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
    
    func assertWriteLittleEndian32(data:NSData, value:Int32) {
        var rawOutput:NSOutputStream = openMemoryStream()
        var output:CodedOutputStream = CodedOutputStream(output: rawOutput)
        output.writeRawLittleEndian32(value)
        output.flush()
    
        var actual:NSData = rawOutput.propertyForKey(NSStreamDataWrittenToMemoryStreamKey) as NSData
        
        XCTAssertTrue(data.isEqualToData(actual), "Test32")
    
        for var blockSize:Int32 = 1; blockSize <= 16; blockSize *= 2 {
            
            var rawOutput:NSOutputStream = openMemoryStream()
            var output:CodedOutputStream = CodedOutputStream(output: rawOutput, bufferSize: blockSize)
            
            output.writeRawLittleEndian32(value)
            output.flush()
    
            let actual:NSData = rawOutput.propertyForKey(NSStreamDataWrittenToMemoryStreamKey) as NSData
            XCTAssertTrue(data.isEqualToData(actual), "Test32")
        }
    }
    
    func assertWriteLittleEndian64(data:NSData, value:Int64) {
        var rawOutput:NSOutputStream = openMemoryStream()
        var output:CodedOutputStream = CodedOutputStream(output: rawOutput)
        output.writeRawLittleEndian64(value)
        output.flush()
        
        var actual:NSData = rawOutput.propertyForKey(NSStreamDataWrittenToMemoryStreamKey) as NSData

        XCTAssertTrue(data.isEqualToData(actual), "Test64")
        
        for var blockSize:Int32 = 1; blockSize <= 16; blockSize *= 2 {
            
            var rawOutput:NSOutputStream = openMemoryStream()
            var output:CodedOutputStream = CodedOutputStream(output: rawOutput, bufferSize: blockSize)
            
            output.writeRawLittleEndian64(value)
            output.flush()
            
            let actual:NSData = rawOutput.propertyForKey(NSStreamDataWrittenToMemoryStreamKey) as NSData
            
            XCTAssertTrue(data.isEqualToData(actual),"Test64")
        }
    }
    
    func assertWriteVarint(data:NSData, value:Int64)
    {
        var shift = WireFormat.logicalRightShift64(value: value, spaces: 31)
        if (shift == 0)
        {
            var rawOutput1:NSOutputStream = openMemoryStream()
            var output1:CodedOutputStream = CodedOutputStream(output: rawOutput1)
            var invalue = Int32(value)
            output1.writeRawVarint32(invalue)
            output1.flush()
    
            var actual1:NSData = rawOutput1.propertyForKey(NSStreamDataWrittenToMemoryStreamKey) as NSData
            XCTAssertTrue(data.isEqualToData(actual1), "")

            XCTAssertTrue(Int32(data.length) == WireFormat.computeRawVarint32Size(Int32(value)), "")
        }
    
        var rawOutput2:NSOutputStream = openMemoryStream()
        var output2:CodedOutputStream = CodedOutputStream(output:rawOutput2)
        output2.writeRawVarint64(value)
        output2.flush()
    
        var actual2:NSData = rawOutput2.propertyForKey(NSStreamDataWrittenToMemoryStreamKey) as NSData
        XCTAssertTrue(data.isEqualToData(actual2), "")
    
    
        XCTAssertTrue(Int32(data.length) == WireFormat.computeRawVarint64Size(value), "")
    
        for var blockSize:Int = 1; blockSize <= 16; blockSize *= 2
        {
    
            if (WireFormat.logicalRightShift64(value: value, spaces: 31) == 0)
            {
                var rawOutput3:NSOutputStream = openMemoryStream()
                var output3:CodedOutputStream = CodedOutputStream(output: rawOutput3, bufferSize: Int32(blockSize))
    
                output3.writeRawVarint32(Int32(value))
                output3.flush()
    
                var actual3:NSData = rawOutput3.propertyForKey(NSStreamDataWrittenToMemoryStreamKey) as NSData
                XCTAssertTrue(data.isEqualToData(actual3), "")
            }
    

            var rawOutput4:NSOutputStream = openMemoryStream()
            var output4:CodedOutputStream = CodedOutputStream(output: rawOutput4, bufferSize: Int32(blockSize))
            output4.writeRawVarint64(value)
            output4.flush()
    
            var actual4:NSData = rawOutput4.propertyForKey(NSStreamDataWrittenToMemoryStreamKey) as NSData
            XCTAssertTrue(data.isEqualToData(actual4), "")
        }
    }
    
    
    func testWriteVarintOne()
    {
        assertWriteVarint(bytes(Byte(0x00)), value:0)
    }
    
    func testWriteVarintTwo()
    {
        assertWriteVarint(bytes(Byte(0x01)), value:1)
    }
    
    func testWriteVarintThree()
    {
        assertWriteVarint(bytes(Byte(0x7f)), value:127)
    }
    
    func testWriteVarintFour()
    {
    //14882
        assertWriteVarint(bytes(0xa2, 0x74), value:(0x22 << 0) | (0x74 << 7))
    }

    func testWriteVarintFive()
    {
    // 2961488830
//        var signedByte:Byte = Byte(129)
//        var byte:SignedByte = SignedByte(signedByte)
        
        var value:Int64 = (0x3e << 0)
        value |= (0x77 << 7)
        value |= (0x12 << 14)
        value |= (0x04 << 21)
        value |= (0x0b << 28)
        assertWriteVarint(bytes(0xbe, 0xf7, 0x92, 0x84, 0x0b), value:value)
    }

    func testWriteVarintSix()
    {
    // 64-bit
    // 7256456126
        var value:Int64 =  (0x3e << 0)
        value |= (0x77 << 7)
        value |= (0x12 << 14)
        value |= (0x04 << 21)
        value |= (0x1b << 28)
        assertWriteVarint(bytes(0xbe, 0xf7, 0x92, 0x84, 0x1b), value:value)
    }
//
    func testWriteVarintSeven()
    {
    // 41256202580718336
        var value:Int64 =  (0x00 << 0)
        value |= (0x66 << 7)
        value |= (0x6b << 14)
        value |= (0x1c << 21)
        value |= (0x43 << 28)
        value |= (0x49 << 35)
        value |= (0x24 << 42)
        value |= (0x49 << 49)
        assertWriteVarint(bytes(0x80, 0xe6, 0xeb, 0x9c, 0xc3, 0xc9, 0xa4, 0x49), value:value)
    }
//
    func testWriteVarintEight()
    {
    // 11964378330978735131
        var value:Int64 =  (0x1b << 0)
        value |= (0x28 << 7)
        value |= (0x79 << 14)
        value |= (0x42 << 21)
        value |= (0x3b << 28)
        value |= (0x56 << 35)
        value |= (0x00 << 42)
        value |= (0x05 << 49)
        value |= (0x26 << 56)
        value |= (0x01 << 63)
        assertWriteVarint(bytes(0x9b, 0xa8, 0xf9, 0xc2, 0xbb, 0xd6, 0x80, 0x85, 0xa6, 0x01), value:value)
    }



    func testWriteLittleEndian()
    {
        
        assertWriteLittleEndian32(bytes(0x78, 0x56, 0x34, 0x12) , value:0x12345678)
        assertWriteLittleEndian32(bytes(0xde, 0xbc, 0xac, 0x11), value:0x11acbcde)
        assertWriteLittleEndian64(bytes(0xf0, 0xde, 0xbc, 0x9a, 0x78, 0x56, 0x34, 0x12), value:0x123456789abcdef0)
        assertWriteLittleEndian64(bytes(0x78, 0x56, 0x34, 0x12, 0xf0, 0xde, 0xbc, 0x11), value:0x11bcdef012345678)
    }
    
    func testEncodeZigZag()
    {
        XCTAssertTrue(0 == WireFormat.encodeZigZag32(0), "")
        XCTAssertTrue(1 == WireFormat.encodeZigZag32(-1), "")
        XCTAssertTrue(2 == WireFormat.encodeZigZag32(1), "")
        XCTAssertTrue(3 == WireFormat.encodeZigZag32(-2), "")
        XCTAssertTrue(0x7FFFFFFE == WireFormat.encodeZigZag32(0x3FFFFFFF), "")
        
        
        XCTAssertTrue(0 == WireFormat.encodeZigZag64( 0), "")
        XCTAssertTrue(1 == WireFormat.encodeZigZag64(-1), "")
        XCTAssertTrue(2 == WireFormat.encodeZigZag64( 1), "")
        XCTAssertTrue(3 == WireFormat.encodeZigZag64(-2), "")
        XCTAssertTrue(0x000000007FFFFFFE == WireFormat.encodeZigZag64(0x000000003FFFFFFF), "")

        
        XCTAssertTrue(0 == WireFormat.encodeZigZag32(WireFormat.decodeZigZag32(0)), "")
        XCTAssertTrue(1 == WireFormat.encodeZigZag32(WireFormat.decodeZigZag32(1)), "")
        XCTAssertTrue(-1 == WireFormat.encodeZigZag32(WireFormat.decodeZigZag32(-1)), "")
        XCTAssertTrue(14927 == WireFormat.encodeZigZag32(WireFormat.decodeZigZag32(14927)), "")
        XCTAssertTrue(-3612 == WireFormat.encodeZigZag32(WireFormat.decodeZigZag32(-3612)), "")
        
        XCTAssertTrue(0 == WireFormat.encodeZigZag64(WireFormat.decodeZigZag64(0)), "")
        XCTAssertTrue(1 == WireFormat.encodeZigZag64(WireFormat.decodeZigZag64(1)), "")
        XCTAssertTrue(-1 == WireFormat.encodeZigZag64(WireFormat.decodeZigZag64(-1)), "")
        XCTAssertTrue(14927 == WireFormat.encodeZigZag64(WireFormat.decodeZigZag64(14927)), "")
        XCTAssertTrue(-3612 == WireFormat.encodeZigZag64(WireFormat.decodeZigZag64(-3612)), "")
        
        XCTAssertTrue(856912304801416 == WireFormat.encodeZigZag64(WireFormat.decodeZigZag64(856912304801416)), "")
        XCTAssertTrue(-75123905439571256 == WireFormat.encodeZigZag64(WireFormat.decodeZigZag64(-75123905439571256)), "")
    }
    
    func testWriteWholeMessage()
    {
        var message = TestUtilities.allSet()
        
        var rawBytes = message.data()
        var goldenData = TestUtilities.goldenData()
        XCTAssertTrue(rawBytes == goldenData, "")
        
        // Try different block sizes.
        for (var blockSize:Int = 1; blockSize < 256; blockSize *= 2) {
            var rawOutput = openMemoryStream()
            var output:CodedOutputStream = CodedOutputStream(output:rawOutput, bufferSize:Int32(blockSize))
            message.writeToCodedOutputStream(output)
            output.flush()
            var actual = rawOutput.propertyForKey(NSStreamDataWrittenToMemoryStreamKey) as NSData
            var bytes = [Byte](count:actual.length, repeatedValue:0)
            actual.getBytes(&bytes)
            XCTAssertTrue(rawBytes == bytes, "")
        }
  
    }

}
