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
    func bytes(from:UInt8...) -> NSData
    {
        let returnData:NSMutableData = NSMutableData()
        var bytesArray = [UInt8](count:Int(from.count), repeatedValue: 0)
        var i:Int = 0
        for index:UInt8 in from
        {
            bytesArray[i] = index
            i += 1
        }
        returnData.appendBytes(&bytesArray, length: bytesArray.count)
        return returnData
    }
    
    func bytesArray(from:[UInt8]) -> NSData
    {
        let returnData:NSMutableData = NSMutableData()
        returnData.appendBytes(from, length: from.count)
        return returnData
    }
    
    func testDecodeZigZag()
    {
        XCTAssertEqual(Int32(0), WireFormat.decodeZigZag32(0))
        XCTAssertEqual(Int32(-1), WireFormat.decodeZigZag32(1))
        XCTAssertEqual(Int32(1), WireFormat.decodeZigZag32(2))
        XCTAssertEqual(Int32(-2), WireFormat.decodeZigZag32(3))
        
        XCTAssertTrue(0x3FFFFFFF == WireFormat.decodeZigZag32(0x7FFFFFFE))
        XCTAssertEqual(Int64(0), WireFormat.decodeZigZag64(0))
        XCTAssertEqual(Int64(-1), WireFormat.decodeZigZag64(1))
        XCTAssertEqual(Int64(1), WireFormat.decodeZigZag64(2))
        XCTAssertEqual(Int64(-2), WireFormat.decodeZigZag64(3))
        
        XCTAssertEqual(Int64(0x000000003FFFFFFF), WireFormat.decodeZigZag64(0x000000007FFFFFFE))
        XCTAssertEqual(Int64(0x000000007FFFFFFF), WireFormat.decodeZigZag64(0x00000000FFFFFFFE))
    }
    
    func assertReadVarint(data:NSData, value:Int64) throws
    {
        
        let shift = WireFormat.logicalRightShift64(value:value, spaces: 31)
        if (shift == 0)
        {
            let input1:CodedInputStream = CodedInputStream(data:data)
            let result = try input1.readRawVarint32()
            XCTAssertTrue(Int32(value) == result, "")

        }

        let input2:CodedInputStream = CodedInputStream(data:data)
        
        let ints = try input2.readRawVarint64()
        XCTAssertTrue(value == ints, "")
    
        if (shift == 0)
        {
            
            let input3:CodedInputStream = CodedInputStream(inputStream:NSInputStream(data:data))
            let variant = try input3.readRawVarint32()
            XCTAssertTrue(Int32(value) == variant, "")
        }
        
        let input4:CodedInputStream = CodedInputStream(inputStream:NSInputStream(data:data))
        let result4 = try input4.readRawVarint64()
        XCTAssertTrue(value == result4, "")
    
    // Try different block sizes.
        
        var blockSize:Int32 = 1
        while blockSize <= 16 {
            if (shift == 0) {
                let smallblock:SmallBlockInputStream = SmallBlockInputStream()
                smallblock.setup(data: data, blocksSize: blockSize)
                let inputs:CodedInputStream = CodedInputStream(inputStream:smallblock)
                let result2 = try inputs.readRawVarint32()
                XCTAssertTrue(Int32(value) == result2, "")
            }
            
            let smallblock2:SmallBlockInputStream = SmallBlockInputStream()
            smallblock2.setup(data: data, blocksSize: blockSize)
            let inputs2:CodedInputStream = CodedInputStream(inputStream:smallblock2)
            let varin64 = try inputs2.readRawVarint64()
            XCTAssertTrue(value == varin64, "")
            blockSize *= 2
        }
    }
    
    func assertReadLittleEndian32(data:NSData, value:Int32) throws
    {
        var dataByte:[UInt8] = [UInt8](count: data.length/sizeof(UInt8), repeatedValue: 0)
        data.getBytes(&dataByte, length: data.length)
        
        let input:CodedInputStream = CodedInputStream(data:data)
        let readRes = try input.readRawLittleEndian32()
        XCTAssertTrue(value == readRes, "")
        
        var blockSize:Int32 = 1
        while blockSize <= 16 {
            let smallblock:SmallBlockInputStream = SmallBlockInputStream()
            smallblock.setup(data: data, blocksSize: blockSize)
            
            let input2:CodedInputStream = CodedInputStream(inputStream:smallblock)
            let readRes2 = try input2.readRawLittleEndian32()
            XCTAssertTrue(value == readRes2, "")
            blockSize *= 2
        }
    }
    

    func assertReadLittleEndian64(data:NSData, value:Int64) throws
    {
        var dataByte:[UInt8] = [UInt8](count: data.length/sizeof(UInt8), repeatedValue: 0)
        data.getBytes(&dataByte, length: data.length)
        
        let input:CodedInputStream = CodedInputStream(data:data)
        let inputValue = try input.readRawLittleEndian64()
        XCTAssertTrue(value == inputValue, "")
        var blockSize:Int32 = 1
        while blockSize <= 16 {
            let smallblock:SmallBlockInputStream = SmallBlockInputStream()
            smallblock.setup(data: data, blocksSize: blockSize)
            
            let input2:CodedInputStream = CodedInputStream(inputStream:smallblock)
            
            let input2Value = try input2.readRawLittleEndian64()
            XCTAssertTrue(value == input2Value, "")
            blockSize *= 2
        }
    }
    
    func assertReadVarintFailure(data:NSData) throws
    {
        var dataByte:[UInt8] = [UInt8](count: data.length, repeatedValue: 0)
        data.getBytes(&dataByte, length:data.length)
        
        let input:CodedInputStream = CodedInputStream(data:data)
        try input.readRawVarint32()
        let input2:CodedInputStream = CodedInputStream(data:data)
        try input2.readRawVarint64()
        
    
    }
    
    func testReadLittleEndian()
    {
        do {
            try assertReadLittleEndian32(bytes(0x78, 0x56, 0x34, 0x12), value:Int32(0x12345678))
            try assertReadLittleEndian32(bytes(0xa1, 0xde, 0xbc, 0x11), value:0x11bcdea1)
    
            try assertReadLittleEndian64(bytes(0xf0, 0xde, 0xbc, 0x9a, 0x78, 0x56, 0x34, 0x12), value:0x123456789abcdef0)
            try assertReadLittleEndian64(bytes(0x78, 0x56, 0x34, 0x12, 0xf0, 0xde, 0xbc, 0x11), value:0x11bcdef012345678)
        }
        catch
        {
            XCTFail("Fail testReadLittleEndian")
        }
    
    }
    
    func testReadVarint()
    {
        do {
            
            try assertReadVarint(bytes(UInt8(0x00)), value:0)
            try assertReadVarint(bytes(UInt8(0x01)), value:1)
            var rvalue14882:Int64 = (0x22 << 0)
            rvalue14882 |= (0x74 << 7)
            try assertReadVarint(bytes(0xa2, 0x74), value:rvalue14882)
            // 2961488830
            
            var rvalue2961488830:Int64 = (0x3e << 0)
            rvalue2961488830 |= (0x77 << 7)
            rvalue2961488830 |= (0x12 << 14)
            rvalue2961488830 |= (0x04 << 21)
            rvalue2961488830 |= (0x0b << 28)
            try assertReadVarint(bytes(0xbe, 0xf7, 0x92, 0x84, 0x0b), value:rvalue2961488830)
            
            // 64-bit
            // 7256456126
            var rvalue:Int64 = (0x3e << 0)
            rvalue |= (0x77 << 7)
            rvalue |= (0x12 << 14)
            rvalue |= (0x04 << 21)
            rvalue |= (0x1b << 28)
            try assertReadVarint(bytes(0xbe, 0xf7, 0x92, 0x84, 0x1b), value:rvalue)
            //
            
            var rvalue41256202580718336:Int64 = (0x00 << 0)
            rvalue41256202580718336 |= (0x66 << 7)
            rvalue41256202580718336 |= (0x6b << 14)
            rvalue41256202580718336 |= (0x1c << 21)
            rvalue41256202580718336 |= (0x43 << 28)
            rvalue41256202580718336 |= (0x49 << 35)
            rvalue41256202580718336 |= (0x24 << 42)
            rvalue41256202580718336 |= (0x49 << 49)
            try assertReadVarint(bytes(0x80, 0xe6, 0xeb, 0x9c, 0xc3, 0xc9, 0xa4, 0x49), value:rvalue41256202580718336)
            
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
            try assertReadVarint(bytes(0x9b, 0xa8, 0xf9, 0xc2, 0xbb, 0xd6, 0x80, 0x85, 0xa6, 0x01), value:rvalue11964378330978735131)
            
        }
        catch
        {
            XCTFail("Fail testReadVarint")
        }
    
//     Failures
//        assertReadVarintFailure(bytes(0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x00))
//        assertReadVarintFailure(bytes(0x80))
    }
    
    func testReadMaliciouslyLargeBlob()
    {
        do {
            let rawOutput:NSOutputStream = NSOutputStream.outputStreamToMemory()
            rawOutput.open()
            let output:CodedOutputStream = CodedOutputStream(output: rawOutput)
            
            let tag:Int32 = WireFormat.LengthDelimited.makeTag(1)
            
            do {
                try output.writeRawVarint32(tag)
                try output.writeRawVarint32(0x7FFFFFFF)
            }
            catch {
                XCTFail("Fail testReadMaliciouslyLargeBlob")
            }
            
            let bytes:[UInt8] = [UInt8](count: 32, repeatedValue: 0)
            let datas = NSData(bytes: bytes, length: 32)
            do {
                try output.writeRawData(datas)
                try output.flush()
            }
            catch  {
                XCTFail("Fail testReadMaliciouslyLargeBlob")
            }
            
            let data:NSData = rawOutput.propertyForKey(NSStreamDataWrittenToMemoryStreamKey) as! NSData
            let input:CodedInputStream = CodedInputStream(data: data)
            let readedTag = try input.readTag()
            XCTAssertTrue(tag == readedTag, "")
        }
        catch
        {
            XCTFail("Fail testReadMaliciouslyLargeBlob")
        }
        
    
    }
    
    func testReadWholeMessage()
    {
        
        do {
            let message = try TestUtilities.allSet()
            let rawBytes = message.data()
            let lengthRaw = Int32(rawBytes.length)
            let lengthSize = message.serializedSize()
            XCTAssertTrue(lengthRaw == lengthSize, "")
            
            var message2 = try ProtobufUnittest.TestAllTypes.parseFromData(rawBytes)
            TestUtilities.assertAllFieldsSet(message2)
            let stream:NSInputStream = NSInputStream(data: rawBytes)
            let codedStream  = CodedInputStream(inputStream:stream)
            let message3 = try ProtobufUnittest.TestAllTypes.parseFromCodedInputStream(codedStream)
            TestUtilities.assertAllFieldsSet(message3)
            XCTAssertTrue(message3 == message2, "")
            
            var blockSize:Int32 = 1
            while blockSize <= 256 {
                let smallblock:SmallBlockInputStream = SmallBlockInputStream()
                smallblock.setup(data: rawBytes, blocksSize: blockSize)
                message2 = try ProtobufUnittest.TestAllTypes.parseFromInputStream(smallblock)
                TestUtilities.assertAllFieldsSet(message2)
                blockSize *= 2
            }
        }
        catch
        {
            XCTFail("Fail testReadWholeMessage")
        }
        
    }
    
    func testSkipWholeMessage()
    {
        do {
            let message = try TestUtilities.allSet()
            let rawBytes = message.data()
            let input1 = CodedInputStream(data:rawBytes)
            let input2 = CodedInputStream(data:rawBytes)
            let unknownFields = UnknownFieldSet.Builder()
            
            while (true) {
                let tag  = try input1.readTag()
                let tag2 = try input2.readTag()
                XCTAssertTrue(tag == tag2, "")
                if (tag2 == 0) {
                    break
                }
                try unknownFields.mergeFieldFrom(tag, input:input1)
                try input2.skipField(tag2)
            }
        }
        catch {
            XCTFail("Fail testSkipWholeMessage")
        }
        
        
    }
    
    
    func testReadHugeBlob()
    {
        do {
            // Allocate and initialize a 1MB blob.
            let blob = NSMutableData(length:1 << 20)!
            
            var i:Int = 0
            while i < blob.length {
                let pointer = UnsafeMutablePointer<UInt8>(blob.mutableBytes)
                let bpointer = UnsafeMutableBufferPointer(start: pointer, count: blob.length)
                bpointer[i] = UInt8(1)
                i += 1
            }
            let builder = ProtobufUnittest.TestAllTypes.Builder()
            try TestUtilities.setAllFields(builder)
            
            builder.optionalBytes = blob
            let message = try builder.build()
            let data = message.data()
            let message2 = try ProtobufUnittest.TestAllTypes.parseFromInputStream(NSInputStream(data:data))
            XCTAssertTrue(message.optionalBytes == message2.optionalBytes, "")
            
            let builder3 = try ProtobufUnittest.TestAllTypes.builderWithPrototype(message2)
            builder3.optionalBytes = try TestUtilities.allSet().optionalBytes
            let message3 = try builder3.build()
            TestUtilities.assertAllFieldsSet(message3)
        }
        catch {
            XCTFail("Fail testReadHugeBlob")
        }
        
    }
    
    

    
}