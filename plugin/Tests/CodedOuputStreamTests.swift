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
    func openMemoryStream() -> OutputStream {
        let stream:OutputStream = OutputStream.toMemory()
        stream.open()
        return stream
    }
    
    func bytes(_ from:UInt8...) -> Data
    {
        let returnData:NSMutableData = NSMutableData()
        var bytesArray = [UInt8](repeating: 0, count: Int(from.count))
        var i:Int = 0
        for index:UInt8 in from
        {
            bytesArray[i] = index
            i += 1
        }
        returnData.append(&bytesArray, length: bytesArray.count)
        return returnData as Data
    }
    
    func assertWriteLittleEndian32(_ data:Data, value:Int32) throws {
        let rawOutput:OutputStream = openMemoryStream()
        let output:CodedOutputStream = CodedOutputStream(stream: rawOutput)

        try output.writeRawLittleEndian32(value: value)
        try output.flush()
    
        let actual:Data = rawOutput.property(forKey: Stream.PropertyKey.dataWrittenToMemoryStreamKey) as! Data
        
        XCTAssertTrue(data == actual, "Test32")
        
        var blockSize:Int = 1
        while blockSize <= 16 {
            let rawOutput:OutputStream = openMemoryStream()
            let output:CodedOutputStream = CodedOutputStream(stream: rawOutput, bufferSize: blockSize)
            
            try output.writeRawLittleEndian32(value: value)
            try output.flush()
            
            let actual:Data = rawOutput.property(forKey: Stream.PropertyKey.dataWrittenToMemoryStreamKey) as! Data
            XCTAssertTrue(data == actual, "Test32")
            blockSize *= 2
        }
    }
    
    func assertWriteLittleEndian64(_ data:Data, value:Int64) throws {
        let rawOutput:OutputStream = openMemoryStream()
        let output:CodedOutputStream = CodedOutputStream(stream: rawOutput)
        try output.writeRawLittleEndian64(value: value)
        try output.flush()
        
        let actual:Data = rawOutput.property(forKey: Stream.PropertyKey.dataWrittenToMemoryStreamKey) as! Data

        XCTAssertTrue(data == actual, "Test64")
        
        
        var blockSize:Int = 1
        while blockSize <= 16 {
            let rawOutput:OutputStream = openMemoryStream()
            let output:CodedOutputStream = CodedOutputStream(stream: rawOutput, bufferSize: blockSize)
            
            try output.writeRawLittleEndian64(value: value)
            try output.flush()
            
            let actual:Data = rawOutput.property(forKey: Stream.PropertyKey.dataWrittenToMemoryStreamKey) as! Data
            
            XCTAssertTrue(data == actual,"Test64")
            blockSize *= 2
        }

    }
    
    func assertWriteVarint(_ data:Data, value:Int64) throws
    {
        let shift = WireFormat.logicalRightShift64(value:value, spaces: 31)
        if (shift == 0)
        {
            let rawOutput1:OutputStream = openMemoryStream()
            let output1:CodedOutputStream = CodedOutputStream(stream: rawOutput1)
            let invalue = Int32(value)
            try output1.writeRawVarint32(value: invalue)
            try output1.flush()
    
            let actual1:Data = rawOutput1.property(forKey: Stream.PropertyKey.dataWrittenToMemoryStreamKey) as! Data
            XCTAssertTrue(data == actual1, "")

            XCTAssertTrue(Int32(data.count) == Int32(value).computeRawVarint32Size(), "")
        }
    
        let rawOutput2:OutputStream = openMemoryStream()
        let output2:CodedOutputStream = CodedOutputStream(stream:rawOutput2)
        try output2.writeRawVarint64(value: value)
        try output2.flush()
    
        let actual2:Data = rawOutput2.property(forKey: Stream.PropertyKey.dataWrittenToMemoryStreamKey) as! Data
        XCTAssertTrue(data == actual2, "")
    
    
        XCTAssertTrue(Int32(data.count) == value.computeRawVarint64Size(), "")
    
        var blockSize:Int = 1
        while blockSize <= 16 {
            if (WireFormat.logicalRightShift64(value:value, spaces: 31) == 0)
            {
                let rawOutput3:OutputStream = openMemoryStream()
                let output3:CodedOutputStream = CodedOutputStream(stream: rawOutput3, bufferSize: blockSize)
                
                try output3.writeRawVarint32(value: Int32(value))
                try output3.flush()
                
                let actual3:Data = rawOutput3.property(forKey: Stream.PropertyKey.dataWrittenToMemoryStreamKey) as! Data
                XCTAssertTrue(data == actual3, "")
            }
            
            
            let rawOutput4:OutputStream = openMemoryStream()
            let output4:CodedOutputStream = CodedOutputStream(stream: rawOutput4, bufferSize: blockSize)
            try output4.writeRawVarint64(value: value)
            try output4.flush()
            
            let actual4:Data = rawOutput4.property(forKey: Stream.PropertyKey.dataWrittenToMemoryStreamKey) as! Data
            XCTAssertTrue(data == actual4, "")
            blockSize *= 2
        }
    }
    
    
    func testWriteVarintOne()
    {
        do {
            try assertWriteVarint(bytes(UInt8(0x00)), value:0)
        }
        catch
        {
            XCTFail("testWriteVarintOne")
        }
    }
    
    func testWriteVarintTwo()
    {
        do {
            try assertWriteVarint(bytes(UInt8(0x01)), value:1)
        }
        catch
        {
            XCTFail("testWriteVarintTwo")
        }
        
    }
    
    func testWriteVarintThree()
    {
        do {
            try assertWriteVarint(bytes(UInt8(0x7f)), value:127)
        }
        catch
        {
            XCTFail("testWriteVarintThree")
        }
        
    }
    
    func testWriteVarintFour()
    {
    //14882
        
        do {
            try assertWriteVarint(bytes(0xa2, 0x74), value:(0x22 << 0) | (0x74 << 7))
        }
        catch
        {
            XCTFail("Fail testWriteVarintFour")
        }
    }

    func testWriteVarintFive()
    {
    // 2961488830
//        var signedByte:UInt8 = UInt8(129)
//        var UInt8:SignedByte = SignedByte(signedByte)
        
        var value:Int64 = (0x3e << 0)
        value |= (0x77 << 7)
        value |= (0x12 << 14)
        value |= (0x04 << 21)
        value |= (0x0b << 28)
        do {
            try assertWriteVarint(bytes(0xbe, 0xf7, 0x92, 0x84, 0x0b), value:value)
        }
        catch
        {
             XCTFail("Fail testWriteVarintFive")
        }
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
        do {
            try assertWriteVarint(bytes(0xbe, 0xf7, 0x92, 0x84, 0x1b), value:value)
        }
        catch
        {
            XCTFail("Fail testWriteVarintSix")
        }
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
        do {
            try assertWriteVarint(bytes(0x80, 0xe6, 0xeb, 0x9c, 0xc3, 0xc9, 0xa4, 0x49), value:value)
        }
        catch
        {
            XCTFail("Fail testWriteVarintSeven")
        }
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
        do {
            try assertWriteVarint(bytes(0x9b, 0xa8, 0xf9, 0xc2, 0xbb, 0xd6, 0x80, 0x85, 0xa6, 0x01), value:value)
        }
        catch
        {
            XCTFail("Fail testWriteVarintEight")
        }
    }



    func testWriteLittleEndian()
    {
        
        do {
            try assertWriteLittleEndian32(bytes(0x78, 0x56, 0x34, 0x12) , value:0x12345678)
            try assertWriteLittleEndian32(bytes(0xde, 0xbc, 0xac, 0x11), value:0x11acbcde)
            try assertWriteLittleEndian64(bytes(0xf0, 0xde, 0xbc, 0x9a, 0x78, 0x56, 0x34, 0x12), value:0x123456789abcdef0)
            try assertWriteLittleEndian64(bytes(0x78, 0x56, 0x34, 0x12, 0xf0, 0xde, 0xbc, 0x11), value:0x11bcdef012345678)
        }
        catch
        {
            XCTFail("Fail testWriteLittleEndian")
        }
    }
    
    func testEncodeZigZag()
    {
        XCTAssertTrue(0 == WireFormat.encodeZigZag32(n: 0), "")
        XCTAssertTrue(1 == WireFormat.encodeZigZag32(n: -1), "")
        XCTAssertTrue(2 == WireFormat.encodeZigZag32(n: 1), "")
        XCTAssertTrue(3 == WireFormat.encodeZigZag32(n: -2), "")
        XCTAssertTrue(0x7FFFFFFE == WireFormat.encodeZigZag32(n: 0x3FFFFFFF), "")
        
        
        XCTAssertTrue(0 == WireFormat.encodeZigZag64(n:  0), "")
        XCTAssertTrue(1 == WireFormat.encodeZigZag64(n: -1), "")
        XCTAssertTrue(2 == WireFormat.encodeZigZag64(n:  1), "")
        XCTAssertTrue(3 == WireFormat.encodeZigZag64(n: -2), "")
        XCTAssertTrue(0x000000007FFFFFFE == WireFormat.encodeZigZag64(n: 0x000000003FFFFFFF), "")
        
        
        XCTAssertTrue(0 == WireFormat.encodeZigZag32(n: WireFormat.decodeZigZag32(n: 0)), "")
        XCTAssertTrue(1 == WireFormat.encodeZigZag32(n: WireFormat.decodeZigZag32(n: 1)), "")
        XCTAssertTrue(-1 == WireFormat.encodeZigZag32(n: WireFormat.decodeZigZag32(n: -1)), "")
        XCTAssertTrue(14927 == WireFormat.encodeZigZag32(n: WireFormat.decodeZigZag32(n: 14927)), "")
        XCTAssertTrue(-3612 == WireFormat.encodeZigZag32(n: WireFormat.decodeZigZag32(n: -3612)), "")
        
        XCTAssertTrue(0 == WireFormat.encodeZigZag64(n: WireFormat.decodeZigZag64(n: 0)), "")
        XCTAssertTrue(1 == WireFormat.encodeZigZag64(n: WireFormat.decodeZigZag64(n: 1)), "")
        XCTAssertTrue(-1 == WireFormat.encodeZigZag64(n: WireFormat.decodeZigZag64(n: -1)), "")
        XCTAssertTrue(14927 == WireFormat.encodeZigZag64(n: WireFormat.decodeZigZag64(n: 14927)), "")
        XCTAssertTrue(-3612 == WireFormat.encodeZigZag64(n: WireFormat.decodeZigZag64(n: -3612)), "")
        
        XCTAssertTrue(856912304801416 == WireFormat.encodeZigZag64(n: WireFormat.decodeZigZag64(n: 856912304801416)), "")
        XCTAssertTrue(-75123905439571256 == WireFormat.encodeZigZag64(n: WireFormat.decodeZigZag64(n: -75123905439571256)), "")
    }
    
    func testWriteWholeMessage()
    {
//        do {
//            let message = try TestUtilities.allSet()
//        
//            let rawBytes = message.data()
//            let goldenData = TestUtilities.goldenData()
//            XCTAssertTrue(rawBytes == goldenData, "")
//        
//        // Try different block sizes.
//            
//            var blockSize:Int = 1
//            while blockSize <= 256 {
//                let rawOutput = openMemoryStream()
//                let output:CodedOutputStream = CodedOutputStream(stream:rawOutput, bufferSize:blockSize)
//                try message.writeTo(codedOutputStream:output)
//                try output.flush()
//                let actual = rawOutput.property(forKey: Stream.PropertyKey.dataWrittenToMemoryStreamKey) as! Data
//                XCTAssertTrue(rawBytes == actual, "")
//                blockSize *= 2
//            }
//        }
//        catch
//        {
//            XCTFail("Fail testWriteLittleEndian")
//        }
  
    }
    
    func testDelimitedEncodingEncoding()
    {
         do {
            let str =  (Bundle(for:TestUtilities.self).resourcePath! as NSString).appendingPathComponent("delimitedFile.dat")
            let stream = OutputStream(toFileAtPath: str, append: false)
            stream?.open()
            for i in 1...100 {
                let mes = try PBProtoPoint.Builder().setLatitude(1.0).setLongitude(Float(i)).build()
                try mes.writeDelimitedTo(outputStream:stream!)
            }
            stream?.close()
            
            let input = InputStream(fileAtPath: str)
            input?.open()
            let message = try PBProtoPoint.parseArrayDelimitedFrom(inputStream:input!)
            XCTAssertTrue(message[1].longitude == 2.0, "")
        }
        catch
        {
            XCTFail("Fail testDelimitedEncodingEncoding")
        }
    }

}
