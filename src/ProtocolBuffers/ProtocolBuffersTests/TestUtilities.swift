//
//  TestUtilities.swift
//  ProtocolBuffers
//
//  Created by Alexey Khokhlov on 07.10.14.
//  Copyright (c) 2014 alexeyxo. All rights reserved.
//

import Foundation
import XCTest
import ProtocolBuffers

class  TestUtilities {
    
    init()
    {
        
    }
    
    class func getData(str:String) -> NSData {
        var bytes = [UInt8]()
        bytes += str.utf8
        return NSData(bytes:&bytes, length:bytes.count)
    }
    class func goldenData() -> NSData {
        
        let str =  (NSBundle(forClass:TestUtilities.self).resourcePath! as NSString).stringByAppendingPathComponent("golden_message")
        let goldenData = NSData(contentsOfFile:str)!
        return goldenData
    }
    
    class func modifyRepeatedExtensions(message:ProtobufUnittest.TestAllExtensions.Builder) throws
    {
        try message.setExtension(ProtobufUnittest.UnittestRoot.repeatedInt32Extension(), index:1, value:Int32(501))
        try message.setExtension(ProtobufUnittest.UnittestRoot.repeatedInt64Extension(), index:1, value:Int64(502))
        try message.setExtension(ProtobufUnittest.UnittestRoot.repeatedUint32Extension(), index:1, value:UInt32(503))
        try message.setExtension(ProtobufUnittest.UnittestRoot.repeatedUint64Extension(), index:1, value:UInt64(504))
        try message.setExtension(ProtobufUnittest.UnittestRoot.repeatedSint32Extension(), index:1, value:Int32(505))
        try message.setExtension(ProtobufUnittest.UnittestRoot.repeatedSint64Extension(), index:1, value:Int64(506))
        try message.setExtension(ProtobufUnittest.UnittestRoot.repeatedFixed32Extension(), index:1, value:UInt32(507))
        try message.setExtension(ProtobufUnittest.UnittestRoot.repeatedFixed64Extension(), index:1, value:UInt64(508))
        try message.setExtension(ProtobufUnittest.UnittestRoot.repeatedSfixed32Extension(), index:1, value:Int32(509))
        try message.setExtension(ProtobufUnittest.UnittestRoot.repeatedSfixed64Extension(), index:1, value:Int64(510))
        try message.setExtension(ProtobufUnittest.UnittestRoot.repeatedFloatExtension(), index:1, value:Float(511.0))
        try message.setExtension(ProtobufUnittest.UnittestRoot.repeatedDoubleExtension(), index:1, value:Double(512.0))
        try message.setExtension(ProtobufUnittest.UnittestRoot.repeatedBoolExtension(), index:1, value:true)
        try message.setExtension(ProtobufUnittest.UnittestRoot.repeatedStringExtension(),index:1, value:"515")
        try message.setExtension(ProtobufUnittest.UnittestRoot.repeatedBytesExtension(), index:1, value:TestUtilities.getData("516"))

        let a = ProtobufUnittest.RepeatedGroupExtension.Builder()
        a.a = 517
        try message.setExtension(ProtobufUnittest.UnittestRoot.repeatedGroupExtension(), index:1, value:a.build())
        
        let b = ProtobufUnittest.TestAllTypes.NestedMessage.Builder()
        b.bb = 518
        try message.setExtension(ProtobufUnittest.UnittestRoot.repeatedNestedMessageExtension(), index:1, value:b.build())
        let foreign = ProtobufUnittest.ForeignMessage.Builder()
        foreign.c = 519
        try message.setExtension(ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension(), index:1, value:foreign.build())
        
        let importMessage = ProtobufUnittestImport.ImportMessage.Builder()
        importMessage.d = 520
        try message.setExtension(ProtobufUnittest.UnittestRoot.repeatedImportMessageExtension(), index:1, value:importMessage.build())
        
        try message.setExtension(ProtobufUnittest.UnittestRoot.repeatedNestedEnumExtension(), index:1, value:ProtobufUnittest.TestAllTypes.NestedEnum.Foo.rawValue)
        
        try message.setExtension(ProtobufUnittest.UnittestRoot.repeatedForeignEnumExtension(), index:1, value:ProtobufUnittest.ForeignEnum.ForeignFoo.rawValue)
        try message.setExtension(ProtobufUnittest.UnittestRoot.repeatedImportEnumExtension(), index:1, value:ProtobufUnittestImport.ImportEnum.ImportFoo.rawValue)
        
        try message.setExtension(ProtobufUnittest.UnittestRoot.repeatedStringPieceExtension(),index:1, value:"524")
        try message.setExtension(ProtobufUnittest.UnittestRoot.repeatedCordExtension(), index:1, value:"525")

    }
    
