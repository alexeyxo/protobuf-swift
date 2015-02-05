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
        var bytes = [Byte]()
        bytes += str.utf8
        return NSData(bytes:&bytes, length:bytes.count)
    }
    class func goldenData() -> NSData {

        var str =  NSBundle(forClass:TestUtilities.self).resourcePath!.stringByAppendingPathComponent("golden_message")
        let goldenData = NSData(contentsOfFile:str)!
        return goldenData
    }

    class func modifyRepeatedExtensions(var message:ProtobufUnittest.TestAllExtensionsBuilder)
    {
        message.setExtension(GoogleProtobufUnittestRoot.repeatedInt32Extension(), index:1, value:Int32(501))
        message.setExtension(GoogleProtobufUnittestRoot.repeatedInt64Extension(), index:1, value:Int64(502))
        message.setExtension(GoogleProtobufUnittestRoot.repeatedUint32Extension(), index:1, value:UInt32(503))
        message.setExtension(GoogleProtobufUnittestRoot.repeatedUint64Extension(), index:1, value:UInt64(504))
        message.setExtension(GoogleProtobufUnittestRoot.repeatedSint32Extension(), index:1, value:Int32(505))
        message.setExtension(GoogleProtobufUnittestRoot.repeatedSint64Extension(), index:1, value:Int64(506))
        message.setExtension(GoogleProtobufUnittestRoot.repeatedFixed32Extension(), index:1, value:UInt32(507))
        message.setExtension(GoogleProtobufUnittestRoot.repeatedFixed64Extension(), index:1, value:UInt64(508))
        message.setExtension(GoogleProtobufUnittestRoot.repeatedSfixed32Extension(), index:1, value:Int32(509))
        message.setExtension(GoogleProtobufUnittestRoot.repeatedSfixed64Extension(), index:1, value:Int64(510))
        message.setExtension(GoogleProtobufUnittestRoot.repeatedFloatExtension(), index:1, value:Float(511.0))
        message.setExtension(GoogleProtobufUnittestRoot.repeatedDoubleExtension(), index:1, value:Double(512.0))
        message.setExtension(GoogleProtobufUnittestRoot.repeatedBoolExtension(), index:1, value:true)
        message.setExtension(GoogleProtobufUnittestRoot.repeatedStringExtension(),index:1, value:"515")
        message.setExtension(GoogleProtobufUnittestRoot.repeatedBytesExtension(), index:1, value:TestUtilities.getData("516"))

        var a = ProtobufUnittest.RepeatedGroup_extension.builder()
        a.a = 517
        message.setExtension(GoogleProtobufUnittestRoot.repeatedGroupExtension(), index:1, value:a.build())

        var b = ProtobufUnittest.TestAllTypes.NestedMessage.builder()
        b.bb = 518
        message.setExtension(GoogleProtobufUnittestRoot.repeatedNestedMessageExtension(), index:1, value:b.build())
        var foreign = ProtobufUnittest.ForeignMessage.builder()
        foreign.c = 519
        message.setExtension(GoogleProtobufUnittestRoot.repeatedForeignMessageExtension(), index:1, value:foreign.build())

        var importMessage = ProtobufUnittestImport.ImportMessage.builder()
        importMessage.d = 520
        message.setExtension(GoogleProtobufUnittestRoot.repeatedImportMessageExtension(), index:1, value:importMessage.build())

        message.setExtension(GoogleProtobufUnittestRoot.repeatedNestedEnumExtension(), index:1, value:ProtobufUnittest.TestAllTypes.NestedEnum.Foo.rawValue)

        message.setExtension(GoogleProtobufUnittestRoot.repeatedForeignEnumExtension(), index:1, value:ProtobufUnittest.ForeignEnum.ForeignFoo.rawValue)
        message.setExtension(GoogleProtobufUnittestRoot.repeatedImportEnumExtension(), index:1, value:ProtobufUnittestImport.ImportEnum.ImportFoo.rawValue)

        message.setExtension(GoogleProtobufUnittestRoot.repeatedStringPieceExtension(),index:1, value:"524")
        message.setExtension(GoogleProtobufUnittestRoot.repeatedCordExtension(), index:1, value:"525")

    }

    func assertAllExtensionsSet(var message:ProtobufUnittest.TestAllExtensions)
    {

        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.optionalInt32Extension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.optionalInt64Extension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.optionalUint32Extension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.optionalUint64Extension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.optionalSint32Extension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.optionalSint64Extension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.optionalFixed32Extension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.optionalFixed64Extension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.optionalSfixed32Extension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.optionalSfixed64Extension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.optionalFloatExtension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.optionalDoubleExtension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.optionalBoolExtension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.optionalStringExtension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.optionalBytesExtension()), "")

        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.optionalGroupExtension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.optionalNestedMessageExtension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.optionalForeignMessageExtension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.optionalImportMessageExtension()), "")

        if let extensions = message.getExtension(GoogleProtobufUnittestRoot.optionalGroupExtension()) as? ProtobufUnittest.OptionalGroup_extension
        {
            XCTAssertTrue(extensions.hasA, "")
        }
        if let ext = message.getExtension(GoogleProtobufUnittestRoot.optionalNestedMessageExtension()) as? ProtobufUnittest.TestAllTypes.NestedMessage
        {
            XCTAssertTrue(ext.hasBb, "")
        }

        if let ext = message.getExtension(GoogleProtobufUnittestRoot.optionalForeignMessageExtension()) as? ProtobufUnittest.ForeignMessage
        {
            XCTAssertTrue(ext.hasC, "")
        }

        if let ext = message.getExtension(GoogleProtobufUnittestRoot.optionalImportMessageExtension()) as? ProtobufUnittestImport.ImportMessage
        {
            XCTAssertTrue(ext.hasD, "")
        }
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.optionalNestedEnumExtension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.optionalForeignEnumExtension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.optionalImportEnumExtension()), "")

        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.optionalStringPieceExtension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.optionalCordExtension()), "")

        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalInt32Extension()) as? Int32
        {
            XCTAssertTrue(101 == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalInt64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(102) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalUint32Extension()) as? UInt32
        {
            XCTAssertTrue(UInt32(103) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalUint64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(104) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalSint32Extension()) as? Int32
        {
            XCTAssertTrue(105 == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalSint64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(106) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalFixed32Extension()) as? UInt32
        {
            XCTAssertTrue(UInt32(107) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalFixed64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(108) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalSfixed32Extension()) as? Int32
        {
            XCTAssertTrue(Int32(109) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalSfixed64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(110) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalFloatExtension()) as? Float
        {
            XCTAssertTrue(Float(111.0) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalDoubleExtension()) as? Double
        {
            XCTAssertTrue(Double(112.0) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalBoolExtension()) as? Bool
        {
            XCTAssertTrue(true == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalStringExtension()) as? String
        {
            XCTAssertTrue("115" == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalBytesExtension()) as? NSData
        {
            XCTAssertTrue(TestUtilities.getData("116") == val, "")
        }

        if let mes = message.getExtension(GoogleProtobufUnittestRoot.optionalGroupExtension()) as? ProtobufUnittest.OptionalGroup_extension
        {
            XCTAssertTrue(117 == mes.a, "")
        }

        if let mes = message.getExtension(GoogleProtobufUnittestRoot.optionalNestedMessageExtension()) as? ProtobufUnittest.TestAllTypes.NestedMessage
        {
            XCTAssertTrue(118 == mes.bb, "")
        }
        if let mes = message.getExtension(GoogleProtobufUnittestRoot.optionalForeignMessageExtension()) as? ProtobufUnittest.ForeignMessage
        {
            XCTAssertTrue(119 == mes.c, "")
        }
        if let mes = message.getExtension(GoogleProtobufUnittestRoot.optionalImportMessageExtension()) as? ProtobufUnittestImport.ImportMessage
        {
            XCTAssertTrue(120 == mes.d, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalNestedEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.Baz.rawValue == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalForeignEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignBaz.rawValue == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalImportEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittestImport.ImportEnum.ImportBaz.rawValue == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalStringPieceExtension()) as? String
        {
            XCTAssertTrue("124" == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalCordExtension()) as? String
        {
            XCTAssertTrue("125" == val, "")
        }

        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }

        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedBytesExtension()) as? Array<Array<Byte>>
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }

        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedNestedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedCordExtension()) as? [String]
        {
            XCTAssertTrue(2 == val.count, "")
        }

        ///
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(201 == val[0],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(202 == val[0],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(203 == val[0],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(204 == val[0],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(205 == val[0],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(206 == val[0],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(207 == val[0],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(208 == val[0],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(209 == val[0],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(210 == val[0],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(Float(211.0) == val[0], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(Double(212.0) == val[0], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(true == val[0], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue("215" == val[0], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedBytesExtension()) as? Array<NSData>
        {
            XCTAssertTrue(TestUtilities.getData("216") == val[0], "")
        }

        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage]
        {
            if let value = val[0] as? ProtobufUnittest.RepeatedGroup_extension
            {
                XCTAssertTrue(217 == value.a, "")
            }
        }

        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage]
        {
            if let value = val[0] as? ProtobufUnittest.TestAllTypes.NestedMessage
            {
                XCTAssertTrue(218 == value.bb, "")
            }
        }
        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            if let value = val[0] as? ProtobufUnittest.ForeignMessage
            {
                XCTAssertTrue(219 == value.c, "")
            }
        }
        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedImportMessageExtension()) as? [GeneratedMessage]
        {
            if let value = val[0] as? ProtobufUnittestImport.ImportMessage
            {
                XCTAssertTrue(220 == value.d, "")
            }
        }
        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedNestedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.Bar.rawValue == val[0], "")
        }
        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignBar.rawValue == val[0], "")
        }
        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittestImport.ImportEnum.ImportBar.rawValue == val[0], "")
        }

        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue("224" == val[0], "")
        }

        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedCordExtension()) as? [String]
        {
            XCTAssertTrue("225" == val[0], "")
        }

        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(301 == val[1],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(302 == val[1],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(303 == val[1],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(304 == val[1],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(305 == val[1],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(306 == val[1],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(307 == val[1],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(308 == val[1],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(309 == val[1],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(310 == val[1],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(Float(311.0) == val[1], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(Double(312.0) == val[1], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(false == val[1], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue("315" == val[1], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedBytesExtension()) as? Array<NSData>
        {
            XCTAssertTrue(TestUtilities.getData("316") == val[1], "")
        }

        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage]
        {
            if let value = val[1] as? ProtobufUnittest.RepeatedGroup_extension
            {
                XCTAssertTrue(317 == value.a, "")
            }
        }

        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage]
        {
            if let value = val[1] as? ProtobufUnittest.TestAllTypes.NestedMessage
            {
                XCTAssertTrue(318 == value.bb, "")
            }
        }
        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            if let value = val[1] as? ProtobufUnittest.ForeignMessage
            {
                XCTAssertTrue(319 == value.c, "")
            }

        }
        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedImportMessageExtension()) as? [GeneratedMessage]
        {
            if let value = val[1] as? ProtobufUnittestImport.ImportMessage
            {
                XCTAssertTrue(320 == value.d, "")
            }

        }
        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedNestedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.Baz.rawValue == val[1], "")
        }
        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignBaz.rawValue == val[1], "")
        }
        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittestImport.ImportEnum.ImportBaz.rawValue == val[1], "")
        }

        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue("324" == val[1], "")
        }

        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedCordExtension()) as? [String]
        {
            XCTAssertTrue("325" == val[1], "")
        }

        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.defaultInt32Extension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.defaultInt64Extension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.defaultUint32Extension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.defaultUint64Extension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.defaultSint32Extension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.defaultSint64Extension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.defaultFixed32Extension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.defaultFixed64Extension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.defaultSfixed32Extension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.defaultSfixed64Extension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.defaultFloatExtension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.defaultDoubleExtension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.defaultBoolExtension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.defaultStringExtension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.defaultBytesExtension()), "")

        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.defaultNestedEnumExtension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.defaultForeignEnumExtension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.defaultImportEnumExtension()), "")

        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.defaultStringPieceExtension()), "")
        XCTAssertTrue(message.hasExtension(GoogleProtobufUnittestRoot.defaultCordExtension()), "")


        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultInt32Extension()) as? Int32
        {
            XCTAssertTrue(401 == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultInt64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(402) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultUint32Extension()) as? UInt32
        {
            XCTAssertTrue(UInt32(403) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultUint64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(404) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultSint32Extension()) as? Int32
        {
            XCTAssertTrue(405 == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultSint64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(406) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultFixed32Extension()) as? UInt32
        {
            XCTAssertTrue(UInt32(407) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultFixed64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(408) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultSfixed32Extension()) as? Int32
        {
            XCTAssertTrue(Int32(409) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultSfixed64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(410) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultFloatExtension()) as? Float
        {
            XCTAssertTrue(Float(411.0) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultDoubleExtension()) as? Double
        {
            XCTAssertTrue(Double(412.0) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultBoolExtension()) as? Bool
        {
            XCTAssertTrue(false == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultStringExtension()) as? String
        {
            XCTAssertTrue("415" == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultBytesExtension()) as? NSData
        {
            XCTAssertTrue(TestUtilities.getData("416") == val, "")
        }

        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultNestedEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.Foo.rawValue == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultForeignEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignFoo.rawValue == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultImportEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittestImport.ImportEnum.ImportFoo.rawValue == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultStringPieceExtension()) as? String
        {
            XCTAssertTrue("424" == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultCordExtension()) as? String
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

        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }

        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedBytesExtension()) as? Array<Array<Byte>>
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }

        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedNestedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedCordExtension()) as? [String]
        {
            XCTAssertTrue(2 == val.count, "")
        }

        ///
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(201 == val[0],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(202 == val[0],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(203 == val[0],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(204 == val[0],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(205 == val[0],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(206 == val[0],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(207 == val[0],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(208 == val[0],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(209 == val[0],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(210 == val[0],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(Float(211.0) == val[0], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(Double(212.0) == val[0], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(true == val[0], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue("215" == val[0], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedBytesExtension()) as? Array<NSData>
        {
            XCTAssertTrue(TestUtilities.getData("216") == val[0], "")
        }

        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage]
        {
            if let values = val[0] as? ProtobufUnittest.RepeatedGroup_extension
            {
                XCTAssertTrue(217 ==  values.a, "")
            }
        }

        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage]
        {
            if let values = val[0] as? ProtobufUnittest.TestAllTypes.NestedMessage
            {
                XCTAssertTrue(218 == values.bb, "")
            }

        }
        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            if let values = val[0] as? ProtobufUnittest.ForeignMessage
            {
                XCTAssertTrue(219 == values.c, "")
            }
        }
        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedImportMessageExtension()) as? [GeneratedMessage]
        {
            if let values = val[0] as? ProtobufUnittestImport.ImportMessage
            {
                XCTAssertTrue(220 == values.d, "")
            }
        }
        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedNestedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.Bar.rawValue == val[0], "")
        }
        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignBar.rawValue == val[0], "")
        }
        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittestImport.ImportEnum.ImportBar.rawValue == val[0], "")
        }

        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue("224" == val[0], "")
        }

        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedCordExtension()) as? [String]
        {
            XCTAssertTrue("225" == val[0], "")
        }


        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(501 == val[1],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(502 == val[1],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(503 == val[1],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(504 == val[1],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(505 == val[1],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(506 == val[1],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(507 == val[1],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(508 == val[1],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(509 == val[1],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(510 == val[1],"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(Float(511.0) == val[1], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(Double(512.0) == val[1], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(true == val[1], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue("515" == val[1], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedBytesExtension()) as? Array<NSData>
        {
            XCTAssertTrue(TestUtilities.getData("516") == val[1], "")
        }

        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage]
        {
            if let values = val[1] as? ProtobufUnittest.RepeatedGroup_extension
            {
                XCTAssertTrue(517 == values.a, "")
            }
        }

        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage]
        {
            if let values = val[1] as? ProtobufUnittest.TestAllTypes.NestedMessage
            {
                XCTAssertTrue(518 == values.bb, "")
            }

        }
        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            if let values = val[1] as? ProtobufUnittest.ForeignMessage
            {
                XCTAssertTrue(519 == values.c, "")
            }

        }
        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedImportMessageExtension()) as? [GeneratedMessage]
        {
            if let values = val[1] as? ProtobufUnittestImport.ImportMessage
            {
                XCTAssertTrue(520 == values.d, "")
            }

        }
        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedNestedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.Foo.rawValue == val[1], "")
        }
        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignFoo.rawValue == val[1], "")
        }
        if let val =  message.getExtension(GoogleProtobufUnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittestImport.ImportEnum.ImportFoo.rawValue == val[1], "")
        }

        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue("524" == val[1], "")
        }

        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedCordExtension()) as? [String]
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
        var data = TestUtilities.getData("116")
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

    class func setAllFields(message:ProtobufUnittest.TestAllTypesBuilder)
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

        var gr = ProtobufUnittest.TestAllTypes.OptionalGroup.builder()
        gr.a = 117
        message.optionalGroup = gr.build()
        var nest = ProtobufUnittest.TestAllTypes.NestedMessage.builder()
        nest.bb = 118
        message.optionalNestedMessage = nest.build()

        var foreign = ProtobufUnittest.ForeignMessage.builder()
        foreign.c = 119
        message.optionalForeignMessage = foreign.build()

        var importMes = ProtobufUnittestImport.ImportMessage.builder()
        importMes.d = 120
        message.optionalImportMessage = importMes.build()

        message.optionalNestedEnum = ProtobufUnittest.TestAllTypes.NestedEnum.Baz
        message.optionalForeignEnum = ProtobufUnittest.ForeignEnum.ForeignBaz
        message.optionalImportEnum = ProtobufUnittestImport.ImportEnum.ImportBaz

        message.optionalStringPiece = "124"
        message.optionalCord = "125"

//        var publicImportBuilder = PublicImportMessageBuilder()
//        publicImportBuilder.e = 126
//        message.optionalPublicImportMessage = publicImportBuilder.build()
//
//        var lazymes = ProtobufUnittest.TestAllTypes.NestedMessage.builder()
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

        var testRep = ProtobufUnittest.TestAllTypes.RepeatedGroup.builder()
        testRep.a = 217
        message.repeatedGroup += [testRep.build()]
        var testNest = ProtobufUnittest.TestAllTypes.NestedMessage.builder()
        testNest.bb = 218
        message.repeatedNestedMessage += [testNest.build()]
        var foreign2 = ProtobufUnittest.ForeignMessage.builder()
        foreign2.c = 219
        message.repeatedForeignMessage += [foreign2.build()]
        var importmes = ProtobufUnittestImport.ImportMessage.builder()
        importmes.d = 220
        message.repeatedImportMessage += [importmes.build()]

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

        var repgroups = ProtobufUnittest.TestAllTypes.RepeatedGroup.builder()
        repgroups.a = 317
        message.repeatedGroup += [repgroups.build()]

        var repNested = ProtobufUnittest.TestAllTypes.NestedMessage.builder()
        repNested.bb = 318
        message.repeatedNestedMessage += [repNested.build()]

        var fBuilder = ProtobufUnittest.ForeignMessage.builder()
        fBuilder.c = 319
        message.repeatedForeignMessage += [fBuilder.build()]

        var impBuilder = ProtobufUnittestImport.ImportMessage.builder()
        impBuilder.d = 320
        message.repeatedImportMessage += [impBuilder.build()]

        message.repeatedNestedEnum += [ProtobufUnittest.TestAllTypes.NestedEnum.Baz]
        message.repeatedForeignEnum += [ProtobufUnittest.ForeignEnum.ForeignBaz]
        message.repeatedImportEnum += [ProtobufUnittestImport.ImportEnum.ImportBaz]

        message.repeatedStringPiece += ["324"]
        message.repeatedCord += ["325"]

//        var repNested2 = ProtobufUnittest.TestAllTypes.NestedMessage.builder()
//        repNested2.bb = 227
//        message.repeatedLazyMessage = [repNested2.build()]
//        var repNested3 = ProtobufUnittest.TestAllTypes.NestedMessage.builder()
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

    class func setOneOfFields(message:ProtobufUnittest.TestAllTypesBuilder)
    {
        message.oneofUint32 = 601
        var builder = ProtobufUnittest.TestAllTypes.NestedMessage.builder()
        builder.bb = 602
        message.oneofNestedMessage = builder.build()
        message.oneofString = "603"
        message.oneofBytes = NSData(bytes: ([Byte]() + "604".utf8), length: 3)
    }

    class func setAllExtensions(message:ProtobufUnittest.TestAllExtensionsBuilder)
    {
        message.setExtension(GoogleProtobufUnittestRoot.optionalInt32Extension(), value:Int32(101))
        message.setExtension(GoogleProtobufUnittestRoot.optionalInt64Extension(), value:Int64(102))
        message.setExtension(GoogleProtobufUnittestRoot.optionalUint32Extension(), value:UInt32(103))
        message.setExtension(GoogleProtobufUnittestRoot.optionalUint64Extension(), value:UInt64(104))
        message.setExtension(GoogleProtobufUnittestRoot.optionalSint32Extension(), value:Int32(105))
        message.setExtension(GoogleProtobufUnittestRoot.optionalSint64Extension(), value:Int64(106))
        message.setExtension(GoogleProtobufUnittestRoot.optionalFixed32Extension(), value:UInt32(107))
        message.setExtension(GoogleProtobufUnittestRoot.optionalFixed64Extension(), value:UInt64(108))
        message.setExtension(GoogleProtobufUnittestRoot.optionalSfixed32Extension(), value:Int32(109))
        message.setExtension(GoogleProtobufUnittestRoot.optionalSfixed64Extension(), value:Int64(110))
        message.setExtension(GoogleProtobufUnittestRoot.optionalFloatExtension(), value:Float(111.0))
        message.setExtension(GoogleProtobufUnittestRoot.optionalDoubleExtension(), value:Double(112.0))
        message.setExtension(GoogleProtobufUnittestRoot.optionalBoolExtension(), value:true)
        message.setExtension(GoogleProtobufUnittestRoot.optionalStringExtension(), value:"115")
        message.setExtension(GoogleProtobufUnittestRoot.optionalBytesExtension(), value:TestUtilities.getData("116"))

        var optgr = ProtobufUnittest.OptionalGroup_extension.builder()
        optgr.a = 117
        message.setExtension(GoogleProtobufUnittestRoot.optionalGroupExtension(), value:optgr.build())

        var netmesb = ProtobufUnittest.TestAllTypes.NestedMessage.builder()
        netmesb.bb = 118
        message.setExtension(GoogleProtobufUnittestRoot.optionalNestedMessageExtension(), value:netmesb.build())

        var forMes = ProtobufUnittest.ForeignMessage.builder()
        forMes.c = 119
        message.setExtension(GoogleProtobufUnittestRoot.optionalForeignMessageExtension(), value:forMes.build())

        var impMes = ProtobufUnittestImport.ImportMessage.builder()
        impMes.d = 120
        message.setExtension(GoogleProtobufUnittestRoot.optionalImportMessageExtension(), value:impMes.build())

        message.setExtension(GoogleProtobufUnittestRoot.optionalNestedEnumExtension(), value:ProtobufUnittest.TestAllTypes.NestedEnum.Baz.rawValue)
        message.setExtension(GoogleProtobufUnittestRoot.optionalForeignEnumExtension(), value:ProtobufUnittest.ForeignEnum.ForeignBaz.rawValue)
        message.setExtension(GoogleProtobufUnittestRoot.optionalImportEnumExtension(), value:ProtobufUnittestImport.ImportEnum.ImportBaz.rawValue)

        message.setExtension(GoogleProtobufUnittestRoot.optionalStringPieceExtension(),  value:"124")
        message.setExtension(GoogleProtobufUnittestRoot.optionalCordExtension(), value:"125")

        // -----------------------------------------------------------------

        message.addExtension(GoogleProtobufUnittestRoot.repeatedInt32Extension(), value:Int32(201))
        message.addExtension(GoogleProtobufUnittestRoot.repeatedInt64Extension(), value:Int64(202))
        message.addExtension(GoogleProtobufUnittestRoot.repeatedUint32Extension(), value:UInt32(203))
        message.addExtension(GoogleProtobufUnittestRoot.repeatedUint64Extension(), value:UInt64(204))
        message.addExtension(GoogleProtobufUnittestRoot.repeatedSint32Extension(), value:Int32(205))
        message.addExtension(GoogleProtobufUnittestRoot.repeatedSint64Extension(), value:Int64(206))
        message.addExtension(GoogleProtobufUnittestRoot.repeatedFixed32Extension(), value:UInt32(207))
        message.addExtension(GoogleProtobufUnittestRoot.repeatedFixed64Extension(), value:UInt64(208))
        message.addExtension(GoogleProtobufUnittestRoot.repeatedSfixed32Extension(), value:Int32(209))
        message.addExtension(GoogleProtobufUnittestRoot.repeatedSfixed64Extension(), value:Int64(210))
        message.addExtension(GoogleProtobufUnittestRoot.repeatedFloatExtension(), value:Float(211.0))
        message.addExtension(GoogleProtobufUnittestRoot.repeatedDoubleExtension(), value:Double(212.0))
        message.addExtension(GoogleProtobufUnittestRoot.repeatedBoolExtension(), value:true)
        message.addExtension(GoogleProtobufUnittestRoot.repeatedStringExtension(), value:"215")
        message.addExtension(GoogleProtobufUnittestRoot.repeatedBytesExtension(), value:TestUtilities.getData("216"))


        var repGr = ProtobufUnittest.RepeatedGroup_extension.builder()
        repGr.a = 217
        message.addExtension(GoogleProtobufUnittestRoot.repeatedGroupExtension(), value:repGr.build())
        var netmesrep = ProtobufUnittest.TestAllTypes.NestedMessage.builder()
        netmesrep.bb = 218
        message.addExtension(GoogleProtobufUnittestRoot.repeatedNestedMessageExtension(), value:netmesrep.build())

        var msgFore = ProtobufUnittest.ForeignMessage.builder()
        msgFore.c = 219
        message.addExtension(GoogleProtobufUnittestRoot.repeatedForeignMessageExtension(), value:msgFore.build())
        var impMes220 = ProtobufUnittestImport.ImportMessage.builder()
        impMes220.d = 220
        message.addExtension(GoogleProtobufUnittestRoot.repeatedImportMessageExtension(), value:impMes220.build())

        message.addExtension(GoogleProtobufUnittestRoot.repeatedNestedEnumExtension(), value:ProtobufUnittest.TestAllTypes.NestedEnum.Bar.rawValue)
        message.addExtension(GoogleProtobufUnittestRoot.repeatedForeignEnumExtension(), value:ProtobufUnittest.ForeignEnum.ForeignBar.rawValue)
        message.addExtension(GoogleProtobufUnittestRoot.repeatedImportEnumExtension(), value:ProtobufUnittestImport.ImportEnum.ImportBar.rawValue)
        message.addExtension(GoogleProtobufUnittestRoot.repeatedStringPieceExtension(), value:"224")
        message.addExtension(GoogleProtobufUnittestRoot.repeatedCordExtension(), value:"225")

        // Add a second one of each field.
        message.addExtension(GoogleProtobufUnittestRoot.repeatedInt32Extension(), value:Int32(301))
        message.addExtension(GoogleProtobufUnittestRoot.repeatedInt64Extension(), value:Int64(302))
        message.addExtension(GoogleProtobufUnittestRoot.repeatedUint32Extension(), value:UInt32(303))
        message.addExtension(GoogleProtobufUnittestRoot.repeatedUint64Extension(), value:UInt64(304))
        message.addExtension(GoogleProtobufUnittestRoot.repeatedSint32Extension(), value:Int32(305))
        message.addExtension(GoogleProtobufUnittestRoot.repeatedSint64Extension(), value:Int64(306))
        message.addExtension(GoogleProtobufUnittestRoot.repeatedFixed32Extension(), value:UInt32(307))
        message.addExtension(GoogleProtobufUnittestRoot.repeatedFixed64Extension(), value:UInt64(308))
        message.addExtension(GoogleProtobufUnittestRoot.repeatedSfixed32Extension(), value:Int32(309))
        message.addExtension(GoogleProtobufUnittestRoot.repeatedSfixed64Extension(), value:Int64(310))
        message.addExtension(GoogleProtobufUnittestRoot.repeatedFloatExtension(), value:Float(311.0))
        message.addExtension(GoogleProtobufUnittestRoot.repeatedDoubleExtension(), value:Double(312.0))
        message.addExtension(GoogleProtobufUnittestRoot.repeatedBoolExtension(), value:false)
        message.addExtension(GoogleProtobufUnittestRoot.repeatedStringExtension(), value:"315")
        message.addExtension(GoogleProtobufUnittestRoot.repeatedBytesExtension(), value:TestUtilities.getData("316"))


        var repGr2 = ProtobufUnittest.RepeatedGroup_extension.builder()
        repGr2.a = 317
        message.addExtension(GoogleProtobufUnittestRoot.repeatedGroupExtension(), value:repGr2.build())
        var netmesrep2 = ProtobufUnittest.TestAllTypes.NestedMessage.builder()
        netmesrep2.bb = 318
        message.addExtension(GoogleProtobufUnittestRoot.repeatedNestedMessageExtension(), value:netmesrep2.build())

        var msgFore2 = ProtobufUnittest.ForeignMessage.builder()
        msgFore2.c = 319
        message.addExtension(GoogleProtobufUnittestRoot.repeatedForeignMessageExtension(), value:msgFore2.build())
        var impMes2 = ProtobufUnittestImport.ImportMessage.builder()
        impMes2.d = 320
        message.addExtension(GoogleProtobufUnittestRoot.repeatedImportMessageExtension(), value:impMes2.build())

        message.addExtension(GoogleProtobufUnittestRoot.repeatedNestedEnumExtension(), value:ProtobufUnittest.TestAllTypes.NestedEnum.Baz.rawValue)
        message.addExtension(GoogleProtobufUnittestRoot.repeatedForeignEnumExtension(), value:ProtobufUnittest.ForeignEnum.ForeignBaz.rawValue)
        message.addExtension(GoogleProtobufUnittestRoot.repeatedImportEnumExtension(), value:ProtobufUnittestImport.ImportEnum.ImportBaz.rawValue)
        message.addExtension(GoogleProtobufUnittestRoot.repeatedStringPieceExtension(), value:"324")
        message.addExtension(GoogleProtobufUnittestRoot.repeatedCordExtension(), value:"325")

        // -----------------------------------------------------------------


        message.setExtension(GoogleProtobufUnittestRoot.defaultInt32Extension(), value:Int32(401))
        message.setExtension(GoogleProtobufUnittestRoot.defaultInt64Extension(), value:Int64(402))
        message.setExtension(GoogleProtobufUnittestRoot.defaultUint32Extension(), value:UInt32(403))
        message.setExtension(GoogleProtobufUnittestRoot.defaultUint64Extension(), value:UInt64(404))
        message.setExtension(GoogleProtobufUnittestRoot.defaultSint32Extension(), value:Int32(405))
        message.setExtension(GoogleProtobufUnittestRoot.defaultSint64Extension(), value:Int64(406))
        message.setExtension(GoogleProtobufUnittestRoot.defaultFixed32Extension(), value:UInt32(407))
        message.setExtension(GoogleProtobufUnittestRoot.defaultFixed64Extension(), value:UInt64(408))
        message.setExtension(GoogleProtobufUnittestRoot.defaultSfixed32Extension(), value:Int32(409))
        message.setExtension(GoogleProtobufUnittestRoot.defaultSfixed64Extension(), value:Int64(410))
        message.setExtension(GoogleProtobufUnittestRoot.defaultFloatExtension(), value:Float(411.0))
        message.setExtension(GoogleProtobufUnittestRoot.defaultDoubleExtension(), value:Double(412.0))
        message.setExtension(GoogleProtobufUnittestRoot.defaultBoolExtension(), value:false)
        message.setExtension(GoogleProtobufUnittestRoot.defaultStringExtension(), value:"415")
        message.setExtension(GoogleProtobufUnittestRoot.defaultBytesExtension(), value:TestUtilities.getData("416"))

        message.setExtension(GoogleProtobufUnittestRoot.defaultNestedEnumExtension(), value:ProtobufUnittest.TestAllTypes.NestedEnum.Foo.rawValue)
        message.setExtension(GoogleProtobufUnittestRoot.defaultForeignEnumExtension(), value:ProtobufUnittest.ForeignEnum.ForeignFoo.rawValue)
        message.setExtension(GoogleProtobufUnittestRoot.defaultImportEnumExtension(), value:ProtobufUnittestImport.ImportEnum.ImportFoo.rawValue)
        message.setExtension(GoogleProtobufUnittestRoot.defaultStringPieceExtension(), value:"424")
        message.setExtension(GoogleProtobufUnittestRoot.defaultCordExtension(), value:"425")

    }
    class func registerAllExtensions(registry:ExtensionRegistry)
    {
        GoogleProtobufUnittestRoot.sharedInstance.registerAllExtensions(registry)
    }

    class func extensionRegistry() -> ExtensionRegistry {
        var registry:ExtensionRegistry = ExtensionRegistry()
        TestUtilities.registerAllExtensions(registry)
        return registry
    }


    class func allSet() -> ProtobufUnittest.TestAllTypes {
        var builder = ProtobufUnittest.TestAllTypes.builder()
        TestUtilities.setAllFields(builder)
        return builder.build()
    }


    class func allExtensionsSet() -> ProtobufUnittest.TestAllExtensions {
        var builder = ProtobufUnittest.TestAllExtensions.builder()
        TestUtilities.setAllExtensions(builder)
        return builder.build()
    }


    class func packedSet() -> ProtobufUnittest.TestPackedTypes{
        var builder = ProtobufUnittest.TestPackedTypes.builder()
        TestUtilities.setPackedFields(builder)
        return builder.build()
    }


    class func packedExtensionsSet() -> ProtobufUnittest.TestPackedExtensions {
        var builder = ProtobufUnittest.TestPackedExtensions.builder()
        TestUtilities.setPackedExtensions(builder)
        return builder.build()
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
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.optionalInt32Extension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.optionalInt64Extension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.optionalUint32Extension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.optionalUint64Extension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.optionalSint32Extension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.optionalSint64Extension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.optionalFixed32Extension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.optionalFixed64Extension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.optionalSfixed32Extension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.optionalSfixed64Extension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.optionalFloatExtension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.optionalDoubleExtension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.optionalBoolExtension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.optionalStringExtension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.optionalBytesExtension()), "")

        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.optionalGroupExtension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.optionalNestedMessageExtension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.optionalForeignMessageExtension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.optionalImportMessageExtension()), "")

        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.optionalNestedEnumExtension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.optionalForeignEnumExtension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.optionalImportEnumExtension()), "")

        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.optionalStringPieceExtension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.optionalCordExtension()), "")

        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalInt32Extension()) as? Int32
        {
            XCTAssertTrue(0 == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalInt64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(0) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalUint32Extension()) as? UInt32
        {
            XCTAssertTrue(0 == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalUint64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(0) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalSint32Extension()) as? Int32
        {
            XCTAssertTrue(0 == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalSint64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(0) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalFixed32Extension()) as? UInt32
        {
            XCTAssertTrue(UInt32(0) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalFixed64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(0) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalSfixed32Extension()) as? Int32
        {
            XCTAssertTrue(0 == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalSfixed64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(0) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalFloatExtension()) as? Float
        {
            XCTAssertTrue(Float(0) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalDoubleExtension()) as? Double
        {
            XCTAssertTrue(Double(0) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalBoolExtension()) as? Bool
        {
            XCTAssertTrue(false == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalStringExtension()) as? String
        {
            XCTAssertTrue("" == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalBytesExtension()) as? NSData
        {
            XCTAssertTrue(NSData() == val, "")
        }

        // Embedded messages should also be clear.
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalGroupExtension()) as? ProtobufUnittest.OptionalGroup_extension
        {
            XCTAssertFalse(val.hasA, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalNestedMessageExtension()) as? ProtobufUnittest.TestAllTypes.NestedMessage
        {
            XCTAssertFalse(val.hasBb, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalForeignMessageExtension()) as? ProtobufUnittest.ForeignMessage
        {
            XCTAssertFalse(val.hasC, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalImportMessageExtension()) as? ProtobufUnittestImport.ImportMessage
        {
            XCTAssertFalse(val.hasD, "")
        }

        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalGroupExtension()) as? ProtobufUnittest.OptionalGroup_extension
        {
            XCTAssertTrue(val.a == 0, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalNestedMessageExtension()) as? ProtobufUnittest.TestAllTypes.NestedMessage
        {
            XCTAssertTrue(val.bb == 0, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalForeignMessageExtension()) as? ProtobufUnittest.ForeignMessage
        {
            XCTAssertTrue(val.c == 0, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalImportMessageExtension()) as? ProtobufUnittestImport.ImportMessage
        {
            XCTAssertTrue(val.d == 0, "")
        }

        // Enums without defaults are set to the first value in the enum.
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalNestedEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.Foo.rawValue == val,"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalForeignEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignFoo.rawValue == val,"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalImportEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittestImport.ImportEnum.ImportFoo.rawValue == val,"")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalStringPieceExtension()) as? String
        {
            XCTAssertTrue("" == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.optionalCordExtension()) as? String
        {
            XCTAssertTrue("" == val, "")
        }

        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(0 == val.count, "")
        }

        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedBytesExtension()) as? Array<Array<Byte>>
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(0 == val.count, "")
        }

        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedNestedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.repeatedCordExtension()) as? [String]
        {
            XCTAssertTrue(0 == val.count, "")
        }

        // hasBlah() should also be NO for all default fields.
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.defaultInt32Extension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.defaultInt64Extension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.defaultUint32Extension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.defaultUint64Extension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.defaultSint32Extension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.defaultSint64Extension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.defaultFixed32Extension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.defaultFixed64Extension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.defaultSfixed32Extension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.defaultSfixed64Extension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.defaultFloatExtension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.defaultDoubleExtension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.defaultBoolExtension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.defaultStringExtension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.defaultBytesExtension()), "")

        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.defaultNestedEnumExtension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.defaultForeignEnumExtension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.defaultImportEnumExtension()), "")

        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.defaultStringPieceExtension()), "")
        XCTAssertFalse(message.hasExtension(GoogleProtobufUnittestRoot.defaultCordExtension()), "")


        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultInt32Extension()) as? Int32
        {
            XCTAssertTrue(41 == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultInt64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(42) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultUint32Extension()) as? UInt32
        {
            XCTAssertTrue(43 == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultUint64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(44) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultSint32Extension()) as? Int32
        {
            XCTAssertTrue(-45 == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultSint64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(46) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultFixed32Extension()) as? UInt32
        {
            XCTAssertTrue(UInt32(47) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultFixed64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(48) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultSfixed32Extension()) as? Int32
        {
            XCTAssertTrue(49 == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultSfixed64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(-50) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultFloatExtension()) as? Float
        {
            XCTAssertTrue(Float(51.5) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultDoubleExtension()) as? Double
        {
            XCTAssertTrue(Double(52e3) == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultBoolExtension()) as? Bool
        {
            XCTAssertTrue(true == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultStringExtension()) as? String
        {
            XCTAssertTrue("hello" == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultBytesExtension()) as? NSData
        {
            XCTAssertTrue(TestUtilities.getData("world") == val, "")
        }

        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultNestedEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.Bar.rawValue == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultForeignEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignBar.rawValue == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultImportEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittestImport.ImportEnum.ImportBar.rawValue == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultStringPieceExtension()) as? String
        {
            XCTAssertTrue("abc" == val, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.defaultCordExtension()) as? String
        {
            XCTAssertTrue("123" == val, "")
        }

    }

    class func assertExtensionsClear(message:ProtobufUnittest.TestAllExtensions)
    {
        TestUtilities().assertExtensionsClear(message)
    }

    class func setPackedFields(message:ProtobufUnittest.TestPackedTypesBuilder)
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

    class func setPackedExtensions(message:ProtobufUnittest.TestPackedExtensionsBuilder)
    {
       message.addExtension(GoogleProtobufUnittestRoot.packedInt32Extension(), value:Int32(601))
       message.addExtension(GoogleProtobufUnittestRoot.packedInt64Extension(), value:Int64(602))
       message.addExtension(GoogleProtobufUnittestRoot.packedUint32Extension(), value:UInt32(603))
       message.addExtension(GoogleProtobufUnittestRoot.packedUint64Extension(), value:UInt64(604))
       message.addExtension(GoogleProtobufUnittestRoot.packedSint32Extension(), value:Int32(605))
       message.addExtension(GoogleProtobufUnittestRoot.packedSint64Extension(), value:Int64(606))
       message.addExtension(GoogleProtobufUnittestRoot.packedFixed32Extension(), value:UInt32(607))
       message.addExtension(GoogleProtobufUnittestRoot.packedFixed64Extension(), value:UInt64(608))
       message.addExtension(GoogleProtobufUnittestRoot.packedSfixed32Extension(), value:Int32(609))
       message.addExtension(GoogleProtobufUnittestRoot.packedSfixed64Extension(), value:Int64(610))
       message.addExtension(GoogleProtobufUnittestRoot.packedFloatExtension(), value:Float(611.0))
       message.addExtension(GoogleProtobufUnittestRoot.packedDoubleExtension(),  value:Double(612.0))
       message.addExtension(GoogleProtobufUnittestRoot.packedBoolExtension(), value:true)
       message.addExtension(GoogleProtobufUnittestRoot.packedEnumExtension(), value:ProtobufUnittest.ForeignEnum.ForeignBar.rawValue)
        // Add a second one of each field.
       message.addExtension(GoogleProtobufUnittestRoot.packedInt32Extension(), value:Int32(701))
       message.addExtension(GoogleProtobufUnittestRoot.packedInt64Extension(), value:Int64(702))
       message.addExtension(GoogleProtobufUnittestRoot.packedUint32Extension(), value:UInt32(703))
       message.addExtension(GoogleProtobufUnittestRoot.packedUint64Extension(), value:UInt64(704))
       message.addExtension(GoogleProtobufUnittestRoot.packedSint32Extension(), value:Int32(705))
       message.addExtension(GoogleProtobufUnittestRoot.packedSint64Extension(), value:Int64(706))
       message.addExtension(GoogleProtobufUnittestRoot.packedFixed32Extension(), value:UInt32(707))
       message.addExtension(GoogleProtobufUnittestRoot.packedFixed64Extension(), value:UInt64(708))
       message.addExtension(GoogleProtobufUnittestRoot.packedSfixed32Extension(), value:Int32(709))
       message.addExtension(GoogleProtobufUnittestRoot.packedSfixed64Extension(), value:Int64(710))
       message.addExtension(GoogleProtobufUnittestRoot.packedFloatExtension(), value:Float(711.0))
       message.addExtension(GoogleProtobufUnittestRoot.packedDoubleExtension(), value:Double(712.0))
       message.addExtension(GoogleProtobufUnittestRoot.packedBoolExtension(), value:false)
       message.addExtension(GoogleProtobufUnittestRoot.packedEnumExtension(), value:ProtobufUnittest.ForeignEnum.ForeignBaz.rawValue)
    }


    func assertPackedExtensionsSet(message:ProtobufUnittest.TestPackedExtensions)
    {
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }

        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }

        ///
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(601 == val[0], "")
        }

        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(602 == val[0], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(603 == val[0], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(604 == val[0], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(605 == val[0], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(606 == val[0], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(607 == val[0], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(608 == val[0], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(609 == val[0], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(610 == val[0], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(611.0 == val[0], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(612.0 == val[0], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(true == val[0], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignBar.rawValue == val[0], "")
        }
        ///

        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(701 == val[1], "")
        }

        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(702 == val[1], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(703 == val[1], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(704 == val[1], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(705 == val[1], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(706 == val[1], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(707 == val[1], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(708 == val[1], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(709 == val[1], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(710 == val[1], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(711.0 == val[1], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(712.0 == val[1], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(false == val[1], "")
        }
        if let val = message.getExtension(GoogleProtobufUnittestRoot.packedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.ForeignBaz.rawValue == val[1], "")
        }
        ///
    }

    class func assertPackedExtensionsSet(message:ProtobufUnittest.TestPackedExtensions) {
        TestUtilities().assertPackedExtensionsSet(message)
    }

}
