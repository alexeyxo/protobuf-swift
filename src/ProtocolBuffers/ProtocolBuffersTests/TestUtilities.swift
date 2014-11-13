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
    
    class func getData(str:String) -> [Byte] {
        var bytes = [Byte]()
        bytes += str.utf8
        return bytes
    }
    class func goldenData() -> [Byte] {
        
        var str =  NSBundle(forClass:TestUtilities.self).resourcePath!.stringByAppendingPathComponent("golden_message")
        let goldenData = NSData(contentsOfFile:str)
        var data = [Byte](count:goldenData!.length, repeatedValue:0)
        goldenData!.getBytes(&data)
        return data
    }
    
    class func modifyRepeatedExtensions(var message:TestAllExtensionsBuilder)
    {
        message.setExtension(UnittestRoot.repeatedInt32Extension(), index:1, value:Int32(501))
        message.setExtension(UnittestRoot.repeatedInt64Extension(), index:1, value:Int64(502))
        message.setExtension(UnittestRoot.repeatedUint32Extension(), index:1, value:UInt32(503))
        message.setExtension(UnittestRoot.repeatedUint64Extension(), index:1, value:UInt64(504))
        message.setExtension(UnittestRoot.repeatedSint32Extension(), index:1, value:Int32(505))
        message.setExtension(UnittestRoot.repeatedSint64Extension(), index:1, value:Int64(506))
        message.setExtension(UnittestRoot.repeatedFixed32Extension(), index:1, value:UInt32(507))
        message.setExtension(UnittestRoot.repeatedFixed64Extension(), index:1, value:UInt64(508))
        message.setExtension(UnittestRoot.repeatedSfixed32Extension(), index:1, value:Int32(509))
        message.setExtension(UnittestRoot.repeatedSfixed64Extension(), index:1, value:Int64(510))
        message.setExtension(UnittestRoot.repeatedFloatExtension(), index:1, value:Float(511.0))
        message.setExtension(UnittestRoot.repeatedDoubleExtension(), index:1, value:Double(512.0))
        message.setExtension(UnittestRoot.repeatedBoolExtension(), index:1, value:true)
        message.setExtension(UnittestRoot.repeatedStringExtension(),index:1, value:"515")
        message.setExtension(UnittestRoot.repeatedBytesExtension(), index:1, value:TestUtilities.getData("516"))

        var a = RepeatedGroup_extension.builder()
        a.a = 517
        message.setExtension(UnittestRoot.repeatedGroupExtension(), index:1, value:a.build())
        
        var b = TestAllTypes.NestedMessage.builder()
        b.bb = 518
        message.setExtension(UnittestRoot.repeatedNestedMessageExtension(), index:1, value:b.build())
        var foreign = ForeignMessage.builder()
        foreign.c = 519
        message.setExtension(UnittestRoot.repeatedForeignMessageExtension(), index:1, value:foreign.build())
        
        var importMessage = ImportMessage.builder()
        importMessage.d = 520
        message.setExtension(UnittestRoot.repeatedImportMessageExtension(), index:1, value:importMessage.build())
        
        message.setExtension(UnittestRoot.repeatedNestedEnumExtension(), index:1, value:TestAllTypes.NestedEnum.Foo.rawValue)
        
        message.setExtension(UnittestRoot.repeatedForeignEnumExtension(), index:1, value:ForeignEnum.ForeignFoo.rawValue)
        message.setExtension(UnittestRoot.repeatedImportEnumExtension(), index:1, value:ImportEnum.ImportFoo.rawValue)
        
        message.setExtension(UnittestRoot.repeatedStringPieceExtension(),index:1, value:"524")
        message.setExtension(UnittestRoot.repeatedCordExtension(), index:1, value:"525")

    }
    
    func assertAllExtensionsSet(var message:TestAllExtensions)
    {
        
        XCTAssertTrue(message.hasExtension(UnittestRoot.optionalInt32Extension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.optionalInt64Extension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.optionalUint32Extension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.optionalUint64Extension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.optionalSint32Extension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.optionalSint64Extension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.optionalFixed32Extension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.optionalFixed64Extension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.optionalSfixed32Extension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.optionalSfixed64Extension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.optionalFloatExtension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.optionalDoubleExtension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.optionalBoolExtension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.optionalStringExtension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.optionalBytesExtension()), "")
        
        XCTAssertTrue(message.hasExtension(UnittestRoot.optionalGroupExtension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.optionalNestedMessageExtension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.optionalForeignMessageExtension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.optionalImportMessageExtension()), "")
        
        if let extensions = message.getExtension(UnittestRoot.optionalGroupExtension()) as? OptionalGroup_extension
        {
            XCTAssertTrue(extensions.hasA, "")
        }
        if let ext = message.getExtension(UnittestRoot.optionalNestedMessageExtension()) as? TestAllTypes.NestedMessage
        {
            XCTAssertTrue(ext.hasBb, "")
        }
        
        if let ext = message.getExtension(UnittestRoot.optionalForeignMessageExtension()) as? ForeignMessage
        {
            XCTAssertTrue(ext.hasC, "")
        }
        
        if let ext = message.getExtension(UnittestRoot.optionalImportMessageExtension()) as? ImportMessage
        {
            XCTAssertTrue(ext.hasD, "")
        }
        XCTAssertTrue(message.hasExtension(UnittestRoot.optionalNestedEnumExtension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.optionalForeignEnumExtension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.optionalImportEnumExtension()), "")
        
        XCTAssertTrue(message.hasExtension(UnittestRoot.optionalStringPieceExtension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.optionalCordExtension()), "")
        
        if let val = message.getExtension(UnittestRoot.optionalInt32Extension()) as? Int32
        {
            XCTAssertTrue(101 == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalInt64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(102) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalUint32Extension()) as? UInt32
        {
            XCTAssertTrue(UInt32(103) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalUint64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(104) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalSint32Extension()) as? Int32
        {
            XCTAssertTrue(105 == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalSint64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(106) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalFixed32Extension()) as? UInt32
        {
            XCTAssertTrue(UInt32(107) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalFixed64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(108) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalSfixed32Extension()) as? Int32
        {
            XCTAssertTrue(Int32(109) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalSfixed64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(110) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalFloatExtension()) as? Float
        {
            XCTAssertTrue(Float(111.0) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalDoubleExtension()) as? Double
        {
            XCTAssertTrue(Double(112.0) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalBoolExtension()) as? Bool
        {
            XCTAssertTrue(true == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalStringExtension()) as? String
        {
            XCTAssertTrue("115" == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalBytesExtension()) as? [Byte]
        {
            XCTAssertTrue(TestUtilities.getData("116") == val, "")
        }
        
        if let mes = message.getExtension(UnittestRoot.optionalGroupExtension()) as? OptionalGroup_extension
        {
            XCTAssertTrue(117 == mes.a, "")
        }
        
        if let mes = message.getExtension(UnittestRoot.optionalNestedMessageExtension()) as? TestAllTypes.NestedMessage
        {
            XCTAssertTrue(118 == mes.bb, "")
        }
        if let mes = message.getExtension(UnittestRoot.optionalForeignMessageExtension()) as? ForeignMessage
        {
            XCTAssertTrue(119 == mes.c, "")
        }
        if let mes = message.getExtension(UnittestRoot.optionalImportMessageExtension()) as? ImportMessage
        {
            XCTAssertTrue(120 == mes.d, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalNestedEnumExtension()) as? Int32
        {
            XCTAssertTrue(TestAllTypes.NestedEnum.Baz.rawValue == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalForeignEnumExtension()) as? Int32
        {
            XCTAssertTrue(ForeignEnum.ForeignBaz.rawValue == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalImportEnumExtension()) as? Int32
        {
            XCTAssertTrue(ImportEnum.ImportBaz.rawValue == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalStringPieceExtension()) as? String
        {
            XCTAssertTrue("124" == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalCordExtension()) as? String
        {
            XCTAssertTrue("125" == val, "")
        }
        
        if let val = message.getExtension(UnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        
        if let val = message.getExtension(UnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedBytesExtension()) as? Array<Array<Byte>>
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        
        if let val = message.getExtension(UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedNestedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedCordExtension()) as? [String]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        
        ///
        if let val = message.getExtension(UnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(201 == val[0],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(202 == val[0],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(203 == val[0],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(204 == val[0],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(205 == val[0],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(206 == val[0],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(207 == val[0],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(208 == val[0],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(209 == val[0],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(210 == val[0],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(Float(211.0) == val[0], "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(Double(212.0) == val[0], "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(true == val[0], "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue("215" == val[0], "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedBytesExtension()) as? Array<Array<Byte>>
        {
            XCTAssertTrue(TestUtilities.getData("216") == val[0], "")
        }
    
        if let val =  message.getExtension(UnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage]
        {
            if let value = val[0] as? RepeatedGroup_extension
            {
                XCTAssertTrue(217 == value.a, "")
            }
        }
        
        if let val =  message.getExtension(UnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage]
        {
            if let value = val[0] as? TestAllTypes.NestedMessage
            {
                XCTAssertTrue(218 == value.bb, "")
            }
        }
        if let val =  message.getExtension(UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            if let value = val[0] as? ForeignMessage
            {
                XCTAssertTrue(219 == value.c, "")
            }
        }
        if let val =  message.getExtension(UnittestRoot.repeatedImportMessageExtension()) as? [GeneratedMessage]
        {
            if let value = val[0] as? ImportMessage
            {
                XCTAssertTrue(220 == value.d, "")
            }
        }
        if let val =  message.getExtension(UnittestRoot.repeatedNestedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(TestAllTypes.NestedEnum.Bar.rawValue == val[0], "")
        }
        if let val =  message.getExtension(UnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ForeignEnum.ForeignBar.rawValue == val[0], "")
        }
        if let val =  message.getExtension(UnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ImportEnum.ImportBar.rawValue == val[0], "")
        }
        
        if let val = message.getExtension(UnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue("224" == val[0], "")
        }
        
        if let val = message.getExtension(UnittestRoot.repeatedCordExtension()) as? [String]
        {
            XCTAssertTrue("225" == val[0], "")
        }

        if let val = message.getExtension(UnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(301 == val[1],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(302 == val[1],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(303 == val[1],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(304 == val[1],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(305 == val[1],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(306 == val[1],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(307 == val[1],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(308 == val[1],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(309 == val[1],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(310 == val[1],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(Float(311.0) == val[1], "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(Double(312.0) == val[1], "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(false == val[1], "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue("315" == val[1], "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedBytesExtension()) as? Array<Array<Byte>>
        {
            XCTAssertTrue(TestUtilities.getData("316") == val[1], "")
        }
        
        if let val =  message.getExtension(UnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage]
        {
            if let value = val[1] as? RepeatedGroup_extension
            {
                XCTAssertTrue(317 == value.a, "")
            }
        }
        
        if let val =  message.getExtension(UnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage]
        {
            if let value = val[1] as? TestAllTypes.NestedMessage
            {
                XCTAssertTrue(318 == value.bb, "")
            }
        }
        if let val =  message.getExtension(UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            if let value = val[1] as? ForeignMessage
            {
                XCTAssertTrue(319 == value.c, "")
            }
            
        }
        if let val =  message.getExtension(UnittestRoot.repeatedImportMessageExtension()) as? [GeneratedMessage]
        {
            if let value = val[1] as? ImportMessage
            {
                XCTAssertTrue(320 == value.d, "")
            }
            
        }
        if let val =  message.getExtension(UnittestRoot.repeatedNestedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(TestAllTypes.NestedEnum.Baz.rawValue == val[1], "")
        }
        if let val =  message.getExtension(UnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ForeignEnum.ForeignBaz.rawValue == val[1], "")
        }
        if let val =  message.getExtension(UnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ImportEnum.ImportBaz.rawValue == val[1], "")
        }
        
        if let val = message.getExtension(UnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue("324" == val[1], "")
        }
        
        if let val = message.getExtension(UnittestRoot.repeatedCordExtension()) as? [String]
        {
            XCTAssertTrue("325" == val[1], "")
        }
        
        XCTAssertTrue(message.hasExtension(UnittestRoot.defaultInt32Extension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.defaultInt64Extension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.defaultUint32Extension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.defaultUint64Extension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.defaultSint32Extension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.defaultSint64Extension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.defaultFixed32Extension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.defaultFixed64Extension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.defaultSfixed32Extension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.defaultSfixed64Extension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.defaultFloatExtension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.defaultDoubleExtension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.defaultBoolExtension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.defaultStringExtension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.defaultBytesExtension()), "")
        
        XCTAssertTrue(message.hasExtension(UnittestRoot.defaultNestedEnumExtension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.defaultForeignEnumExtension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.defaultImportEnumExtension()), "")
        
        XCTAssertTrue(message.hasExtension(UnittestRoot.defaultStringPieceExtension()), "")
        XCTAssertTrue(message.hasExtension(UnittestRoot.defaultCordExtension()), "")
        
        
        if let val = message.getExtension(UnittestRoot.defaultInt32Extension()) as? Int32
        {
            XCTAssertTrue(401 == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultInt64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(402) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultUint32Extension()) as? UInt32
        {
            XCTAssertTrue(UInt32(403) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultUint64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(404) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultSint32Extension()) as? Int32
        {
            XCTAssertTrue(405 == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultSint64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(406) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultFixed32Extension()) as? UInt32
        {
            XCTAssertTrue(UInt32(407) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultFixed64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(408) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultSfixed32Extension()) as? Int32
        {
            XCTAssertTrue(Int32(409) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultSfixed64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(410) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultFloatExtension()) as? Float
        {
            XCTAssertTrue(Float(411.0) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultDoubleExtension()) as? Double
        {
            XCTAssertTrue(Double(412.0) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultBoolExtension()) as? Bool
        {
            XCTAssertTrue(false == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultStringExtension()) as? String
        {
            XCTAssertTrue("415" == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultBytesExtension()) as? [Byte]
        {
            XCTAssertTrue(TestUtilities.getData("416") == val, "")
        }
    
        if let val = message.getExtension(UnittestRoot.defaultNestedEnumExtension()) as? Int32
        {
            XCTAssertTrue(TestAllTypes.NestedEnum.Foo.rawValue == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultForeignEnumExtension()) as? Int32
        {
            XCTAssertTrue(ForeignEnum.ForeignFoo.rawValue == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultImportEnumExtension()) as? Int32
        {
            XCTAssertTrue(ImportEnum.ImportFoo.rawValue == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultStringPieceExtension()) as? String
        {
            XCTAssertTrue("424" == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultCordExtension()) as? String
        {
            XCTAssertTrue("425" == val, "")
        }
        
    }
    
    class func assertAllExtensionsSet(message:TestAllExtensions)
    {
        return TestUtilities().assertAllExtensionsSet(message)
    }
    
    func assertRepeatedExtensionsModified(message:TestAllExtensions)
    {
        
        if let val = message.getExtension(UnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        
        if let val = message.getExtension(UnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedBytesExtension()) as? Array<Array<Byte>>
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        
        if let val = message.getExtension(UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedNestedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedCordExtension()) as? [String]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        
        ///
        if let val = message.getExtension(UnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(201 == val[0],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(202 == val[0],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(203 == val[0],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(204 == val[0],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(205 == val[0],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(206 == val[0],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(207 == val[0],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(208 == val[0],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(209 == val[0],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(210 == val[0],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(Float(211.0) == val[0], "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(Double(212.0) == val[0], "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(true == val[0], "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue("215" == val[0], "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedBytesExtension()) as? Array<Array<Byte>>
        {
            XCTAssertTrue(TestUtilities.getData("216") == val[0], "")
        }
        
        if let val =  message.getExtension(UnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage]
        {
            if let values = val[0] as? RepeatedGroup_extension
            {
                XCTAssertTrue(217 ==  values.a, "")
            }
        }
        
        if let val =  message.getExtension(UnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage]
        {
            if let values = val[0] as? TestAllTypes.NestedMessage
            {
                XCTAssertTrue(218 == values.bb, "")
            }
            
        }
        if let val =  message.getExtension(UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            if let values = val[0] as? ForeignMessage
            {
                XCTAssertTrue(219 == values.c, "")
            }
        }
        if let val =  message.getExtension(UnittestRoot.repeatedImportMessageExtension()) as? [GeneratedMessage]
        {
            if let values = val[0] as? ImportMessage
            {
                XCTAssertTrue(220 == values.d, "")
            }
        }
        if let val =  message.getExtension(UnittestRoot.repeatedNestedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(TestAllTypes.NestedEnum.Bar.rawValue == val[0], "")
        }
        if let val =  message.getExtension(UnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ForeignEnum.ForeignBar.rawValue == val[0], "")
        }
        if let val =  message.getExtension(UnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ImportEnum.ImportBar.rawValue == val[0], "")
        }
        
        if let val = message.getExtension(UnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue("224" == val[0], "")
        }
        
        if let val = message.getExtension(UnittestRoot.repeatedCordExtension()) as? [String]
        {
            XCTAssertTrue("225" == val[0], "")
        }

        
        if let val = message.getExtension(UnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(501 == val[1],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(502 == val[1],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(503 == val[1],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(504 == val[1],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(505 == val[1],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(506 == val[1],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(507 == val[1],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(508 == val[1],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(509 == val[1],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(510 == val[1],"")
        }
        if let val = message.getExtension(UnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(Float(511.0) == val[1], "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(Double(512.0) == val[1], "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(true == val[1], "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue("515" == val[1], "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedBytesExtension()) as? Array<Array<Byte>>
        {
            XCTAssertTrue(TestUtilities.getData("516") == val[1], "")
        }
        
        if let val =  message.getExtension(UnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage]
        {
            if let values = val[1] as? RepeatedGroup_extension
            {
                XCTAssertTrue(517 == values.a, "")
            }
        }
        
        if let val =  message.getExtension(UnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage]
        {
            if let values = val[1] as? TestAllTypes.NestedMessage
            {
                XCTAssertTrue(518 == values.bb, "")
            }
            
        }
        if let val =  message.getExtension(UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            if let values = val[1] as? ForeignMessage
            {
                XCTAssertTrue(519 == values.c, "")
            }
            
        }
        if let val =  message.getExtension(UnittestRoot.repeatedImportMessageExtension()) as? [GeneratedMessage]
        {
            if let values = val[1] as? ImportMessage
            {
                XCTAssertTrue(520 == values.d, "")
            }
            
        }
        if let val =  message.getExtension(UnittestRoot.repeatedNestedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(TestAllTypes.NestedEnum.Foo.rawValue == val[1], "")
        }
        if let val =  message.getExtension(UnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ForeignEnum.ForeignFoo.rawValue == val[1], "")
        }
        if let val =  message.getExtension(UnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ImportEnum.ImportFoo.rawValue == val[1], "")
        }
        
        if let val = message.getExtension(UnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue("524" == val[1], "")
        }
        
        if let val = message.getExtension(UnittestRoot.repeatedCordExtension()) as? [String]
        {
            XCTAssertTrue("525" == val[1], "")
        }
    }
    
    class func assertRepeatedExtensionsModified(message:TestAllExtensions)
    {
        TestUtilities().assertRepeatedExtensionsModified(message)
    }
    
    func assertAllFieldsSet(message:TestAllTypes)
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
        var data = TestUtilities.getData("116")
        XCTAssertTrue(data == message.optionalBytes, "")
        
        XCTAssertTrue(117 == message.optionalGroup.a, "")
        XCTAssertTrue(118 == message.optionalNestedMessage.bb, "")
        XCTAssertTrue(119 == message.optionalForeignMessage.c, "")
        XCTAssertTrue(120 == message.optionalImportMessage.d, "")
        
        XCTAssertTrue(TestAllTypes.NestedEnum.Baz == message.optionalNestedEnum, "")
        XCTAssertTrue(ForeignEnum.ForeignBaz == message.optionalForeignEnum, "")
        XCTAssertTrue(ImportEnum.ImportBaz == message.optionalImportEnum, "")
        
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
        
        XCTAssertTrue(TestAllTypes.NestedEnum.Bar == message.repeatedNestedEnum[0], "")
        XCTAssertTrue(ForeignEnum.ForeignBar == message.repeatedForeignEnum[0], "")
        XCTAssertTrue(ImportEnum.ImportBar == message.repeatedImportEnum[0], "")
        
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
        
        XCTAssertTrue(TestAllTypes.NestedEnum.Baz == message.repeatedNestedEnum[1], "")
        XCTAssertTrue(ForeignEnum.ForeignBaz == message.repeatedForeignEnum[1], "")
        XCTAssertTrue(ImportEnum.ImportBaz == message.repeatedImportEnum[1], "")
        
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
        
        XCTAssertTrue(TestAllTypes.NestedEnum.Foo == message.defaultNestedEnum, "")
        XCTAssertTrue(ForeignEnum.ForeignFoo == message.defaultForeignEnum, "")
        XCTAssertTrue(ImportEnum.ImportFoo == message.defaultImportEnum, "")
        
        XCTAssertTrue("424" == message.defaultStringPiece, "")
        XCTAssertTrue("425" == message.defaultCord, "")
    
    }
    
    class func assertAllFieldsSet(message:TestAllTypes)
    {
        TestUtilities().assertAllFieldsSet(message)
    }
    
    class func setAllFields(message:TestAllTypesBuilder)
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
        
        var gr = TestAllTypes.OptionalGroup.builder()
        gr.a = 117
        message.optionalGroup = gr.build()
        var nest = TestAllTypes.NestedMessage.builder()
        nest.bb = 118
        message.optionalNestedMessage = nest.build()
        
        var foreign = ForeignMessage.builder()
        foreign.c = 119
        message.optionalForeignMessage = foreign.build()
        
        var importMes = ImportMessage.builder()
        importMes.d = 120
        message.optionalImportMessage = importMes.build()
        
        message.optionalNestedEnum = TestAllTypes.NestedEnum.Baz
        message.optionalForeignEnum = ForeignEnum.ForeignBaz
        message.optionalImportEnum = ImportEnum.ImportBaz
        
        message.optionalStringPiece = "124"
        message.optionalCord = "125"
        
//        var publicImportBuilder = PublicImportMessageBuilder()
//        publicImportBuilder.e = 126
//        message.optionalPublicImportMessage = publicImportBuilder.build()
//
//        var lazymes = TestAllTypes.NestedMessage.builder()
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
        
        var testRep = TestAllTypes.RepeatedGroup.builder()
        testRep.a = 217
        message.repeatedGroup += [testRep.build()]
        var testNest = TestAllTypes.NestedMessage.builder()
        testNest.bb = 218
        message.repeatedNestedMessage += [testNest.build()]
        var foreign2 = ForeignMessage.builder()
        foreign2.c = 219
        message.repeatedForeignMessage += [foreign2.build()]
        var importmes = ImportMessage.builder()
        importmes.d = 220
        message.repeatedImportMessage += [importmes.build()]
        
        message.repeatedNestedEnum += [TestAllTypes.NestedEnum.Bar]
        message.repeatedForeignEnum += [ForeignEnum.ForeignBar]
        message.repeatedImportEnum += [ImportEnum.ImportBar]
        
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
        
        var repgroups = TestAllTypes.RepeatedGroup.builder()
        repgroups.a = 317
        message.repeatedGroup += [repgroups.build()]
        
        var repNested = TestAllTypes.NestedMessage.builder()
        repNested.bb = 318
        message.repeatedNestedMessage += [repNested.build()]
        
        var fBuilder = ForeignMessage.builder()
        fBuilder.c = 319
        message.repeatedForeignMessage += [fBuilder.build()]
        
        var impBuilder = ImportMessage.builder()
        impBuilder.d = 320
        message.repeatedImportMessage += [impBuilder.build()]
        
        message.repeatedNestedEnum += [TestAllTypes.NestedEnum.Baz]
        message.repeatedForeignEnum += [ForeignEnum.ForeignBaz]
        message.repeatedImportEnum += [ImportEnum.ImportBaz]
        
        message.repeatedStringPiece += ["324"]
        message.repeatedCord += ["325"]
        
//        var repNested2 = TestAllTypes.NestedMessage.builder()
//        repNested2.bb = 227
//        message.repeatedLazyMessage = [repNested2.build()]
//        var repNested3 = TestAllTypes.NestedMessage.builder()
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
        
        message.defaultNestedEnum  = TestAllTypes.NestedEnum.Foo
        message.defaultForeignEnum = ForeignEnum.ForeignFoo
        message.defaultImportEnum = ImportEnum.ImportFoo
        
        message.defaultStringPiece = "424"
        message.defaultCord = "425"
        
    }
    
    class func setOneOfFields(message:TestAllTypesBuilder)
    {
        message.oneofUint32 = 601
        var builder = TestAllTypes.NestedMessage.builder()
        builder.bb = 602
        message.oneofNestedMessage = builder.build()
        message.oneofString = "603"
        message.oneofBytes = [Byte]() + "604".utf8
    }
    
    class func setAllExtensions(message:TestAllExtensionsBuilder)
    {
        message.setExtension(UnittestRoot.optionalInt32Extension(), value:Int32(101))
        message.setExtension(UnittestRoot.optionalInt64Extension(), value:Int64(102))
        message.setExtension(UnittestRoot.optionalUint32Extension(), value:UInt32(103))
        message.setExtension(UnittestRoot.optionalUint64Extension(), value:UInt64(104))
        message.setExtension(UnittestRoot.optionalSint32Extension(), value:Int32(105))
        message.setExtension(UnittestRoot.optionalSint64Extension(), value:Int64(106))
        message.setExtension(UnittestRoot.optionalFixed32Extension(), value:UInt32(107))
        message.setExtension(UnittestRoot.optionalFixed64Extension(), value:UInt64(108))
        message.setExtension(UnittestRoot.optionalSfixed32Extension(), value:Int32(109))
        message.setExtension(UnittestRoot.optionalSfixed64Extension(), value:Int64(110))
        message.setExtension(UnittestRoot.optionalFloatExtension(), value:Float(111.0))
        message.setExtension(UnittestRoot.optionalDoubleExtension(), value:Double(112.0))
        message.setExtension(UnittestRoot.optionalBoolExtension(), value:true)
        message.setExtension(UnittestRoot.optionalStringExtension(), value:"115")
        message.setExtension(UnittestRoot.optionalBytesExtension(), value:TestUtilities.getData("116"))
        
        var optgr = OptionalGroup_extension.builder()
        optgr.a = 117
        message.setExtension(UnittestRoot.optionalGroupExtension(), value:optgr.build())
        
        var netmesb = TestAllTypes.NestedMessage.builder()
        netmesb.bb = 118
        message.setExtension(UnittestRoot.optionalNestedMessageExtension(), value:netmesb.build())
        
        var forMes = ForeignMessage.builder()
        forMes.c = 119
        message.setExtension(UnittestRoot.optionalForeignMessageExtension(), value:forMes.build())
        
        var impMes = ImportMessage.builder()
        impMes.d = 120
        message.setExtension(UnittestRoot.optionalImportMessageExtension(), value:impMes.build())
        
        message.setExtension(UnittestRoot.optionalNestedEnumExtension(), value:TestAllTypes.NestedEnum.Baz.rawValue)
        message.setExtension(UnittestRoot.optionalForeignEnumExtension(), value:ForeignEnum.ForeignBaz.rawValue)
        message.setExtension(UnittestRoot.optionalImportEnumExtension(), value:ImportEnum.ImportBaz.rawValue)
        
        message.setExtension(UnittestRoot.optionalStringPieceExtension(),  value:"124")
        message.setExtension(UnittestRoot.optionalCordExtension(), value:"125")
        
        // -----------------------------------------------------------------
        
        message.addExtension(UnittestRoot.repeatedInt32Extension(), value:Int32(201))
        message.addExtension(UnittestRoot.repeatedInt64Extension(), value:Int64(202))
        message.addExtension(UnittestRoot.repeatedUint32Extension(), value:UInt32(203))
        message.addExtension(UnittestRoot.repeatedUint64Extension(), value:UInt64(204))
        message.addExtension(UnittestRoot.repeatedSint32Extension(), value:Int32(205))
        message.addExtension(UnittestRoot.repeatedSint64Extension(), value:Int64(206))
        message.addExtension(UnittestRoot.repeatedFixed32Extension(), value:UInt32(207))
        message.addExtension(UnittestRoot.repeatedFixed64Extension(), value:UInt64(208))
        message.addExtension(UnittestRoot.repeatedSfixed32Extension(), value:Int32(209))
        message.addExtension(UnittestRoot.repeatedSfixed64Extension(), value:Int64(210))
        message.addExtension(UnittestRoot.repeatedFloatExtension(), value:Float(211.0))
        message.addExtension(UnittestRoot.repeatedDoubleExtension(), value:Double(212.0))
        message.addExtension(UnittestRoot.repeatedBoolExtension(), value:true)
        message.addExtension(UnittestRoot.repeatedStringExtension(), value:"215")
        message.addExtension(UnittestRoot.repeatedBytesExtension(), value:TestUtilities.getData("216"))
        
        
        var repGr = RepeatedGroup_extension.builder()
        repGr.a = 217
        message.addExtension(UnittestRoot.repeatedGroupExtension(), value:repGr.build())
        var netmesrep = TestAllTypes.NestedMessage.builder()
        netmesrep.bb = 218
        message.addExtension(UnittestRoot.repeatedNestedMessageExtension(), value:netmesrep.build())
        
        var msgFore = ForeignMessage.builder()
        msgFore.c = 219
        message.addExtension(UnittestRoot.repeatedForeignMessageExtension(), value:msgFore.build())
        var impMes220 = ImportMessage.builder()
        impMes220.d = 220
        message.addExtension(UnittestRoot.repeatedImportMessageExtension(), value:impMes220.build())
        
        message.addExtension(UnittestRoot.repeatedNestedEnumExtension(), value:TestAllTypes.NestedEnum.Bar.rawValue)
        message.addExtension(UnittestRoot.repeatedForeignEnumExtension(), value:ForeignEnum.ForeignBar.rawValue)
        message.addExtension(UnittestRoot.repeatedImportEnumExtension(), value:ImportEnum.ImportBar.rawValue)
        message.addExtension(UnittestRoot.repeatedStringPieceExtension(), value:"224")
        message.addExtension(UnittestRoot.repeatedCordExtension(), value:"225")
        
        // Add a second one of each field.
        message.addExtension(UnittestRoot.repeatedInt32Extension(), value:Int32(301))
        message.addExtension(UnittestRoot.repeatedInt64Extension(), value:Int64(302))
        message.addExtension(UnittestRoot.repeatedUint32Extension(), value:UInt32(303))
        message.addExtension(UnittestRoot.repeatedUint64Extension(), value:UInt64(304))
        message.addExtension(UnittestRoot.repeatedSint32Extension(), value:Int32(305))
        message.addExtension(UnittestRoot.repeatedSint64Extension(), value:Int64(306))
        message.addExtension(UnittestRoot.repeatedFixed32Extension(), value:UInt32(307))
        message.addExtension(UnittestRoot.repeatedFixed64Extension(), value:UInt64(308))
        message.addExtension(UnittestRoot.repeatedSfixed32Extension(), value:Int32(309))
        message.addExtension(UnittestRoot.repeatedSfixed64Extension(), value:Int64(310))
        message.addExtension(UnittestRoot.repeatedFloatExtension(), value:Float(311.0))
        message.addExtension(UnittestRoot.repeatedDoubleExtension(), value:Double(312.0))
        message.addExtension(UnittestRoot.repeatedBoolExtension(), value:false)
        message.addExtension(UnittestRoot.repeatedStringExtension(), value:"315")
        message.addExtension(UnittestRoot.repeatedBytesExtension(), value:TestUtilities.getData("316"))
        
        
        var repGr2 = RepeatedGroup_extension.builder()
        repGr2.a = 317
        message.addExtension(UnittestRoot.repeatedGroupExtension(), value:repGr2.build())
        var netmesrep2 = TestAllTypes.NestedMessage.builder()
        netmesrep2.bb = 318
        message.addExtension(UnittestRoot.repeatedNestedMessageExtension(), value:netmesrep2.build())
        
        var msgFore2 = ForeignMessage.builder()
        msgFore2.c = 319
        message.addExtension(UnittestRoot.repeatedForeignMessageExtension(), value:msgFore2.build())
        var impMes2 = ImportMessage.builder()
        impMes2.d = 320
        message.addExtension(UnittestRoot.repeatedImportMessageExtension(), value:impMes2.build())
        
        message.addExtension(UnittestRoot.repeatedNestedEnumExtension(), value:TestAllTypes.NestedEnum.Baz.rawValue)
        message.addExtension(UnittestRoot.repeatedForeignEnumExtension(), value:ForeignEnum.ForeignBaz.rawValue)
        message.addExtension(UnittestRoot.repeatedImportEnumExtension(), value:ImportEnum.ImportBaz.rawValue)
        message.addExtension(UnittestRoot.repeatedStringPieceExtension(), value:"324")
        message.addExtension(UnittestRoot.repeatedCordExtension(), value:"325")
        
        // -----------------------------------------------------------------
        
        
        message.setExtension(UnittestRoot.defaultInt32Extension(), value:Int32(401))
        message.setExtension(UnittestRoot.defaultInt64Extension(), value:Int64(402))
        message.setExtension(UnittestRoot.defaultUint32Extension(), value:UInt32(403))
        message.setExtension(UnittestRoot.defaultUint64Extension(), value:UInt64(404))
        message.setExtension(UnittestRoot.defaultSint32Extension(), value:Int32(405))
        message.setExtension(UnittestRoot.defaultSint64Extension(), value:Int64(406))
        message.setExtension(UnittestRoot.defaultFixed32Extension(), value:UInt32(407))
        message.setExtension(UnittestRoot.defaultFixed64Extension(), value:UInt64(408))
        message.setExtension(UnittestRoot.defaultSfixed32Extension(), value:Int32(409))
        message.setExtension(UnittestRoot.defaultSfixed64Extension(), value:Int64(410))
        message.setExtension(UnittestRoot.defaultFloatExtension(), value:Float(411.0))
        message.setExtension(UnittestRoot.defaultDoubleExtension(), value:Double(412.0))
        message.setExtension(UnittestRoot.defaultBoolExtension(), value:false)
        message.setExtension(UnittestRoot.defaultStringExtension(), value:"415")
        message.setExtension(UnittestRoot.defaultBytesExtension(), value:TestUtilities.getData("416"))
        
        message.setExtension(UnittestRoot.defaultNestedEnumExtension(), value:TestAllTypes.NestedEnum.Foo.rawValue)
        message.setExtension(UnittestRoot.defaultForeignEnumExtension(), value:ForeignEnum.ForeignFoo.rawValue)
        message.setExtension(UnittestRoot.defaultImportEnumExtension(), value:ImportEnum.ImportFoo.rawValue)
        message.setExtension(UnittestRoot.defaultStringPieceExtension(), value:"424")
        message.setExtension(UnittestRoot.defaultCordExtension(), value:"425")
        
    }
    class func registerAllExtensions(registry:ExtensionRegistry)
    {
        UnittestRoot.sharedInstance.registerAllExtensions(registry)
    }
    
    class func extensionRegistry() -> ExtensionRegistry {
        var registry:ExtensionRegistry = ExtensionRegistry()
        TestUtilities.registerAllExtensions(registry)
        return registry
    }
    
    
    class func allSet() -> TestAllTypes {
        var builder = TestAllTypes.builder()
        TestUtilities.setAllFields(builder)
        return builder.build()
    }
    
    
    class func allExtensionsSet() -> TestAllExtensions {
        var builder = TestAllExtensions.builder()
        TestUtilities.setAllExtensions(builder)
        return builder.build()
    }
    
    
    class func packedSet() -> TestPackedTypes{
        var builder = TestPackedTypes.builder()
        TestUtilities.setPackedFields(builder)
        return builder.build()
    }
    
    
    class func packedExtensionsSet() -> TestPackedExtensions {
        var builder = TestPackedExtensions.builder()
        TestUtilities.setPackedExtensions(builder)
        return builder.build()
    }
    
    func assertClear(message:TestAllTypes)
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
        XCTAssertTrue([Byte]() == message.optionalBytes, "")
        
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
        XCTAssertTrue(TestAllTypes.NestedEnum.Foo == message.optionalNestedEnum, "")
        XCTAssertTrue(ForeignEnum.ForeignFoo == message.optionalForeignEnum, "")
        XCTAssertTrue(ImportEnum.ImportFoo == message.optionalImportEnum, "")
        
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
        
        XCTAssertTrue(TestAllTypes.NestedEnum.Bar == message.defaultNestedEnum, "")
        XCTAssertTrue(ForeignEnum.ForeignBar == message.defaultForeignEnum, "")
        XCTAssertTrue(ImportEnum.ImportBar == message.defaultImportEnum, "")
        
        XCTAssertTrue("abc" == message.defaultStringPiece, "")
        XCTAssertTrue("123" == message.defaultCord, "")
    }
    
    class func assertClear(message:TestAllTypes)
    {
        TestUtilities().assertClear(message)
    }
    
    func assertExtensionsClear(message:TestAllExtensions)
    {
        XCTAssertFalse(message.hasExtension(UnittestRoot.optionalInt32Extension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.optionalInt64Extension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.optionalUint32Extension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.optionalUint64Extension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.optionalSint32Extension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.optionalSint64Extension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.optionalFixed32Extension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.optionalFixed64Extension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.optionalSfixed32Extension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.optionalSfixed64Extension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.optionalFloatExtension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.optionalDoubleExtension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.optionalBoolExtension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.optionalStringExtension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.optionalBytesExtension()), "")
        
        XCTAssertFalse(message.hasExtension(UnittestRoot.optionalGroupExtension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.optionalNestedMessageExtension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.optionalForeignMessageExtension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.optionalImportMessageExtension()), "")
        
        XCTAssertFalse(message.hasExtension(UnittestRoot.optionalNestedEnumExtension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.optionalForeignEnumExtension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.optionalImportEnumExtension()), "")
        
        XCTAssertFalse(message.hasExtension(UnittestRoot.optionalStringPieceExtension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.optionalCordExtension()), "")
        
        if let val = message.getExtension(UnittestRoot.optionalInt32Extension()) as? Int32
        {
            XCTAssertTrue(0 == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalInt64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(0) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalUint32Extension()) as? UInt32
        {
            XCTAssertTrue(0 == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalUint64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(0) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalSint32Extension()) as? Int32
        {
            XCTAssertTrue(0 == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalSint64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(0) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalFixed32Extension()) as? UInt32
        {
            XCTAssertTrue(UInt32(0) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalFixed64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(0) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalSfixed32Extension()) as? Int32
        {
            XCTAssertTrue(0 == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalSfixed64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(0) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalFloatExtension()) as? Float
        {
            XCTAssertTrue(Float(0) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalDoubleExtension()) as? Double
        {
            XCTAssertTrue(Double(0) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalBoolExtension()) as? Bool
        {
            XCTAssertTrue(false == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalStringExtension()) as? String
        {
            XCTAssertTrue("" == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalBytesExtension()) as? [Byte]
        {
            XCTAssertTrue([Byte]() == val, "")
        }
        
        // Embedded messages should also be clear.
        if let val = message.getExtension(UnittestRoot.optionalGroupExtension()) as? OptionalGroup_extension
        {
            XCTAssertFalse(val.hasA, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalNestedMessageExtension()) as? TestAllTypes.NestedMessage
        {
            XCTAssertFalse(val.hasBb, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalForeignMessageExtension()) as? ForeignMessage
        {
            XCTAssertFalse(val.hasC, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalImportMessageExtension()) as? ImportMessage
        {
            XCTAssertFalse(val.hasD, "")
        }
        
        if let val = message.getExtension(UnittestRoot.optionalGroupExtension()) as? OptionalGroup_extension
        {
            XCTAssertTrue(val.a == 0, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalNestedMessageExtension()) as? TestAllTypes.NestedMessage
        {
            XCTAssertTrue(val.bb == 0, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalForeignMessageExtension()) as? ForeignMessage
        {
            XCTAssertTrue(val.c == 0, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalImportMessageExtension()) as? ImportMessage
        {
            XCTAssertTrue(val.d == 0, "")
        }
        
        // Enums without defaults are set to the first value in the enum.
        if let val = message.getExtension(UnittestRoot.optionalNestedEnumExtension()) as? Int32
        {
            XCTAssertTrue(TestAllTypes.NestedEnum.Foo.rawValue == val,"")
        }
        if let val = message.getExtension(UnittestRoot.optionalForeignEnumExtension()) as? Int32
        {
            XCTAssertTrue(ForeignEnum.ForeignFoo.rawValue == val,"")
        }
        if let val = message.getExtension(UnittestRoot.optionalImportEnumExtension()) as? Int32
        {
            XCTAssertTrue(ImportEnum.ImportFoo.rawValue == val,"")
        }
        if let val = message.getExtension(UnittestRoot.optionalStringPieceExtension()) as? String
        {
            XCTAssertTrue("" == val, "")
        }
        if let val = message.getExtension(UnittestRoot.optionalCordExtension()) as? String
        {
            XCTAssertTrue("" == val, "")
        }
        
        if let val = message.getExtension(UnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        
        if let val = message.getExtension(UnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedBytesExtension()) as? Array<Array<Byte>>
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        
        if let val = message.getExtension(UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedNestedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedCordExtension()) as? [String]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        
        // hasBlah() should also be NO for all default fields.
        XCTAssertFalse(message.hasExtension(UnittestRoot.defaultInt32Extension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.defaultInt64Extension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.defaultUint32Extension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.defaultUint64Extension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.defaultSint32Extension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.defaultSint64Extension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.defaultFixed32Extension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.defaultFixed64Extension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.defaultSfixed32Extension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.defaultSfixed64Extension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.defaultFloatExtension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.defaultDoubleExtension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.defaultBoolExtension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.defaultStringExtension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.defaultBytesExtension()), "")
        
        XCTAssertFalse(message.hasExtension(UnittestRoot.defaultNestedEnumExtension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.defaultForeignEnumExtension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.defaultImportEnumExtension()), "")
        
        XCTAssertFalse(message.hasExtension(UnittestRoot.defaultStringPieceExtension()), "")
        XCTAssertFalse(message.hasExtension(UnittestRoot.defaultCordExtension()), "")
        
        
        if let val = message.getExtension(UnittestRoot.defaultInt32Extension()) as? Int32
        {
            XCTAssertTrue(41 == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultInt64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(42) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultUint32Extension()) as? UInt32
        {
            XCTAssertTrue(43 == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultUint64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(44) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultSint32Extension()) as? Int32
        {
            XCTAssertTrue(-45 == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultSint64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(46) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultFixed32Extension()) as? UInt32
        {
            XCTAssertTrue(UInt32(47) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultFixed64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(48) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultSfixed32Extension()) as? Int32
        {
            XCTAssertTrue(49 == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultSfixed64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(-50) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultFloatExtension()) as? Float
        {
            XCTAssertTrue(Float(51.5) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultDoubleExtension()) as? Double
        {
            XCTAssertTrue(Double(52e3) == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultBoolExtension()) as? Bool
        {
            XCTAssertTrue(true == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultStringExtension()) as? String
        {
            XCTAssertTrue("hello" == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultBytesExtension()) as? [Byte]
        {
            XCTAssertTrue(TestUtilities.getData("world") == val, "")
        }
        
        if let val = message.getExtension(UnittestRoot.defaultNestedEnumExtension()) as? Int32
        {
            XCTAssertTrue(TestAllTypes.NestedEnum.Bar.rawValue == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultForeignEnumExtension()) as? Int32
        {
            XCTAssertTrue(ForeignEnum.ForeignBar.rawValue == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultImportEnumExtension()) as? Int32
        {
            XCTAssertTrue(ImportEnum.ImportBar.rawValue == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultStringPieceExtension()) as? String
        {
            XCTAssertTrue("abc" == val, "")
        }
        if let val = message.getExtension(UnittestRoot.defaultCordExtension()) as? String
        {
            XCTAssertTrue("123" == val, "")
        }
        
    }
    
    class func assertExtensionsClear(message:TestAllExtensions)
    {
        TestUtilities().assertExtensionsClear(message)
    }
    
    class func setPackedFields(message:TestPackedTypesBuilder)
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
        message.packedEnum += [ForeignEnum.ForeignBar]
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
        message.packedEnum += [ForeignEnum.ForeignBaz]
    }
    
    func assertPackedFieldsSet(message:TestPackedTypes)
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
        XCTAssertTrue(ForeignEnum.ForeignBar ==  message.packedEnum[0], "")
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
        XCTAssertTrue(ForeignEnum.ForeignBaz ==  message.packedEnum[1], "")
    }
    
    class func assertPackedFieldsSet(message:TestPackedTypes)
    {
        TestUtilities().assertPackedFieldsSet(message)
    }
    
    class func setPackedExtensions(message:TestPackedExtensionsBuilder)
    {
       message.addExtension(UnittestRoot.packedInt32Extension(), value:Int32(601))
       message.addExtension(UnittestRoot.packedInt64Extension(), value:Int64(602))
       message.addExtension(UnittestRoot.packedUint32Extension(), value:UInt32(603))
       message.addExtension(UnittestRoot.packedUint64Extension(), value:UInt64(604))
       message.addExtension(UnittestRoot.packedSint32Extension(), value:Int32(605))
       message.addExtension(UnittestRoot.packedSint64Extension(), value:Int64(606))
       message.addExtension(UnittestRoot.packedFixed32Extension(), value:UInt32(607))
       message.addExtension(UnittestRoot.packedFixed64Extension(), value:UInt64(608))
       message.addExtension(UnittestRoot.packedSfixed32Extension(), value:Int32(609))
       message.addExtension(UnittestRoot.packedSfixed64Extension(), value:Int64(610))
       message.addExtension(UnittestRoot.packedFloatExtension(), value:Float(611.0))
       message.addExtension(UnittestRoot.packedDoubleExtension(),  value:Double(612.0))
       message.addExtension(UnittestRoot.packedBoolExtension(), value:true)
       message.addExtension(UnittestRoot.packedEnumExtension(), value:ForeignEnum.ForeignBar.rawValue)
        // Add a second one of each field.
       message.addExtension(UnittestRoot.packedInt32Extension(), value:Int32(701))
       message.addExtension(UnittestRoot.packedInt64Extension(), value:Int64(702))
       message.addExtension(UnittestRoot.packedUint32Extension(), value:UInt32(703))
       message.addExtension(UnittestRoot.packedUint64Extension(), value:UInt64(704))
       message.addExtension(UnittestRoot.packedSint32Extension(), value:Int32(705))
       message.addExtension(UnittestRoot.packedSint64Extension(), value:Int64(706))
       message.addExtension(UnittestRoot.packedFixed32Extension(), value:UInt32(707))
       message.addExtension(UnittestRoot.packedFixed64Extension(), value:UInt64(708))
       message.addExtension(UnittestRoot.packedSfixed32Extension(), value:Int32(709))
       message.addExtension(UnittestRoot.packedSfixed64Extension(), value:Int64(710))
       message.addExtension(UnittestRoot.packedFloatExtension(), value:Float(711.0))
       message.addExtension(UnittestRoot.packedDoubleExtension(), value:Double(712.0))
       message.addExtension(UnittestRoot.packedBoolExtension(), value:false)
       message.addExtension(UnittestRoot.packedEnumExtension(), value:ForeignEnum.ForeignBaz.rawValue)
    }
    
    
    func assertPackedExtensionsSet(message:TestPackedExtensions)
    {
        if let val = message.getExtension(UnittestRoot.packedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        
        if let val = message.getExtension(UnittestRoot.packedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.packedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.packedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.packedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.packedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.packedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.packedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.packedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.packedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.packedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.packedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.packedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.packedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        
        ///
        if let val = message.getExtension(UnittestRoot.packedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(601 == val[0], "")
        }
        
        if let val = message.getExtension(UnittestRoot.packedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(602 == val[0], "")
        }
        if let val = message.getExtension(UnittestRoot.packedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(603 == val[0], "")
        }
        if let val = message.getExtension(UnittestRoot.packedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(604 == val[0], "")
        }
        if let val = message.getExtension(UnittestRoot.packedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(605 == val[0], "")
        }
        if let val = message.getExtension(UnittestRoot.packedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(606 == val[0], "")
        }
        if let val = message.getExtension(UnittestRoot.packedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(607 == val[0], "")
        }
        if let val = message.getExtension(UnittestRoot.packedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(608 == val[0], "")
        }
        if let val = message.getExtension(UnittestRoot.packedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(609 == val[0], "")
        }
        if let val = message.getExtension(UnittestRoot.packedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(610 == val[0], "")
        }
        if let val = message.getExtension(UnittestRoot.packedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(611.0 == val[0], "")
        }
        if let val = message.getExtension(UnittestRoot.packedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(612.0 == val[0], "")
        }
        if let val = message.getExtension(UnittestRoot.packedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(true == val[0], "")
        }
        if let val = message.getExtension(UnittestRoot.packedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ForeignEnum.ForeignBar.rawValue == val[0], "")
        }
        ///
        
        if let val = message.getExtension(UnittestRoot.packedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(701 == val[1], "")
        }
        
        if let val = message.getExtension(UnittestRoot.packedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(702 == val[1], "")
        }
        if let val = message.getExtension(UnittestRoot.packedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(703 == val[1], "")
        }
        if let val = message.getExtension(UnittestRoot.packedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(704 == val[1], "")
        }
        if let val = message.getExtension(UnittestRoot.packedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(705 == val[1], "")
        }
        if let val = message.getExtension(UnittestRoot.packedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(706 == val[1], "")
        }
        if let val = message.getExtension(UnittestRoot.packedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(707 == val[1], "")
        }
        if let val = message.getExtension(UnittestRoot.packedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(708 == val[1], "")
        }
        if let val = message.getExtension(UnittestRoot.packedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(709 == val[1], "")
        }
        if let val = message.getExtension(UnittestRoot.packedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(710 == val[1], "")
        }
        if let val = message.getExtension(UnittestRoot.packedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(711.0 == val[1], "")
        }
        if let val = message.getExtension(UnittestRoot.packedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(712.0 == val[1], "")
        }
        if let val = message.getExtension(UnittestRoot.packedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(false == val[1], "")
        }
        if let val = message.getExtension(UnittestRoot.packedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ForeignEnum.ForeignBaz.rawValue == val[1], "")
        }
        ///
    }
    
    class func assertPackedExtensionsSet(message:TestPackedExtensions) {
        TestUtilities().assertPackedExtensionsSet(message)
    }
    
}