    func assertAllExtensionsSet(message:ProtobufUnittest.TestAllExtensions)
    {
        
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalInt32Extension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalInt64Extension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalUint32Extension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalUint64Extension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalSint32Extension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalSint64Extension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalFixed32Extension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalFixed64Extension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalSfixed32Extension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalSfixed64Extension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalFloatExtension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalDoubleExtension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalBoolExtension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalStringExtension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalBytesExtension()), "")
        
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalGroupExtension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalNestedMessageExtension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalForeignMessageExtension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalImportMessageExtension()), "")
        
        if let extensions = message.getExtension(ProtobufUnittest.UnittestRoot.optionalGroupExtension()) as? ProtobufUnittest.OptionalGroupExtension
        {
            XCTAssertTrue(extensions.hasA, "")
        }
        if let ext = message.getExtension(ProtobufUnittest.UnittestRoot.optionalNestedMessageExtension()) as? ProtobufUnittest.TestAllTypes.NestedMessage
        {
            XCTAssertTrue(ext.hasBb, "")
        }
        
        if let ext = message.getExtension(ProtobufUnittest.UnittestRoot.optionalForeignMessageExtension()) as? ProtobufUnittest.ForeignMessage
        {
            XCTAssertTrue(ext.hasC, "")
        }
        
        if let ext = message.getExtension(ProtobufUnittest.UnittestRoot.optionalImportMessageExtension()) as? ProtobufUnittestImport.ImportMessage
        {
            XCTAssertTrue(ext.hasD, "")
        }
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalNestedEnumExtension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalForeignEnumExtension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalImportEnumExtension()), "")
        
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalStringPieceExtension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalCordExtension()), "")
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalInt32Extension()) as? Int32
        {
            XCTAssertTrue(101 == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalInt64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(102) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalUint32Extension()) as? UInt32
        {
            XCTAssertTrue(UInt32(103) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalUint64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(104) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalSint32Extension()) as? Int32
        {
            XCTAssertTrue(105 == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalSint64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(106) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalFixed32Extension()) as? UInt32
        {
            XCTAssertTrue(UInt32(107) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalFixed64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(108) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalSfixed32Extension()) as? Int32
        {
            XCTAssertTrue(Int32(109) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalSfixed64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(110) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalFloatExtension()) as? Float
        {
            XCTAssertTrue(Float(111.0) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalDoubleExtension()) as? Double
        {
            XCTAssertTrue(Double(112.0) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalBoolExtension()) as? Bool
        {
            XCTAssertTrue(true == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalStringExtension()) as? String
        {
            XCTAssertTrue("115" == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalBytesExtension()) as? NSData
        {
            XCTAssertTrue(TestUtilities.getData("116") == val, "")
        }
        
        if let mes = message.getExtension(ProtobufUnittest.UnittestRoot.optionalGroupExtension()) as? ProtobufUnittest.OptionalGroupExtension
        {
            XCTAssertTrue(117 == mes.a, "")
        }
        
        if let mes = message.getExtension(ProtobufUnittest.UnittestRoot.optionalNestedMessageExtension()) as? ProtobufUnittest.TestAllTypes.NestedMessage
        {
            XCTAssertTrue(118 == mes.bb, "")
        }
        if let mes = message.getExtension(ProtobufUnittest.UnittestRoot.optionalForeignMessageExtension()) as? ProtobufUnittest.ForeignMessage
        {
            XCTAssertTrue(119 == mes.c, "")
        }
        if let mes = message.getExtension(ProtobufUnittest.UnittestRoot.optionalImportMessageExtension()) as? ProtobufUnittestImport.ImportMessage
        {
            XCTAssertTrue(120 == mes.d, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalNestedEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.Baz.rawValue == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalForeignEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignBaz.rawValue == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalImportEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittestImport.ImportEnum.ImportBaz.rawValue == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalStringPieceExtension()) as? String
        {
            XCTAssertTrue("124" == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalCordExtension()) as? String
        {
            XCTAssertTrue("125" == val, "")
        }
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedBytesExtension()) as? Array<Array<UInt8>>
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedNestedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedCordExtension()) as? [String]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        
        ///
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(201 == val[0],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(202 == val[0],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(203 == val[0],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(204 == val[0],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(205 == val[0],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(206 == val[0],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(207 == val[0],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(208 == val[0],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(209 == val[0],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(210 == val[0],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(Float(211.0) == val[0], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(Double(212.0) == val[0], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(true == val[0], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue("215" == val[0], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedBytesExtension()) as? Array<NSData>
        {
            XCTAssertTrue(TestUtilities.getData("216") == val[0], "")
        }
    
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage]
        {
            if let value = val[0] as? ProtobufUnittest.RepeatedGroupExtension
            {
                XCTAssertTrue(217 == value.a, "")
            }
        }
        
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage]
        {
            if let value = val[0] as? ProtobufUnittest.TestAllTypes.NestedMessage
            {
                XCTAssertTrue(218 == value.bb, "")
            }
        }
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            if let value = val[0] as? ProtobufUnittest.ForeignMessage
            {
                XCTAssertTrue(219 == value.c, "")
            }
        }
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedImportMessageExtension()) as? [GeneratedMessage]
        {
            if let value = val[0] as? ProtobufUnittestImport.ImportMessage
            {
                XCTAssertTrue(220 == value.d, "")
            }
        }
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedNestedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.Bar.rawValue == val[0], "")
        }
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignBar.rawValue == val[0], "")
        }
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittestImport.ImportEnum.ImportBar.rawValue == val[0], "")
        }
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue("224" == val[0], "")
        }
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedCordExtension()) as? [String]
        {
            XCTAssertTrue("225" == val[0], "")
        }

        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(301 == val[1],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(302 == val[1],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(303 == val[1],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(304 == val[1],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(305 == val[1],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(306 == val[1],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(307 == val[1],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(308 == val[1],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(309 == val[1],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(310 == val[1],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(Float(311.0) == val[1], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(Double(312.0) == val[1], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(false == val[1], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue("315" == val[1], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedBytesExtension()) as? Array<NSData>
        {
            XCTAssertTrue(TestUtilities.getData("316") == val[1], "")
        }
        
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage]
        {
            if let value = val[1] as? ProtobufUnittest.RepeatedGroupExtension
            {
                XCTAssertTrue(317 == value.a, "")
            }
        }
        
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage]
        {
            if let value = val[1] as? ProtobufUnittest.TestAllTypes.NestedMessage
            {
                XCTAssertTrue(318 == value.bb, "")
            }
        }
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            if let value = val[1] as? ProtobufUnittest.ForeignMessage
            {
                XCTAssertTrue(319 == value.c, "")
            }
            
        }
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedImportMessageExtension()) as? [GeneratedMessage]
        {
            if let value = val[1] as? ProtobufUnittestImport.ImportMessage
            {
                XCTAssertTrue(320 == value.d, "")
            }
            
        }
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedNestedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.Baz.rawValue == val[1], "")
        }
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignBaz.rawValue == val[1], "")
        }
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittestImport.ImportEnum.ImportBaz.rawValue == val[1], "")
        }
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue("324" == val[1], "")
        }
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedCordExtension()) as? [String]
        {
            XCTAssertTrue("325" == val[1], "")
        }
        
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultInt32Extension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultInt64Extension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultUint32Extension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultUint64Extension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultSint32Extension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultSint64Extension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultFixed32Extension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultFixed64Extension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultSfixed32Extension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultSfixed64Extension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultFloatExtension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultDoubleExtension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultBoolExtension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultStringExtension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultBytesExtension()), "")
        
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultNestedEnumExtension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultForeignEnumExtension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultImportEnumExtension()), "")
        
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultStringPieceExtension()), "")
        XCTAssertTrue(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultCordExtension()), "")
        
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultInt32Extension()) as? Int32
        {
            XCTAssertTrue(401 == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultInt64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(402) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultUint32Extension()) as? UInt32
        {
            XCTAssertTrue(UInt32(403) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultUint64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(404) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultSint32Extension()) as? Int32
        {
            XCTAssertTrue(405 == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultSint64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(406) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultFixed32Extension()) as? UInt32
        {
            XCTAssertTrue(UInt32(407) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultFixed64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(408) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultSfixed32Extension()) as? Int32
        {
            XCTAssertTrue(Int32(409) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultSfixed64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(410) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultFloatExtension()) as? Float
        {
            XCTAssertTrue(Float(411.0) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultDoubleExtension()) as? Double
        {
            XCTAssertTrue(Double(412.0) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultBoolExtension()) as? Bool
        {
            XCTAssertTrue(false == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultStringExtension()) as? String
        {
            XCTAssertTrue("415" == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultBytesExtension()) as? NSData
        {
            XCTAssertTrue(TestUtilities.getData("416") == val, "")
        }
    
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultNestedEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.Foo.rawValue == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultForeignEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignFoo.rawValue == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultImportEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittestImport.ImportEnum.ImportFoo.rawValue == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultStringPieceExtension()) as? String
        {
            XCTAssertTrue("424" == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultCordExtension()) as? String
        {
            XCTAssertTrue("425" == val, "")
        }
        
    }
    
    class func assertAllExtensionsSet(message:ProtobufUnittest.TestAllExtensions)
    {
        return TestUtilities().assertAllExtensionsSet(message)
    }
    
    func assertRepeatedExtensionsModified(message:ProtobufUnittest.TestAllExtensions)
    {
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedBytesExtension()) as? Array<Array<UInt8>>
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedNestedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedCordExtension()) as? [String]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        
        ///
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(201 == val[0],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(202 == val[0],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(203 == val[0],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(204 == val[0],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(205 == val[0],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(206 == val[0],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(207 == val[0],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(208 == val[0],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(209 == val[0],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(210 == val[0],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(Float(211.0) == val[0], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(Double(212.0) == val[0], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(true == val[0], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue("215" == val[0], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedBytesExtension()) as? Array<NSData>
        {
            XCTAssertTrue(TestUtilities.getData("216") == val[0], "")
        }
        
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage]
        {
            if let values = val[0] as? ProtobufUnittest.RepeatedGroupExtension
            {
                XCTAssertTrue(217 ==  values.a, "")
            }
        }
        
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage]
        {
            if let values = val[0] as? ProtobufUnittest.TestAllTypes.NestedMessage
            {
                XCTAssertTrue(218 == values.bb, "")
            }
            
        }
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            if let values = val[0] as? ProtobufUnittest.ForeignMessage
            {
                XCTAssertTrue(219 == values.c, "")
            }
        }
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedImportMessageExtension()) as? [GeneratedMessage]
        {
            if let values = val[0] as? ProtobufUnittestImport.ImportMessage
            {
                XCTAssertTrue(220 == values.d, "")
            }
        }
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedNestedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.Bar.rawValue == val[0], "")
        }
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignBar.rawValue == val[0], "")
        }
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittestImport.ImportEnum.ImportBar.rawValue == val[0], "")
        }
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue("224" == val[0], "")
        }
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedCordExtension()) as? [String]
        {
            XCTAssertTrue("225" == val[0], "")
        }

        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(501 == val[1],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(502 == val[1],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(503 == val[1],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(504 == val[1],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(505 == val[1],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(506 == val[1],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(507 == val[1],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(508 == val[1],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(509 == val[1],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(510 == val[1],"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(Float(511.0) == val[1], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(Double(512.0) == val[1], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(true == val[1], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue("515" == val[1], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedBytesExtension()) as? Array<NSData>
        {
            XCTAssertTrue(TestUtilities.getData("516") == val[1], "")
        }
        
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage]
        {
            if let values = val[1] as? ProtobufUnittest.RepeatedGroupExtension
            {
                XCTAssertTrue(517 == values.a, "")
            }
        }
        
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage]
        {
            if let values = val[1] as? ProtobufUnittest.TestAllTypes.NestedMessage
            {
                XCTAssertTrue(518 == values.bb, "")
            }
            
        }
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            if let values = val[1] as? ProtobufUnittest.ForeignMessage
            {
                XCTAssertTrue(519 == values.c, "")
            }
            
        }
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedImportMessageExtension()) as? [GeneratedMessage]
        {
            if let values = val[1] as? ProtobufUnittestImport.ImportMessage
            {
                XCTAssertTrue(520 == values.d, "")
            }
            
        }
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedNestedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.Foo.rawValue == val[1], "")
        }
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignFoo.rawValue == val[1], "")
        }
        if let val =  message.getExtension(ProtobufUnittest.UnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittestImport.ImportEnum.ImportFoo.rawValue == val[1], "")
        }
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue("524" == val[1], "")
        }
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedCordExtension()) as? [String]
        {
            XCTAssertTrue("525" == val[1], "")
        }
    }
    
    class func assertRepeatedExtensionsModified(message:ProtobufUnittest.TestAllExtensions)
    {
        TestUtilities().assertRepeatedExtensionsModified(message)
    }
    
    func assertAllFieldsSet(message:ProtobufUnittest.TestAllTypes)
    {
        XCTAssertTrue(message.hasOptionalInt32, "")
        XCTAssertTrue(message.hasOptionalInt64, "")
        XCTAssertTrue(message.hasOptionalUint32, "")
        XCTAssertTrue(message.hasOptionalUint64, "")
        XCTAssertTrue(message.hasOptionalSint32, "")
        XCTAssertTrue(message.hasOptionalSint64, "")
        XCTAssertTrue(message.hasOptionalFixed32, "")
        XCTAssertTrue(message.hasOptionalFixed64, "")
        XCTAssertTrue(message.hasOptionalSfixed32, "")
        XCTAssertTrue(message.hasOptionalSfixed64, "")
        XCTAssertTrue(message.hasOptionalFloat, "")
        XCTAssertTrue(message.hasOptionalDouble, "")
        XCTAssertTrue(message.hasOptionalBool, "")
        XCTAssertTrue(message.hasOptionalString, "")
        XCTAssertTrue(message.hasOptionalBytes, "")
        
        XCTAssertTrue(message.hasOptionalGroup, "")
        XCTAssertTrue(message.hasOptionalNestedMessage, "")
        XCTAssertTrue(message.hasOptionalForeignMessage, "")
        XCTAssertTrue(message.hasOptionalImportMessage, "")
        
        XCTAssertTrue(message.optionalGroup.hasA, "")
        XCTAssertTrue(message.optionalNestedMessage.hasBb, "")
        XCTAssertTrue(message.optionalForeignMessage.hasC, "")
        XCTAssertTrue(message.optionalImportMessage.hasD, "")
        
        XCTAssertTrue(message.hasOptionalNestedEnum, "")
        XCTAssertTrue(message.hasOptionalForeignEnum, "")
        XCTAssertTrue(message.hasOptionalImportEnum, "")
        
        XCTAssertTrue(message.hasOptionalStringPiece, "")
        XCTAssertTrue(message.hasOptionalCord, "")
        
        XCTAssertTrue(101 == message.optionalInt32, "")
        XCTAssertTrue(102 == message.optionalInt64, "")
        XCTAssertTrue(103 == message.optionalUint32, "")
        XCTAssertTrue(104 == message.optionalUint64, "")
        XCTAssertTrue(105 == message.optionalSint32, "")
        XCTAssertTrue(106 == message.optionalSint64, "")
        XCTAssertTrue(107 == message.optionalFixed32, "")
        XCTAssertTrue(108 == message.optionalFixed64, "")
        XCTAssertTrue(109 == message.optionalSfixed32, "")
        XCTAssertTrue(110 == message.optionalSfixed64, "")
        XCTAssertTrue(Float(111.0) == message.optionalFloat, "")
        XCTAssertTrue(Double(112.0) == message.optionalDouble, "")
        XCTAssertTrue(true == message.optionalBool, "")
        XCTAssertTrue("115" == message.optionalString, "")
        let data = TestUtilities.getData("116")
        XCTAssertTrue(data == message.optionalBytes, "")
        
        XCTAssertTrue(117 == message.optionalGroup.a, "")
        XCTAssertTrue(118 == message.optionalNestedMessage.bb, "")
        XCTAssertTrue(119 == message.optionalForeignMessage.c, "")
        XCTAssertTrue(120 == message.optionalImportMessage.d, "")
        
        XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.Baz == message.optionalNestedEnum, "")
        XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignBaz == message.optionalForeignEnum, "")
        XCTAssertTrue(ProtobufUnittestImport.ImportEnum.ImportBaz == message.optionalImportEnum, "")
        
        XCTAssertTrue("124" == message.optionalStringPiece, "")
        XCTAssertTrue("125" == message.optionalCord, "")
        
        // -----------------------------------------------------------------
        
        XCTAssertTrue(2 == message.repeatedInt32.count, "")
        XCTAssertTrue(2 == message.repeatedInt64.count, "")
        XCTAssertTrue(2 == message.repeatedUint32.count, "")
        XCTAssertTrue(2 == message.repeatedUint64.count, "")
        XCTAssertTrue(2 == message.repeatedSint32.count, "")
        XCTAssertTrue(2 == message.repeatedSint64.count, "")
        XCTAssertTrue(2 == message.repeatedFixed32.count, "")
        XCTAssertTrue(2 == message.repeatedFixed64.count, "")
        XCTAssertTrue(2 == message.repeatedSfixed32.count, "")
        XCTAssertTrue(2 == message.repeatedSfixed64.count, "")
        XCTAssertTrue(2 == message.repeatedFloat.count, "")
        XCTAssertTrue(2 == message.repeatedDouble.count, "")
        XCTAssertTrue(2 == message.repeatedBool.count, "")
        XCTAssertTrue(2 == message.repeatedString.count, "")
        XCTAssertTrue(2 == message.repeatedBytes.count, "")
        
        XCTAssertTrue(2 == message.repeatedGroup.count, "")
        XCTAssertTrue(2 == message.repeatedNestedMessage.count, "")
        XCTAssertTrue(2 == message.repeatedForeignMessage.count, "")
        XCTAssertTrue(2 == message.repeatedImportMessage.count, "")
        XCTAssertTrue(2 == message.repeatedNestedEnum.count, "")
        XCTAssertTrue(2 == message.repeatedForeignEnum.count, "")
        XCTAssertTrue(2 == message.repeatedImportEnum.count, "")
        
        XCTAssertTrue(2 == message.repeatedStringPiece.count, "")
        XCTAssertTrue(2 == message.repeatedCord.count, "")
        
        XCTAssertTrue(201 == message.repeatedInt32[0], "")
        XCTAssertTrue(202 == message.repeatedInt64[0], "")
        XCTAssertTrue(203 == message.repeatedUint32[0], "")
        XCTAssertTrue(204 == message.repeatedUint64[0], "")
        XCTAssertTrue(205 == message.repeatedSint32[0], "")
        XCTAssertTrue(206 == message.repeatedSint64[0], "")
        XCTAssertTrue(207 == message.repeatedFixed32[0], "")
        XCTAssertTrue(208 == message.repeatedFixed64[0], "")
        XCTAssertTrue(209 == message.repeatedSfixed32[0], "")
        XCTAssertTrue(210 == message.repeatedSfixed64[0], "")
        XCTAssertTrue(Float(211.0) == message.repeatedFloat[0], "")
        XCTAssertTrue(Double(212.0) == message.repeatedDouble[0], "")
        XCTAssertTrue(true == message.repeatedBool[0], "")
        XCTAssertTrue("215" == message.repeatedString[0], "")
        XCTAssertTrue(TestUtilities.getData("216") == message.repeatedBytes[0], "")
        
        XCTAssertTrue(217 == message.repeatedGroup[0].a, "")
        XCTAssertTrue(218 == message.repeatedNestedMessage[0].bb, "")
        XCTAssertTrue(219 == message.repeatedForeignMessage[0].c, "")
        XCTAssertTrue(220 == message.repeatedImportMessage[0].d, "")
        
        XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.Bar == message.repeatedNestedEnum[0], "")
        XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignBar == message.repeatedForeignEnum[0], "")
        XCTAssertTrue(ProtobufUnittestImport.ImportEnum.ImportBar == message.repeatedImportEnum[0], "")
        
        XCTAssertTrue("224" == message.repeatedStringPiece[0], "")
        XCTAssertTrue("225" == message.repeatedCord[0], "")
        
        XCTAssertTrue(301 == message.repeatedInt32[1], "")
        XCTAssertTrue(302 == message.repeatedInt64[1], "")
        XCTAssertTrue(303 == message.repeatedUint32[1], "")
        XCTAssertTrue(304 == message.repeatedUint64[1], "")
        XCTAssertTrue(305 == message.repeatedSint32[1], "")
        XCTAssertTrue(306 == message.repeatedSint64[1], "")
        XCTAssertTrue(307 == message.repeatedFixed32[1], "")
        XCTAssertTrue(308 == message.repeatedFixed64[1], "")
        XCTAssertTrue(309 == message.repeatedSfixed32[1], "")
        XCTAssertTrue(310 == message.repeatedSfixed64[1], "")
        XCTAssertTrue(Float(311.0) == message.repeatedFloat[1], "")
        XCTAssertTrue(Double(312.0) == message.repeatedDouble[1], "")
        XCTAssertTrue(false == message.repeatedBool[1], "")
        XCTAssertTrue("315" == message.repeatedString[1], "")
        XCTAssertTrue(TestUtilities.getData("316") == message.repeatedBytes[1], "")
        
        XCTAssertTrue(317 == message.repeatedGroup[1].a, "")
        XCTAssertTrue(318 == message.repeatedNestedMessage[1].bb, "")
        XCTAssertTrue(319 == message.repeatedForeignMessage[1].c, "")
        XCTAssertTrue(320 == message.repeatedImportMessage[1].d, "")
        
        XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.Baz == message.repeatedNestedEnum[1], "")
        XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignBaz == message.repeatedForeignEnum[1], "")
        XCTAssertTrue(ProtobufUnittestImport.ImportEnum.ImportBaz == message.repeatedImportEnum[1], "")
        
        XCTAssertTrue("324" == message.repeatedStringPiece[1], "")
        XCTAssertTrue("325" == message.repeatedCord[1], "")
        
        // -----------------------------------------------------------------
        
        XCTAssertTrue(message.hasDefaultInt32, "")
        XCTAssertTrue(message.hasDefaultInt64, "")
        XCTAssertTrue(message.hasDefaultUint32, "")
        XCTAssertTrue(message.hasDefaultUint64, "")
        XCTAssertTrue(message.hasDefaultSint32, "")
        XCTAssertTrue(message.hasDefaultSint64, "")
        XCTAssertTrue(message.hasDefaultFixed32, "")
        XCTAssertTrue(message.hasDefaultFixed64, "")
        XCTAssertTrue(message.hasDefaultSfixed32, "")
        XCTAssertTrue(message.hasDefaultSfixed64, "")
        XCTAssertTrue(message.hasDefaultFloat, "")
        XCTAssertTrue(message.hasDefaultDouble, "")
        XCTAssertTrue(message.hasDefaultBool, "")
        XCTAssertTrue(message.hasDefaultString, "")
        XCTAssertTrue(message.hasDefaultBytes, "")
        
        XCTAssertTrue(message.hasDefaultNestedEnum, "")
        XCTAssertTrue(message.hasDefaultForeignEnum, "")
        XCTAssertTrue(message.hasDefaultImportEnum, "")
        
        XCTAssertTrue(message.hasDefaultStringPiece, "")
        XCTAssertTrue(message.hasDefaultCord, "")
        
        XCTAssertTrue(401 == message.defaultInt32, "")
        XCTAssertTrue(402 == message.defaultInt64, "")
        XCTAssertTrue(403 == message.defaultUint32, "")
        XCTAssertTrue(404 == message.defaultUint64, "")
        XCTAssertTrue(405 == message.defaultSint32, "")
        XCTAssertTrue(406 == message.defaultSint64, "")
        XCTAssertTrue(407 == message.defaultFixed32, "")
        XCTAssertTrue(408 == message.defaultFixed64, "")
        XCTAssertTrue(409 == message.defaultSfixed32, "")
        XCTAssertTrue(410 == message.defaultSfixed64, "")
        XCTAssertTrue(Float(411.0) == message.defaultFloat, "")
        XCTAssertTrue(Double(412.0) == message.defaultDouble, "")
        XCTAssertTrue(false == message.defaultBool, "")
        XCTAssertTrue("415" == message.defaultString, "")
        XCTAssertTrue(TestUtilities.getData("416") == message.defaultBytes, "")
        
        XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.Foo == message.defaultNestedEnum, "")
        XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignFoo == message.defaultForeignEnum, "")
        XCTAssertTrue(ProtobufUnittestImport.ImportEnum.ImportFoo == message.defaultImportEnum, "")
        
        XCTAssertTrue("424" == message.defaultStringPiece, "")
        XCTAssertTrue("425" == message.defaultCord, "")
    
    }
    
    class func assertAllFieldsSet(message:ProtobufUnittest.TestAllTypes)
    {
        TestUtilities().assertAllFieldsSet(message)
    }
    
    class func setAllFields(message:ProtobufUnittest.TestAllTypes.Builder) throws
    {
        message.optionalInt32 = Int32(101)
        message.optionalInt64 = Int64(102)
        message.optionalUint32 = UInt32(103)
        message.optionalUint64 = UInt64(104)
        message.optionalSint32 = Int32(105)
        message.optionalSint64 = Int64(106)
        message.optionalFixed32 = UInt32(107)
        message.optionalFixed64 = UInt64(108)
        message.optionalSfixed32 = Int32(109)
        message.optionalSfixed64 = Int64(110)
        message.optionalFloat = Float(111.0)
        message.optionalDouble = Double(112.0)
        message.optionalBool = true
        message.optionalString = "115"
        message.optionalBytes = TestUtilities.getData("116")
        
        let gr = ProtobufUnittest.TestAllTypes.OptionalGroup.Builder()
        gr.a = 117
        message.optionalGroup = try gr.build()
        let nest = ProtobufUnittest.TestAllTypes.NestedMessage.Builder()
        nest.bb = 118
        message.optionalNestedMessage = try nest.build()
        
        let foreign = ProtobufUnittest.ForeignMessage.Builder()
        foreign.c = 119
        message.optionalForeignMessage = try foreign.build()
        
        let importMes = ProtobufUnittestImport.ImportMessage.Builder()
        importMes.d = 120
        message.optionalImportMessage = try importMes.build()
        
        message.optionalNestedEnum = ProtobufUnittest.TestAllTypes.NestedEnum.Baz
        message.optionalForeignEnum = ProtobufUnittest.ForeignEnum.ForeignBaz
        message.optionalImportEnum = ProtobufUnittestImport.ImportEnum.ImportBaz
        
        message.optionalStringPiece = "124"
        message.optionalCord = "125"
        
//        let publicImportBuilder = PublicImportMessageBuilder()
//        publicImportBuilder.e = 126
//        message.optionalPublicImportMessage = publicImportBuilder.build()
//
//        let lazymes = ProtobufUnittest.TestAllTypes.NestedMessage.Builder()
//        lazymes.bb = 127
//        message.optionalLazyMessage = lazymes.build()

        
        // -----------------------------------------------------------------
        
        message.repeatedInt32 += [201]
        message.repeatedInt64 += [202]
        message.repeatedUint32 += [203]
        message.repeatedUint64 += [204]
        message.repeatedSint32 += [205]
        message.repeatedSint64 += [206]
        message.repeatedFixed32 += [207]
        message.repeatedFixed64 += [208]
        message.repeatedSfixed32 += [209]
        message.repeatedSfixed64 += [210]
        message.repeatedFloat += [211]
        message.repeatedDouble += [212]
        message.repeatedBool += [true]
        message.repeatedString += ["215"]
        message.repeatedBytes += [TestUtilities.getData("216")]
        
        let testRep = ProtobufUnittest.TestAllTypes.RepeatedGroup.Builder()
        testRep.a = 217
        message.repeatedGroup += [try testRep.build()]
        let testNest = ProtobufUnittest.TestAllTypes.NestedMessage.Builder()
        testNest.bb = 218
        message.repeatedNestedMessage += [try testNest.build()]
        let foreign2 = ProtobufUnittest.ForeignMessage.Builder()
        foreign2.c = 219
        message.repeatedForeignMessage += [try foreign2.build()]
        let importmes = ProtobufUnittestImport.ImportMessage.Builder()
        importmes.d = 220
        message.repeatedImportMessage += [try importmes.build()]
        
        message.repeatedNestedEnum += [ProtobufUnittest.TestAllTypes.NestedEnum.Bar]
        message.repeatedForeignEnum += [ProtobufUnittest.ForeignEnum.ForeignBar]
        message.repeatedImportEnum += [ProtobufUnittestImport.ImportEnum.ImportBar]
        
        message.repeatedStringPiece += ["224"]
        message.repeatedCord += ["225"]
        
        message.repeatedInt32 += [301]
        message.repeatedInt64 += [302]
        message.repeatedUint32 += [303]
        message.repeatedUint64 += [304]
        message.repeatedSint32 += [305]
        message.repeatedSint64 += [306]
        message.repeatedFixed32 += [307]
        message.repeatedFixed64 += [308]
        message.repeatedSfixed32 += [309]
        message.repeatedSfixed64 += [310]
        message.repeatedFloat += [Float(311)]
        message.repeatedDouble += [Double(312)]
        message.repeatedBool += [false]
        message.repeatedString += ["315"]
        message.repeatedBytes += [TestUtilities.getData("316")]
        
        let repgroups = ProtobufUnittest.TestAllTypes.RepeatedGroup.Builder()
        repgroups.a = 317
        message.repeatedGroup += [try repgroups.build()]
        
        let repNested = ProtobufUnittest.TestAllTypes.NestedMessage.Builder()
        repNested.bb = 318
        message.repeatedNestedMessage += [try repNested.build()]
        
        let fBuilder = ProtobufUnittest.ForeignMessage.Builder()
        fBuilder.c = 319
        message.repeatedForeignMessage += [try fBuilder.build()]
        
        let impBuilder = ProtobufUnittestImport.ImportMessage.Builder()
        impBuilder.d = 320
        message.repeatedImportMessage += [try impBuilder.build()]
        
        message.repeatedNestedEnum += [ProtobufUnittest.TestAllTypes.NestedEnum.Baz]
        message.repeatedForeignEnum += [ProtobufUnittest.ForeignEnum.ForeignBaz]
        message.repeatedImportEnum += [ProtobufUnittestImport.ImportEnum.ImportBaz]
        
        message.repeatedStringPiece += ["324"]
        message.repeatedCord += ["325"]
        
//        let repNested2 = ProtobufUnittest.TestAllTypes.NestedMessage.Builder()
//        repNested2.bb = 227
//        message.repeatedLazyMessage = [repNested2.build()]
//        let repNested3 = ProtobufUnittest.TestAllTypes.NestedMessage.Builder()
//        repNested3.bb = 327
//        message.repeatedLazyMessage += [repNested3.build()]
        
        
        // -----------------------------------------------------------------
        
        message.defaultInt32 = 401
        message.defaultInt64 = 402
        message.defaultUint32 = 403
        message.defaultUint64 = 404
        message.defaultSint32 = 405
        message.defaultSint64 = 406
        message.defaultFixed32 = 407
        message.defaultFixed64 = 408
        message.defaultSfixed32 = 409
        message.defaultSfixed64 = 410
        message.defaultFloat = 411
        message.defaultDouble = 412
        message.defaultBool = false
        message.defaultString = "415"
        message.defaultBytes = TestUtilities.getData("416")
        
        message.defaultNestedEnum  = ProtobufUnittest.TestAllTypes.NestedEnum.Foo
        message.defaultForeignEnum = ProtobufUnittest.ForeignEnum.ForeignFoo
        message.defaultImportEnum = ProtobufUnittestImport.ImportEnum.ImportFoo
        
        message.defaultStringPiece = "424"
        message.defaultCord = "425"
        
    }
    
    class func setOneOfFields(message:ProtobufUnittest.TestAllTypes.Builder) throws
    {
        message.oneofUint32 = 601
        let builder = ProtobufUnittest.TestAllTypes.NestedMessage.Builder()
        builder.bb = 602
        message.oneofNestedMessage = try builder.build()
        message.oneofString = "603"
        message.oneofBytes = NSData(bytes: ([UInt8]() + "604".utf8), length: 3)
    }
    
    class func setAllExtensions(message:ProtobufUnittest.TestAllExtensions.Builder) throws
    {
        try message.setExtension(ProtobufUnittest.UnittestRoot.optionalInt32Extension(), value:Int32(101))
        try message.setExtension(ProtobufUnittest.UnittestRoot.optionalInt64Extension(), value:Int64(102))
        try message.setExtension(ProtobufUnittest.UnittestRoot.optionalUint32Extension(), value:UInt32(103))
        try message.setExtension(ProtobufUnittest.UnittestRoot.optionalUint64Extension(), value:UInt64(104))
        try message.setExtension(ProtobufUnittest.UnittestRoot.optionalSint32Extension(), value:Int32(105))
        try message.setExtension(ProtobufUnittest.UnittestRoot.optionalSint64Extension(), value:Int64(106))
        try message.setExtension(ProtobufUnittest.UnittestRoot.optionalFixed32Extension(), value:UInt32(107))
        try message.setExtension(ProtobufUnittest.UnittestRoot.optionalFixed64Extension(), value:UInt64(108))
        try message.setExtension(ProtobufUnittest.UnittestRoot.optionalSfixed32Extension(), value:Int32(109))
        try message.setExtension(ProtobufUnittest.UnittestRoot.optionalSfixed64Extension(), value:Int64(110))
        try message.setExtension(ProtobufUnittest.UnittestRoot.optionalFloatExtension(), value:Float(111.0))
        try message.setExtension(ProtobufUnittest.UnittestRoot.optionalDoubleExtension(), value:Double(112.0))
        try message.setExtension(ProtobufUnittest.UnittestRoot.optionalBoolExtension(), value:true)
        try message.setExtension(ProtobufUnittest.UnittestRoot.optionalStringExtension(), value:"115")
        try message.setExtension(ProtobufUnittest.UnittestRoot.optionalBytesExtension(), value:TestUtilities.getData("116"))
        
        let optgr = ProtobufUnittest.OptionalGroupExtension.Builder()
        optgr.a = 117
        try message.setExtension(ProtobufUnittest.UnittestRoot.optionalGroupExtension(), value:optgr.build())
        
        let netmesb = ProtobufUnittest.TestAllTypes.NestedMessage.Builder()
        netmesb.bb = 118
        try message.setExtension(ProtobufUnittest.UnittestRoot.optionalNestedMessageExtension(), value:netmesb.build())
        
        let forMes = ProtobufUnittest.ForeignMessage.Builder()
        forMes.c = 119
        try message.setExtension(ProtobufUnittest.UnittestRoot.optionalForeignMessageExtension(), value:forMes.build())
        
        let impMes = ProtobufUnittestImport.ImportMessage.Builder()
        impMes.d = 120
        try message.setExtension(ProtobufUnittest.UnittestRoot.optionalImportMessageExtension(), value:impMes.build())
        
        try message.setExtension(ProtobufUnittest.UnittestRoot.optionalNestedEnumExtension(), value:ProtobufUnittest.TestAllTypes.NestedEnum.Baz.rawValue)
        try message.setExtension(ProtobufUnittest.UnittestRoot.optionalForeignEnumExtension(), value:ProtobufUnittest.ForeignEnum.ForeignBaz.rawValue)
        try message.setExtension(ProtobufUnittest.UnittestRoot.optionalImportEnumExtension(), value:ProtobufUnittestImport.ImportEnum.ImportBaz.rawValue)
        
        try message.setExtension(ProtobufUnittest.UnittestRoot.optionalStringPieceExtension(),  value:"124")
        try message.setExtension(ProtobufUnittest.UnittestRoot.optionalCordExtension(), value:"125")
        
        // -----------------------------------------------------------------
        
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedInt32Extension(), value:Int32(201))
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedInt64Extension(), value:Int64(202))
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedUint32Extension(), value:UInt32(203))
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedUint64Extension(), value:UInt64(204))
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedSint32Extension(), value:Int32(205))
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedSint64Extension(), value:Int64(206))
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedFixed32Extension(), value:UInt32(207))
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedFixed64Extension(), value:UInt64(208))
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedSfixed32Extension(), value:Int32(209))
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedSfixed64Extension(), value:Int64(210))
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedFloatExtension(), value:Float(211.0))
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedDoubleExtension(), value:Double(212.0))
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedBoolExtension(), value:true)
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedStringExtension(), value:"215")
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedBytesExtension(), value:TestUtilities.getData("216"))
        
        
        let repGr = ProtobufUnittest.RepeatedGroupExtension.Builder()
        repGr.a = 217
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedGroupExtension(), value:repGr.build())
        let netmesrep = ProtobufUnittest.TestAllTypes.NestedMessage.Builder()
        netmesrep.bb = 218
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedNestedMessageExtension(), value:netmesrep.build())
        
        let msgFore = ProtobufUnittest.ForeignMessage.Builder()
        msgFore.c = 219
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension(), value:msgFore.build())
        let impMes220 = ProtobufUnittestImport.ImportMessage.Builder()
        impMes220.d = 220
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedImportMessageExtension(), value:impMes220.build())
        
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedNestedEnumExtension(), value:ProtobufUnittest.TestAllTypes.NestedEnum.Bar.rawValue)
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedForeignEnumExtension(), value:ProtobufUnittest.ForeignEnum.ForeignBar.rawValue)
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedImportEnumExtension(), value:ProtobufUnittestImport.ImportEnum.ImportBar.rawValue)
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedStringPieceExtension(), value:"224")
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedCordExtension(), value:"225")
        
        // Add a second one of each field.
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedInt32Extension(), value:Int32(301))
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedInt64Extension(), value:Int64(302))
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedUint32Extension(), value:UInt32(303))
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedUint64Extension(), value:UInt64(304))
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedSint32Extension(), value:Int32(305))
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedSint64Extension(), value:Int64(306))
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedFixed32Extension(), value:UInt32(307))
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedFixed64Extension(), value:UInt64(308))
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedSfixed32Extension(), value:Int32(309))
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedSfixed64Extension(), value:Int64(310))
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedFloatExtension(), value:Float(311.0))
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedDoubleExtension(), value:Double(312.0))
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedBoolExtension(), value:false)
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedStringExtension(), value:"315")
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedBytesExtension(), value:TestUtilities.getData("316"))
        
        
        let repGr2 = ProtobufUnittest.RepeatedGroupExtension.Builder()
        repGr2.a = 317
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedGroupExtension(), value:repGr2.build())
        let netmesrep2 = ProtobufUnittest.TestAllTypes.NestedMessage.Builder()
        netmesrep2.bb = 318
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedNestedMessageExtension(), value:netmesrep2.build())
        
        let msgFore2 = ProtobufUnittest.ForeignMessage.Builder()
        msgFore2.c = 319
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension(), value:msgFore2.build())
        let impMes2 = ProtobufUnittestImport.ImportMessage.Builder()
        impMes2.d = 320
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedImportMessageExtension(), value:impMes2.build())
        
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedNestedEnumExtension(), value:ProtobufUnittest.TestAllTypes.NestedEnum.Baz.rawValue)
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedForeignEnumExtension(), value:ProtobufUnittest.ForeignEnum.ForeignBaz.rawValue)
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedImportEnumExtension(), value:ProtobufUnittestImport.ImportEnum.ImportBaz.rawValue)
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedStringPieceExtension(), value:"324")
        try message.addExtension(ProtobufUnittest.UnittestRoot.repeatedCordExtension(), value:"325")
        
        // -----------------------------------------------------------------
        
        
        try message.setExtension(ProtobufUnittest.UnittestRoot.defaultInt32Extension(), value:Int32(401))
        try message.setExtension(ProtobufUnittest.UnittestRoot.defaultInt64Extension(), value:Int64(402))
        try message.setExtension(ProtobufUnittest.UnittestRoot.defaultUint32Extension(), value:UInt32(403))
        try message.setExtension(ProtobufUnittest.UnittestRoot.defaultUint64Extension(), value:UInt64(404))
        try message.setExtension(ProtobufUnittest.UnittestRoot.defaultSint32Extension(), value:Int32(405))
        try message.setExtension(ProtobufUnittest.UnittestRoot.defaultSint64Extension(), value:Int64(406))
        try message.setExtension(ProtobufUnittest.UnittestRoot.defaultFixed32Extension(), value:UInt32(407))
        try message.setExtension(ProtobufUnittest.UnittestRoot.defaultFixed64Extension(), value:UInt64(408))
        try message.setExtension(ProtobufUnittest.UnittestRoot.defaultSfixed32Extension(), value:Int32(409))
        try message.setExtension(ProtobufUnittest.UnittestRoot.defaultSfixed64Extension(), value:Int64(410))
        try message.setExtension(ProtobufUnittest.UnittestRoot.defaultFloatExtension(), value:Float(411.0))
        try message.setExtension(ProtobufUnittest.UnittestRoot.defaultDoubleExtension(), value:Double(412.0))
        try message.setExtension(ProtobufUnittest.UnittestRoot.defaultBoolExtension(), value:false)
        try message.setExtension(ProtobufUnittest.UnittestRoot.defaultStringExtension(), value:"415")
        try message.setExtension(ProtobufUnittest.UnittestRoot.defaultBytesExtension(), value:TestUtilities.getData("416"))
        
        try message.setExtension(ProtobufUnittest.UnittestRoot.defaultNestedEnumExtension(), value:ProtobufUnittest.TestAllTypes.NestedEnum.Foo.rawValue)
        try message.setExtension(ProtobufUnittest.UnittestRoot.defaultForeignEnumExtension(), value:ProtobufUnittest.ForeignEnum.ForeignFoo.rawValue)
        try message.setExtension(ProtobufUnittest.UnittestRoot.defaultImportEnumExtension(), value:ProtobufUnittestImport.ImportEnum.ImportFoo.rawValue)
        try message.setExtension(ProtobufUnittest.UnittestRoot.defaultStringPieceExtension(), value:"424")
        try message.setExtension(ProtobufUnittest.UnittestRoot.defaultCordExtension(), value:"425")
        
    }
    class func registerAllExtensions(registry:ExtensionRegistry)
    {
        ProtobufUnittest.UnittestRoot.sharedInstance.registerAllExtensions(registry)
    }
    
    class func extensionRegistry() -> ExtensionRegistry {
        let registry:ExtensionRegistry = ExtensionRegistry()
        TestUtilities.registerAllExtensions(registry)
        return registry
    }
    
    
    class func allSet() throws -> ProtobufUnittest.TestAllTypes {
        let builder = ProtobufUnittest.TestAllTypes.Builder()
        try TestUtilities.setAllFields(builder)
        return try builder.build()
    }
    
    
    class func allExtensionsSet() throws -> ProtobufUnittest.TestAllExtensions {
        let builder = ProtobufUnittest.TestAllExtensions.Builder()
        try TestUtilities.setAllExtensions(builder)
        return try builder.build()
    }
    
    
    class func packedSet() throws -> ProtobufUnittest.TestPackedTypes{
        let builder = ProtobufUnittest.TestPackedTypes.Builder()
        TestUtilities.setPackedFields(builder)
        return try builder.build()
    }
    
    
    class func packedExtensionsSet() throws -> ProtobufUnittest.TestPackedExtensions {
        let builder = ProtobufUnittest.TestPackedExtensions.Builder()
        try TestUtilities.setPackedExtensions(builder)
        return try builder.build()
    }
    
    func assertClear(message:ProtobufUnittest.TestAllTypes)
    {
        XCTAssertFalse(message.hasOptionalInt32, "")
        XCTAssertFalse(message.hasOptionalInt64, "")
        XCTAssertFalse(message.hasOptionalUint32, "")
        XCTAssertFalse(message.hasOptionalUint64, "")
        XCTAssertFalse(message.hasOptionalSint32, "")
        XCTAssertFalse(message.hasOptionalSint64, "")
        XCTAssertFalse(message.hasOptionalFixed32, "")
        XCTAssertFalse(message.hasOptionalFixed64, "")
        XCTAssertFalse(message.hasOptionalSfixed32, "")
        XCTAssertFalse(message.hasOptionalSfixed64, "")
        XCTAssertFalse(message.hasOptionalFloat, "")
        XCTAssertFalse(message.hasOptionalDouble, "")
        XCTAssertFalse(message.hasOptionalBool, "")
        XCTAssertFalse(message.hasOptionalString, "")
        XCTAssertFalse(message.hasOptionalBytes, "")
        
        XCTAssertFalse(message.hasOptionalGroup, "")
        XCTAssertFalse(message.hasOptionalNestedMessage, "")
        XCTAssertFalse(message.hasOptionalForeignMessage, "")
        XCTAssertFalse(message.hasOptionalImportMessage, "")
        
        XCTAssertFalse(message.hasOptionalNestedEnum, "")
        XCTAssertFalse(message.hasOptionalForeignEnum, "")
        XCTAssertFalse(message.hasOptionalImportEnum, "")
        
        XCTAssertFalse(message.hasOptionalStringPiece, "")
        XCTAssertFalse(message.hasOptionalCord, "")
        
        // Optional fields without defaults are set to zero or something like it.
        XCTAssertTrue(0 == message.optionalInt32, "")
        XCTAssertTrue(0 == message.optionalInt64, "")
        XCTAssertTrue(0 == message.optionalUint32, "")
        XCTAssertTrue(0 == message.optionalUint64, "")
        XCTAssertTrue(0 == message.optionalSint32, "")
        XCTAssertTrue(0 == message.optionalSint64, "")
        XCTAssertTrue(0 == message.optionalFixed32, "")
        XCTAssertTrue(0 == message.optionalFixed64, "")
        XCTAssertTrue(0 == message.optionalSfixed32, "")
        XCTAssertTrue(0 == message.optionalSfixed64, "")
        XCTAssertTrue(0 == message.optionalFloat, "")
        XCTAssertTrue(0 == message.optionalDouble, "")
        XCTAssertTrue(false == message.optionalBool, "")
        XCTAssertTrue("" == message.optionalString, "")
        XCTAssertTrue(NSData() == message.optionalBytes, "")
        
        // Embedded messages should also be clear.
        XCTAssertFalse(message.optionalGroup.hasA, "")
        XCTAssertFalse(message.optionalNestedMessage.hasBb, "")
        XCTAssertFalse(message.optionalForeignMessage.hasC, "")
        XCTAssertFalse(message.optionalImportMessage.hasD, "")
        
        XCTAssertTrue(0 == message.optionalGroup.a, "")
        XCTAssertTrue(0 == message.optionalNestedMessage.bb, "")
        XCTAssertTrue(0 == message.optionalForeignMessage.c, "")
        XCTAssertTrue(0 == message.optionalImportMessage.d, "")
        
        // Enums without defaults are set to the first value in the enum.
        XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.Foo == message.optionalNestedEnum, "")
        XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignFoo == message.optionalForeignEnum, "")
        XCTAssertTrue(ProtobufUnittestImport.ImportEnum.ImportFoo == message.optionalImportEnum, "")
        
        XCTAssertTrue("" == message.optionalStringPiece, "")
        XCTAssertTrue("" == message.optionalCord, "")
        
        // Repeated fields are empty.
        XCTAssertTrue(0 == message.repeatedInt32.count, "")
        XCTAssertTrue(0 == message.repeatedInt64.count, "")
        XCTAssertTrue(0 == message.repeatedUint32.count, "")
        XCTAssertTrue(0 == message.repeatedUint64.count, "")
        XCTAssertTrue(0 == message.repeatedSint32.count, "")
        XCTAssertTrue(0 == message.repeatedSint64.count, "")
        XCTAssertTrue(0 == message.repeatedFixed32.count, "")
        XCTAssertTrue(0 == message.repeatedFixed64.count, "")
        XCTAssertTrue(0 == message.repeatedSfixed32.count, "")
        XCTAssertTrue(0 == message.repeatedSfixed64.count, "")
        XCTAssertTrue(0 == message.repeatedFloat.count, "")
        XCTAssertTrue(0 == message.repeatedDouble.count, "")
        XCTAssertTrue(0 == message.repeatedBool.count, "")
        XCTAssertTrue(0 == message.repeatedString.count, "")
        XCTAssertTrue(0 == message.repeatedBytes.count, "")
        
        XCTAssertTrue(0 == message.repeatedGroup.count, "")
        XCTAssertTrue(0 == message.repeatedNestedMessage.count, "")
        XCTAssertTrue(0 == message.repeatedForeignMessage.count, "")
        XCTAssertTrue(0 == message.repeatedImportMessage.count, "")
        XCTAssertTrue(0 == message.repeatedNestedEnum.count, "")
        XCTAssertTrue(0 == message.repeatedForeignEnum.count, "")
        XCTAssertTrue(0 == message.repeatedImportEnum.count, "")
        
        XCTAssertTrue(0 == message.repeatedStringPiece.count, "")
        XCTAssertTrue(0 == message.repeatedCord.count, "")
        
        // hasBlah() should also be NO for all default fields.
        XCTAssertFalse(message.hasDefaultInt32, "")
        XCTAssertFalse(message.hasDefaultInt64, "")
        XCTAssertFalse(message.hasDefaultUint32, "")
        XCTAssertFalse(message.hasDefaultUint64, "")
        XCTAssertFalse(message.hasDefaultSint32, "")
        XCTAssertFalse(message.hasDefaultSint64, "")
        XCTAssertFalse(message.hasDefaultFixed32, "")
        XCTAssertFalse(message.hasDefaultFixed64, "")
        XCTAssertFalse(message.hasDefaultSfixed32, "")
        XCTAssertFalse(message.hasDefaultSfixed64, "")
        XCTAssertFalse(message.hasDefaultFloat, "")
        XCTAssertFalse(message.hasDefaultDouble, "")
        XCTAssertFalse(message.hasDefaultBool, "")
        XCTAssertFalse(message.hasDefaultString, "")
        XCTAssertFalse(message.hasDefaultBytes, "")
        
        XCTAssertFalse(message.hasDefaultNestedEnum, "")
        XCTAssertFalse(message.hasDefaultForeignEnum, "")
        XCTAssertFalse(message.hasDefaultImportEnum, "")
        
        XCTAssertFalse(message.hasDefaultStringPiece, "")
        XCTAssertFalse(message.hasDefaultCord, "")
        
        // Fields with defaults have their default values (duh).
        XCTAssertTrue( 41 == message.defaultInt32, "")
        XCTAssertTrue( 42 == message.defaultInt64, "")
        XCTAssertTrue( 43 == message.defaultUint32, "")
        XCTAssertTrue( 44 == message.defaultUint64, "")
        XCTAssertTrue(-45 == message.defaultSint32, "")
        XCTAssertTrue( 46 == message.defaultSint64, "")
        XCTAssertTrue( 47 == message.defaultFixed32, "")
        XCTAssertTrue( 48 == message.defaultFixed64, "")
        XCTAssertTrue( 49 == message.defaultSfixed32, "")
        XCTAssertTrue(-50 == message.defaultSfixed64, "")
        XCTAssertTrue(51.5 == message.defaultFloat, "")
        XCTAssertTrue(52e3 == message.defaultDouble, "")
        XCTAssertTrue(true == message.defaultBool, "")
        XCTAssertTrue("hello" == message.defaultString, "")
        XCTAssertTrue(TestUtilities.getData("world") == message.defaultBytes, "")
        
        XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.Bar == message.defaultNestedEnum, "")
        XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignBar == message.defaultForeignEnum, "")
        XCTAssertTrue(ProtobufUnittestImport.ImportEnum.ImportBar == message.defaultImportEnum, "")
        
        XCTAssertTrue("abc" == message.defaultStringPiece, "")
        XCTAssertTrue("123" == message.defaultCord, "")
    }
    
    class func assertClear(message:ProtobufUnittest.TestAllTypes)
    {
        TestUtilities().assertClear(message)
    }
    
    func assertExtensionsClear(message:ProtobufUnittest.TestAllExtensions)
    {
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalInt32Extension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalInt64Extension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalUint32Extension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalUint64Extension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalSint32Extension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalSint64Extension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalFixed32Extension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalFixed64Extension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalSfixed32Extension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalSfixed64Extension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalFloatExtension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalDoubleExtension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalBoolExtension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalStringExtension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalBytesExtension()), "")
        
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalGroupExtension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalNestedMessageExtension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalForeignMessageExtension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalImportMessageExtension()), "")
        
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalNestedEnumExtension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalForeignEnumExtension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalImportEnumExtension()), "")
        
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalStringPieceExtension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.optionalCordExtension()), "")
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalInt32Extension()) as? Int32
        {
            XCTAssertTrue(0 == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalInt64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(0) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalUint32Extension()) as? UInt32
        {
            XCTAssertTrue(0 == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalUint64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(0) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalSint32Extension()) as? Int32
        {
            XCTAssertTrue(0 == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalSint64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(0) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalFixed32Extension()) as? UInt32
        {
            XCTAssertTrue(UInt32(0) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalFixed64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(0) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalSfixed32Extension()) as? Int32
        {
            XCTAssertTrue(0 == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalSfixed64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(0) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalFloatExtension()) as? Float
        {
            XCTAssertTrue(Float(0) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalDoubleExtension()) as? Double
        {
            XCTAssertTrue(Double(0) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalBoolExtension()) as? Bool
        {
            XCTAssertTrue(false == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalStringExtension()) as? String
        {
            XCTAssertTrue("" == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalBytesExtension()) as? NSData
        {
            XCTAssertTrue(NSData() == val, "")
        }
        
        // Embedded messages should also be clear.
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalGroupExtension()) as? ProtobufUnittest.OptionalGroupExtension
        {
            XCTAssertFalse(val.hasA, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalNestedMessageExtension()) as? ProtobufUnittest.TestAllTypes.NestedMessage
        {
            XCTAssertFalse(val.hasBb, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalForeignMessageExtension()) as? ProtobufUnittest.ForeignMessage
        {
            XCTAssertFalse(val.hasC, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalImportMessageExtension()) as? ProtobufUnittestImport.ImportMessage
        {
            XCTAssertFalse(val.hasD, "")
        }
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalGroupExtension()) as? ProtobufUnittest.OptionalGroupExtension
        {
            XCTAssertTrue(val.a == 0, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalNestedMessageExtension()) as? ProtobufUnittest.TestAllTypes.NestedMessage
        {
            XCTAssertTrue(val.bb == 0, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalForeignMessageExtension()) as? ProtobufUnittest.ForeignMessage
        {
            XCTAssertTrue(val.c == 0, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalImportMessageExtension()) as? ProtobufUnittestImport.ImportMessage
        {
            XCTAssertTrue(val.d == 0, "")
        }
        
        // Enums without defaults are set to the first value in the enum.
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalNestedEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.Foo.rawValue == val,"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalForeignEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignFoo.rawValue == val,"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalImportEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittestImport.ImportEnum.ImportFoo.rawValue == val,"")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalStringPieceExtension()) as? String
        {
            XCTAssertTrue("" == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.optionalCordExtension()) as? String
        {
            XCTAssertTrue("" == val, "")
        }
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedBytesExtension()) as? Array<Array<UInt8>>
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedNestedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.repeatedCordExtension()) as? [String]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        
        // hasBlah() should also be NO for all default fields.
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultInt32Extension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultInt64Extension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultUint32Extension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultUint64Extension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultSint32Extension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultSint64Extension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultFixed32Extension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultFixed64Extension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultSfixed32Extension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultSfixed64Extension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultFloatExtension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultDoubleExtension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultBoolExtension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultStringExtension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultBytesExtension()), "")
        
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultNestedEnumExtension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultForeignEnumExtension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultImportEnumExtension()), "")
        
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultStringPieceExtension()), "")
        XCTAssertFalse(message.hasExtension(ProtobufUnittest.UnittestRoot.defaultCordExtension()), "")
        
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultInt32Extension()) as? Int32
        {
            XCTAssertTrue(41 == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultInt64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(42) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultUint32Extension()) as? UInt32
        {
            XCTAssertTrue(43 == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultUint64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(44) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultSint32Extension()) as? Int32
        {
            XCTAssertTrue(-45 == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultSint64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(46) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultFixed32Extension()) as? UInt32
        {
            XCTAssertTrue(UInt32(47) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultFixed64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(48) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultSfixed32Extension()) as? Int32
        {
            XCTAssertTrue(49 == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultSfixed64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(-50) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultFloatExtension()) as? Float
        {
            XCTAssertTrue(Float(51.5) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultDoubleExtension()) as? Double
        {
            XCTAssertTrue(Double(52e3) == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultBoolExtension()) as? Bool
        {
            XCTAssertTrue(true == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultStringExtension()) as? String
        {
            XCTAssertTrue("hello" == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultBytesExtension()) as? NSData
        {
            XCTAssertTrue(TestUtilities.getData("world") == val, "")
        }
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultNestedEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.Bar.rawValue == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultForeignEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignBar.rawValue == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultImportEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittestImport.ImportEnum.ImportBar.rawValue == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultStringPieceExtension()) as? String
        {
            XCTAssertTrue("abc" == val, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.defaultCordExtension()) as? String
        {
            XCTAssertTrue("123" == val, "")
        }
        
    }
    
    class func assertExtensionsClear(message:ProtobufUnittest.TestAllExtensions)
    {
        TestUtilities().assertExtensionsClear(message)
    }
    
    class func setPackedFields(message:ProtobufUnittest.TestPackedTypes.Builder)
    {
        message.packedInt32 += [601]
        message.packedInt64 += [602]
        message.packedUint32 += [603]
        message.packedUint64 += [604]
        message.packedSint32 += [605]
        message.packedSint64 += [606]
        message.packedFixed32 += [607]
        message.packedFixed64 += [608]
        message.packedSfixed32 += [609]
        message.packedSfixed64 += [610]
        message.packedFloat += [611]
        message.packedDouble += [612]
        message.packedBool += [true]
        message.packedEnum += [ProtobufUnittest.ForeignEnum.ForeignBar]
        // Add a second one of each field.
        message.packedInt32 += [701]
        message.packedInt64 += [702]
        message.packedUint32 += [703]
        message.packedUint64 += [704]
        message.packedSint32 += [705]
        message.packedSint64 += [706]
        message.packedFixed32 += [707]
        message.packedFixed64 += [708]
        message.packedSfixed32 += [709]
        message.packedSfixed64 += [710]
        message.packedFloat += [711]
        message.packedDouble += [712]
        message.packedBool += [false]
        message.packedEnum += [ProtobufUnittest.ForeignEnum.ForeignBaz]
    }
    
    func assertPackedFieldsSet(message:ProtobufUnittest.TestPackedTypes)
    {
        XCTAssertTrue(2 ==  message.packedInt32.count, "")
        XCTAssertTrue(2 ==  message.packedInt64.count, "")
        XCTAssertTrue(2 ==  message.packedUint32.count, "")
        XCTAssertTrue(2 ==  message.packedUint64.count, "")
        XCTAssertTrue(2 ==  message.packedSint32.count, "")
        XCTAssertTrue(2 ==  message.packedSint64.count, "")
        XCTAssertTrue(2 ==  message.packedFixed32.count, "")
        XCTAssertTrue(2 ==  message.packedFixed64.count, "")
        XCTAssertTrue(2 ==  message.packedSfixed32.count, "")
        XCTAssertTrue(2 ==  message.packedSfixed64.count, "")
        XCTAssertTrue(2 ==  message.packedFloat.count, "")
        XCTAssertTrue(2 ==  message.packedDouble.count, "")
        XCTAssertTrue(2 ==  message.packedBool.count, "")
        XCTAssertTrue(2 ==  message.packedEnum.count, "")
        XCTAssertTrue(601   ==  message.packedInt32[0], "")
        XCTAssertTrue(602   ==  message.packedInt64[0], "")
        XCTAssertTrue(603   ==  message.packedUint32[0], "")
        XCTAssertTrue(604   ==  message.packedUint64[0], "")
        XCTAssertTrue(605   ==  message.packedSint32[0], "")
        XCTAssertTrue(606   ==  message.packedSint64[0], "")
        XCTAssertTrue(607   ==  message.packedFixed32[0], "")
        XCTAssertTrue(608   ==  message.packedFixed64[0], "")
        XCTAssertTrue(609   ==  message.packedSfixed32[0], "")
        XCTAssertTrue(610   ==  message.packedSfixed64[0], "")
        XCTAssertTrue(611   ==  message.packedFloat[0], "")
        XCTAssertTrue(612   ==  message.packedDouble[0], "")
        XCTAssertTrue(true  ==  message.packedBool[0], "")
        XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignBar ==  message.packedEnum[0], "")
        XCTAssertTrue(701   ==  message.packedInt32[1], "")
        XCTAssertTrue(702   ==  message.packedInt64[1], "")
        XCTAssertTrue(703   ==  message.packedUint32[1], "")
        XCTAssertTrue(704   ==  message.packedUint64[1], "")
        XCTAssertTrue(705   ==  message.packedSint32[1], "")
        XCTAssertTrue(706   ==  message.packedSint64[1], "")
        XCTAssertTrue(707   ==  message.packedFixed32[1], "")
        XCTAssertTrue(708   ==  message.packedFixed64[1], "")
        XCTAssertTrue(709   ==  message.packedSfixed32[1], "")
        XCTAssertTrue(710   ==  message.packedSfixed64[1], "")
        XCTAssertTrue(711   ==  message.packedFloat[1], "")
        XCTAssertTrue(712   ==  message.packedDouble[1], "")
        XCTAssertTrue(false ==  message.packedBool[1], "")
        XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignBaz ==  message.packedEnum[1], "")
    }
    
    class func assertPackedFieldsSet(message:ProtobufUnittest.TestPackedTypes)
    {
        TestUtilities().assertPackedFieldsSet(message)
    }
    
    class func setPackedExtensions(message:ProtobufUnittest.TestPackedExtensions.Builder) throws
    {
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedInt32Extension(), value:Int32(601))
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedInt64Extension(), value:Int64(602))
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedUint32Extension(), value:UInt32(603))
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedUint64Extension(), value:UInt64(604))
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedSint32Extension(), value:Int32(605))
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedSint64Extension(), value:Int64(606))
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedFixed32Extension(), value:UInt32(607))
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedFixed64Extension(), value:UInt64(608))
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedSfixed32Extension(), value:Int32(609))
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedSfixed64Extension(), value:Int64(610))
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedFloatExtension(), value:Float(611.0))
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedDoubleExtension(),  value:Double(612.0))
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedBoolExtension(), value:true)
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedEnumExtension(), value:ProtobufUnittest.ForeignEnum.ForeignBar.rawValue)
        // Add a second one of each field.
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedInt32Extension(), value:Int32(701))
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedInt64Extension(), value:Int64(702))
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedUint32Extension(), value:UInt32(703))
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedUint64Extension(), value:UInt64(704))
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedSint32Extension(), value:Int32(705))
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedSint64Extension(), value:Int64(706))
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedFixed32Extension(), value:UInt32(707))
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedFixed64Extension(), value:UInt64(708))
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedSfixed32Extension(), value:Int32(709))
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedSfixed64Extension(), value:Int64(710))
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedFloatExtension(), value:Float(711.0))
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedDoubleExtension(), value:Double(712.0))
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedBoolExtension(), value:false)
       try message.addExtension(ProtobufUnittest.UnittestRoot.packedEnumExtension(), value:ProtobufUnittest.ForeignEnum.ForeignBaz.rawValue)
    }
    
    
    func assertPackedExtensionsSet(message:ProtobufUnittest.TestPackedExtensions)
    {
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        
        ///
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(601 == val[0], "")
        }
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(602 == val[0], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(603 == val[0], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(604 == val[0], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(605 == val[0], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(606 == val[0], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(607 == val[0], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(608 == val[0], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(609 == val[0], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(610 == val[0], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(611.0 == val[0], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(612.0 == val[0], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(true == val[0], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignBar.rawValue == val[0], "")
        }
        ///
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(701 == val[1], "")
        }
        
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(702 == val[1], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(703 == val[1], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(704 == val[1], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(705 == val[1], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(706 == val[1], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(707 == val[1], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(708 == val[1], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(709 == val[1], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(710 == val[1], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(711.0 == val[1], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(712.0 == val[1], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(false == val[1], "")
        }
        if let val = message.getExtension(ProtobufUnittest.UnittestRoot.packedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignBaz.rawValue == val[1], "")
        }
        ///
    }
    
    class func assertPackedExtensionsSet(message:ProtobufUnittest.TestPackedExtensions) {
        TestUtilities().assertPackedExtensionsSet(message)
    }
    
}