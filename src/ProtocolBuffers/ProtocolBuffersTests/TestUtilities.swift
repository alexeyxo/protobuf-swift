//
//  TestUtilities.swift
//  ProtocolBuffers
//
//  Created by Alexey Khokhlov on 07.10.14.
//  Copyright (c) 2014 alexeyxo. All rights reserved.
//

import Foundation
import XCTest

class  TestUtilities {
    
    class func getData(str:String) -> [Byte] {
        var bytes = [Byte]()
        bytes += str.utf8
        return bytes
    }
    class func goldenData() -> NSData {
        
        var str =  NSBundle(forClass:TestUtilities.self).resourcePath!.stringByAppendingPathComponent("golden_message")
        let goldenData = NSData(contentsOfFile:str)
        return goldenData!
    }
    
    class func modifyRepeatedExtensions(message:TestAllExtensionsBuilder)
    {
        message.setExtension(UnittestRoot.repeatedInt32Extension(), index:1, value:Int32(501))
        message.setExtension(UnittestRoot.repeatedInt64Extension(), index:1, value:Int32(502))
        message.setExtension(UnittestRoot.repeatedUint32Extension(), index:1, value:Int32(503))
        message.setExtension(UnittestRoot.repeatedUint64Extension(), index:1, value:Int32(504))
        message.setExtension(UnittestRoot.repeatedSint32Extension(), index:1, value:Int32(505))
        message.setExtension(UnittestRoot.repeatedSint64Extension(), index:1, value:Int32(506))
        message.setExtension(UnittestRoot.repeatedFixed32Extension(), index:1, value:Int32(507))
        message.setExtension(UnittestRoot.repeatedFixed64Extension(), index:1, value:Int64(508))
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
    
    func assertAllExtensionsSet(message:TestAllExtensions)
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
            XCTAssertTrue(2 == val.count, "");
        }
        
        if let val = message.getExtension(UnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "");
        }
        if let val = message.getExtension(UnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(2 == val.count, "");
        }
        if let val = message.getExtension(UnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(2 == val.count, "");
        }
        if let val = message.getExtension(UnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "");
        }
        if let val = message.getExtension(UnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "");
        }
        if let val = message.getExtension(UnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(2 == val.count, "");
        }
        if let val = message.getExtension(UnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(2 == val.count, "");
        }
        if let val = message.getExtension(UnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "");
        }
        if let val = message.getExtension(UnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "");
        }
        if let val = message.getExtension(UnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(2 == val.count, "");
        }
        if let val = message.getExtension(UnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(2 == val.count, "");
        }
        if let val = message.getExtension(UnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(2 == val.count, "");
        }
        if let val = message.getExtension(UnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue(2 == val.count, "");
        }
        if let val = message.getExtension(UnittestRoot.repeatedBytesExtension()) as? Array<Array<Byte>>
        {
            XCTAssertTrue(2 == val.count, "");
        }
        if let val = message.getExtension(UnittestRoot.repeatedGroupExtension()) as? [RepeatedGroup_extension]
        {
            XCTAssertTrue(2 == val.count, "");
        }
        if let val = message.getExtension(UnittestRoot.repeatedNestedMessageExtension()) as? [TestAllTypes.NestedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(UnittestRoot.repeatedForeignMessageExtension()) as? [ForeignMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        
        if let val = message.getExtension(UnittestRoot.repeatedForeignMessageExtension()) as? [ImportMessage]
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
        
    }
}