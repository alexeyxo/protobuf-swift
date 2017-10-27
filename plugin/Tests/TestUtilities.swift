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
    
    init() {
        
    }
    
    class func getData(_ str:String) -> Data {
        var bytes = [UInt8]()
        bytes += str.utf8
        return Data(bytes: bytes, count:bytes.count)
    }
    class func goldenData() -> Data {
        
        let str =  (Bundle(for:TestUtilities.self).resourcePath! as NSString).appendingPathComponent("golden_message")
        let goldenData = try! Data(contentsOf: URL(fileURLWithPath: str))
        return goldenData
    }
    
    class func modifyRepeatedExtensions(_ message:ProtobufUnittest.TestAllExtensions.Builder) throws {
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedInt32Extension(), index:1, value:Int32(501))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedInt64Extension(), index:1, value:Int64(502))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedUint32Extension(), index:1, value:UInt32(503))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedUint64Extension(), index:1, value:UInt64(504))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSint32Extension(), index:1, value:Int32(505))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSint64Extension(), index:1, value:Int64(506))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFixed32Extension(), index:1, value:UInt32(507))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFixed64Extension(), index:1, value:UInt64(508))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSfixed32Extension(), index:1, value:Int32(509))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSfixed64Extension(), index:1, value:Int64(510))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFloatExtension(), index:1, value:Float(511.0))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedDoubleExtension(), index:1, value:Double(512.0))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedBoolExtension(), index:1, value:true)
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedStringExtension(),index:1, value:"515")
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedBytesExtension(), index:1, value:TestUtilities.getData("516"))

        let a = ProtobufUnittest.RepeatedGroupExtension.Builder()
        a.a = 517
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedGroupExtension(), index:1, value:a.build())
        
        let b = ProtobufUnittest.TestAllTypes.NestedMessage.Builder()
        b.bb = 518
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedNestedMessageExtension(), index:1, value:b.build())
        let foreign = ProtobufUnittest.ForeignMessage.Builder()
        foreign.c = 519
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension(), index:1, value:foreign.build())
        
        let importMessage = ProtobufUnittestImport.ImportMessage.Builder()
        importMessage.d = 520
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedImportMessageExtension(), index:1, value:importMessage.build())
        
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedNestedEnumExtension(), index:1, value:ProtobufUnittest.TestAllTypes.NestedEnum.foo.rawValue)
        
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedForeignEnumExtension(), index:1, value:ProtobufUnittest.ForeignEnum.foreignFoo.rawValue)
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedImportEnumExtension(), index:1, value:ProtobufUnittestImport.ImportEnum.importFoo.rawValue)
        
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedStringPieceExtension(),index:1, value:"524")
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedCordExtension(), index:1, value:"525")

    }
    
    func assertAllExtensionsSet(_ message:ProtobufUnittest.TestAllExtensions) {
        
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalInt32Extension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalInt64Extension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalUint32Extension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalUint64Extension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalSint32Extension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalSint64Extension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalFixed32Extension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalFixed64Extension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalSfixed32Extension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalSfixed64Extension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalFloatExtension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalDoubleExtension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalBoolExtension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalStringExtension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalBytesExtension()), "")
        
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalGroupExtension()), "")
    
    
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalNestedMessageExtension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalForeignMessageExtension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalImportMessageExtension()), "")
        
        if let extensions = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalGroupExtension()) as? ProtobufUnittest.OptionalGroupExtension {
            XCTAssertTrue(extensions.hasA, "")
        }
        if let ext = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalNestedMessageExtension()) as? ProtobufUnittest.TestAllTypes.NestedMessage {
            XCTAssertTrue(ext.hasBb, "")
        }
        
        if let ext = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalForeignMessageExtension()) as? ProtobufUnittest.ForeignMessage {
            XCTAssertTrue(ext.hasC, "")
        }
        
        if let ext = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalImportMessageExtension()) as? ProtobufUnittestImport.ImportMessage {
            XCTAssertTrue(ext.hasD, "")
        }
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalNestedEnumExtension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalForeignEnumExtension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalImportEnumExtension()), "")
        
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalStringPieceExtension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalCordExtension()), "")
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalInt32Extension()) as? Int32 {
            XCTAssertTrue(101 == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalInt64Extension()) as? Int64 {
            XCTAssertTrue(Int64(102) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalUint32Extension()) as? UInt32 {
            XCTAssertTrue(UInt32(103) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalUint64Extension()) as? UInt64 {
            XCTAssertTrue(UInt64(104) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalSint32Extension()) as? Int32 {
            XCTAssertTrue(105 == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalSint64Extension()) as? Int64 {
            XCTAssertTrue(Int64(106) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalFixed32Extension()) as? UInt32 {
            XCTAssertTrue(UInt32(107) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalFixed64Extension()) as? UInt64 {
            XCTAssertTrue(UInt64(108) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalSfixed32Extension()) as? Int32 {
            XCTAssertTrue(Int32(109) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalSfixed64Extension()) as? Int64 {
            XCTAssertTrue(Int64(110) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalFloatExtension()) as? Float {
            XCTAssertTrue(Float(111.0) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalDoubleExtension()) as? Double {
            XCTAssertTrue(Double(112.0) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalBoolExtension()) as? Bool {
            XCTAssertTrue(true == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalStringExtension()) as? String {
            XCTAssertTrue("115" == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalBytesExtension()) as? Data {
            XCTAssertTrue(TestUtilities.getData("116") == val, "")
        }
        
        if let mes = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalGroupExtension()) as? ProtobufUnittest.OptionalGroupExtension {
            XCTAssertTrue(117 == mes.a, "")
        }
        
        if let mes = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalNestedMessageExtension()) as? ProtobufUnittest.TestAllTypes.NestedMessage {
            XCTAssertTrue(118 == mes.bb, "")
        }
        if let mes = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalForeignMessageExtension()) as? ProtobufUnittest.ForeignMessage {
            XCTAssertTrue(119 == mes.c, "")
        }
        if let mes = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalImportMessageExtension()) as? ProtobufUnittestImport.ImportMessage {
            XCTAssertTrue(120 == mes.d, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalNestedEnumExtension()) as? Int32 {
            XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.baz.rawValue == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalForeignEnumExtension()) as? Int32 {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.foreignBaz.rawValue == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalImportEnumExtension()) as? Int32 {
            XCTAssertTrue(ProtobufUnittestImport.ImportEnum.importBaz.rawValue == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalStringPieceExtension()) as? String {
            XCTAssertTrue("124" == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalCordExtension()) as? String {
            XCTAssertTrue("125" == val, "")
        }
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedInt32Extension()) as? [Int32] {
            XCTAssertTrue(2 == val.count, "")
        }
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedInt64Extension()) as? [Int64] {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedUint32Extension()) as? [UInt32] {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedUint64Extension()) as? [UInt64] {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSint32Extension()) as? [Int32] {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSint64Extension()) as? [Int64] {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFixed32Extension()) as? [UInt32] {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFixed64Extension()) as? [UInt64] {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSfixed32Extension()) as? [Int32] {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSfixed64Extension()) as? [Int64] {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFloatExtension()) as? [Float] {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedDoubleExtension()) as? [Double] {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedBoolExtension()) as? [Bool] {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedStringExtension()) as? [String] {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedBytesExtension()) as? Array<Array<UInt8>> {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage] {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage] {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage] {
            XCTAssertTrue(2 == val.count, "")
        }
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage] {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedNestedEnumExtension()) as? [Int32] {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedForeignEnumExtension()) as? [Int32] {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedImportEnumExtension()) as? [Int32] {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedStringPieceExtension()) as? [String] {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedCordExtension()) as? [String] {
            XCTAssertTrue(2 == val.count, "")
        }
        
        ///
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedInt32Extension()) as? [Int32] {
            XCTAssertTrue(201 == val[0],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedInt64Extension()) as? [Int64] {
            XCTAssertTrue(202 == val[0],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedUint32Extension()) as? [UInt32] {
            XCTAssertTrue(203 == val[0],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedUint64Extension()) as? [UInt64] {
            XCTAssertTrue(204 == val[0],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSint32Extension()) as? [Int32] {
            XCTAssertTrue(205 == val[0],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSint64Extension()) as? [Int64] {
            XCTAssertTrue(206 == val[0],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFixed32Extension()) as? [UInt32] {
            XCTAssertTrue(207 == val[0],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFixed64Extension()) as? [UInt64] {
            XCTAssertTrue(208 == val[0],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSfixed32Extension()) as? [Int32] {
            XCTAssertTrue(209 == val[0],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSfixed64Extension()) as? [Int64] {
            XCTAssertTrue(210 == val[0],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFloatExtension()) as? [Float] {
            XCTAssertTrue(Float(211.0) == val[0], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedDoubleExtension()) as? [Double] {
            XCTAssertTrue(Double(212.0) == val[0], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedBoolExtension()) as? [Bool] {
            XCTAssertTrue(true == val[0], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedStringExtension()) as? [String] {
            XCTAssertTrue("215" == val[0], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedBytesExtension()) as? Array<Data> {
            XCTAssertTrue(TestUtilities.getData("216") == val[0], "")
        }
    
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage] {
            if let value = val[0] as? ProtobufUnittest.RepeatedGroupExtension {
                XCTAssertTrue(217 == value.a, "")
            }
        }
        
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage] {
            if let value = val[0] as? ProtobufUnittest.TestAllTypes.NestedMessage {
                XCTAssertTrue(218 == value.bb, "")
            }
        }
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage] {
            if let value = val[0] as? ProtobufUnittest.ForeignMessage {
                XCTAssertTrue(219 == value.c, "")
            }
        }
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedImportMessageExtension()) as? [GeneratedMessage] {
            if let value = val[0] as? ProtobufUnittestImport.ImportMessage {
                XCTAssertTrue(220 == value.d, "")
            }
        }
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedNestedEnumExtension()) as? [Int32] {
            XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.bar.rawValue == val[0], "")
        }
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedForeignEnumExtension()) as? [Int32] {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.foreignBar.rawValue == val[0], "")
        }
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedImportEnumExtension()) as? [Int32] {
            XCTAssertTrue(ProtobufUnittestImport.ImportEnum.importBar.rawValue == val[0], "")
        }
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedStringPieceExtension()) as? [String] {
            XCTAssertTrue("224" == val[0], "")
        }
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedCordExtension()) as? [String] {
            XCTAssertTrue("225" == val[0], "")
        }

        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedInt32Extension()) as? [Int32] {
            XCTAssertTrue(301 == val[1],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedInt64Extension()) as? [Int64] {
            XCTAssertTrue(302 == val[1],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedUint32Extension()) as? [UInt32] {
            XCTAssertTrue(303 == val[1],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedUint64Extension()) as? [UInt64] {
            XCTAssertTrue(304 == val[1],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSint32Extension()) as? [Int32] {
            XCTAssertTrue(305 == val[1],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSint64Extension()) as? [Int64] {
            XCTAssertTrue(306 == val[1],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFixed32Extension()) as? [UInt32] {
            XCTAssertTrue(307 == val[1],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFixed64Extension()) as? [UInt64] {
            XCTAssertTrue(308 == val[1],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSfixed32Extension()) as? [Int32] {
            XCTAssertTrue(309 == val[1],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSfixed64Extension()) as? [Int64] {
            XCTAssertTrue(310 == val[1],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFloatExtension()) as? [Float] {
            XCTAssertTrue(Float(311.0) == val[1], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(Double(312.0) == val[1], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedBoolExtension()) as? [Bool] {
            XCTAssertTrue(false == val[1], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedStringExtension()) as? [String] {
            XCTAssertTrue("315" == val[1], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedBytesExtension()) as? Array<Data> {
            XCTAssertTrue(TestUtilities.getData("316") == val[1], "")
        }
        
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage] {
            if let value = val[1] as? ProtobufUnittest.RepeatedGroupExtension {
                XCTAssertTrue(317 == value.a, "")
            }
        }
        
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage] {
            if let value = val[1] as? ProtobufUnittest.TestAllTypes.NestedMessage {
                XCTAssertTrue(318 == value.bb, "")
            }
        }
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage] {
            if let value = val[1] as? ProtobufUnittest.ForeignMessage {
                XCTAssertTrue(319 == value.c, "")
            }
            
        }
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedImportMessageExtension()) as? [GeneratedMessage] {
            if let value = val[1] as? ProtobufUnittestImport.ImportMessage
            {
                XCTAssertTrue(320 == value.d, "")
            }
            
        }
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedNestedEnumExtension()) as? [Int32] {
            XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.baz.rawValue == val[1], "")
        }
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.foreignBaz.rawValue == val[1], "")
        }
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittestImport.ImportEnum.importBaz.rawValue == val[1], "")
        }
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue("324" == val[1], "")
        }
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedCordExtension()) as? [String]
        {
            XCTAssertTrue("325" == val[1], "")
        }
        
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultInt32Extension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultInt64Extension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultUint32Extension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultUint64Extension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultSint32Extension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultSint64Extension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultFixed32Extension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultFixed64Extension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultSfixed32Extension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultSfixed64Extension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultFloatExtension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultDoubleExtension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultBoolExtension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultStringExtension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultBytesExtension()), "")
        
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultNestedEnumExtension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultForeignEnumExtension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultImportEnumExtension()), "")
        
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultStringPieceExtension()), "")
        XCTAssertTrue(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultCordExtension()), "")
        
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultInt32Extension()) as? Int32
        {
            XCTAssertTrue(401 == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultInt64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(402) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultUint32Extension()) as? UInt32
        {
            XCTAssertTrue(UInt32(403) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultUint64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(404) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultSint32Extension()) as? Int32
        {
            XCTAssertTrue(405 == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultSint64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(406) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultFixed32Extension()) as? UInt32
        {
            XCTAssertTrue(UInt32(407) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultFixed64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(408) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultSfixed32Extension()) as? Int32
        {
            XCTAssertTrue(Int32(409) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultSfixed64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(410) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultFloatExtension()) as? Float
        {
            XCTAssertTrue(Float(411.0) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultDoubleExtension()) as? Double
        {
            XCTAssertTrue(Double(412.0) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultBoolExtension()) as? Bool
        {
            XCTAssertTrue(false == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultStringExtension()) as? String
        {
            XCTAssertTrue("415" == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultBytesExtension()) as? Data
        {
            XCTAssertTrue(TestUtilities.getData("416") == val, "")
        }
    
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultNestedEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.foo.rawValue == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultForeignEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.foreignFoo.rawValue == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultImportEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittestImport.ImportEnum.importFoo.rawValue == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultStringPieceExtension()) as? String
        {
            XCTAssertTrue("424" == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultCordExtension()) as? String
        {
            XCTAssertTrue("425" == val, "")
        }
        
    }
    
    class func assertAllExtensionsSet(_ message:ProtobufUnittest.TestAllExtensions)
    {
        return TestUtilities().assertAllExtensionsSet(message)
    }
    
    func assertRepeatedExtensionsModified(_ message:ProtobufUnittest.TestAllExtensions)
    {
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedBytesExtension()) as? Array<Array<UInt8>>
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedNestedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedCordExtension()) as? [String]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        
        ///
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(201 == val[0],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(202 == val[0],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(203 == val[0],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(204 == val[0],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(205 == val[0],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(206 == val[0],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(207 == val[0],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(208 == val[0],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(209 == val[0],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(210 == val[0],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(Float(211.0) == val[0], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(Double(212.0) == val[0], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(true == val[0], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue("215" == val[0], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedBytesExtension()) as? Array<Data>
        {
            XCTAssertTrue(TestUtilities.getData("216") == val[0], "")
        }
        
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage]
        {
            if let values = val[0] as? ProtobufUnittest.RepeatedGroupExtension
            {
                XCTAssertTrue(217 ==  values.a, "")
            }
        }
        
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage]
        {
            if let values = val[0] as? ProtobufUnittest.TestAllTypes.NestedMessage
            {
                XCTAssertTrue(218 == values.bb, "")
            }
            
        }
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            if let values = val[0] as? ProtobufUnittest.ForeignMessage
            {
                XCTAssertTrue(219 == values.c, "")
            }
        }
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedImportMessageExtension()) as? [GeneratedMessage]
        {
            if let values = val[0] as? ProtobufUnittestImport.ImportMessage
            {
                XCTAssertTrue(220 == values.d, "")
            }
        }
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedNestedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.bar.rawValue == val[0], "")
        }
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.foreignBar.rawValue == val[0], "")
        }
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittestImport.ImportEnum.importBar.rawValue == val[0], "")
        }
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue("224" == val[0], "")
        }
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedCordExtension()) as? [String]
        {
            XCTAssertTrue("225" == val[0], "")
        }

        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(501 == val[1],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(502 == val[1],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(503 == val[1],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(504 == val[1],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(505 == val[1],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(506 == val[1],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(507 == val[1],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(508 == val[1],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(509 == val[1],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(510 == val[1],"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(Float(511.0) == val[1], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(Double(512.0) == val[1], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(true == val[1], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue("515" == val[1], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedBytesExtension()) as? Array<Data>
        {
            XCTAssertTrue(TestUtilities.getData("516") == val[1], "")
        }
        
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage]
        {
            if let values = val[1] as? ProtobufUnittest.RepeatedGroupExtension
            {
                XCTAssertTrue(517 == values.a, "")
            }
        }
        
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage]
        {
            if let values = val[1] as? ProtobufUnittest.TestAllTypes.NestedMessage
            {
                XCTAssertTrue(518 == values.bb, "")
            }
            
        }
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            if let values = val[1] as? ProtobufUnittest.ForeignMessage
            {
                XCTAssertTrue(519 == values.c, "")
            }
            
        }
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedImportMessageExtension()) as? [GeneratedMessage]
        {
            if let values = val[1] as? ProtobufUnittestImport.ImportMessage
            {
                XCTAssertTrue(520 == values.d, "")
            }
            
        }
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedNestedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.foo.rawValue == val[1], "")
        }
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.foreignFoo.rawValue == val[1], "")
        }
        if let val =  message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittestImport.ImportEnum.importFoo.rawValue == val[1], "")
        }
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue("524" == val[1], "")
        }
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedCordExtension()) as? [String]
        {
            XCTAssertTrue("525" == val[1], "")
        }
    }
    
    class func assertRepeatedExtensionsModified(_ message:ProtobufUnittest.TestAllExtensions)
    {
        TestUtilities().assertRepeatedExtensionsModified(message)
    }
    
    func assertAllFieldsSet(_ message:ProtobufUnittest.TestAllTypes)
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
        
        XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.baz == message.optionalNestedEnum, "")
        XCTAssertTrue(ProtobufUnittest.ForeignEnum.foreignBaz == message.optionalForeignEnum, "")
        XCTAssertTrue(ProtobufUnittestImport.ImportEnum.importBaz == message.optionalImportEnum, "")
        
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
        
        XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.bar == message.repeatedNestedEnum[0], "")
        XCTAssertTrue(ProtobufUnittest.ForeignEnum.foreignBar == message.repeatedForeignEnum[0], "")
        XCTAssertTrue(ProtobufUnittestImport.ImportEnum.importBar == message.repeatedImportEnum[0], "")
        
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
        
        XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.baz == message.repeatedNestedEnum[1], "")
        XCTAssertTrue(ProtobufUnittest.ForeignEnum.foreignBaz == message.repeatedForeignEnum[1], "")
        XCTAssertTrue(ProtobufUnittestImport.ImportEnum.importBaz == message.repeatedImportEnum[1], "")
        
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
        
        XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.foo == message.defaultNestedEnum, "")
        XCTAssertTrue(ProtobufUnittest.ForeignEnum.foreignFoo == message.defaultForeignEnum, "")
        XCTAssertTrue(ProtobufUnittestImport.ImportEnum.importFoo == message.defaultImportEnum, "")
        
        XCTAssertTrue("424" == message.defaultStringPiece, "")
        XCTAssertTrue("425" == message.defaultCord, "")
    
    }
    
    class func assertAllFieldsSet(_ message:ProtobufUnittest.TestAllTypes)
    {
        TestUtilities().assertAllFieldsSet(message)
    }
    
    class func setAllFields(_ message:ProtobufUnittest.TestAllTypes.Builder) throws
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
        
        message.optionalNestedEnum = ProtobufUnittest.TestAllTypes.NestedEnum.baz
        message.optionalForeignEnum = ProtobufUnittest.ForeignEnum.foreignBaz
        message.optionalImportEnum = ProtobufUnittestImport.ImportEnum.importBaz
        
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
        
        message.repeatedNestedEnum += [ProtobufUnittest.TestAllTypes.NestedEnum.bar]
        message.repeatedForeignEnum += [ProtobufUnittest.ForeignEnum.foreignBar]
        message.repeatedImportEnum += [ProtobufUnittestImport.ImportEnum.importBar]
        
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
        
        message.repeatedNestedEnum += [ProtobufUnittest.TestAllTypes.NestedEnum.baz]
        message.repeatedForeignEnum += [ProtobufUnittest.ForeignEnum.foreignBaz]
        message.repeatedImportEnum += [ProtobufUnittestImport.ImportEnum.importBaz]
        
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
        
        message.defaultNestedEnum  = ProtobufUnittest.TestAllTypes.NestedEnum.foo
        message.defaultForeignEnum = ProtobufUnittest.ForeignEnum.foreignFoo
        message.defaultImportEnum = ProtobufUnittestImport.ImportEnum.importFoo
        
        message.defaultStringPiece = "424"
        message.defaultCord = "425"
        
    }
    
    class func setOneOfFields(_ message:ProtobufUnittest.TestAllTypes.Builder) throws
    {
        message.oneofUint32 = 601
        let builder = ProtobufUnittest.TestAllTypes.NestedMessage.Builder()
        builder.bb = 602
        message.oneofNestedMessage = try builder.build()
        message.oneofString = "603"
        message.oneofBytes = Data(bytes: ([UInt8]() + "604".utf8), count: 3)
    }
    
    class func setAllExtensions(_ message:ProtobufUnittest.TestAllExtensions.Builder) throws
    {
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.optionalInt32Extension(), value:Int32(101))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.optionalInt64Extension(), value:Int64(102))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.optionalUint32Extension(), value:UInt32(103))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.optionalUint64Extension(), value:UInt64(104))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.optionalSint32Extension(), value:Int32(105))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.optionalSint64Extension(), value:Int64(106))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.optionalFixed32Extension(), value:UInt32(107))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.optionalFixed64Extension(), value:UInt64(108))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.optionalSfixed32Extension(), value:Int32(109))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.optionalSfixed64Extension(), value:Int64(110))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.optionalFloatExtension(), value:Float(111.0))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.optionalDoubleExtension(), value:Double(112.0))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.optionalBoolExtension(), value:true)
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.optionalStringExtension(), value:"115")
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.optionalBytesExtension(), value:TestUtilities.getData("116"))
        
        let optgr = ProtobufUnittest.OptionalGroupExtension.Builder()
        optgr.a = 117
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.optionalGroupExtension(), value:optgr.build())
        
        let netmesb = ProtobufUnittest.TestAllTypes.NestedMessage.Builder()
        netmesb.bb = 118
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.optionalNestedMessageExtension(), value:netmesb.build())
        
        let forMes = ProtobufUnittest.ForeignMessage.Builder()
        forMes.c = 119
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.optionalForeignMessageExtension(), value:forMes.build())
        
        let impMes = ProtobufUnittestImport.ImportMessage.Builder()
        impMes.d = 120
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.optionalImportMessageExtension(), value:impMes.build())
        
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.optionalNestedEnumExtension(), value:ProtobufUnittest.TestAllTypes.NestedEnum.baz.rawValue)
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.optionalForeignEnumExtension(), value:ProtobufUnittest.ForeignEnum.foreignBaz.rawValue)
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.optionalImportEnumExtension(), value:ProtobufUnittestImport.ImportEnum.importBaz.rawValue)
        
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.optionalStringPieceExtension(),  value:"124")
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.optionalCordExtension(), value:"125")
        
        // -----------------------------------------------------------------
        
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedInt32Extension(), value:Int32(201))
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedInt64Extension(), value:Int64(202))
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedUint32Extension(), value:UInt32(203))
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedUint64Extension(), value:UInt64(204))
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSint32Extension(), value:Int32(205))
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSint64Extension(), value:Int64(206))
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFixed32Extension(), value:UInt32(207))
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFixed64Extension(), value:UInt64(208))
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSfixed32Extension(), value:Int32(209))
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSfixed64Extension(), value:Int64(210))
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFloatExtension(), value:Float(211.0))
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedDoubleExtension(), value:Double(212.0))
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedBoolExtension(), value:true)
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedStringExtension(), value:"215")
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedBytesExtension(), value:TestUtilities.getData("216"))
        
        
        let repGr = ProtobufUnittest.RepeatedGroupExtension.Builder()
        repGr.a = 217
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedGroupExtension(), value:repGr.build())
        let netmesrep = ProtobufUnittest.TestAllTypes.NestedMessage.Builder()
        netmesrep.bb = 218
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedNestedMessageExtension(), value:netmesrep.build())
        
        let msgFore = ProtobufUnittest.ForeignMessage.Builder()
        msgFore.c = 219
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension(), value:msgFore.build())
        let impMes220 = ProtobufUnittestImport.ImportMessage.Builder()
        impMes220.d = 220
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedImportMessageExtension(), value:impMes220.build())
        
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedNestedEnumExtension(), value:ProtobufUnittest.TestAllTypes.NestedEnum.bar.rawValue)
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedForeignEnumExtension(), value:ProtobufUnittest.ForeignEnum.foreignBar.rawValue)
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedImportEnumExtension(), value:ProtobufUnittestImport.ImportEnum.importBar.rawValue)
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedStringPieceExtension(), value:"224")
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedCordExtension(), value:"225")
        
        // Add a second one of each field.
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedInt32Extension(), value:Int32(301))
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedInt64Extension(), value:Int64(302))
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedUint32Extension(), value:UInt32(303))
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedUint64Extension(), value:UInt64(304))
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSint32Extension(), value:Int32(305))
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSint64Extension(), value:Int64(306))
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFixed32Extension(), value:UInt32(307))
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFixed64Extension(), value:UInt64(308))
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSfixed32Extension(), value:Int32(309))
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSfixed64Extension(), value:Int64(310))
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFloatExtension(), value:Float(311.0))
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedDoubleExtension(), value:Double(312.0))
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedBoolExtension(), value:false)
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedStringExtension(), value:"315")
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedBytesExtension(), value:TestUtilities.getData("316"))
        
        
        let repGr2 = ProtobufUnittest.RepeatedGroupExtension.Builder()
        repGr2.a = 317
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedGroupExtension(), value:repGr2.build())
        let netmesrep2 = ProtobufUnittest.TestAllTypes.NestedMessage.Builder()
        netmesrep2.bb = 318
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedNestedMessageExtension(), value:netmesrep2.build())
        
        let msgFore2 = ProtobufUnittest.ForeignMessage.Builder()
        msgFore2.c = 319
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension(), value:msgFore2.build())
        let impMes2 = ProtobufUnittestImport.ImportMessage.Builder()
        impMes2.d = 320
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedImportMessageExtension(), value:impMes2.build())
        
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedNestedEnumExtension(), value:ProtobufUnittest.TestAllTypes.NestedEnum.baz.rawValue)
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedForeignEnumExtension(), value:ProtobufUnittest.ForeignEnum.foreignBaz.rawValue)
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedImportEnumExtension(), value:ProtobufUnittestImport.ImportEnum.importBaz.rawValue)
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedStringPieceExtension(), value:"324")
        try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedCordExtension(), value:"325")
        
        // -----------------------------------------------------------------
        
        
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.defaultInt32Extension(), value:Int32(401))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.defaultInt64Extension(), value:Int64(402))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.defaultUint32Extension(), value:UInt32(403))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.defaultUint64Extension(), value:UInt64(404))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.defaultSint32Extension(), value:Int32(405))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.defaultSint64Extension(), value:Int64(406))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.defaultFixed32Extension(), value:UInt32(407))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.defaultFixed64Extension(), value:UInt64(408))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.defaultSfixed32Extension(), value:Int32(409))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.defaultSfixed64Extension(), value:Int64(410))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.defaultFloatExtension(), value:Float(411.0))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.defaultDoubleExtension(), value:Double(412.0))
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.defaultBoolExtension(), value:false)
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.defaultStringExtension(), value:"415")
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.defaultBytesExtension(), value:TestUtilities.getData("416"))
        
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.defaultNestedEnumExtension(), value:ProtobufUnittest.TestAllTypes.NestedEnum.foo.rawValue)
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.defaultForeignEnumExtension(), value:ProtobufUnittest.ForeignEnum.foreignFoo.rawValue)
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.defaultImportEnumExtension(), value:ProtobufUnittestImport.ImportEnum.importFoo.rawValue)
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.defaultStringPieceExtension(), value:"424")
        try message.setExtension(extensions:ProtobufUnittest.UnittestRoot.defaultCordExtension(), value:"425")
        
    }
    class func registerAllExtensions(_ registry:ExtensionRegistry)
    {
        ProtobufUnittest.UnittestRoot.default.registerAllExtensions(registry:registry)
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
    
    func assertClear(_ message:ProtobufUnittest.TestAllTypes)
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
        XCTAssertTrue(Data() == message.optionalBytes, "")
        
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
        XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.foo == message.optionalNestedEnum, "")
        XCTAssertTrue(ProtobufUnittest.ForeignEnum.foreignFoo == message.optionalForeignEnum, "")
        XCTAssertTrue(ProtobufUnittestImport.ImportEnum.importFoo == message.optionalImportEnum, "")
        
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
        
        XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.bar == message.defaultNestedEnum, "")
        XCTAssertTrue(ProtobufUnittest.ForeignEnum.foreignBar == message.defaultForeignEnum, "")
        XCTAssertTrue(ProtobufUnittestImport.ImportEnum.importBar == message.defaultImportEnum, "")
        
        XCTAssertTrue("abc" == message.defaultStringPiece, "")
        XCTAssertTrue("123" == message.defaultCord, "")
    }
    
    class func assertClear(_ message:ProtobufUnittest.TestAllTypes)
    {
        TestUtilities().assertClear(message)
    }
    
    func assertExtensionsClear(_ message:ProtobufUnittest.TestAllExtensions)
    {
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalInt32Extension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalInt64Extension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalUint32Extension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalUint64Extension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalSint32Extension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalSint64Extension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalFixed32Extension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalFixed64Extension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalSfixed32Extension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalSfixed64Extension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalFloatExtension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalDoubleExtension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalBoolExtension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalStringExtension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalBytesExtension()), "")
        
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalGroupExtension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalNestedMessageExtension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalForeignMessageExtension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalImportMessageExtension()), "")
        
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalNestedEnumExtension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalForeignEnumExtension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalImportEnumExtension()), "")
        
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalStringPieceExtension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalCordExtension()), "")
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalInt32Extension()) as? Int32
        {
            XCTAssertTrue(0 == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalInt64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(0) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalUint32Extension()) as? UInt32
        {
            XCTAssertTrue(0 == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalUint64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(0) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalSint32Extension()) as? Int32
        {
            XCTAssertTrue(0 == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalSint64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(0) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalFixed32Extension()) as? UInt32
        {
            XCTAssertTrue(UInt32(0) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalFixed64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(0) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalSfixed32Extension()) as? Int32
        {
            XCTAssertTrue(0 == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalSfixed64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(0) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalFloatExtension()) as? Float
        {
            XCTAssertTrue(Float(0) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalDoubleExtension()) as? Double
        {
            XCTAssertTrue(Double(0) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalBoolExtension()) as? Bool
        {
            XCTAssertTrue(false == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalStringExtension()) as? String
        {
            XCTAssertTrue("" == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalBytesExtension()) as? Data
        {
            XCTAssertTrue(Data() == val, "")
        }
        
        // Embedded messages should also be clear.
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalGroupExtension()) as? ProtobufUnittest.OptionalGroupExtension
        {
            XCTAssertFalse(val.hasA, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalNestedMessageExtension()) as? ProtobufUnittest.TestAllTypes.NestedMessage
        {
            XCTAssertFalse(val.hasBb, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalForeignMessageExtension()) as? ProtobufUnittest.ForeignMessage
        {
            XCTAssertFalse(val.hasC, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalImportMessageExtension()) as? ProtobufUnittestImport.ImportMessage
        {
            XCTAssertFalse(val.hasD, "")
        }
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalGroupExtension()) as? ProtobufUnittest.OptionalGroupExtension
        {
            XCTAssertTrue(val.a == nil, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalNestedMessageExtension()) as? ProtobufUnittest.TestAllTypes.NestedMessage
        {
            XCTAssertTrue(val.bb == nil, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalForeignMessageExtension()) as? ProtobufUnittest.ForeignMessage
        {
            XCTAssertTrue(val.c == nil, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalImportMessageExtension()) as? ProtobufUnittestImport.ImportMessage
        {
            XCTAssertTrue(val.d == nil, "")
        }
        
        // Enums without defaults are set to the first value in the enum.
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalNestedEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.foo.rawValue == val,"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalForeignEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.foreignFoo.rawValue == val,"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalImportEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittestImport.ImportEnum.importFoo.rawValue == val,"")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalStringPieceExtension()) as? String
        {
            XCTAssertTrue("" == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.optionalCordExtension()) as? String
        {
            XCTAssertTrue("" == val, "")
        }
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedStringExtension()) as? [String]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedBytesExtension()) as? Array<Array<UInt8>>
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedGroupExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedNestedMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedForeignMessageExtension()) as? [GeneratedMessage]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedNestedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedForeignEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedImportEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedStringPieceExtension()) as? [String]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedCordExtension()) as? [String]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        
        // hasBlah() should also be NO for all default fields.
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultInt32Extension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultInt64Extension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultUint32Extension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultUint64Extension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultSint32Extension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultSint64Extension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultFixed32Extension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultFixed64Extension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultSfixed32Extension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultSfixed64Extension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultFloatExtension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultDoubleExtension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultBoolExtension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultStringExtension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultBytesExtension()), "")
        
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultNestedEnumExtension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultForeignEnumExtension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultImportEnumExtension()), "")
        
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultStringPieceExtension()), "")
        XCTAssertFalse(message.hasExtension(extensions:ProtobufUnittest.UnittestRoot.defaultCordExtension()), "")
        
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultInt32Extension()) as? Int32
        {
            XCTAssertTrue(41 == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultInt64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(42) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultUint32Extension()) as? UInt32
        {
            XCTAssertTrue(43 == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultUint64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(44) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultSint32Extension()) as? Int32
        {
            XCTAssertTrue(-45 == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultSint64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(46) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultFixed32Extension()) as? UInt32
        {
            XCTAssertTrue(UInt32(47) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultFixed64Extension()) as? UInt64
        {
            XCTAssertTrue(UInt64(48) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultSfixed32Extension()) as? Int32
        {
            XCTAssertTrue(49 == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultSfixed64Extension()) as? Int64
        {
            XCTAssertTrue(Int64(-50) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultFloatExtension()) as? Float
        {
            XCTAssertTrue(Float(51.5) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultDoubleExtension()) as? Double
        {
            XCTAssertTrue(Double(52e3) == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultBoolExtension()) as? Bool
        {
            XCTAssertTrue(true == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultStringExtension()) as? String
        {
            XCTAssertTrue("hello" == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultBytesExtension()) as? Data
        {
            XCTAssertTrue(TestUtilities.getData("world") == val, "")
        }
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultNestedEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittest.TestAllTypes.NestedEnum.bar.rawValue == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultForeignEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.foreignBar.rawValue == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultImportEnumExtension()) as? Int32
        {
            XCTAssertTrue(ProtobufUnittestImport.ImportEnum.importBar.rawValue == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultStringPieceExtension()) as? String
        {
            XCTAssertTrue("abc" == val, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.defaultCordExtension()) as? String
        {
            XCTAssertTrue("123" == val, "")
        }
        
    }
    
    class func assertExtensionsClear(_ message:ProtobufUnittest.TestAllExtensions)
    {
        TestUtilities().assertExtensionsClear(message)
    }
    
    class func setPackedFields(_ message:ProtobufUnittest.TestPackedTypes.Builder)
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
        message.packedEnum += [ProtobufUnittest.ForeignEnum.foreignBar]
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
        message.packedEnum += [ProtobufUnittest.ForeignEnum.foreignBaz]
    }
    
    func assertPackedFieldsSet(_ message:ProtobufUnittest.TestPackedTypes)
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
        XCTAssertTrue(ProtobufUnittest.ForeignEnum.foreignBar ==  message.packedEnum[0], "")
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
        XCTAssertTrue(ProtobufUnittest.ForeignEnum.foreignBaz ==  message.packedEnum[1], "")
    }
    
    class func assertPackedFieldsSet(_ message:ProtobufUnittest.TestPackedTypes)
    {
        TestUtilities().assertPackedFieldsSet(message)
    }
    
    class func setPackedExtensions(_ message:ProtobufUnittest.TestPackedExtensions.Builder) throws
    {
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedInt32Extension(), value:Int32(601))
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedInt64Extension(), value:Int64(602))
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedUint32Extension(), value:UInt32(603))
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedUint64Extension(), value:UInt64(604))
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedSint32Extension(), value:Int32(605))
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedSint64Extension(), value:Int64(606))
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedFixed32Extension(), value:UInt32(607))
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedFixed64Extension(), value:UInt64(608))
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedSfixed32Extension(), value:Int32(609))
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedSfixed64Extension(), value:Int64(610))
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedFloatExtension(), value:Float(611.0))
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedDoubleExtension(),  value:Double(612.0))
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedBoolExtension(), value:true)
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedEnumExtension(), value:ProtobufUnittest.ForeignEnum.foreignBar.rawValue)
        // Add a second one of each field.
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedInt32Extension(), value:Int32(701))
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedInt64Extension(), value:Int64(702))
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedUint32Extension(), value:UInt32(703))
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedUint64Extension(), value:UInt64(704))
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedSint32Extension(), value:Int32(705))
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedSint64Extension(), value:Int64(706))
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedFixed32Extension(), value:UInt32(707))
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedFixed64Extension(), value:UInt64(708))
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedSfixed32Extension(), value:Int32(709))
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedSfixed64Extension(), value:Int64(710))
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedFloatExtension(), value:Float(711.0))
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedDoubleExtension(), value:Double(712.0))
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedBoolExtension(), value:false)
       try message.addExtension(extensions:ProtobufUnittest.UnittestRoot.packedEnumExtension(), value:ProtobufUnittest.ForeignEnum.foreignBaz.rawValue)
    }
    
    
    func assertPackedExtensionsSet(_ message:ProtobufUnittest.TestPackedExtensions)
    {
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(2 == val.count, "")
        }
        
        ///
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(601 == val[0], "")
        }
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(602 == val[0], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(603 == val[0], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(604 == val[0], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(605 == val[0], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(606 == val[0], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(607 == val[0], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(608 == val[0], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(609 == val[0], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(610 == val[0], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(611.0 == val[0], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(612.0 == val[0], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(true == val[0], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.foreignBar.rawValue == val[0], "")
        }
        ///
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(701 == val[1], "")
        }
        
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedInt64Extension()) as? [Int64]
        {
            XCTAssertTrue(702 == val[1], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedUint32Extension()) as? [UInt32]
        {
            XCTAssertTrue(703 == val[1], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedUint64Extension()) as? [UInt64]
        {
            XCTAssertTrue(704 == val[1], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedSint32Extension()) as? [Int32]
        {
            XCTAssertTrue(705 == val[1], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedSint64Extension()) as? [Int64]
        {
            XCTAssertTrue(706 == val[1], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedFixed32Extension()) as? [UInt32]
        {
            XCTAssertTrue(707 == val[1], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedFixed64Extension()) as? [UInt64]
        {
            XCTAssertTrue(708 == val[1], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedSfixed32Extension()) as? [Int32]
        {
            XCTAssertTrue(709 == val[1], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedSfixed64Extension()) as? [Int64]
        {
            XCTAssertTrue(710 == val[1], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedFloatExtension()) as? [Float]
        {
            XCTAssertTrue(711.0 == val[1], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedDoubleExtension()) as? [Double]
        {
            XCTAssertTrue(712.0 == val[1], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedBoolExtension()) as? [Bool]
        {
            XCTAssertTrue(false == val[1], "")
        }
        if let val = message.getExtension(extensions:ProtobufUnittest.UnittestRoot.packedEnumExtension()) as? [Int32]
        {
            XCTAssertTrue(ProtobufUnittest.ForeignEnum.foreignBaz.rawValue == val[1], "")
        }
        ///
    }
    
    class func assertPackedExtensionsSet(_ message:ProtobufUnittest.TestPackedExtensions) {
        TestUtilities().assertPackedExtensionsSet(message)
    }
    
}

let testData = "ChFNb2RlbENsaWVudC5wcm90bxoICAMQBBgAIgB6vKUCCiBnb29nbGUvcHJvdG9idWYvZGVzY3JpcHRvci5wcm90bxIPZ29vZ2xlLnByb3RvYnVmIk0KEUZpbGVEZXNjcmlwdG9yU2V0EjgKBGZpbGUYASADKAsyJC5nb29nbGUucHJvdG9idWYuRmlsZURlc2NyaXB0b3JQcm90b1IEZmlsZSLMBAoTRmlsZURlc2NyaXB0b3JQcm90bxISCgRuYW1lGAEgASgJUgRuYW1lEhgKB3BhY2thZ2UYAiABKAlSB3BhY2thZ2USHgoKZGVwZW5kZW5jeRgDIAMoCVIKZGVwZW5kZW5jeRIrChFwdWJsaWNfZGVwZW5kZW5jeRgKIAMoBVIQcHVibGljRGVwZW5kZW5jeRInCg93ZWFrX2RlcGVuZGVuY3kYCyADKAVSDndlYWtEZXBlbmRlbmN5EkMKDG1lc3NhZ2VfdHlwZRgEIAMoCzIgLmdvb2dsZS5wcm90b2J1Zi5EZXNjcmlwdG9yUHJvdG9SC21lc3NhZ2VUeXBlEkEKCWVudW1fdHlwZRgFIAMoCzIkLmdvb2dsZS5wcm90b2J1Zi5FbnVtRGVzY3JpcHRvclByb3RvUghlbnVtVHlwZRJBCgdzZXJ2aWNlGAYgAygLMicuZ29vZ2xlLnByb3RvYnVmLlNlcnZpY2VEZXNjcmlwdG9yUHJvdG9SB3NlcnZpY2USQwoJZXh0ZW5zaW9uGAcgAygLMiUuZ29vZ2xlLnByb3RvYnVmLkZpZWxkRGVzY3JpcHRvclByb3RvUglleHRlbnNpb24SNgoHb3B0aW9ucxgIIAEoCzIcLmdvb2dsZS5wcm90b2J1Zi5GaWxlT3B0aW9uc1IHb3B0aW9ucxJJChBzb3VyY2VfY29kZV9pbmZvGAkgASgLMh8uZ29vZ2xlLnByb3RvYnVmLlNvdXJjZUNvZGVJbmZvUg5zb3VyY2VDb2RlSW5mbyLCBAoPRGVzY3JpcHRvclByb3RvEhIKBG5hbWUYASABKAlSBG5hbWUSOwoFZmllbGQYAiADKAsyJS5nb29nbGUucHJvdG9idWYuRmllbGREZXNjcmlwdG9yUHJvdG9SBWZpZWxkEkMKCWV4dGVuc2lvbhgGIAMoCzIlLmdvb2dsZS5wcm90b2J1Zi5GaWVsZERlc2NyaXB0b3JQcm90b1IJZXh0ZW5zaW9uEkEKC25lc3RlZF90eXBlGAMgAygLMiAuZ29vZ2xlLnByb3RvYnVmLkRlc2NyaXB0b3JQcm90b1IKbmVzdGVkVHlwZRJBCgllbnVtX3R5cGUYBCADKAsyJC5nb29nbGUucHJvdG9idWYuRW51bURlc2NyaXB0b3JQcm90b1IIZW51bVR5cGUSWAoPZXh0ZW5zaW9uX3JhbmdlGAUgAygLMi8uZ29vZ2xlLnByb3RvYnVmLkRlc2NyaXB0b3JQcm90by5FeHRlbnNpb25SYW5nZVIOZXh0ZW5zaW9uUmFuZ2USRAoKb25lb2ZfZGVjbBgIIAMoCzIlLmdvb2dsZS5wcm90b2J1Zi5PbmVvZkRlc2NyaXB0b3JQcm90b1IJb25lb2ZEZWNsEjkKB29wdGlvbnMYByABKAsyHy5nb29nbGUucHJvdG9idWYuTWVzc2FnZU9wdGlvbnNSB29wdGlvbnMaOAoORXh0ZW5zaW9uUmFuZ2USFAoFc3RhcnQYASABKAVSBXN0YXJ0EhAKA2VuZBgCIAEoBVIDZW5kIvsFChRGaWVsZERlc2NyaXB0b3JQcm90bxISCgRuYW1lGAEgASgJUgRuYW1lEhYKBm51bWJlchgDIAEoBVIGbnVtYmVyEkEKBWxhYmVsGAQgASgOMisuZ29vZ2xlLnByb3RvYnVmLkZpZWxkRGVzY3JpcHRvclByb3RvLkxhYmVsUgVsYWJlbBI+CgR0eXBlGAUgASgOMiouZ29vZ2xlLnByb3RvYnVmLkZpZWxkRGVzY3JpcHRvclByb3RvLlR5cGVSBHR5cGUSGwoJdHlwZV9uYW1lGAYgASgJUgh0eXBlTmFtZRIaCghleHRlbmRlZRgCIAEoCVIIZXh0ZW5kZWUSIwoNZGVmYXVsdF92YWx1ZRgHIAEoCVIMZGVmYXVsdFZhbHVlEh8KC29uZW9mX2luZGV4GAkgASgFUgpvbmVvZkluZGV4EjcKB29wdGlvbnMYCCABKAsyHS5nb29nbGUucHJvdG9idWYuRmllbGRPcHRpb25zUgdvcHRpb25zIrYCCgRUeXBlEg8KC1RZUEVfRE9VQkxFEAESDgoKVFlQRV9GTE9BVBACEg4KClRZUEVfSU5UNjQQAxIPCgtUWVBFX1VJTlQ2NBAEEg4KClRZUEVfSU5UMzIQBRIQCgxUWVBFX0ZJWEVENjQQBhIQCgxUWVBFX0ZJWEVEMzIQBxINCglUWVBFX0JPT0wQCBIPCgtUWVBFX1NUUklORxAJEg4KClRZUEVfR1JPVVAQChIQCgxUWVBFX01FU1NBR0UQCxIOCgpUWVBFX0JZVEVTEAwSDwoLVFlQRV9VSU5UMzIQDRINCglUWVBFX0VOVU0QDhIRCg1UWVBFX1NGSVhFRDMyEA8SEQoNVFlQRV9TRklYRUQ2NBAQEg8KC1RZUEVfU0lOVDMyEBESDwoLVFlQRV9TSU5UNjQQEiJDCgVMYWJlbBISCg5MQUJFTF9PUFRJT05BTBABEhIKDkxBQkVMX1JFUVVJUkVEEAISEgoOTEFCRUxfUkVQRUFURUQQAyIqChRPbmVvZkRlc2NyaXB0b3JQcm90bxISCgRuYW1lGAEgASgJUgRuYW1lIqIBChNFbnVtRGVzY3JpcHRvclByb3RvEhIKBG5hbWUYASABKAlSBG5hbWUSPwoFdmFsdWUYAiADKAsyKS5nb29nbGUucHJvdG9idWYuRW51bVZhbHVlRGVzY3JpcHRvclByb3RvUgV2YWx1ZRI2CgdvcHRpb25zGAMgASgLMhwuZ29vZ2xlLnByb3RvYnVmLkVudW1PcHRpb25zUgdvcHRpb25zIoMBChhFbnVtVmFsdWVEZXNjcmlwdG9yUHJvdG8SEgoEbmFtZRgBIAEoCVIEbmFtZRIWCgZudW1iZXIYAiABKAVSBm51bWJlchI7CgdvcHRpb25zGAMgASgLMiEuZ29vZ2xlLnByb3RvYnVmLkVudW1WYWx1ZU9wdGlvbnNSB29wdGlvbnMipwEKFlNlcnZpY2VEZXNjcmlwdG9yUHJvdG8SEgoEbmFtZRgBIAEoCVIEbmFtZRI+CgZtZXRob2QYAiADKAsyJi5nb29nbGUucHJvdG9idWYuTWV0aG9kRGVzY3JpcHRvclByb3RvUgZtZXRob2QSOQoHb3B0aW9ucxgDIAEoCzIfLmdvb2dsZS5wcm90b2J1Zi5TZXJ2aWNlT3B0aW9uc1IHb3B0aW9ucyKlAQoVTWV0aG9kRGVzY3JpcHRvclByb3RvEhIKBG5hbWUYASABKAlSBG5hbWUSHQoKaW5wdXRfdHlwZRgCIAEoCVIJaW5wdXRUeXBlEh8KC291dHB1dF90eXBlGAMgASgJUgpvdXRwdXRUeXBlEjgKB29wdGlvbnMYBCABKAsyHi5nb29nbGUucHJvdG9idWYuTWV0aG9kT3B0aW9uc1IHb3B0aW9ucyKDBgoLRmlsZU9wdGlvbnMSIQoMamF2YV9wYWNrYWdlGAEgASgJUgtqYXZhUGFja2FnZRIwChRqYXZhX291dGVyX2NsYXNzbmFtZRgIIAEoCVISamF2YU91dGVyQ2xhc3NuYW1lEjUKE2phdmFfbXVsdGlwbGVfZmlsZXMYCiABKAg6BWZhbHNlUhFqYXZhTXVsdGlwbGVGaWxlcxJHCh1qYXZhX2dlbmVyYXRlX2VxdWFsc19hbmRfaGFzaBgUIAEoCDoFZmFsc2VSGWphdmFHZW5lcmF0ZUVxdWFsc0FuZEhhc2gSOgoWamF2YV9zdHJpbmdfY2hlY2tfdXRmOBgbIAEoCDoFZmFsc2VSE2phdmFTdHJpbmdDaGVja1V0ZjgSUwoMb3B0aW1pemVfZm9yGAkgASgOMikuZ29vZ2xlLnByb3RvYnVmLkZpbGVPcHRpb25zLk9wdGltaXplTW9kZToFU1BFRURSC29wdGltaXplRm9yEh0KCmdvX3BhY2thZ2UYCyABKAlSCWdvUGFja2FnZRI1ChNjY19nZW5lcmljX3NlcnZpY2VzGBAgASgIOgVmYWxzZVIRY2NHZW5lcmljU2VydmljZXMSOQoVamF2YV9nZW5lcmljX3NlcnZpY2VzGBEgASgIOgVmYWxzZVITamF2YUdlbmVyaWNTZXJ2aWNlcxI1ChNweV9nZW5lcmljX3NlcnZpY2VzGBIgASgIOgVmYWxzZVIRcHlHZW5lcmljU2VydmljZXMSJQoKZGVwcmVjYXRlZBgXIAEoCDoFZmFsc2VSCmRlcHJlY2F0ZWQSWAoUdW5pbnRlcnByZXRlZF9vcHRpb24Y5wcgAygLMiQuZ29vZ2xlLnByb3RvYnVmLlVuaW50ZXJwcmV0ZWRPcHRpb25SE3VuaW50ZXJwcmV0ZWRPcHRpb24iOgoMT3B0aW1pemVNb2RlEgkKBVNQRUVEEAESDQoJQ09ERV9TSVpFEAISEAoMTElURV9SVU5USU1FEAMqCQjoBxCAgICAAiKoAgoOTWVzc2FnZU9wdGlvbnMSPAoXbWVzc2FnZV9zZXRfd2lyZV9mb3JtYXQYASABKAg6BWZhbHNlUhRtZXNzYWdlU2V0V2lyZUZvcm1hdBJMCh9ub19zdGFuZGFyZF9kZXNjcmlwdG9yX2FjY2Vzc29yGAIgASgIOgVmYWxzZVIcbm9TdGFuZGFyZERlc2NyaXB0b3JBY2Nlc3NvchIlCgpkZXByZWNhdGVkGAMgASgIOgVmYWxzZVIKZGVwcmVjYXRlZBJYChR1bmludGVycHJldGVkX29wdGlvbhjnByADKAsyJC5nb29nbGUucHJvdG9idWYuVW5pbnRlcnByZXRlZE9wdGlvblITdW5pbnRlcnByZXRlZE9wdGlvbioJCOgHEICAgIACIo4DCgxGaWVsZE9wdGlvbnMSQQoFY3R5cGUYASABKA4yIy5nb29nbGUucHJvdG9idWYuRmllbGRPcHRpb25zLkNUeXBlOgZTVFJJTkdSBWN0eXBlEhYKBnBhY2tlZBgCIAEoCFIGcGFja2VkEhkKBGxhenkYBSABKAg6BWZhbHNlUgRsYXp5EiUKCmRlcHJlY2F0ZWQYAyABKAg6BWZhbHNlUgpkZXByZWNhdGVkEjAKFGV4cGVyaW1lbnRhbF9tYXBfa2V5GAkgASgJUhJleHBlcmltZW50YWxNYXBLZXkSGQoEd2VhaxgKIAEoCDoFZmFsc2VSBHdlYWsSWAoUdW5pbnRlcnByZXRlZF9vcHRpb24Y5wcgAygLMiQuZ29vZ2xlLnByb3RvYnVmLlVuaW50ZXJwcmV0ZWRPcHRpb25SE3VuaW50ZXJwcmV0ZWRPcHRpb24iLwoFQ1R5cGUSCgoGU1RSSU5HEAASCAoEQ09SRBABEhAKDFNUUklOR19QSUVDRRACKgkI6AcQgICAgAIiugEKC0VudW1PcHRpb25zEh8KC2FsbG93X2FsaWFzGAIgASgIUgphbGxvd0FsaWFzEiUKCmRlcHJlY2F0ZWQYAyABKAg6BWZhbHNlUgpkZXByZWNhdGVkElgKFHVuaW50ZXJwcmV0ZWRfb3B0aW9uGOcHIAMoCzIkLmdvb2dsZS5wcm90b2J1Zi5VbmludGVycHJldGVkT3B0aW9uUhN1bmludGVycHJldGVkT3B0aW9uKgkI6AcQgICAgAIingEKEEVudW1WYWx1ZU9wdGlvbnMSJQoKZGVwcmVjYXRlZBgBIAEoCDoFZmFsc2VSCmRlcHJlY2F0ZWQSWAoUdW5pbnRlcnByZXRlZF9vcHRpb24Y5wcgAygLMiQuZ29vZ2xlLnByb3RvYnVmLlVuaW50ZXJwcmV0ZWRPcHRpb25SE3VuaW50ZXJwcmV0ZWRPcHRpb24qCQjoBxCAgICAAiKcAQoOU2VydmljZU9wdGlvbnMSJQoKZGVwcmVjYXRlZBghIAEoCDoFZmFsc2VSCmRlcHJlY2F0ZWQSWAoUdW5pbnRlcnByZXRlZF9vcHRpb24Y5wcgAygLMiQuZ29vZ2xlLnByb3RvYnVmLlVuaW50ZXJwcmV0ZWRPcHRpb25SE3VuaW50ZXJwcmV0ZWRPcHRpb24qCQjoBxCAgICAAiKbAQoNTWV0aG9kT3B0aW9ucxIlCgpkZXByZWNhdGVkGCEgASgIOgVmYWxzZVIKZGVwcmVjYXRlZBJYChR1bmludGVycHJldGVkX29wdGlvbhjnByADKAsyJC5nb29nbGUucHJvdG9idWYuVW5pbnRlcnByZXRlZE9wdGlvblITdW5pbnRlcnByZXRlZE9wdGlvbioJCOgHEICAgIACIpoDChNVbmludGVycHJldGVkT3B0aW9uEkEKBG5hbWUYAiADKAsyLS5nb29nbGUucHJvdG9idWYuVW5pbnRlcnByZXRlZE9wdGlvbi5OYW1lUGFydFIEbmFtZRIpChBpZGVudGlmaWVyX3ZhbHVlGAMgASgJUg9pZGVudGlmaWVyVmFsdWUSLAoScG9zaXRpdmVfaW50X3ZhbHVlGAQgASgEUhBwb3NpdGl2ZUludFZhbHVlEiwKEm5lZ2F0aXZlX2ludF92YWx1ZRgFIAEoA1IQbmVnYXRpdmVJbnRWYWx1ZRIhCgxkb3VibGVfdmFsdWUYBiABKAFSC2RvdWJsZVZhbHVlEiEKDHN0cmluZ192YWx1ZRgHIAEoDFILc3RyaW5nVmFsdWUSJwoPYWdncmVnYXRlX3ZhbHVlGAggASgJUg5hZ2dyZWdhdGVWYWx1ZRpKCghOYW1lUGFydBIbCgluYW1lX3BhcnQYASACKAlSCG5hbWVQYXJ0EiEKDGlzX2V4dGVuc2lvbhgCIAIoCFILaXNFeHRlbnNpb24i6wEKDlNvdXJjZUNvZGVJbmZvEkQKCGxvY2F0aW9uGAEgAygLMiguZ29vZ2xlLnByb3RvYnVmLlNvdXJjZUNvZGVJbmZvLkxvY2F0aW9uUghsb2NhdGlvbhqSAQoITG9jYXRpb24SFgoEcGF0aBgBIAMoBUICEAFSBHBhdGgSFgoEc3BhbhgCIAMoBUICEAFSBHNwYW4SKQoQbGVhZGluZ19jb21tZW50cxgDIAEoCVIPbGVhZGluZ0NvbW1lbnRzEisKEXRyYWlsaW5nX2NvbW1lbnRzGAQgASgJUhB0cmFpbGluZ0NvbW1lbnRzQikKE2NvbS5nb29nbGUucHJvdG9idWZCEERlc2NyaXB0b3JQcm90b3NIAUro+QEKBxIFJgCuBQEKqg8KAQwSAyYAEjLBDCBQcm90b2NvbCBCdWZmZXJzIC0gR29vZ2xlJ3MgZGF0YSBpbnRlcmNoYW5nZSBmb3JtYXQKIENvcHlyaWdodCAyMDA4IEdvb2dsZSBJbmMuICBBbGwgcmlnaHRzIHJlc2VydmVkLgogaHR0cHM6Ly9kZXZlbG9wZXJzLmdvb2dsZS5jb20vcHJvdG9jb2wtYnVmZmVycy8KCiBSZWRpc3RyaWJ1dGlvbiBhbmQgdXNlIGluIHNvdXJjZSBhbmQgYmluYXJ5IGZvcm1zLCB3aXRoIG9yIHdpdGhvdXQKIG1vZGlmaWNhdGlvbiwgYXJlIHBlcm1pdHRlZCBwcm92aWRlZCB0aGF0IHRoZSBmb2xsb3dpbmcgY29uZGl0aW9ucyBhcmUKIG1ldDoKCiAgICAgKiBSZWRpc3RyaWJ1dGlvbnMgb2Ygc291cmNlIGNvZGUgbXVzdCByZXRhaW4gdGhlIGFib3ZlIGNvcHlyaWdodAogbm90aWNlLCB0aGlzIGxpc3Qgb2YgY29uZGl0aW9ucyBhbmQgdGhlIGZvbGxvd2luZyBkaXNjbGFpbWVyLgogICAgICogUmVkaXN0cmlidXRpb25zIGluIGJpbmFyeSBmb3JtIG11c3QgcmVwcm9kdWNlIHRoZSBhYm92ZQogY29weXJpZ2h0IG5vdGljZSwgdGhpcyBsaXN0IG9mIGNvbmRpdGlvbnMgYW5kIHRoZSBmb2xsb3dpbmcgZGlzY2xhaW1lcgogaW4gdGhlIGRvY3VtZW50YXRpb24gYW5kL29yIG90aGVyIG1hdGVyaWFscyBwcm92aWRlZCB3aXRoIHRoZQogZGlzdHJpYnV0aW9uLgogICAgICogTmVpdGhlciB0aGUgbmFtZSBvZiBHb29nbGUgSW5jLiBub3IgdGhlIG5hbWVzIG9mIGl0cwogY29udHJpYnV0b3JzIG1heSBiZSB1c2VkIHRvIGVuZG9yc2Ugb3IgcHJvbW90ZSBwcm9kdWN0cyBkZXJpdmVkIGZyb20KIHRoaXMgc29mdHdhcmUgd2l0aG91dCBzcGVjaWZpYyBwcmlvciB3cml0dGVuIHBlcm1pc3Npb24uCgogVEhJUyBTT0ZUV0FSRSBJUyBQUk9WSURFRCBCWSBUSEUgQ09QWVJJR0hUIEhPTERFUlMgQU5EIENPTlRSSUJVVE9SUwogIkFTIElTIiBBTkQgQU5ZIEVYUFJFU1MgT1IgSU1QTElFRCBXQVJSQU5USUVTLCBJTkNMVURJTkcsIEJVVCBOT1QKIExJTUlURUQgVE8sIFRIRSBJTVBMSUVEIFdBUlJBTlRJRVMgT0YgTUVSQ0hBTlRBQklMSVRZIEFORCBGSVRORVNTIEZPUgogQSBQQVJUSUNVTEFSIFBVUlBPU0UgQVJFIERJU0NMQUlNRUQuIElOIE5PIEVWRU5UIFNIQUxMIFRIRSBDT1BZUklHSFQKIE9XTkVSIE9SIENPTlRSSUJVVE9SUyBCRSBMSUFCTEUgRk9SIEFOWSBESVJFQ1QsIElORElSRUNULCBJTkNJREVOVEFMLAogU1BFQ0lBTCwgRVhFTVBMQVJZLCBPUiBDT05TRVFVRU5USUFMIERBTUFHRVMgKElOQ0xVRElORywgQlVUIE5PVAogTElNSVRFRCBUTywgUFJPQ1VSRU1FTlQgT0YgU1VCU1RJVFVURSBHT09EUyBPUiBTRVJWSUNFUzsgTE9TUyBPRiBVU0UsCiBEQVRBLCBPUiBQUk9GSVRTOyBPUiBCVVNJTkVTUyBJTlRFUlJVUFRJT04pIEhPV0VWRVIgQ0FVU0VEIEFORCBPTiBBTlkKIFRIRU9SWSBPRiBMSUFCSUxJVFksIFdIRVRIRVIgSU4gQ09OVFJBQ1QsIFNUUklDVCBMSUFCSUxJVFksIE9SIFRPUlQKIChJTkNMVURJTkcgTkVHTElHRU5DRSBPUiBPVEhFUldJU0UpIEFSSVNJTkcgSU4gQU5ZIFdBWSBPVVQgT0YgVEhFIFVTRQogT0YgVEhJUyBTT0ZUV0FSRSwgRVZFTiBJ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PT09PT09PT09PQogT3B0aW9ucwoyzQ0gRWFjaCBvZiB0aGUgZGVmaW5pdGlvbnMgYWJvdmUgbWF5IGhhdmUgIm9wdGlvbnMiIGF0dGFjaGVkLiAgVGhlc2UgYXJlCiBqdXN0IGFubm90YXRpb25zIHdoaWNoIG1heSBjYXVzZSBjb2RlIHRvIGJlIGdlbmVyYXRlZCBzbGlnaHRseSBkaWZmZXJlbnRseQogb3IgbWF5IGNvbnRhaW4gaGludHMgZm9yIGNvZGUgdGhhdCBtYW5pcHVsYXRlcyBwcm90b2NvbCBtZXNzYWdlcy4KCiBDbGllbnRzIG1heSBkZWZpbmUgY3VzdG9tIG9wdGlvbnMgYXMgZXh0ZW5zaW9ucyBvZiB0aGUgKk9wdGlvbnMgbWVzc2FnZXMuCiBUaGVzZSBleHRlbnNpb25zIG1heSBub3QgeWV0IGJlIGtub3duIGF0IHBhcnNpbmcgdGltZSwgc28gdGhlIHBhcnNlciBjYW5ub3QKIHN0b3JlIHRoZSB2YWx1ZXMgaW4gdGhlbS4gIEluc3RlYWQgaXQgc3RvcmVzIHRoZW0gaW4gYSBmaWVsZCBpbiB0aGUgKk9wdGlvbnMKIG1lc3NhZ2UgY2FsbGVkIHVuaW50ZXJwcmV0ZWRfb3B0aW9uLiBUaGlzIGZpZWxkIG11c3QgaGF2ZSB0aGUgc2FtZSBuYW1lCiBhY3Jvc3MgYWxsICpPcHRpb25zIG1lc3NhZ2VzLiBXZSB0aGVuIHVzZSB0aGlzIGZpZWxkIHRvIHBvcHVsYXRlIHRoZQogZXh0ZW5zaW9ucyB3aGVuIHdlIGJ1aWxkIGEgZGVzY3JpcHRvciwgYXQgd2hpY2ggcG9pbnQgYWxsIHByb3RvcyBoYXZlIGJlZW4KIHBhcnNlZCBhbmQgc28gYWxsIGV4dGVuc2lvbnMgYXJlIGtub3duLgoKIEV4dGVuc2lvbiBudW1iZXJzIGZvciBjdXN0b20gb3B0aW9ucyBtYXkgYmUgY2hvc2VuIGFzIGZvbGxvd3M6CiAqIEZvciBvcHRpb25zIHdoaWNoIHdpbGwgb25seSBiZSB1c2VkIHdpdGhpbiBhIHNpbmdsZSBhcHBsaWNhdGlvbiBvcgogICBvcmdhbml6YXRpb24sIG9yIGZvciBleHBlcmltZW50YWwgb3B0aW9ucywgdXNlIGZpZWxkIG51bWJlcnMgNTAwMDAKICAgdGhyb3VnaCA5OTk5OS4gIEl0IGlzIHVwIHRvIHlvdSB0byBlbnN1cmUgdGhhdCB5b3UgZG8gbm90IHVzZSB0aGUKICAgc2FtZSBudW1iZXIgZm9yIG11bHRpcGxlIG9wdGlvbnMuCiAqIEZvciBvcHRpb25zIHdoaWNoIHdpbGwgYmUgcHVibGlzaGVkIGFuZCB1c2VkIHB1YmxpY2x5IGJ5IG11bHRpcGxlCiAgIGluZGVwZW5kZW50IGVudGl0aWVzLCBlLW1haWwgcHJvdG9idWYtZ2xvYmFsLWV4dGVuc2lvbi1yZWdpc3RyeUBnb29nbGUuY29tCiAgIHRvIHJlc2VydmUgZXh0ZW5zaW9uIG51bWJlcnMuIFNpbXBseSBwcm92aWRlIHlvdXIgcHJvamVjdCBuYW1lIChlLmcuCiAgIE9iamVjdC1DIHBsdWdpbikgYW5kIHlvdXIgcG9yamVjdCB3ZWJzaXRlIChpZiBhdmFpbGFibGUpIC0tIHRoZXJlJ3Mgbm8gbmVlZAogICB0byBleHBsYWluIGhvdyB5b3UgaW50ZW5kIHRvIHVzZSB0aGVtLiBVc3VhbGx5IHlvdSBvbmx5IG5lZWQgb25lIGV4dGVuc2lvbgogICBudW1iZXIuIFlvdSBjYW4gZGVjbGFyZSBtdWx0aXBsZSBvcHRpb25zIHdpdGggb25seSBvbmUgZXh0ZW5zaW9uIG51bWJlciBieQogICBwdXR0aW5nIHRoZW0gaW4gYSBzdWItbWVzc2FnZS4gU2VlIHRoZSBDdXN0b20gT3B0aW9ucyBzZWN0aW9uIG9mIHRoZSBkb2NzCiAgIGZvciBleGFtcGxlczoKICAgaHR0cHM6Ly9kZXZlbG9wZXJzLmdvb2dsZS5jb20vcHJvdG9jb2wtYnVmZmVycy9kb2NzL3Byb3RvI29wdGlvbnMKICAgSWYgdGhpcyB0dXJucyBvdXQgdG8gYmUgcG9wdWxhciwgYSB3ZWIgc2VydmljZSB3aWxsIGJlIHNldCB1cAogICB0byBhdXRvbWF0aWNhbGx5IGFzc2lnbiBvcHRpb24gbnVtYmVycy4KCgsKAwQJARIE/QEIEwr0AQoEBAkCABIEgwICIxrlASBTZXRzIHRoZSBKYXZhIHBhY2thZ2Ugd2hlcmUgY2xhc3NlcyBnZW5lcmF0ZWQgZnJvbSB0aGlzIC5wcm90byB3aWxsIGJlCiBwbGFjZWQuICBCeSBkZWZhdWx0LCB0aGUgcHJvdG8gcGFja2FnZSBpcyB1c2VkLCBidXQgdGhpcyBpcyBvZnRlbgogaW5hcHByb3ByaWF0ZSBiZWNhdXNlIHByb3RvIHBhY2thZ2VzIGRvIG5vdCBub3JtYWxseSBzdGFydCB3aXRoIGJhY2t3YXJkcwogZG9tYWluIG5hbWVzLgoKDQoFBAkCAAQSBIMCAgoKDQoFBAkCAAUSBIMCCxEKDQoFBAkCAAESBIMCEh4KDQoFBAkCAAMSBIMCISIKvwIKBAQJAgESBIsCAisasAIgSWYgc2V0LCBhbGwgdGhlIGNsYXNzZXMgZnJvbSB0aGUgLnByb3RvIGZpbGUgYXJlIHdyYXBwZWQgaW4gYSBzaW5nbGUKIG91dGVyIGNsYXNzIHdpdGggdGhlIGdpdmVuIG5hbWUuICBUaGlzIGFwcGxpZXMgdG8gYm90aCBQcm90bzEKIChlcXVpdmFsZW50IHRvIHRoZSBvbGQgIi0tb25lX2phdmFfZmlsZSIgb3B0aW9uKSBhbmQgUHJvdG8yICh3aGVyZQogYSAucHJvdG8gYWx3YXlzIHRyYW5zbGF0ZXMgdG8gYSBzaW5nbGUgY2xhc3MsIGJ1dCB5b3UgbWF5IHdhbnQgdG8KIGV4cGxpY2l0bHkgY2hvb3NlIHRoZSBjbGFzcyBuYW1lKS4KCg0KBQQJAgEEEgSLAgIKCg0KBQQJAgEFEgSLAgsRCg0KBQQJAgEBEgSLAhImCg0KBQQJAgEDEgSLAikqCqMDCgQECQICEgSTAgI5GpQDIElmIHNldCB0cnVlLCB0aGVuIHRoZSBKYXZhIGNvZGUgZ2VuZXJhdG9yIHdpbGwgZ2VuZXJhdGUgYSBzZXBhcmF0ZSAuamF2YQogZmlsZSBmb3IgZWFjaCB0b3AtbGV2ZWwgbWVzc2FnZSwgZW51bSwgYW5kIHNlcnZpY2UgZGVmaW5lZCBpbiB0aGUgLnByb3RvCiBmaWxlLiAgVGh1cywgdGhlc2UgdHlwZXMgd2lsbCAqbm90KiBiZSBuZXN0ZWQgaW5zaWRlIHRoZSBvdXRlciBjbGFzcwogbmFtZWQgYnkgamF2YV9vdXRlcl9jbGFzc25hbWUuICBIb3dldmVyLCB0aGUgb3V0ZXIgY2xhc3Mgd2lsbCBzdGlsbCBiZQogZ2VuZXJhdGVkIHRvIGNvbnRhaW4gdGhlIGZpbGUncyBnZXREZXNjcmlwdG9yKCkgbWV0aG9kIGFzIHdlbGwgYXMgYW55CiB0b3AtbGV2ZWwgZXh0ZW5zaW9ucyBkZWZpbmVkIGluIHRoZSBmaWxlLgoKDQoFBAkCAgQSBJMCAgoKDQoFBAkCAgUSBJMCCw8KDQoFBAkCAgESBJMCECMKDQoFBAkCAgMSBJMCJigKDQoFBAkCAggSBJMCKTgKDQoFBAkCAgcSBJMCMjcKnwUKBAQJAgMSBJ8CAkMakAUgSWYgc2V0IHRydWUsIHRoZW4gdGhlIEphdmEgY29kZSBnZW5lcmF0b3Igd2lsbCBnZW5lcmF0ZSBlcXVhbHMoKSBhbmQKIGhhc2hDb2RlKCkgbWV0aG9kcyBmb3IgYWxsIG1lc3NhZ2VzIGRlZmluZWQgaW4gdGhlIC5wcm90byBmaWxlLgogLSBJbiB0aGUgZnVsbCBydW50aW1lLCB0aGlzIGlzIHB1cmVseSBhIHNwZWVkIG9wdGltaXphdGlvbiwgYXMgdGhlCiBBYnN0cmFjdE1lc3NhZ2UgYmFzZSBjbGFzcyBpbmNsdWRlcyByZWZsZWN0aW9uLWJhc2VkIGltcGxlbWVudGF0aW9ucyBvZgogdGhlc2UgbWV0aG9kcy4KLSBJbiB0aGUgbGl0ZSBydW50aW1lLCBzZXR0aW5nIHRoaXMgb3B0aW9uIGNoYW5nZXMgdGhlIHNlbWFudGljcyBvZgogZXF1YWxzKCkgYW5kIGhhc2hDb2RlKCkgdG8gbW9yZSBjbG9zZWx5IG1hdGNoIHRob3NlIG9mIHRoZSBmdWxsIHJ1bnRpbWU7CiB0aGUgZ2VuZXJhdGVkIG1ldGhvZHMgY29tcHV0ZSB0aGVpciByZXN1bHRzIGJhc2VkIG9uIGZpZWxkIHZhbHVlcyByYXRoZXIKIHRoYW4gb2JqZWN0IGlkZW50aXR5LiAoSW1wbGVtZW50YXRpb25zIHNob3VsZCBub3QgYXNzdW1lIHRoYXQgaGFzaGNvZGVzCiB3aWxsIGJlIGNvbnNpc3RlbnQgYWNyb3NzIHJ1bnRpbWVzIG9yIHZlcnNpb25zIG9mIHRoZSBwcm90b2NvbCBjb21waWxlci4pCgoNCgUECQIDBBIEnwICCgoNCgUECQIDBRIEnwILDwoNCgUECQIDARIEnwIQLQoNCgUECQIDAxIEnwIwMgoNCgUECQIDCBIEnwIzQgoNCgUECQIDBxIEnwI8QQrmAgoEBAkCBBIEpwICPBrXAiBJZiBzZXQgdHJ1ZSwgdGhlbiB0aGUgSmF2YTIgY29kZSBnZW5lcmF0b3Igd2lsbCBnZW5lcmF0ZSBjb2RlIHRoYXQKIHRocm93cyBhbiBleGNlcHRpb24gd2hlbmV2ZXIgYW4gYXR0ZW1wdCBpcyBtYWRlIHRvIGFzc2lnbiBhIG5vbi1VVEYtOAogYnl0ZSBzZXF1ZW5jZSB0byBhIHN0cmluZyBmaWVsZC4KIE1lc3NhZ2UgcmVmbGVjdGlvbiB3aWxsIGRvIHRoZSBzYW1lLgogSG93ZXZlciwgYW4gZXh0ZW5zaW9uIGZpZWxkIHN0aWxsIGFjY2VwdHMgbm9uLVVURi04IGJ5dGUgc2VxdWVuY2VzLgogVGhpcyBvcHRpb24gaGFzIG5vIGVmZmVjdCBvbiB3aGVuIHVzZWQgd2l0aCB0aGUgbGl0ZSBydW50aW1lLgoKDQoFBAkCBAQSBKcCAgoKDQoFBAkCBAUSBKcCCw8KDQoFBAkCBAESBKcCECYKDQoFBAkCBAMSBKcCKSsKDQoFBAkCBAgSBKcCLDsKDQoFBAkCBAcSBKcCNToKTAoEBAkEABIGqwICsAIDGjwgR2VuZXJhdGVkIGNsYXNzZXMgY2FuIGJlIG9wdGltaXplZCBmb3Igc3BlZWQgb3IgY29kZSBzaXplLgoKDQoFBAkEAAESBKsCBxMKRAoGBAkEAAIAEgSsAgQOIjQgR2VuZXJhdGUgY29tcGxldGUgY29kZSBmb3IgcGFyc2luZywgc2VyaWFsaXphdGlvbiwKCg8KBwQJBAACAAESBKwCBAkKDwoHBAkEAAIAAhIErAIMDQpHCgYECQQAAgESBK4CBBIaBiBldGMuCiIvIFVzZSBSZWZsZWN0aW9uT3BzIHRvIGltcGxlbWVudCB0aGVzZSBtZXRob2RzLgoKDwoHBAkEAAIBARIErgIEDQoPCgcECQQAAgECEgSuAhARCkcKBgQJBAACAhIErwIEFSI3IEdlbmVyYXRlIGNvZGUgdXNpbmcgTWVzc2FnZUxpdGUgYW5kIHRoZSBsaXRlIHJ1bnRpbWUuCgoPCgcECQQAAgIBEgSvAgQQCg8KBwQJBAACAgISBK8CExQKDAoEBAkCBRIEsQICOQoNCgUECQIFBBIEsQICCgoNCgUECQIFBhIEsQILFwoNCgUECQIFARIEsQIYJAoNCgUECQIFAxIEsQInKAoNCgUECQIFCBIEsQIpOAoNCgUECQIFBxIEsQIyNwpzCgQECQIGEgS1AgIiGmUgU2V0cyB0aGUgR28gcGFja2FnZSB3aGVyZSBzdHJ1Y3RzIGdlbmVyYXRlZCBmcm9tIHRoaXMgLnByb3RvIHdpbGwgYmUKIHBsYWNlZC4gIFRoZXJlIGlzIG5vIGRlZmF1bHQuCgoNCgUECQIGBBIEtQICCgoNCgUECQIGBRIEtQILEQoNCgUECQIGARIEtQISHAoNCgUECQIGAxIEtQIfIQrLBAoEBAkCBxIEwwICORq8BCBTaG91bGQgZ2VuZXJpYyBzZXJ2aWNlcyBiZSBnZW5lcmF0ZWQgaW4gZWFjaCBsYW5ndWFnZT8gICJHZW5lcmljIiBzZXJ2aWNlcwogYXJlIG5vdCBzcGVjaWZpYyB0byBhbnkgcGFydGljdWxhciBSUEMgc3lzdGVtLiAgVGhleSBhcmUgZ2VuZXJhdGVkIGJ5IHRoZQogbWFpbiBjb2RlIGdlbmVyYXRvcnMgaW4gZWFjaCBsYW5ndWFnZSAod2l0aG91dCBhZGRpdGlvbmFsIHBsdWdpbnMpLgogR2VuZXJpYyBzZXJ2aWNlcyB3ZXJlIHRoZSBvbmx5IGtpbmQgb2Ygc2VydmljZSBnZW5lcmF0aW9uIHN1cHBvcnRlZCBieQogZWFybHkgdmVyc2lvbnMgb2YgcHJvdG8yLgoKIEdlbmVyaWMgc2VydmljZXMgYXJlIG5vdyBjb25zaWRlcmVkIGRlcHJlY2F0ZWQgaW4gZmF2b3Igb2YgdXNpbmcgcGx1Z2lucwogdGhhdCBnZW5lcmF0ZSBjb2RlIHNwZWNpZmljIHRvIHlvdXIgcGFydGljdWxhciBSUEMgc3lzdGVtLiAgVGhlcmVmb3JlLAogdGhlc2UgZGVmYXVsdCB0byBmYWxzZS4gIE9sZCBjb2RlIHdoaWNoIGRlcGVuZHMgb24gZ2VuZXJpYyBzZXJ2aWNlcyBzaG91bGQKIGV4cGxpY2l0bHkgc2V0IHRoZW0gdG8gdHJ1ZS4KCg0KBQQJAgcEEgTDAgIKCg0KBQQJAgcFEgTDAgsPCg0KBQQJAgcBEgTDAhAjCg0KBQQJAgcDEgTDAiYoCg0KBQQJAgcIEgTDAik4Cg0KBQQJAgcHEgTDAjI3CgwKBAQJAggSBMQCAjsKDQoFBAkCCAQSBMQCAgoKDQoFBAkCCAUSBMQCCw8KDQoFBAkCCAESBMQCECUKDQoFBAkCCAMSBMQCKCoKDQoFBAkCCAgSBMQCKzoKDQoFBAkCCAcSBMQCNDkKDAoEBAkCCRIExQICOQoNCgUECQIJBBIExQICCgoNCgUECQIJBRIExQILDwoNCgUECQIJARIExQIQIwoNCgUECQIJAxIExQImKAoNCgUECQIJCBIExQIpOAoNCgUECQIJBxIExQIyNwrzAQoEBAkCChIEywICMBrkASBJcyB0aGlzIGZpbGUgZGVwcmVjYXRlZD8KIERlcGVuZGluZyBvbiB0aGUgdGFyZ2V0IHBsYXRmb3JtLCB0aGlzIGNhbiBlbWl0IERlcHJlY2F0ZWQgYW5ub3RhdGlvbnMKIGZvciBldmVyeXRoaW5nIGluIHRoZSBmaWxlLCBvciBpdCB3aWxsIGJlIGNvbXBsZXRlbHkgaWdub3JlZDsgaW4gdGhlIHZlcnkKIGxlYXN0LCB0aGlzIGlzIGEgZm9ybWFsaXphdGlvbiBmb3IgZGVwcmVjYXRpbmcgZmlsZXMuCgoNCgUECQIKBBIEywICCgoNCgUECQIKBRIEywILDwoNCgUECQIKARIEywIQGgoNCgUECQIKAxIEywIdHwoNCgUECQIKCBIEywIgLwoNCgUECQIKBxIEywIpLgpPCgQECQILEgTPAgI6GkEgVGhlIHBhcnNlciBzdG9yZXMgb3B0aW9ucyBpdCBkb2Vzbid0IHJlY29nbml6ZSBoZXJlLiBTZWUgYWJvdmUuCgoNCgUECQILBBIEzwICCgoNCgUECQILBhIEzwILHgoNCgUECQILARIEzwIfMwoNCgUECQILAxIEzwI2OQpaCgMECQUSBNICAhkaTSBDbGllbnRzIGNhbiBkZWZpbmUgY3VzdG9tIG9wdGlvbnMgaW4gZXh0ZW5zaW9ucyBvZiB0aGlzIG1lc3NhZ2UuIFNlZSBhYm92ZS4KCgwKBAQJBQASBNICDRgKDQoFBAkFAAESBNICDREKDQoFBAkFAAISBNICFRgKDAoCBAoSBtUCAPoCAQoLCgMECgESBNUCCBYK2AUKBAQKAgASBOgCAjwayQUgU2V0IHRydWUgdG8gdXNlIHRoZSBvbGQgcHJvdG8xIE1lc3NhZ2VTZXQgd2lyZSBmb3JtYXQgZm9yIGV4dGVuc2lvbnMuCiBUaGlzIGlzIHByb3ZpZGVkIGZvciBiYWNrd2FyZHMtY29tcGF0aWJpbGl0eSB3aXRoIHRoZSBNZXNzYWdlU2V0IHdpcmUKIGZvcm1hdC4gIFlvdSBzaG91bGQgbm90IHVzZSB0aGlzIGZvciBhbnkgb3RoZXIgcmVhc29uOiAgSXQncyBsZXNzCiBlZmZpY2llbnQsIGhhcyBmZXdlciBmZWF0dXJlcywgYW5kIGlzIG1vcmUgY29tcGxpY2F0ZWQuCgogVGhlIG1lc3NhZ2UgbXVzdCBiZSBkZWZpbmVkIGV4YWN0bHkgYXMgZm9sbG93czoKICAgbWVzc2FnZSBGb28gewogICAgIG9wdGlvbiBtZXNzYWdlX3NldF93aXJlX2Zvcm1hdCA9IHRydWU7CiAgICAgZXh0ZW5zaW9ucyA0IHRvIG1heDsKICAgfQogTm90ZSB0aGF0IHRoZSBtZXNzYWdlIGNhbm5vdCBoYXZlIGFueSBkZWZpbmVkIGZpZWxkczsgTWVzc2FnZVNldHMgb25seQogaGF2ZSBleHRlbnNpb25zLgoKIEFsbCBleHRlbnNpb25zIG9mIHlvdXIgdHlwZSBtdXN0IGJlIHNpbmd1bGFyIG1lc3NhZ2VzOyBlLmcuIHRoZXkgY2Fubm90CiBiZSBpbnQzMnMsIGVudW1zLCBvciByZXBlYXRlZCBtZXNzYWdlcy4KCiBCZWNhdXNlIHRoaXMgaXMgYW4gb3B0aW9uLCB0aGUgYWJvdmUgdHdvIHJlc3RyaWN0aW9ucyBhcmUgbm90IGVuZm9yY2VkIGJ5CiB0aGUgcHJvdG9jb2wgY29tcGlsZXIuCgoNCgUECgIABBIE6AICCgoNCgUECgIABRIE6AILDwoNCgUECgIAARIE6AIQJwoNCgUECgIAAxIE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IGlzIGVuY29kZWQgYXMKIGEgc2luZ2xlIGxlbmd0aC1kZWxpbWl0ZWQgYmxvYi4KCg0KBQQLAgEEEgSOAwIKCg0KBQQLAgEFEgSOAwsPCg0KBQQLAgEBEgSOAxAWCg0KBQQLAgEDEgSOAxkaCvAMCgQECwICEgSuAwIpGuEMIFNob3VsZCB0aGlzIGZpZWxkIGJlIHBhcnNlZCBsYXppbHk/ICBMYXp5IGFwcGxpZXMgb25seSB0byBtZXNzYWdlLXR5cGUKIGZpZWxkcy4gIEl0IG1lYW5zIHRoYXQgd2hlbiB0aGUgb3V0ZXIgbWVzc2FnZSBpcyBpbml0aWFsbHkgcGFyc2VkLCB0aGUKIGlubmVyIG1lc3NhZ2UncyBjb250ZW50cyB3aWxsIG5vdCBiZSBwYXJzZWQgYnV0IGluc3RlYWQgc3RvcmVkIGluIGVuY29kZWQKIGZvcm0uICBUaGUgaW5uZXIgbWVzc2FnZSB3aWxsIGFjdHVhbGx5IGJlIHBhcnNlZCB3aGVuIGl0IGlzIGZpcnN0IGFjY2Vzc2VkLgoKIFRoaXMgaXMgb25seSBhIGhpbnQuICBJbXBsZW1lbnRhdGlvbnMgYXJlIGZyZWUgdG8gY2hvb3NlIHdoZXRoZXIgdG8gdXNlCiBlYWdlciBvciBsYXp5IHBhcnNpbmcgcmVnYXJkbGVzcyBvZiB0aGUgdmFsdWUgb2YgdGhpcyBvcHRpb24uICBIb3dldmVyLAogc2V0dGluZyB0aGlzIG9wdGlvbiB0cnVlIHN1Z2dlc3RzIHRoYXQgdGhlIHByb3RvY29sIGF1dGhvciBiZWxpZXZlcyB0aGF0CiB1c2luZyBsYXp5IHBhcnNpbmcgb24gdGhpcyBmaWVsZCBpcyB3b3J0aCB0aGUgYWRkaXRpb25hbCBib29ra2VlcGluZwogb3ZlcmhlYWQgdHlwaWNhbGx5IG5lZWRlZCB0byBpbXBsZW1lbnQgaXQuCgogVGhpcyBvcHRpb24gZG9lcyBub3QgYWZmZWN0IHRoZSBwdWJsaWMgaW50ZXJmYWNlIG9mIGFueSBnZW5lcmF0ZWQgY29kZTsKIGFsbCBtZXRob2Qgc2lnbmF0dXJlcyByZW1haW4gdGhlIHNhbWUuICBGdXJ0aGVybW9yZSwgdGhyZWFkLXNhZmV0eSBvZiB0aGUKIGludGVyZmFjZSBpcyBub3QgYWZmZWN0ZWQgYnkgdGhpcyBvcHRpb247IGNvbnN0IG1ldGhvZHMgcmVtYWluIHNhZmUgdG8KIGNhbGwgZnJvbSBtdWx0aXBsZSB0aHJlYWRzIGNvbmN1cnJlbnRseSwgd2hpbGUgbm9uLWNvbnN0IG1ldGhvZHMgY29udGludWUKIHRvIHJlcXVpcmUgZXhjbHVzaXZlIGFjY2Vzcy4KCgogTm90ZSB0aGF0IGltcGxlbWVudGF0aW9ucyBtYXkgY2hvb3NlIG5vdCB0byBjaGVjayByZXF1aXJlZCBmaWVsZHMgd2l0aGluCiBhIGxhenkgc3ViLW1lc3NhZ2UuICBUaGF0IGlzLCBjYWxsaW5nIElzSW5pdGlhbGl6ZWQoKSBvbiB0aGUgb3V0aGVyIG1lc3NhZ2UKIG1heSByZXR1cm4gdHJ1ZSBldmVuIGlmIHRoZSBpbm5lciBtZXNzYWdlIGhhcyBtaXNzaW5nIHJlcXVpcmVkIGZpZWxkcy4KIFRoaXMgaXMgbmVjZXNzYXJ5IGJlY2F1c2Ugb3RoZXJ3aXNlIHRoZSBpbm5lciBtZXNzYWdlIHdvdWxkIGhhdmUgdG8gYmUKIHBhcnNlZCBpbiBvcmRlciB0byBwZXJmb3JtIHRoZSBjaGVjaywgZGVmZWF0aW5nIHRoZSBwdXJwb3NlIG9mIGxhenkKIHBhcnNpbmcuICBBbiBpbXBsZW1lbnRhdGlvbiB3aGljaCBjaG9vc2VzIG5vdCB0byBjaGVjayByZXF1aXJlZCBmaWVsZHMKIG11c3QgYmUgY29uc2lzdGVudCBhYm91dCBpdC4gIFRoYXQgaXMsIGZvciBhbnkgcGFydGljdWxhciBzdWItbWVzc2FnZSwgdGhlCiBpbXBsZW1lbnRhdGlvbiBtdXN0IGVpdGhlciAqYWx3YXlzKiBjaGVjayBpdHMgcmVxdWlyZWQgZmllbGRzLCBvciAqbmV2ZXIqCiBjaGVjayBpdHMgcmVxdWlyZWQgZmllbGRzLCByZWdhcmRsZXNzIG9mIHdoZXRoZXIgb3Igbm90IHRoZSBtZXNzYWdlIGhhcwogYmVlbiBwYXJzZWQuCgoNCgUECwICBBIErgMCCgoNCgUECwICBRIErgMLDwoNCgUECwICARIE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BJYEFRgKiwMKAgQQEgagBAC0BAEa/AIgQSBtZXNzYWdlIHJlcHJlc2VudGluZyBhIG9wdGlvbiB0aGUgcGFyc2VyIGRvZXMgbm90IHJlY29nbml6ZS4gVGhpcyBvbmx5CiBhcHBlYXJzIGluIG9wdGlvbnMgcHJvdG9zIGNyZWF0ZWQgYnkgdGhlIGNvbXBpbGVyOjpQYXJzZXIgY2xhc3MuCiBEZXNjcmlwdG9yUG9vbCByZXNvbHZlcyB0aGVzZSB3aGVuIGJ1aWxkaW5nIERlc2NyaXB0b3Igb2JqZWN0cy4gVGhlcmVmb3JlLAogb3B0aW9ucyBwcm90b3MgaW4gZGVzY3JpcHRvciBvYmplY3RzIChlLmcuIHJldHVybmVkIGJ5IERlc2NyaXB0b3I6Om9wdGlvbnMoKSwKIG9yIHByb2R1Y2VkIGJ5IERlc2NyaXB0b3I6OkNvcHlUbygpKSB3aWxsIG5ldmVyIGhhdmUgVW5pbnRlcnByZXRlZE9wdGlvbnMKIGluIHRoZW0uCgoLCgMEEAESBKAECBsKywIKBAQQAwASBqYEAqkEAxq6AiBUaGUgbmFtZSBvZiB0aGUgdW5pbnRlcnByZXRlZCBvcHRpb24uICBFYWNoIHN0cmluZyByZXByZXNlbnRzIGEgc2VnbWVudCBpbgogYSBkb3Qtc2VwYXJhdGVkIG5hbWUuICBpc19leHRlbnNpb24gaXMgdHJ1ZSBpZmYgYSBzZWdtZW50IHJlcHJlc2VudHMgYW4KIGV4dGVuc2lvbiAoZGVub3RlZCB3aXRoIHBhcmVudGhlc2VzIGluIG9wdGlvbnMgc3BlY3MgaW4gLnByb3RvIGZpbGVzKS4KIEUuZy4seyBbImZvbyIsIGZhbHNlXSwgWyJiYXIuYmF6IiwgdHJ1ZV0sIFsicXV4IiwgZmFsc2VdIH0gcmVwcmVzZW50cwogImZvby4oYmFyLmJheikucXV4Ii4KCg0KBQQQAwABEgSmBAoSCg4KBgQQAwACABIEpwQEIgoPCgcEEAMAAgAEEgSnBAQMCg8KBwQQAwACAAUSBKcEDRMKDwoHBBADAAIAARIEpwQUHQoPCgcEEAMAAgADEgSnBCAhCg4KBgQQAwACARIEqAQEIwoPCgcEEAMAAgEEEgSoBAQMCg8KBwQQAwACAQUSBKgEDREKDwoHBBADAAIBARIEqAQSHgoPCgcEEAMAAgEDEgSoBCEiCgwKBAQQAgASBKoEAh0KDQoFBBACAAQSBKoEAgoKDQoFBBACAAYSBKoECxMKDQoFBBACAAESBKoEFBgKDQoFBBACAAMSBKoEGxwKnAEKBAQQAgESBK4EAicajQEgVGhlIHZhbHVlIG9mIHRoZSB1bmludGVycHJldGVkIG9wdGlvbiwgaW4gd2hhdGV2ZXIgdHlwZSB0aGUgdG9rZW5pemVyCiBpZGVudGlmaWVkIGl0IGFzIGR1cmluZyBwYXJzaW5nLiBFeGFjdGx5IG9uZSBvZiB0aGVzZSBzaG91bGQgYmUgc2V0LgoKDQoFBBACAQQSBK4EAgoKDQoFBBACAQUSBK4ECxEKDQoFBBACAQESBK4EEiIKDQoFBBACAQMSBK4EJSYKDAoEBBACAhIErwQCKQoNCgUEEAICBBIErwQCCgoNCgUEEAICBRIErwQLEQoNCgUEEAICARIErwQSJAoNCgUEEAICAxIErwQnKAoMCgQEEAIDEgSwBAIoCg0KBQQQAgMEEgSwBAIKCg0KBQQQAgMFEgSwBAsQCg0KBQQQAgMBEgSwBBEjCg0KBQQQAgMDEgSwBCYnCgwKBAQQAgQSBLEEAiMKDQoFBBACBAQSBLEEAgoKDQoFBBACBAUSBLEECxEKDQoFBBACBAESBLEEEh4KDQoFBBACBAMSBLEEISIKDAoEBBACBRIEsgQCIgoNCgUEEAIFBBIEsgQCCgoNCgUEEAIFBRIEsgQLEAoNCgUEEAIFARIEsgQRHQoNCgUEEAIFAxIEsgQgIQoMCgQEEAIGEgSzBAImCg0KBQQQAgYEEgSzBAIKCg0KBQQQAgYFEgSzBAsRCg0KBQQQAgYBEgSzBBIhCg0KBQQQAgYDEgSzBCQlCtoBCgIEERIGuwQArgUBGmogRW5jYXBzdWxhdGVzIGluZm9ybWF0aW9uIGFib3V0IHRoZSBvcmlnaW5hbCBzb3VyY2UgZmlsZSBmcm9tIHdoaWNoIGEKIEZpbGVEZXNjcmlwdG9yUHJvdG8gd2FzIGdlbmVyYXRlZC4KMmAgPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQogT3B0aW9uYWwgc291cmNlIGNvZGUgaW5mbwoKCwoDBBEBEgS7BAgWCoIRCgQEEQIAEgTnBAIhGvMQIEEgTG9jYXRpb24gaWRlbnRpZmllcyBhIHBpZWNlIG9mIHNvdXJjZSBjb2RlIGluIGEgLnByb3RvIGZpbGUgd2hpY2gKIGNvcnJlc3BvbmRzIHRvIGEgcGFydGljdWxhciBkZWZpbml0aW9uLiAgVGhpcyBpbmZvcm1hdGlvbiBpcyBpbnRlbmRlZAogdG8gYmUgdXNlZnVsIHRvIElERXMsIGNvZGUgaW5kZXhlcnMsIGRvY3VtZW50YXRpb24gZ2VuZXJhdG9ycywgYW5kIHNpbWlsYXIKIHRvb2xzLgoKIEZvciBleGFtcGxlLCBzYXkgd2UgaGF2ZSBhIGZpbGUgbGlrZToKICAgbWVzc2FnZSBGb28gewogICAgIG9wdGlvbmFsIHN0cmluZyBmb28gPSAxOwogICB9CiBMZXQncyBsb29rIGF0IGp1c3QgdGhlIGZpZWxkIGRlZmluaXRpb246CiAgIG9wdGlvbmFsIHN0cmluZyBmb28gPSAxOwogICBeICAgICAgIF5eICAgICBeXiAgXiAgXl5eCiAgIGEgICAgICAgYmMgICAgIGRlICBmICBnaGkKIFdlIGhhdmUgdGhlIGZvbGxvd2luZyBsb2NhdGlvbnM6CiAgIHNwYW4gICBwYXRoICAgICAgICAgICAgICAgcmVwcmVzZW50cwogICBbYSxpKSAgWyA0LCAwLCAyLCAwIF0gICAgIFRoZSB3aG9sZSBmaWVsZCBkZWZpbml0aW9uLgogICBbYSxiKSAgWyA0LCAwLCAyLCAwLCA0IF0gIFRoZSBsYWJlbCAob3B0aW9uYWwpLgogICBbYyxkKSAgWyA0LCAwLCAyLCAwLCA1IF0gIFRoZSB0eXBlIChzdHJpbmcpLgogICBbZSxmKSAgWyA0LCAwLCAyLCAwLCAxIF0gIFRoZSBuYW1lIChmb28pLgogICBbZyxoKSAgWyA0LCAwLCAyLCAwLCAzIF0gIFRoZSBudW1iZXIgKDEpLgoKIE5vdGVzOgogLSBBIGxvY2F0aW9uIG1heSByZWZlciB0byBhIHJlcGVhdGVkIGZpZWxkIGl0c2VsZiAoaS5lLiBub3QgdG8gYW55CiAgIHBhcnRpY3VsYXIgaW5kZXggd2l0aGluIGl0KS4gIFRoaXMgaXMgdXNlZCB3aGVuZXZlciBhIHNldCBvZiBlbGVtZW50cyBhcmUKICAgbG9naWNhbGx5IGVuY2xvc2VkIGluIGEgc2luZ2xlIGNvZGUgc2VnbWVudC4gIEZvciBleGFtcGxlLCBhbiBlbnRpcmUKICAgZXh0ZW5kIGJsb2NrIChwb3NzaWJseSBjb250YWluaW5nIG11bHRpcGxlIGV4dGVuc2lvbiBkZWZpbml0aW9ucykgd2lsbAogICBoYXZlIGFuIG91dGVyIGxvY2F0aW9uIHdob3NlIHBhdGggcmVmZXJzIHRvIHRoZSAiZXh0ZW5zaW9ucyIgcmVwZWF0ZWQKICAgZmllbGQgd2l0aG91dCBhbiBpbmRleC4KIC0gTXVsdGlwbGUgbG9jYXRpb25zIG1heSBoYXZlIHRoZSBzYW1lIHBhdGguICBUaGlzIGhhcHBlbnMgd2hlbiBhIHNpbmdsZQogICBsb2dpY2FsIGRlY2xhcmF0aW9uIGlzIHNwcmVhZCBvdXQgYWNyb3NzIG11bHRpcGxlIHBsYWNlcy4gIFRoZSBtb3N0CiAgIG9idmlvdXMgZXhhbXBsZSBpcyB0aGUgImV4dGVuZCIgYmxvY2sgYWdhaW4gLS0gdGhlcmUgbWF5IGJlIG11bHRpcGxlCiAgIGV4dGVuZCBibG9ja3MgaW4gdGhlIHNhbWUgc2NvcGUsIGVhY2ggb2Ygd2hpY2ggd2lsbCBoYXZlIHRoZSBzYW1lIHBhdGguCiAtIEEgbG9jYXRpb24ncyBzcGFuIGlzIG5vdCBhbHdheXMgYSBzdWJzZXQgb2YgaXRzIHBhcmVudCdzIHNwYW4uICBGb3IKICAgZXhhbXBsZSwgdGhlICJleHRlbmRlZSIgb2YgYW4gZXh0ZW5zaW9uIGRlY2xhcmF0aW9uIGFwcGVhcnMgYXQgdGhlCiAgIGJlZ2lubmluZyBvZiB0aGUgImV4dGVuZCIgYmxvY2sgYW5kIGlzIHNoYXJlZCBieSBhbGwgZXh0ZW5zaW9ucyB3aXRoaW4KICAgdGhlIGJsb2NrLgogLSBKdXN0IGJlY2F1c2UgYSBsb2NhdGlvbidzIHNwYW4gaXMgYSBzdWJzZXQgb2Ygc29tZSBvdGhlciBsb2NhdGlvbidzIHNwYW4KICAgZG9lcyBub3QgbWVhbiB0aGF0IGl0IGlzIGEgZGVzY2VuZGVudC4gIEZvciBleGFtcGxlLCBhICJncm91cCIgZGVmaW5lcwogICBib3RoIGEgdHlwZSBhbmQgYSBmaWVsZCBpbiBhIHNpbmdsZSBkZWNsYXJhdGlvbi4gIFRodXMsIHRoZSBsb2NhdGlvbnMKICAgY29ycmVzcG9uZGluZyB0byB0aGUgdHlwZSBhbmQgZmllbGQgYW5kIHRoZWlyIGNvbXBvbmVudHMgd2lsbCBvdmVybGFwLgogLSBDb2RlIHdoaWNoIHRyaWVzIHRvIGludGVycHJldCBsb2NhdGlvbnMgc2hvdWxkIHByb2JhYmx5IGJlIGRlc2lnbmVkIHRvCiAgIGlnbm9yZSB0aG9zZSB0aGF0IGl0IGRvZXNuJ3QgdW5kZXJzdGFuZCwgYXMgbW9yZSB0eXBlcyBvZiBsb2NhdGlvbnMgY291bGQKICAgYmUgcmVjb3JkZWQgaW4gdGhlIGZ1dHVyZS4KCg0KBQQRAgAEEgTnBAIKCg0KBQQRAgAGEgTnBAsTCg0KBQQRAgABEgTnBBQcCg0KBQQRAgADEgTnBB8gCg4KBAQRAwASBugEAq0FAwoNCgUEEQMAARIE6AQKEgqDBwoGBBEDAAIAEgSABQQqGvIGIElkZW50aWZpZXMgd2hpY2ggcGFydCBvZiB0aGUgRmlsZURlc2NyaXB0b3JQcm90byB3YXMgZGVmaW5lZCBhdCB0aGlzCiBsb2NhdGlvbi4KCiBFYWNoIGVsZW1lbnQgaXMgYSBmaWVsZCBudW1iZXIgb3IgYW4gaW5kZXguICBUaGV5IGZvcm0gYSBwYXRoIGZyb20KIHRoZSByb290IEZpbGVEZXNjcmlwdG9yUHJvdG8gdG8gdGhlIHBsYWNlIHdoZXJlIHRoZSBkZWZpbml0aW9uLiAgRm9yCiBleGFtcGxlLCB0aGlzIHBhdGg6CiAgIFsgNCwgMywgMiwgNywgMSBdCiByZWZlcnMgdG86CiAgIGZpbGUubWVzc2FnZV90eXBlKDMpICAvLyA0LCAzCiAgICAgICAuZmllbGQoNykgICAgICAgICAvLyAyLCA3CiAgICAgICAubmFtZSgpICAgICAgICAgICAvLyAxCiBUaGlzIGlzIGJlY2F1c2UgRmlsZURlc2NyaXB0b3JQcm90by5tZXNzYWdlX3R5cGUgaGFzIGZpZWxkIG51bWJlciA0OgogICByZXBlYXRlZCBEZXNjcmlwdG9yUHJvdG8gbWVzc2FnZV90eXBlID0gNDsKIGFuZCBEZXNjcmlwdG9yUHJvdG8uZmllbGQgaGFzIGZpZWxkIG51bWJlciAyOgogICByZXBlYXRlZCBGaWVsZERlc2NyaXB0b3JQcm90byBmaWVsZCA9IDI7CiBhbmQgRmllbGREZXNjcmlwdG9yUHJvdG8ubmFtZSBoYXMgZmllbGQgbnVtYmVyIDE6CiAgIG9wdGlvbmFsIHN0cmluZyBuYW1lID0gMTsKCiBUaHVzLCB0aGUgYWJvdmUgcGF0aCBnaXZlcyB0aGUgbG9jYXRpb24gb2YgYSBmaWVsZCBuYW1lLiAgSWYgd2UgcmVtb3ZlZAogdGhlIGxhc3QgZWxlbWVudDoKICAgWyA0LCAzLCAyLCA3IF0KIHRoaXMgcGF0aCByZWZlcnMgdG8gdGhlIHdob2xlIGZpZWxkIGRlY2xhcmF0aW9uIChmcm9tIHRoZSBiZWdpbm5pbmcKIG9mIHRoZSBsYWJlbCB0byB0aGUgdGVybWluYXRpbmcgc2VtaWNvbG9uKS4KCg8KBwQRAwACAAQSBIAFBAwKDwoHBBEDAAIABRIEgAUNEgoPCgcEEQMAAgABEgSABRMXCg8KBwQRAwACAAMSBIAFGhsKDwoHBBEDAAIACBIEgAUcKQoSCgoEEQMAAgAI5wcAEgSABR0oChMKCwQRAwACAAjnBwACEgSABR0jChQKDAQRAwACAAjnBwACABIEgAUdIwoVCg0EEQMAAgAI5wcAAgABEgSABR0jChMKCwQRAwACAAjnBwADEgSABSQoCtICCgYEEQMAAgESBIcFBCoawQIgQWx3YXlzIGhhcyBleGFjdGx5IHRocmVlIG9yIGZvdXIgZWxlbWVudHM6IHN0YXJ0IGxpbmUsIHN0YXJ0IGNvbHVtbiwKIGVuZCBsaW5lIChvcHRpb25hbCwgb3RoZXJ3aXNlIGFzc3VtZWQgc2FtZSBhcyBzdGFydCBsaW5lKSwgZW5kIGNvbHVtbi4KIFRoZXNlIGFyZSBwYWNrZWQgaW50byBhIHNpbmdsZSBmaWVsZCBmb3IgZWZmaWNpZW5jeS4gIE5vdGUgdGhhdCBsaW5lCiBhbmQgY29sdW1uIG51bWJlcnMgYXJlIHplcm8tYmFzZWQgLS0gdHlwaWNhbGx5IHlvdSB3aWxsIHdhbnQgdG8gYWRkCiAxIHRvIGVhY2ggYmVmb3JlIGRpc3BsYXlpbmcgdG8gYSB1c2VyLgoKDwoHBBEDAAIBBBIEhwUEDAoPCgcEEQMAAgEFEgSHBQ0SCg8KBwQRAwACAQESBIcFExcKDwoHBBEDAAIBAxIEhwUaGwoPCgcEEQMAAgEIEgSHBRwpChIKCgQRAwACAQjnBwASBIcFHSgKEwoLBBEDAAIBCOcHAAISBIcFHSMKFAoMBBEDAAIBCOcHAAIAEgSHBR0jChUKDQQRAwACAQjnBwACAAESBIcFHSMKEwoLBBEDAAIBCOcHAAMSBIcFJCgK2QgKBgQRAwACAhIEqwUEKRrICCBJZiB0aGlzIFNvdXJjZUNvZGVJbmZvIHJlcHJlc2VudHMgYSBjb21wbGV0ZSBkZWNsYXJhdGlvbiwgdGhlc2UgYXJlIGFueQogY29tbWVudHMgYXBwZWFyaW5nIGJlZm9yZSBhbmQgYWZ0ZXIgdGhlIGRlY2xhcmF0aW9uIHdoaWNoIGFwcGVhciB0byBiZQogYXR0YWNoZWQgdG8gdGhlIGRlY2xhcmF0aW9uLgoKIEEgc2VyaWVzIG9mIGxpbmUgY29tbWVudHMgYXBwZWFyaW5nIG9uIGNvbnNlY3V0aXZlIGxpbmVzLCB3aXRoIG5vIG90aGVyCiB0b2tlbnMgYXBwZWFyaW5nIG9uIHRob3NlIGxpbmVzLCB3aWxsIGJlIHRyZWF0ZWQgYXMgYSBzaW5nbGUgY29tbWVudC4KCiBPbmx5IHRoZSBjb21tZW50IGNvbnRlbnQgaXMgcHJvdmlkZWQ7IGNvbW1lbnQgbWFya2VycyAoZS5nLiAvLykgYXJlCiBzdHJpcHBlZCBvdXQuICBGb3IgYmxvY2sgY29tbWVudHMsIGxlYWRpbmcgd2hpdGVzcGFjZSBhbmQgYW4gYXN0ZXJpc2sKIHdpbGwgYmUgc3RyaXBwZWQgZnJvbSB0aGUgYmVnaW5uaW5nIG9mIGVhY2ggbGluZSBvdGhlciB0aGFuIHRoZSBmaXJzdC4KIE5ld2xpbmVzIGFyZSBpbmNsdWRlZCBpbiB0aGUgb3V0cHV0LgoKIEV4YW1wbGVzOgoKICAgb3B0aW9uYWwgaW50MzIgZm9vID0gMTsgIC8vIENvbW1lbnQgYXR0YWNoZWQgdG8gZm9vLgogICAvLyBDb21tZW50IGF0dGFjaGVkIHRvIGJhci4KICAgb3B0aW9uYWwgaW50MzIgYmFyID0gMjsKCiAgIG9wdGlvbmFsIHN0cmluZyBiYXogPSAzOwogICAvLyBDb21tZW50IGF0dGFjaGVkIHRvIGJhei4KICAgLy8gQW5vdGhlciBsaW5lIGF0dGFjaGVkIHRvIGJhei4KCiAgIC8vIENvbW1lbnQgYXR0YWNoZWQgdG8gcXV4LgogICAvLwogICAvLyBBbm90aGVyIGxpbmUgYXR0YWNoZWQgdG8gcXV4LgogICBvcHRpb25hbCBkb3VibGUgcXV4ID0gNDsKCiAgIG9wdGlvbmFsIHN0cmluZyBjb3JnZSA9IDU7CiAgIC8qIEJsb2NrIGNvbW1lbnQgYXR0YWNoZWQKICAgICogdG8gY29yZ2UuICBMZWFkaW5nIGFzdGVyaXNrcwogICAgKiB3aWxsIGJlIHJlbW92ZWQuICovCiAgIC8qIEJsb2NrIGNvbW1lbnQgYXR0YWNoZWQgdG8KICAgICogZ3JhdWx0LiAqLwogICBvcHRpb25hbCBpbnQzMiBncmF1bHQgPSA2OwoKDwoHBBEDAAICBBIEqwUEDAoPCgcEEQMAAgIFEgSrBQ0TCg8KBwQRAwACAgESBKsFFCQKDwoHBBEDAAICAxIEqwUnKAoOCgYEEQMAAgMSBKwFBCoKDwoHBBEDAAIDBBIErAUEDAoPCgcEEQMAAgMFEgSsBQ0TCg8KBwQRAwACAwESBKwFFCUKDwoHBBEDAAIDAxIErAUoKXqZJQomZ29vZ2xlL3Byb3RvYnVmL3N3aWZ0LWRlc2NyaXB0b3IucHJvdG8SD2dvb2dsZS5wcm90b2J1ZhogZ29vZ2xlL3Byb3RvYnVmL2Rlc2NyaXB0b3IucHJvdG8i8gIKEFN3aWZ0RmlsZU9wdGlvbnMSIQoMY2xhc3NfcHJlZml4GAEgASgJUgtjbGFzc1ByZWZpeBJmChdlbnRpdGllc19hY2Nlc3NfY29udHJvbBgCIAEoDjIeLmdvb2dsZS5wcm90b2J1Zi5BY2Nlc3NDb250cm9sOg5QdWJsaWNFbnRpdGllc1IVZW50aXRpZXNBY2Nlc3NDb250cm9sEjgKFWNvbXBpbGVfZm9yX2ZyYW1ld29yaxgDIAEoCDoEdHJ1ZVITY29tcGlsZUZvckZyYW1ld29yaxIuCg9nZW5lcmF0ZV9zdHJ1Y3QYBCABKAg6BWZhbHNlUg5nZW5lcmF0ZVN0cnVjdBI7ChZnZW5lcmF0ZV9yZWFsbV9vYmplY3RzGAUgASgIOgVmYWxzZVIUZ2VuZXJhdGVSZWFsbU9iamVjdHMSLAoOZ2VuZXJhdGVfcmVhY3QYBiABKAg6BWZhbHNlUg1nZW5lcmF0ZVJlYWN0IukBChNTd2lmdE1lc3NhZ2VPcHRpb25zEjUKE2dlbmVyYXRlX2Vycm9yX3R5cGUYASABKAg6BWZhbHNlUhFnZW5lcmF0ZUVycm9yVHlwZRI5ChVnZW5lcmF0ZV9yZWFsbV9vYmplY3QYAiABKAg6BWZhbHNlUhNnZW5lcmF0ZVJlYWxtT2JqZWN0EiwKDmdlbmVyYXRlX3JlYWN0GAMgASgIOgVmYWxzZVINZ2VuZXJhdGVSZWFjdBIyChVhZGRpdGlvbmFsX2NsYXNzX25hbWUYBCABKAlSE2FkZGl0aW9uYWxDbGFzc05hbWUi8QEKEVN3aWZ0RmllbGRPcHRpb25zEj0KF3JlYWxtX2luZGV4ZWRfcHJvcGVydGllGAEgASgIOgVmYWxzZVIVcmVhbG1JbmRleGVkUHJvcGVydGllEjEKEXJlYWxtX3ByaW1hcnlfa2V5GAIgASgIOgVmYWxzZVIPcmVhbG1QcmltYXJ5S2V5EmoKGHJlYWxtX292ZXJyaWRlX3Byb3BlcnRpZRgDIAEoDjImLmdvb2dsZS5wcm90b2J1Zi5SZWFsbU92ZXJyaWRlUmVwZWF0ZWQ6CE9WRVJSSURFUhZyZWFsbU92ZXJyaWRlUHJvcGVydGllIrIBChBTd2lmdEVudW1PcHRpb25zEjUKE2dlbmVyYXRlX2Vycm9yX3R5cGUYASABKAg6BWZhbHNlUhFnZW5lcmF0ZUVycm9yVHlwZRIsCg5nZW5lcmF0ZV9yZWFjdBgCIAEoCDoFZmFsc2VSDWdlbmVyYXRlUmVhY3QSOQoVZ2VuZXJhdGVfcmVhbG1fb2JqZWN0GAMgASgIOgVmYWxzZVITZ2VuZXJhdGVSZWFsbU9iamVjdCo5Cg1BY2Nlc3NDb250cm9sEhQKEEludGVybmFsRW50aXRpZXMQABISCg5QdWJsaWNFbnRpdGllcxABKjEKFVJlYWxtT3ZlcnJpZGVSZXBlYXRlZBIMCghPVkVSUklERRAAEgoKBkFQUEVORBABOnAKEnN3aWZ0X2ZpbGVfb3B0aW9ucxIcLmdvb2dsZS5wcm90b2J1Zi5GaWxlT3B0aW9ucxi7q7cCIAEoCzIhLmdvb2dsZS5wcm90b2J1Zi5Td2lmdEZpbGVPcHRpb25zUhBzd2lmdEZpbGVPcHRpb25zOnQKE3N3aWZ0X2ZpZWxkX29wdGlvbnMSHS5nb29nbGUucHJvdG9idWYuRmllbGRPcHRpb25zGLqrtwIgASgLMiIuZ29vZ2xlLnByb3RvYnVmLlN3aWZ0RmllbGRPcHRpb25zUhFzd2lmdEZpZWxkT3B0aW9uczp8ChVzd2lmdF9tZXNzYWdlX29wdGlvbnMSHy5nb29nbGUucHJvdG9idWYuTWVzc2FnZU9wdGlvbnMYuau3AiABKAsyJC5nb29nbGUucHJvdG9idWYuU3dpZnRNZXNzYWdlT3B0aW9uc1ITc3dpZnRNZXNzYWdlT3B0aW9uczpwChJzd2lmdF9lbnVtX29wdGlvbnMSHC5nb29nbGUucHJvdG9idWYuRW51bU9wdGlvbnMYuKu3AiABKAsyIS5nb29nbGUucHJvdG9idWYuU3dpZnRFbnVtT3B0aW9uc1IQc3dpZnRFbnVtT3B0aW9uc0IO2tu6EwIYANrbuhMCEAFK2xcKBhIEEABKVgqFBQoBDBIDEAASGvoEIFByb3RvY29sIEJ1ZmZlcnMgZm9yIFN3aWZ0DQoNCiBDb3B5cmlnaHQgMjAxNCBBbGV4ZXlYby4NCiBDb3B5cmlnaHQgMjAwOCBHb29nbGUgSW5jLg0KDQogTGljZW5zZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbnNlLCBWZXJzaW9uIDIuMCAodGhlICJMaWNlbnNlIik7DQogeW91IG1heSBub3QgdXNlIHRoaXMgZmlsZSBleGNlcHQgaW4gY29tcGxpYW5jZSB3aXRoIHRoZSBMaWNlbnNlLg0KIFlvdSBtYXkgb2J0YWluIGEgY29weSBvZiB0aGUg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CgoDBwAEEgMPBAwKCgoDBwAGEgMPDSEKCgoDBwABEgMPIjgKCgoDBwADEgMPO0MKCQoBBxIEEgAUAQoJCgIHARIDEwRACgoKAwcBAhIDEgclCgoKAwcBBBIDEwQMCgoKAwcBBhIDEw0fCgoKAwcBARIDEyA0CgoKAwcBAxIDEzc/erOOAQoRTW9kZWxEb21haW4ucHJvdG8SCFByb3RvQXBpGiZnb29nbGUvcHJvdG9idWYvc3dpZnQtZGVzY3JpcHRvci5wcm90bxonZ29vZ2xlL3Byb3RvYnVmL2tvdGxpbi1kZXNjcmlwdG9yLnByb3RvIpQLCgtTeXN0ZW1FcnJvchJMCgllcnJvckNvZGUYASABKA4yJS5Qcm90b0FwaS5TeXN0ZW1FcnJvci5TeXN0ZW1FcnJvckNvZGU6B1VOS05PV05SCWVycm9yQ29kZRIgCgtlcnJvckRldGFpbBgCIAEoCVILZXJyb3JEZXRhaWwSSAoNc2VydmljZUVycm9ycxgDIAMoCzIiLlByb3RvQXBpLlN5c3RlbUVycm9yLlNlcnZpY2VFcnJvclINc2VydmljZUVycm9ycxp/CgxTZXJ2aWNlRXJyb3ISRAoJZXJyb3JDb2RlGAEgAigOMiYuUHJvdG9BcGkuU3lzdGVtRXJyb3IuU2VydmljZUVycm9yQ29kZVIJZXJyb3JDb2RlEiAKC2Vycm9yRGV0YWlsGAIgASgJUgtlcnJvckRldGFpbDoHytu6EwIIASLiAgoPU3lzdGVtRXJyb3JDb2RlEgsKB1VOS05PV04QABIXChNORUVEX1JFR0VORVJBVEVfS0VZEAESGgoWSU5WQUxJRF9TSUdOX0FMR09SSVRITRACEg4KCldST05HX0NPREUQAxIQCgxDT0RFX0VYUElSRUQQBBIaChZXUk9OR19QUk9UT0JVRl9NRVNTQUdFEAUSEgoOVU5WRVJJRklFRF9KV1QQBhIPCgtGRUxJWF9FUlJPUhAHEgsKB05PX1VVSUQQCBIYChRVTktOT1dOX0RFVklDRV9UT0tFThAJEg0KCU5PVF9GT1VORBAKEhcKE0lOVkFMSURfQ1JFREVOVElBTFMQCxIWChJJTlZBTElEX0FVVEhfVE9LRU4QDBIRCg1TRVJWSUNFX0VSUk9SEA0SFQoRQ0xJRU5UX05PVF9FWElTVFMQDhIQCgxTT0NLRVRfRVJST1IQDxoHwtu6EwIIASLbBQoQU2VydmljZUVycm9yQ29kZRIVChFUT09fTUFOWV9DT05UQUNUUxAAEhcKE0NIQU5ORUxfSk9JTl9GQUlMRUQQARIeChpERVZJQ0VfVkVSSUZJQ0FUSU9OX0ZBSUxFRBACEh8KG1ZFUklGSUNBVElPTl9BVFRFTVBUX0ZBSUxFRBADEhAKDFJBVEVfRVhQSVJFRBAEEhEKDVdST05HX1BST0RVQ1QQBRIUChBOT1RfRU5PVUdIX01PTkVZEAYSHQoZSU5WQUxJRF9UUkFOU0ZFUl9DVVJSRU5DWRAHEhUKEVBST0RVQ1RfTk9UX0ZPVU5EEAgSFAoQQ0xJRU5UX05PVF9GT1VORBAJEhAKDFdST05HX1BBUkFNUxAKEhEKDUJJQ19OT1RfRk9VTkQQCxISCg5CQU5LX05PVF9GT1VORBAMEhoKFk1JU1NFRF9SRVFVSVJFRF9QQVJBTVMQDRITCg9XUk9OR19PUEVSQVRJT04QDhIXChNPUEVSQVRJT05fTk9UX0ZPVU5EEA8SHQoZU0hPUF9JVEVNX0lTX09VVF9PRl9TVE9DSxAQEhsKF05PVF9FTk9VR0hfUk9DS0VUUlVCTEVTEBESHQoZQUREUkVTU19TVFJJTkdfSVNfTUlTU0lORxASEhwKGEFERFJFU1NfSE9VU0VfSVNfTUlTU0lORxATEhYKElBST1ZJREVSX05PVF9GT1VORBAUEhAKDFdST05HX0FNT1VOVBAVEiMKH1RPT19NQU5ZX0lOVEVSTkFMX0NBU0hfUkVRVUVTVFMQFhIUChBUT09fTUFOWV9GUklFTkRTEBcSEQoNQUxSRUFEWV9FWElTVBAYEhQKEE5PVF9DQVJEX09SX1NBRkUQGRILCgdOT1RfUlVCEBoSFAoQTUFYX1NNU19BVFRFTVBUUxAbEhkKFUxJTktFRF9DQVJEX05PVF9GT1VORBAcGgfC27oTAggBOgfK27oTAggBIuQCCgZEZXZpY2USEAoDYXBwGAEgAigJUgNhcHASEgoEYXBwdhgCIAIoCVIEYXBwdhIUCgVhcHB2YxgDIAEoBVIFYXBwdmMSEgoEcG5zdBgEIAEoCVIEcG5zdBISCgRkdWlkGAUgASgJUgRkdWlkEhIKBGl1aWQYBiABKAlSBGl1aWQSFgoGb3NuYW1lGAcgAigJUgZvc25hbWUSFgoGb3N2bWFqGAggASgFUgZvc3ZtYWoSFgoGb3N2bWluGAkgASgFUgZvc3ZtaW4SFgoGb3N2cGF0GAogASgFUgZvc3ZwYXQSEAoDbG9jGAsgAigJUgNsb2MSEgoEZGV2bRgMIAIoCVIEZGV2bRISCgRkZXZuGA0gAigJUgRkZXZuEhQKBWR0eXBlGA4gASgJUgVkdHlwZRIQCgNtY2MYDyABKAlSA21jYxIQCgNtbmMYECABKAlSA21uYxIOCgJkdBgRIAEoCVICZHQiJwoJUm9ja2V0S2V5EhAKA2tleRgBIAIoDFIDa2V5OgjSrJ/CAQIQASK/AQoGQXZhdGFyEikKBGZvcm0YASACKA4yFS5Qcm90b0FwaS5BdmF0YXIuRm9ybVIEZm9ybRIQCgN1cmwYAiABKAlSA3VybBIUCgVlbW9qaRgDIAIoCVIFZW1vamkiUgoERm9ybRIKCgZDSVJDTEUQABIMCghTUVVJUkNMRRABEgsKB0hFWEFHT04QAxIQCgxST1VORF9TUVVBUkUQBBIRCg1TUVVJUkNMRV9ST01CEAY6DsrbuhMCEAHK27oTAhgBIo0CCgRQdXNoEg4KAmlkGAEgAigJUgJpZBIUCgV0aXRsZRgCIAIoCVIFdGl0bGUSFgoGZGV0YWlsGAMgAigJUgZkZXRhaWwSFgoGY29sb3JzGAQgAygJUgZjb2xvcnMSLwoHYWN0aW9ucxgFIAMoCzIVLlByb3RvQXBpLlB1c2guQnV0dG9uUgdhY3Rpb25zGm4KBkJ1dHRvbhIWCgZhY3Rpb24YASACKAlSBmFjdGlvbhIUCgV0aXRsZRgCIAIoCVIFdGl0bGUSFAoFY29sb3IYAyACKAlSBWNvbG9yEiAKC2FjdGl2ZUNvbG9yGAQgAigJUgthY3RpdmVDb2xvcjoOytu6EwIQAcrbuhMCGAEiSwoFTW9uZXkSFgoGYW1vdW50GAEgAigBUgZhbW91bnQSGgoIY3VycmVuY3kYAiACKAlSCGN1cnJlbmN5Og7K27oTAhABytu6EwIYASJwCghMb2NhdGlvbhIaCghsYXRpdHVkZRgBIAIoAVIIbGF0aXR1ZGUSHAoJbG9uZ2l0dWRlGAIgAigBUglsb25naXR1ZGUSGgoIYWNjdXJhY3kYAyACKAFSCGFjY3VyYWN5Og7K27oTAhABytu6EwIYASJYCghNZXJjaGFudBIOCgJpZBgBIAIoCVICaWQSGAoHaWNvblVybBgCIAEoCVIHaWNvblVybBISCgRuYW1lGAMgAigJUgRuYW1lOg7K27oTAhABytu6EwIYASJyCghDYXJkQmFuaxISCgRuYW1lGAEgASgJUgRuYW1lEhgKB2ljb25VcmwYAiABKAlSB2ljb25VcmwSKAoPYmFja2dyb3VuZENvbG9yGAMgASgJUg9iYWNrZ3JvdW5kQ29sb3I6DsrbuhMCEAHK27oTAhgBIk0KD0NhcHR1cmVDYXJkRGF0YRIUCgVtb250aBgCIAEoBVIFbW9udGgSEgoEeWVhchgDIAEoBVIEeWVhchIQCgNwYW4YBCACKAlSA3BhbiI2CgVDb2xvchIdCgV2YWx1ZRgBIAIoCUIH0tu6EwIQAVIFdmFsdWU6DsrbuhMCEAHK27oTAhgBIrwCCgdBZGRyZXNzEjoKB2RldGFpbHMYASACKAsyIC5Qcm90b0FwaS5BZGRyZXNzLkFkZHJlc3NEZXRhaWxzUgdkZXRhaWxzGvQBCg5BZGRyZXNzRGV0YWlscxIUCgVob3VzZRgBIAIoCVIFaG91c2USIgoMY2l0eVdpdGhUeXBlGAIgASgJUgxjaXR5V2l0aFR5cGUSJgoOc3RyZWV0V2l0aFR5cGUYAyABKAlSDnN0cmVldFdpdGhUeXBlEhwKCWhvdXNlVHlwZRgEIAEoCVIJaG91c2VUeXBlEhwKCWJsb2NrVHlwZRgFIAEoCVIJYmxvY2tUeXBlEhQKBWJsb2NrGAYgASgJUgVibG9jaxIaCghmbGF0VHlwZRgHIAEoCVIIZmxhdFR5cGUSEgoEZmxhdBgIIAEoCVIEZmxhdConCgZHZW5kZXISCAoETUFMRRAAEgoKBkZFTUFMRRABGgfC27oTAhgBKjUKCEN1cnJlbmN5EgcKA1JVUhAAEgcKA1VTRBABEgcKA0VVUhACGg7C27oTAhgBwtu6EwIQAUIlCiFydS5yb2NrZXRiYW5rLnByb3RvbW9kZWwuUHJvdG9BcGlQAUrvcwoHEgUAAI4CAQoICgEMEgMAABIKCQoCAwASAwIHLwoJCgIDARIDAwcwCggKAQISAwUIEAoICgEIEgMGADoKCwoECOcHABIDBgA6CgwKBQjnBwACEgMGBxMKDQoGCOcHAAIAEgMGBxMKDgoHCOcHAAIAARIDBgcTCgwKBQjnBwAHEgMGFjkKCAoBCBIDBwAiCgsKBAjnBwESAwcAIgoMCgUI5wcBAhIDBwcaCg0KBgjnBwECABIDBwcaCg4KBwjnBwECAAESAwcHGgoMCgUI5wcBAxIDBx0hCgoKAgQAEgQKAHYBCgoKAwQAARIDCggTCgoKAwQABxIDCwJNCg0KBgQAB+cHABIDCwJNCg4KBwQAB+cHAAISAwsJRQoPCggEAAfnBwACABIDCwkxChAKCQQAB+cHAAIAARIDCwowCg8KCAQAB+cHAAIBEgMLMkUKEAoJBAAH5wcAAgEBEgMLMkUKDgoHBAAH5wcAAxIDC0hMCgsKBAQAAgASAwwCPQoMCgUEAAIABBIDDAIKCgwKBQQAAgAGEgMMCxoKDAoFBAACAAESAwwbJAoMCgUEAAIAAxIDDCcoCgwKBQQAAgAIEgMMKTwKDAoFBAACAAcSAww0OwoLCgQEAAIBEgMNAiIKDAoFBAACAQQSAw0CCgoMCgUEAAIBBRIDDQsRCgwKBQQAAgEBEgMNEh0KDAoFBAACAQMSAw0gIQoLCgQEAAICEgMOAioKDAoFBAACAgQSAw4CCgoMCgUEAAICBhIDDgsXCgwKBQQAAgIBEgMOGCUKDAoFBAACAgMSAw4oKQoMCgQEAAMAEgQQAhQDCgwKBQQAAwABEgMQChYKDAoFBAADAAcSAxEETwoPCggEAAMAB+cHABIDEQRPChAKCQQAAwAH5wcAAhIDEQtHChEKCgQAAwAH5wcAAgASAxELMwoSCgsEAAMAB+cHAAIAARIDEQwyChEKCgQAAwAH5wcAAgESAxE0RwoSCgsEAAMAB+cHAAIBARIDETRHChAKCQQAAwAH5wcAAxIDEUpOCg0KBgQAAwACABIDEgQsCg4KBwQAAwACAAQSAxIEDAoOCgcEAAMAAgAGEgMSDR0KDgoHBAADAAIAARIDEh4nCg4KBwQAAwACAAMSAxIqKwoNCgYEAAMAAgESAxMEJAoOCgcEAAMAAgEEEgMTBAwKDgoHBAADAAIBBRIDEw0TCg4KBwQAAwACAQESAxMUHwoOCgcEAAMAAgEDEgMTIiMKDAoEBAAEABIEFgI3AwoMCgUEAAQAARIDFgcWCgwKBQQABAADEgMXBEwKDwoIBAAEAAPnBwASAxcETAoQCgkEAAQAA+cHAAISAxcLRAoRCgoEAAQAA+cHAAIAEgMXCzAKEgoLBAAEAAPnBwACAAESAxcMLwoRCgoEAAQAA+cHAAIBEgMXMUQKEgoLBAAEAAPnBwACAQESAxcxRAoQCgkEAAQAA+cHAAMSAxdHSwo1CgYEAAQAAgASAxkEEBomLyDQndC10LjQt9Cy0LXRgdGC0L3QsNGPINC+0YjQuNCx0LrQsAoKDgoHBAAEAAIAARIDGQQLCg4KBwQABAACAAISAxkODwpSCgYEAAQAAgESAxsEHBpDLyDQndC10L7QsdGF0L7QtNC40LzQviDQv9C10YDQtdCz0LXQvdC10YDQuNGA0L7QstCw0YLRjCDQutC70Y7Rh9C4CgoOCgcEAAQAAgEBEgMbBBcKDgoHBAAEAAIBAhIDGxobCkgKBgQABAACAhIDHQQfGjkvINCd0LXQuNC30LLQtdGB0YLQvdGL0Lkg0LDQu9Cz0L7RgNC40YLQvCDQv9C+0LTQv9C40YHQuAoKDgoHBAAEAAICARIDHQQaCg4KBwQABAACAgISAx0dHgp4CgYEAAQAAgMSAx8EExppLyDQndC10L/RgNCw0LLQuNC70YzQvdGL0Lkg0LrQvtC0INC/0L7QtNGC0LLQtdGA0LbQtNCw0LXQvdC40Y8g0YDQtdCz0LjRgdGC0YDQsNGG0LjQuCDRg9GB0YLRgNC+0LnRgdGC0LIKCg4KBwQABAACAwESAx8EDgoOCgcEAAQAAgMCEgMfERIKRwoGBAAEAAIEEgMhBBUaOC8g0JrQvtC0INC/0L7QtNCy0LXQttC00LXQvdC40Y8g0LrQu9GO0YfQtdC5INC40YHRgtC10LoKCg4KBwQABAACBAESAyEEEAoOCgcEAAQAAgQCEgMhExQKTgoGBAAEAAIFEgMjBB8aPy8g0J3QtdC/0YDQsNCy0LjQu9GM0L3Ri9C5INC/0YDQvtGB0YLQvtCx0LDRhCDQvNC10YHRgdCw0L3QtNC2CgoOCgcEAAQAAgUBEgMjBBoKDgoHBAAEAAIFAhIDIx0eCk0KBgQABAACBhIDJQQXGj4vINCd0LXQstC+0LfQvNC+0LbQvdC+INCy0LXRgNC40YTQuNGG0LjRgNC+0LLQsNGC0YwgSldUIFRva2VuCgoOCgcEAAQAAgYBEgMlBBIKDgoHBAAEAAIGAhIDJRUWCjYKBgQABAACBxIDJwQUGicvINCk0LXQu9C40LrRgSDQv9C+0YHQu9Cw0Lsg0L3QsNGF0LXRgAoKDgoHBAAEAAIHARIDJwQPCg4KBwQABAACBwISAycSEwopCgYEAAQAAggSAykEEBoaLyBkdWlkINC/0YDQvtC10LHQsNC70YHRjwoKDgoHBAAEAAIIARIDKQQLCg4KBwQABAACCAISAykODwotCgYEAAQAAgkSAysEHRoeLyDRgdGC0YDQtdC80L3Ri9C5INGC0L7QutC10L0KCg4KBwQABAACCQESAysEGAoOCgcEAAQAAgkCEgMrGxwKLQoGBAAEAAIKEgMtBBMaHi8g0L3QtdCy0LXQtNC+0LzRi9C5INGA0L7Rg9GCCgoOCgcEAAQAAgoBEgMtBA0KDgoHBAAEAAIKAhIDLRASCisKBgQABAACCxIDLwQdGhwvIGludmFsaWQgbG9naW4gY3JlZGVudGlhbHMKCg4KBwQABAACCwESAy8EFwoOCgcEAAQAAgsCEgMvGhwKDQoGBAAEAAIMEgMwBBwKDgoHBAAEAAIMARIDMAQWCg4KBwQABAACDAISAzAZGwqGAQoGBAAEAAINEgMyBBcady8g0JXRgdC70Lgg0LLRgdC1INCe0Jog0L3QviDQtdGB0YLRjCDRgdC10YDQstC40YHQvdGL0LUg0L7RiNC40LHQutC4KNCd0LDQv9GA0LjQvNC10YAg0L7RiNC40LHQutCwINCy0LDQu9C40LTQsNGG0LjQuCkKCg4KBwQABAACDQESAzIEEQoOCgcEAAQAAg0CEgMyFBYKWwoGBAAEAAIOEgM0BBsaTC8g0JrQu9C40LXQvdGCINC90LUg0L3QsNC50LTQtdC9INC/0YDQuCDQv9C+0LTRgtCy0LXRgNC20LTQtdC90LjQuCDRgNC10LPQuAoKDgoHBAAEAAIOARIDNAQVCg4KBwQABAACDgISAzQYGgowCgYEAAQAAg8SAzYEFhohLyDQntGI0LjQsdC60LAg0LjQtyDRgdC+0LrQtdGC0LAKCg4KBwQABAACDwESAzYEEAoOCgcEAAQAAg8CEgM2ExUKDAoEBAAEARIEOAJ1AwoMCgUEAAQBARIDOAcXCgwKBQQABAEDEgM5BEwKDwoIBAAEAQPnBwASAzkETAoQCgkEAAQBA+cHAAISAzkLRAoRCgoEAAQBA+cHAAIAEgM5CzAKEgoLBAAEAQPnBwACAAESAzkMLwoRCgoEAAQBA+cHAAIBEgM5MUQKEgoLBAAEAQPnBwACAQESAzkxRAoQCgkEAAQBA+cHAAMSAzlHSwo+CgYEAAQBAgASAzsEGhovLyDQodC70LjRiNC60L7QvCDQvNC90L7Qs9C+INC60L7QvdGC0LDQutGC0L7QsgoKDgoHBAAEAQIAARIDOwQVCg4KBwQABAECAAISAzsYGQpVCgYEAAQBAgESAz0EHBpGLyDQndC1INGB0LzQvtCzINC/0L7QtNC60LvRjtGH0LjRgtGM0YHRjyDQuiDQutCw0L3QsNC70YMg0YHQvtC60LXRgtCwCgoOCgcEAAQBAgEBEgM9BBcKDgoHBAAEAQIBAhIDPRobClQKBgQABAECAhIDPwQjGkUvINCS0LXRgNC40YTQuNC60LDRhtC40Y8g0YPRgdGC0YDQvtC50YHRgtCy0LAg0L/RgNC+0LLQsNC70LjQu9Cw0YHRjAoKDgoHBAAEAQICARIDPwQeCg4KBwQABAECAgISAz8hIgp1CgYEAAQBAgMSA0EEJBpmLyDQndC1INGB0LzQvtCz0LvQuCDQv9C+0LTQs9C+0YLQvtCy0LjRgtGMINC/0L7Qv9GL0YLQutGDINCy0LXRgNC40YTQuNC60LDRhtC40Lgg0YPRgdGC0YDQvtC50YHRgtCy0LAKCg4KBwQABAECAwESA0EEHwoOCgcEAAQBAgMCEgNBIiMKdwoGBAAEAQIEEgNDBBUaaC8g0KHRgtCw0YDRi9C5INC60YPRgNGBINCy0LDQu9GO0YIgKNC90LDQv9GA0LjQvNC10YAg0L/RgNC4INC/0LXRgNC10LLQvtC00LUg0LzQtdC20LTRgyDRgdGH0LXRgtCw0LzQuCkKCg4KBwQABAECBAESA0MEEAoOCgcEAAQBAgQCEgNDExQKeAoGBAAEAQIFEgNFBBYaaS8g0J/RgNC+0LTRg9C60YIg0L3QtSDQv9C+0LTRhdC+0LTQuNGCICjQvdCw0L/RgNC40LzQtdGAINC/0YDQuCDQv9C10YDQtdCy0L7QtNC1INC90LAg0Y3RgtC+0YIg0YHRh9C10YIpCgoOCgcEAAQBAgUBEgNFBBEKDgoHBAAEAQIFAhIDRRQVCmIKBgQABAECBhIDRwQZGlMvINCd0LXQtNC+0YHRgtCw0YLQvtGH0L3QviDQtNC10L3QtdCzINC00LvRjyDRgdC+0LLQtdGA0YjQtdC90LjRjyDQvtC/0LXRgNCw0YbQuNC4CgoOCgcEAAQBAgYBEgNHBBQKDgoHBAAEAQIGAhIDRxcYCkAKBgQABAECBxIDSQQiGjEvINCd0LXQstC10YDQvdCw0Y8g0LLQsNC70Y7RgtCwINC/0LXRgNC10LLQvtC00LAKCg4KBwQABAECBwESA0kEHQoOCgcEAAQBAgcCEgNJICEKRQoGBAAEAQIIEgNLBBoaNi8g0KLQsNC60L7QuSDQv9GA0L7QtNGD0LrRgiDQvdC1INGB0YPRidC10YHRgtCy0YPQtdGCCgoOCgcEAAQBAggBEgNLBBUKDgoHBAAEAQIIAhIDSxgZCjAKBgQABAECCRIDTQQZGiEvINCa0LvQuNC10L3RgiDQvdC1INC90LDQudC00LXQvQoKDgoHBAAEAQIJARIDTQQUCg4KBwQABAECCQISA00XGApGCgYEAAQBAgoSA08EFho3LyDQn9C10YDQtdC00LDQvdGLINC90LXQstC10YDQvdGL0LUg0L/QsNGA0LDQvNC10YLRgNGLCgoOCgcEAAQBAgoBEgNPBBAKDgoHBAAEAQIKAhIDTxMVCioKBgQABAECCxIDUQQXGhsvINCR0JjQmiDQvdC1INC90LDQudC00LXQvQoKDgoHBAAEAQILARIDUQQRCg4KBwQABAECCwISA1EUFgosCgYEAAQBAgwSA1MEGBodLyDQkdCw0L3QuiDQvdC1INC90LDQudC00LXQvQoKDgoHBAAEAQIMARIDUwQSCg4KBwQABAECDAISA1MVFwpTCgYEAAQBAg0SA1UEIBpELyDQndC1INGF0LLQsNGC0LDQtdGCINC+0LHRj9C30LDRgtC10LvRjNC90YvRhSDQv9Cw0YDQsNC80LXRgtGA0L7QsgoKDgoHBAAEAQINARIDVQQaCg4KBwQABAECDQISA1UdHwo7CgYEAAQBAg4SA1cEGRosLyDQndC10L/QvtC00YXQvtC00Y/RidCw0Y8g0L7Qv9C10YDQsNGG0LjRjwoKDgoHBAAEAQIOARIDVwQTCg4KBwQABAECDgISA1cWGAo2CgYEAAQBAg8SA1kEHRonLyDQntC/0LXRgNCw0YbQuNGPINC90LUg0L3QsNC50LTQtdC90LAKCg4KBwQABAECDwESA1kEFwoOCgcEAAQBAg8CEgNZGhwKNwoGBAAEAQIQEgNbBCMaKC8g0KLQvtCy0LDRgNCwINC90LXRgiDQsiDQvdCw0LvQuNGH0LjQuAoKDgoHBAAEAQIQARIDWwQdCg4KBwQABAECEAISA1sgIgo8CgYEAAQBAhESA10EIRotLyDQndC1INGF0LLQsNGC0LDQtdGCINGA0L7QutC10YLRgNGD0LHQu9C10LkKCg4KBwQABAECEQESA10EGwoOCgcEAAQBAhECEgNdHiAKOAoGBAAEAQISEgNfBCMaKS8g0J3Rg9C20LXQvSDQsNC00YDQtdGBINC00L7RgdGC0LDQstC60LgKCg4KBwQABAECEgESA18EHQoOCgcEAAQBAhICEgNfICIKSAoGBAAEAQITEgNhBCIaOS8g0JTQu9GPINC00L7RgdGC0LDQstC60Lgg0L3Rg9C20LXQvSDQvdC+0LzQtdGAINC00L7QvNCwCgoOCgcEAAQBAhMBEgNhBBwKDgoHBAAEAQITAhIDYR8hCjYKBgQABAECFBIDYwQcGicvINCf0YDQvtCy0LDQudC00LXRgCDQvdC1INC90LDQudC00LXQvQoKDgoHBAAEAQIUARIDYwQWCg4KBwQABAECFAISA2MZGwotCgYEAAQBAhUSA2UEFhoeLyDQndC10LLQtdGA0L3QsNGPINGB0YPQvNC80LAKCg4KBwQABAECFQESA2UEEAoOCgcEAAQBAhUCEgNlExUKVQoGBAAEAQIWEgNnBCkaRi8g0KHQu9C40LbQutC+0Lwg0LzQvdC+0LPQviDQt9Cw0L/RgNC+0YHQvtCyINCx0LDQsdC70LAg0LIg0LHQsNGC0YfQtQoKDgoHBAAEAQIWARIDZwQjCg4KBwQABAECFgISA2cmKAo4CgYEAAQBAhcSA2kEGhopLyDQodC70LjQttC60L7QvCDQvNC90L7Qs9C+INC00YDRg9C30LXQuQoKDgoHBAAEAQIXARIDaQQUCg4KBwQABAECFwISA2kXGQrsAQoGBAAEAQIYEgNsBBca3AEvINCf0L7Qv9GL0YLQutCwINGB0L7Qt9C00LDRgtGMINC60LDRgNGC0YMo0YfRgtC+LdC70LjQsdC+KSwg0L/RgNC4INGD0LbQtSDRgdGD0YnQtdGB0YLQstGD0Y7RidC10Lkg0LrQsNGA0YLQtSDRgSDRgtCw0LrQvtC5INCy0LDQu9GO0YLQvtC5Ci8gKNC/0YDQuCDQutCw0LrQvtC8LdC70LjQsdC+INC+0LPRgNCw0L3QuNGH0LXQvdC40Lgg0L3QsCDQutC+0LvQuNGH0LXRgdGC0LLQvikKCg4KBwQABAECGAESA2wEEQoOCgcEAAQBAhgCEgNsFBYKVwoGBAAEAQIZEgNuBBoaSC8g0J/RgNC+0LTRg9C60YIg0L3QtSDRj9Cy0LvRj9C10YLRgdGPINC60LDRgNGC0L7QuSDQuNC70Lgg0YHRh9C10YLQvtC8CgoOCgcEAAQBAhkBEgNuBBQKDgoHBAAEAQIZAhIDbhcZCoIBCgYEAAQBAhoSA3AEERpzLyDQktCw0LvRjtGC0LAg0L/RgNC+0LTRg9C60YLQsCAtINC90LUg0YDRg9Cx0LvQuCAo0L3QsNC/0YDQuNC80LXRgCDQv9GA0Lgg0L/QvtC/0YvRgtC60LUg0L7Qv9C70LDRgtGLINGD0YHQu9GD0LMpCgoOCgcEAAQBAhoBEgNwBAsKDgoHBAAEAQIaAhIDcA4QCk8KBgQABAECGxIDcgQaGkAvINCR0L7Qu9GM0YjQtSDQvdC10LvRjNC30Y8g0L/QtdGA0LXQvtGC0L/RgNCw0LLQu9GP0YLRjCDRgdC80YEKCg4KBwQABAECGwESA3IEFAoOCgcEAAQBAhsCEgNyFxkKYwoGBAAEAQIcEgN0BB8aVC8g0JfQsNC70LjQvdC60L7QstCw0L3QsNGPINC60LDRgNGC0LAg0LTQu9GPINC/0LXRgNC10LLQvtC00L7QsiDQvdC1INC90LDQudC00LXQvdCwCgoOCgcEAAQBAhwBEgN0BBkKDgoHBAAEAQIcAhIDdBweCj0KAgQBEgV5AJwBARowINCY0L3RhNC+0YDQvNCw0YbQuNGPINC+0LEg0YPRgdGC0YDQvtC50YHRgtCy0LUKCgoKAwQBARIDeQgOCjEKBAQBAgASA3sCGxokYnVuZGxlIChpT1MpLCBwYWNrYWdlTmFtZSAoQW5kcm9pZCkKCgwKBQQBAgAEEgN7AgoKDAoFBAECAAUSA3sLEQoMCgUEAQIAARIDexIVCgwKBQQBAgADEgN7GRoKLwoEBAECARIDfQIbGiLQktC10YDRgdC40Y8g0L/RgNC40LvQvtC20LXQvdC40Y8KCgwKBQQBAgEEEgN9AgoKDAoFBAECAQUSA30LEQoMCgUEAQIBARIDfRIWCgwKBQQBAgEDEgN9GRoKNgoEBAECAhIDfwIbGinQktC10YDRgdC40Y8g0L/RgNC40LvQvtC20LXQvdC40Y8g0LrQvtC0CgoMCgUEAQICBBIDfwIKCgwKBQQBAgIFEgN/CxAKDAoFBAECAgESA38RFgoMCgUEAQICAxIDfxkaCl4KBAQBAgMSBIEBAhsaUNCd0LDRgtC40LLQvdGL0Lkg0L/Rg9GIINCw0LTRgNC10YEuIGRldmljZVRva2VuIChpT1MpLCByZWdpc3RyYXRpb25JZCAoQW5kcm9pZCkKCg0KBQQBAgMEEgSBAQIKCg0KBQQBAgMFEgSBAQsRCg0KBQQBAgMBEgSBARIWCg0KBQQBAgMDEgSBARkaClcKBAQBAgQSBIMBAhsaSdCd0LXQuNC30LzQtdC90Y/QtdC80YvQuSDQuNC00LXQvdGC0LjRhNC40LrQsNGC0L7RgCDRg9GB0YLRgNC+0LnRgdGC0LLQsAoKDQoFBAECBAQSBIMBAgoKDQoFBAECBAUSBIMBCxEKDQoFBAECBAESBIMBEhYKDQoFBAECBAMSBIMBGRoKQAoEBAECBRIEhQECGxoy0JjQtNC10L3RgtC40YTQuNC60LDRgtC+0YAg0LjQvdGB0YLQsNC70LvRj9GG0LjQuAoKDQoFBAECBQQSBIUBAgoKDQoFBAECBQUSBIUBCxEKDQoFBAECBQESBIUBEhYKDQoFBAECBQMSBIUBGRoKGgoEBAECBhIEhwECHRoM0JjQvNGPINCe0KEKCg0KBQQBAgYEEgSHAQIKCg0KBQQBAgYFEgSHAQsRCg0KBQQBAgYBEgSHARIYCg0KBQQBAgYDEgSHARscCjEKBAQBAgcSBIkBAhwaI9Cc0LDQttC+0YDQvdCw0Y8g0LLQtdGA0YHQuNGPINCe0KEKCg0KBQQBAgcEEgSJAQIKCg0KBQQBAgcFEgSJAQsQCg0KBQQBAgcBEgSJAREXCg0KBQQBAgcDEgSJARobCjEKBAQBAggSBIsBAhwaI9Cc0LjQvdC+0YDQvdCw0Y8g0LLQtdGA0YHQuNGPINCe0KEKCg0KBQQBAggEEgSLAQIKCg0KBQQBAggFEgSLAQsQCg0KBQQBAggBEgSLAREXCg0KBQQBAggDEgSLARobCikKBAQBAgkSBI0BAh4aG9Cf0LDRgtGHINCy0LXRgNGB0LjQuCDQntChCgoNCgUEAQIJBBIEjQECCgoNCgUEAQIJBRIEjQELEAoNCgUEAQIJARIEjQERFwoNCgUEAQIJAxIEjQEbHQowCgQEAQIKEgSPAQIbGiLQm9C+0LrQsNC70Ywg0YPRgdGC0YDQvtC50YHRgtCy0LAKCg0KBQQBAgoEEgSPAQIKCg0KBQQBAgoFEgSPAQsRCg0KBQQBAgoBEgSPARIVCg0KBQQBAgoDEgSPARgaCigKBAQBAgsSBJEBAhwaGtCU0LXQstCw0LnRgSDQvNC+0LTQtdC70YwKCg0KBQQBAgsEEgSRAQIKCg0KBQQBAgsFEgSRAQsRCg0KBQQBAgsBEgSRARIWCg0KBQQBAgsDEgSRARkbCiQKBAQBAgwSBJMBAhwaFtCU0LXQstCw0LnRgSDQvdC10LnQvAoKDQoFBAECDAQSBJMBAgoKDQoFBAECDAUSBJMBCxEKDQoFBAECDAESBJMBEhYKDQoFBAECDAMSBJMBGRsKQwoEBAECDRIElQECHRo1RGV2aWNlIFR5cGUg0YDQsNC90YzRiNC1INCx0YvQu9C+IEhUVFBfWF9ERVZJQ0VfVFlQRQoKDQoFBAECDQQSBJUBAgoKDQoFBAECDQUSBJUBCxEKDQoFBAECDQESBJUBEhcKDQoFBAECDQMSBJUBGhwKIgoEBAECDhIElwECGxoUTW9iaWxlIGNvdW50cnkgY29kZQoKDQoFBAECDgQSBJcBAgoKDQoFBAECDgUSBJcBCxEKDQoFBAECDgESBJcBEhUKDQoFBAECDgMSBJcBGBoKIgoEBAECDxIEmQECGxoUTW9iaWxlIG5ldHdvcmsgY29kZQoKDQoFBAECDwQSBJkBAgoKDQoFBAECDwUSBJkBCxEKDQoFBAECDwESBJkBEhUKDQoFBAECDwMSBJkBGBoKLgoEBAECEBIEmwECGhog0KLQvtC60LXQvSDRg9GB0YLRgNC+0LnRgdGC0LLQsAoKDQoFBAECEAQSBJsBAgoKDQoFBAECEAUSBJsBCxEKDQoFBAECEAESBJsBEhQKDQoFBAECEAMSBJsBFxkK+gEKAgQCEgajAQCnAQEa6wEg0JrQodCbINCo0LjRhNGA0L7QstCw0L3QuNC1ICjQmtC+0LvRj9C9IC0g0KHQtdGA0LPQtdC5IC0g0JvQtdGF0LApCiBQdWJsaWMga2V5IFJTQTIwNDgKIEhlYWRlciBBRVMyNTYgQ3J5cHRlZAogSGVhZGVyIG5hbWUgWC1LRVkKIEhlYWRlciB2YWx1ZSA9IEhFWFNUUiggUlNBMjA0OCggSEVYU1RSKEFFU19LRVkpIHx8IEhFWFNUUihJTklUX1ZFQ1RPUikgfHwgSEVYU1RSKFJBTkRPTV9TRUNSRVRfSldUKSApICkKCgsKAwQCARIEowEIEQoLCgMEAgcSBKUBAlAKMAoGBAIH5wcAEgSlAQJQGiAg0KHQsNC8INC60LvRjtGHINCx0LjQvdCw0YDQutCwCgoPCgcEAgfnBwACEgSlAQlIChAKCAQCB+cHAAIAEgSlAQkyChEKCQQCB+cHAAIAARIEpQEKMQoQCggEAgfnBwACARIEpQEzSAoRCgkEAgfnBwACAQESBKUBM0gKDwoHBAIH5wcAAxIEpQFLTwoMCgQEAgIAEgSmAQIZCg0KBQQCAgAEEgSmAQIKCg0KBQQCAgAFEgSmAQsQCg0KBQQCAgABEgSmAREUCg0KBQQCAgADEgSmARcYCgwKAgQDEgapAQC2AQEKCwoDBAMBEgSpAQgOCgsKAwQDBxIEqgECTwoOCgYEAwfnBwASBKoBAk8KDwoHBAMH5wcAAhIEqgEJRwoQCggEAwfnBwACABIEqgEJMQoRCgkEAwfnBwACAAESBKoBCjAKEAoIBAMH5wcAAgESBKoBMkcKEQoJBAMH5wcAAgEBEgSqATJHCg8KBwQDB+cHAAMSBKoBSk4KCwoDBAMHEgSrAQJICg4KBgQDB+cHARIEqwECSAoPCgcEAwfnBwECEgSrAQlAChAKCAQDB+cHAQIAEgSrAQkxChEKCQQDB+cHAQIAARIEqwEKMAoQCggEAwfnBwECARIEqwEyQAoRCgkEAwfnBwECAQESBKsBMkAKDwoHBAMH5wcBAxIEqwFDRwoOCgQEAwQAEgasAQKyAQMKDQoFBAMEAAESBKwBBwsKDgoGBAMEAAIAEgStAQQPCg8KBwQDBAACAAESBK0BBAoKDwoHBAMEAAIAAhIErQENDgoOCgYEAwQAAgESBK4BBBEKDwoHBAMEAAIBARIErgEEDAoPCgcEAwQAAgECEgSuAQ8QCg4KBgQDBAACAhIErwEEEAoPCgcEAwQAAgIBEgSvAQQLCg8KBwQDBAACAgISBK8BDg8KDgoGBAMEAAIDEgSwAQQVCg8KBwQDBAACAwESBLABBBAKDwoHBAMEAAIDAhIEsAETFAoOCgYEAwQAAgQSBLEBBBYKDwoHBAMEAAIEARIEsQEEEQoPCgcEAwQAAgQCEgSxARQVCgwKBAQDAgASBLMBAhkKDQoFBAMCAAQSBLMBAgoKDQoFBAMCAAYSBLMBCw8KDQoFBAMCAAESBLMBEBQKDQoFBAMCAAMSBLMBFxgKDAoEBAMCARIEtAECGgoNCgUEAwIBBBIEtAECCgoNCgUEAwIBBRIEtAELEQoNCgUEAwIBARIEtAESFQoNCgUEAwIBAxIEtAEYGQoMCgQEAwICEgS1AQIcCg0KBQQDAgIEEgS1AQIKCg0KBQQDAgIFEgS1AQsRCg0KBQQDAgIBEgS1ARIXCg0KBQQDAgIDEgS1ARobCgwKAgUAEga5AQC9AQEKCwoDBQABEgS5AQULCgsKAwUAAxIEugEETgoOCgYFAAPnBwASBLoBBE4KDwoHBQAD5wcAAhIEugELRgoQCggFAAPnBwACABIEugELMAoRCgkFAAPnBwACAAESBLoBDC8KEAoIBQAD5wcAAgESBLoBMUYKEQoJBQAD5wcAAgEBEgS6ATFGCg8KBwUAA+cHAAMSBLoBSU0KDAoEBQACABIEuwECCwoNCgUFAAIAARIEuwECBgoNCgUFAAIAAhIEuwEJCgoMCgQFAAIBEgS8AQINCg0KBQUAAgEBEgS8AQIICg0KBQUAAgECEgS8AQsMCgwKAgQEEga+AQDMAQEKCwoDBAQBEgS+AQgMCgsKAwQEBxIEvwECTwoOCgYEBAfnBwASBL8BAk8KDwoHBAQH5wcAAhIEvwEJRwoQCggEBAfnBwACABIEvwEJMQoRCgkEBAfnBwACAAESBL8BCjAKEAoIBAQH5wcAAgESBL8BMkcKEQoJBAQH5wcAAgEBEgS/ATJHCg8KBwQEB+cHAAMSBL8BSk4KCwoDBAQHEgTAAQJICg4KBgQEB+cHARIEwAECSAoPCgcEBAfnBwECEgTAAQlAChAKCAQEB+cHAQIAEgTAAQkxChEKCQQEB+cHAQIAARIEwAEKMAoQCggEBAfnBwECARIEwAEyQAoRCgkEBAfnBwECAQESBMABMkAKDwoHBAQH5wcBAxIEwAFDRwoOCgQEBAMAEgbBAQLGAQMKDQoFBAQDAAESBMEBChAKDgoGBAQDAAIAEgTCAQQfCg8KBwQEAwACAAQSBMIBBAwKDwoHBAQDAAIABRIEwgENEwoPCgcEBAMAAgABEgTCARQaCg8KBwQEAwACAAMSBMIBHR4KDgoGBAQDAAIBEgTDAQQeCg8KBwQEAwACAQQSBMMBBAwKDwoHBAQDAAIBBRIEwwENEwoPCgcEBAMAAgEBEgTDARQZCg8KBwQEAwACAQMSBMMBHB0KDgoGBAQDAAICEgTEAQQeCg8KBwQEAwACAgQSBMQBBAwKDwoHBAQDAAICBRIExAENEwoPCgcEBAMAAgIBEgTEARQZCg8KBwQEAwACAgMSBMQBHB0KDgoGBAQDAAIDEgTFAQQkCg8KBwQEAwACAwQSBMUBBAwKDwoHBAQDAAIDBRIExQENEwoPCgcEBAMAAgMBEgTFARQfCg8KBwQEAwACAwMSBMUBIiMKDAoEBAQCABIExwECGQoNCgUEBAIABBIExwECCgoNCgUEBAIABRIExwELEQoNCgUEBAIAARIExwESFAoNCgUEBAIAAxIExwEXGAoMCgQEBAIBEgTIAQIcCg0KBQQEAgEEEgTIAQIKCg0KBQQEAgEFEgTIAQsRCg0KBQQEAgEBEgTIARIXCg0KBQQEAgEDEgTIARobCgwKBAQEAgISBMkBAh0KDQoFBAQCAgQSBMkBAgoKDQoFBAQCAgUSBMkBCxEKDQoFBAQCAgESBMkBEhgKDQoFBAQCAgMSBMkBGxwKDAoEBAQCAxIEygECHQoNCgUEBAIDBBIEygECCgoNCgUEBAIDBRIEygELEQoNCgUEBAIDARIEygESGAoNCgUEBAIDAxIEygEbHAoMCgQEBAIEEgTLAQIeCg0KBQQEAgQEEgTLAQIKCg0KBQQEAgQGEgTLAQsRCg0KBQQEAgQBEgTLARIZCg0KBQQEAgQDEgTLARwdCgwKAgUBEgbOAQDUAQEKCwoDBQEBEgTOAQUNCgsKAwUBAxIEzwEETgoOCgYFAQPnBwASBM8BBE4KDwoHBQED5wcAAhIEzwELRgoQCggFAQPnBwACABIEzwELMAoRCgkFAQPnBwACAAESBM8BDC8KEAoIBQED5wcAAgESBM8BMUYKEQoJBQED5wcAAgEBEgTPATFGCg8KBwUBA+cHAAMSBM8BSU0KCwoDBQEDEgTQAQRHCg4KBgUBA+cHARIE0AEERwoPCgcFAQPnBwECEgTQAQs/ChAKCAUBA+cHAQIAEgTQAQswChEKCQUBA+cHAQIAARIE0AEMLwoQCggFAQPnBwECARIE0AExPwoRCgkFAQPnBwECAQESBNABMT8KDwoHBQED5wcBAxIE0AFCRgoMCgQFAQIAEgTRAQIKCg0KBQUBAgABEgTRAQIFCg0KBQUBAgACEgTRAQgJCgwKBAUBAgESBNIBAgoKDQoFBQECAQESBNIBAgUKDQoFBQECAQISBNIBCAkKDAoEBQECAhIE0wECCgoNCgUFAQICARIE0wECBQoNCgUFAQICAhIE0wEICQoMCgIEBRIG1gEA2wEBCgsKAwQFARIE1gEIDQoLCgMEBQcSBNcBAk8KDgoGBAUH5wcAEgTXAQJPCg8KBwQFB+cHAAISBNcBCUcKEAoIBAUH5wcAAgASBNcBCTEKEQoJBAUH5wcAAgABEgTXAQowChAKCAQFB+cHAAIBEgTXATJHChEKCQQFB+cHAAIBARIE1wEyRwoPCgcEBQfnBwADEgTXAUpOCgsKAwQFBxIE2AECSAoOCgYEBQfnBwESBNgBAkgKDwoHBAUH5wcBAhIE2AEJQAoQCggEBQfnBwECABIE2AEJMQoRCgkEBQfnBwECAAESBNgBCjAKEAoIBAUH5wcBAgESBNgBMkAKEQoJBAUH5wcBAgEBEgTYATJACg8KBwQFB+cHAQMSBNgBQ0cKDAoEBAUCABIE2QECHQoNCgUEBQIABBIE2QECCgoNCgUEBQIABRIE2QELEQoNCgUEBQIAARIE2QESGAoNCgUEBQIAAxIE2QEbHAoMCgQEBQIBEgTaAQIfCg0KBQQFAgEEEgTaAQIKCg0KBQQFAgEFEgTaAQsRCg0KBQQFAgEBEgTaARIaCg0KBQQFAgEDEgTaAR0eCgwKAgQGEgbdAQDjAQEKCwoDBAYBEgTdAQgQCgsKAwQGBxIE3gECTwoOCgYEBgfnBwASBN4BAk8KDwoHBAYH5wcAAhIE3gEJRwoQCggEBgfnBwACABIE3gEJMQoRCgkEBgfnBwACAAESBN4BCjAKEAoIBAYH5wcAAgESBN4BMkcKEQoJBAYH5wcAAgEBEgTeATJHCg8KBwQGB+cHAAMSBN4BSk4KCwoDBAYHEgTfAQJICg4KBgQGB+cHARIE3wECSAoPCgcEBgfnBwECEgTfAQlAChAKCAQGB+cHAQIAEgTfAQkxChEKCQQGB+cHAQIAARIE3wEKMAoQCggEBgfnBwECARIE3wEyQAoRCgkEBgfnBwECAQESBN8BMkAKDwoHBAYH5wcBAxIE3wFDRwoMCgQEBgIAEgTgAQIfCg0KBQQGAgAEEgTgAQIKCg0KBQQGAgAFEgTgAQsRCg0KBQQGAgABEgTgARIaCg0KBQQGAgADEgTgAR0eCgwKBAQGAgESBOEBAiAKDQoFBAYCAQQSBOEBAgoKDQoFBAYCAQUSBOEBCxEKDQoFBAYCAQESBOEBEhsKDQoFBAYCAQMSBOEBHh8KDAoEBAYCAhIE4gECHwoNCgUEBgICBBIE4gECCgoNCgUEBgICBRIE4gELEQoNCgUEBgICARIE4gESGgoNCgUEBgICAxIE4gEdHgoMCgIEBxIG5QEA6wEBCgsKAwQHARIE5QEIEAoLCgMEBwcSBOYBAk8KDgoGBAcH5wcAEgTmAQJPCg8KBwQHB+cHAAISBOYBCUcKEAoIBAcH5wcAAgASBOYBCTEKEQoJBAcH5wcAAgABEgTmAQowChAKCAQHB+cHAAIBEgTmATJHChEKCQQHB+cHAAIBARIE5gEyRwoPCgcEBwfnBwADEgTmAUpOCgsKAwQHBxIE5wECSAoOCgYEBwfnBwESBOcBAkgKDwoHBAcH5wcBAhIE5wEJQAoQCggEBwfnBwECABIE5wEJMQoRCgkEBwfnBwECAAESBOcBCjAKEAoIBAcH5wcBAgESBOcBMkAKEQoJBAcH5wcBAgEBEgTnATJACg8KBwQHB+cHAQMSBOcBQ0cKDAoEBAcCABIE6AECGQoNCgUEBwIABBIE6AECCgoNCgUEBwIABRIE6AELEQoNCgUEBwIAARIE6AESFAoNCgUEBwIAAxIE6AEXGAoMCgQEBwIBEgTpAQIeCg0KBQQHAgEEEgTpAQIKCg0KBQQHAgEFEgTpAQsRCg0KBQQHAgEBEgTpARIZCg0KBQQHAgEDEgTpARwdCgwKBAQHAgISBOoBAhsKDQoFBAcCAgQSBOoBAgoKDQoFBAcCAgUSBOoBCxEKDQoFBAcCAgESBOoBEhYKDQoFBAcCAgMSBOoBGRoKDAoCBAgSBu0BAPMBAQoLCgMECAESBO0BCBAKCwoDBAgHEgTuAQJPCg4KBgQIB+cHABIE7gECTwoPCgcECAfnBwACEgTuAQlHChAKCAQIB+cHAAIAEgTuAQkxChEKCQQIB+cHAAIAARIE7gEKMAoQCggECAfnBwACARIE7gEyRwoRCgkECAfnBwACAQESBO4BMkcKDwoHBAgH5wcAAxIE7gFKTgoLCgMECAcSBO8BAkgKDgoGBAgH5wcBEgTvAQJICg8KBwQIB+cHAQISBO8BCUAKEAoIBAgH5wcBAgASBO8BCTEKEQoJBAgH5wcBAgABEgTvAQowChAKCAQIB+cHAQIBEgTvATJAChEKCQQIB+cHAQIBARIE7wEyQAoPCgcECAfnBwEDEgTvAUNHCgwKBAQIAgASBPABAhsKDQoFBAgCAAQSBPABAgoKDQoFBAgCAAUSBPABCxEKDQoFBAgCAAESBPABEhYKDQoFBAgCAAMSBPABGRoKDAoEBAgCARIE8QECHgoNCgUECAIBBBIE8QECCgoNCgUECAIBBRIE8QELEQoNCgUECAIBARIE8QESGQoNCgUECAIBAxIE8QEcHQoMCgQECAICEgTyAQImCg0KBQQIAgIEEgTyAQIKCg0KBQQIAgIFEgTyAQsRCg0KBQQIAgIBEgTyARIhCg0KBQQIAgIDEgTyASQlCgwKAgQJEgb1AQD5AQEKCwoDBAkBEgT1AQgXCgwKBAQJAgASBPYBAhsKDQoFBAkCAAQSBPYBAgoKDQoFBAkCAAUSBPYBCxAKDQoFBAkCAAESBPYBERYKDQoFBAkCAAMSBPYBGRoKDAoEBAkCARIE9wECGgoNCgUECQIBBBIE9wECCgoNCgUECQIBBRIE9wELEAoNCgUECQIBARIE9wERFQoNCgUECQIBAxIE9wEYGQoMCgQECQICEgT4AQIaCg0KBQQJAgIEEgT4AQIKCg0KBQQJAgIFEgT4AQsRCg0KBQQJAgIBEgT4ARIVCg0KBQQJAgIDEgT4ARgZCgwKAgQKEgb8AQCAAgEKCwoDBAoBEgT8AQgNCgsKAwQKBxIE/QEEUQoOCgYECgfnBwASBP0BBFEKDwoHBAoH5wcAAhIE/QELSQoQCggECgfnBwACABIE/QELMwoRCgkECgfnBwACAAESBP0BDDIKEAoIBAoH5wcAAgESBP0BNEkKEQoJBAoH5wcAAgEBEgT9ATRJCg8KBwQKB+cHAAMSBP0BTFAKCwoDBAoHEgT+AQRKCg4KBgQKB+cHARIE/gEESgoPCgcECgfnBwECEgT+AQtCChAKCAQKB+cHAQIAEgT+AQszChEKCQQKB+cHAQIAARIE/gEMMgoQCggECgfnBwECARIE/gE0QgoRCgkECgfnBwECAQESBP4BNEIKDwoHBAoH5wcBAxIE/gFFSQoMCgQECgIAEgT/AQRgCg0KBQQKAgAEEgT/AQQMCg0KBQQKAgAFEgT/AQ0TCg0KBQQKAgABEgT/ARQZCg0KBQQKAgADEgT/ARwdCg0KBQQKAgAIEgT/AR5fChAKCAQKAgAI5wcAEgT/AR9eChEKCQQKAgAI5wcAAhIE/wEfVwoSCgoECgIACOcHAAIAEgT/AR9FChMKCwQKAgAI5wcAAgABEgT/ASBEChIKCgQKAgAI5wcAAgESBP8BRlcKEwoLBAoCAAjnBwACAQESBP8BRlcKEQoJBAoCAAjnBwADEgT/AVpeCgwKAgQLEgaCAgCOAgEKCwoDBAsBEgSCAggPCg4KBAQLAwASBoMCBIwCBQoNCgUECwMAARIEgwIMGgoOCgYECwMAAgASBIQCCCIKDwoHBAsDAAIABBIEhAIIEAoPCgcECwMAAgAFEgSEAhEXCg8KBwQLAwACAAESBIQCGB0KDwoHBAsDAAIAAxIEhAIgIQoOCgYECwMAAgESBIUCCCkKDwoHBAsDAAIBBBIEhQIIEAoPCgcECwMAAgEFEgSFAhEXCg8KBwQLAwACAQESBIUCGCQKDwoHBAsDAAIBAxIEhQInKAoOCgYECwMAAgISBIYCCCsKDwoHBAsDAAICBBIEhgIIEAoPCgcECwMAAgIFEgSGAhEXCg8KBwQLAwACAgESBIYCGCYKDwoHBAsDAAICAxIEhgIpKgoOCgYECwMAAgMSBIcCCCYKDwoHBAsDAAIDBBIEhwIIEAoPCgcECwMAAgMFEgSHAhEXCg8KBwQLAwACAwESBIcCGCEKDwoHBAsDAAIDAxIEhwIkJQoOCgYECwMAAgQSBIgCCCYKDwoHBAsDAAIEBBIEiAIIEAoPCgcECwMAAgQFEgSIAhEXCg8KBwQLAwACBAESBIgCGCEKDwoHBAsDAAIEAxIEiAIkJQoOCgYECwMAAgUSBIkCCCIKDwoHBAsDAAIFBBIEiQIIEAoPCgcECwMAAgUFEgSJAhEXCg8KBwQLAwACBQESBIkCGB0KDwoHBAsDAAIFAxIEiQIgIQoOCgYECwMAAgYSBIoCCCUKDwoHBAsDAAIGBBIEigIIEAoPCgcECwMAAgYFEgSKAhEXCg8KBwQLAwACBgESBIoCGCAKDwoHBAsDAAIGAxIEigIjJAoOCgYECwMAAgcSBIsCCCEKDwoHBAsDAAIHBBIEiwIIEAoPCgcECwMAAgcFEgSLAhEXCg8KBwQLAwACBwESBIsCGBwKDwoHBAsDAAIHAxIEiwIfIAoMCgQECwIAEgSNAgQoCg0KBQQLAgAEEgSNAgQMCg0KBQQLAgAGEgSNAg0bCg0KBQQLAgABEgSNAhwjCg0KBQQLAgADEgSNAiYnesIQChFNb2RlbEZyaWVuZC5wcm90bxIIUHJvdG9BcGkaJmdvb2dsZS9wcm90b2J1Zi9zd2lmdC1kZXNjcmlwdG9yLnByb3RvGhFNb2RlbERvbWFpbi5wcm90byK2AwoGRnJpZW5kEh4KAmlkGAEgAigJQg7S27oTAhAB0tu6EwIIAVICaWQSHAoJZmlyc3ROYW1lGAIgASgJUglmaXJzdE5hbWUSGgoIbGFzdE5hbWUYAyABKAlSCGxhc3ROYW1lEhQKBXBob25lGAQgASgJUgVwaG9uZRIoCg9maXJzdE5hbWVEYXRpdmUYBSABKAlSD2ZpcnN0TmFtZURhdGl2ZRImCg5sYXN0TmFtZURhdGl2ZRgGIAEoCVIObGFzdE5hbWVEYXRpdmUSLAoRZmlyc3ROYW1lR2VuaXRpdmUYByABKAlSEWZpcnN0TmFtZUdlbml0aXZlEioKEGxhc3ROYW1lR2VuaXRpdmUYCCABKAlSEGxhc3ROYW1lR2VuaXRpdmUSKAoGYXZhdGFyGAkgAigLMhAuUHJvdG9BcGkuQXZhdGFyUgZhdmF0YXISKAoGZ2VuZGVyGAogAigOMhAuUHJvdG9BcGkuR2VuZGVyUgZnZW5kZXISLAoRbGFzdE9wZXJhdGlvbkRhdGUYCyABKAVSEWxhc3RPcGVyYXRpb25EYXRlOg7K27oTAhABytu6EwIYAUIlCiFydS5yb2NrZXRiYW5rLnByb3RvbW9kZWwuUHJvdG9BcGlQAUqHDAoGEgQAABgBCggKAQwSAwAAEgoJCgIDABIDAgcvCgkKAgMBEgMDBxoKCAoBAhIDBQgQCggKAQgSAwYAOgoLCgQI5wcAEgMGADoKDAoFCOcHAAISAwYHEwoNCgYI5wcAAgASAwYHEwoOCgcI5wcAAgABEgMGBxMKDAoFCOcHAAcSAwYWOQoICgEIEgMHACIKCwoECOcHARIDBwAiCgwKBQjnBwECEgMHBxoKDQoGCOcHAQIAEgMHBxoKDgoHCOcHAQIAARIDBwcaCgwKBQjnBwEDEgMHHSEKCgoCBAASBAoAGAEKCgoDBAABEgMKCA4KCgoDBAAHEgMLBFEKDQoGBAAH5wcAEgMLBFEKDgoHBAAH5wcAAhIDCwtJCg8KCAQAB+cHAAIAEgMLCzMKEAoJBAAH5wcAAgABEgMLDDIKDwoIBAAH5wcAAgESAws0SQoQCgkEAAfnBwACAQESAws0SQoOCgcEAAfnBwADEgMLTFAKCgoDBAAHEgMMBEoKDQoGBAAH5wcBEgMMBEoKDgoHBAAH5wcBAhIDDAtCCg8KCAQAB+cHAQIAEgMMCzMKEAoJBAAH5wcBAgABEgMMDDIKDwoIBAAH5wcBAgESAww0QgoQCgkEAAfnBwECAQESAww0QgoOCgcEAAfnBwEDEgMMRUkKDAoEBAACABIEDQSkAQoMCgUEAAIABBIDDQQMCgwKBQQAAgAFEgMNDRMKDAoFBAACAAESAw0UFgoMCgUEAAIAAxIDDRkaCg0KBQQAAgAIEgQNG6MBCg8KCAQAAgAI5wcAEgMNHFsKEAoJBAACAAjnBwACEgMNHFQKEQoKBAACAAjnBwACABIDDRxCChIKCwQAAgAI5wcAAgABEgMNHUEKEQoKBAACAAjnBwACARIDDUNUChIKCwQAAgAI5wcAAgEBEgMNQ1QKEAoJBAACAAjnBwADEgMNV1sKEAoIBAACAAjnBwESBA1dogEKEQoJBAACAAjnBwECEgQNXZsBChIKCgQAAgAI5wcBAgASBA1dgwEKEwoLBAACAAjnBwECAAESBA1eggEKEwoKBAACAAjnBwECARIFDYQBmwEKFAoLBAACAAjnBwECAQESBQ2EAZsBChIKCQQAAgAI5wcBAxIFDZ4BogEKCwoEBAACARIDDgQiCgwKBQQAAgEEEgMOBAwKDAoFBAACAQUSAw4NEwoMCgUEAAIBARIDDhQdCgwKBQQAAgEDEgMOICEKCwoEBAACAhIDDwQhCgwKBQQAAgIEEgMPBAwKDAoFBAACAgUSAw8NEwoMCgUEAAICARIDDxQcCgwKBQQAAgIDEgMPHyAKCwoEBAACAxIDEAQeCgwKBQQAAgMEEgMQBAwKDAoFBAACAwUSAxANEwoMCgUEAAIDARIDEBQZCgwKBQQAAgMDEgMQHB0KCwoEBAACBBIDEQQoCgwKBQQAAgQEEgMRBAwKDAoFBAACBAUSAxENEwoMCgUEAAIEARIDERQjCgwKBQQAAgQDEgMRJicKCwoEBAACBRIDEgQnCgwKBQQAAgUEEgMSBAwKDAoFBAACBQUSAxINEwoMCgUEAAIFARIDEhQiCgwKBQQAAgUDEgMSJSYKCwoEBAACBhIDEwQqCgwKBQQAAgYEEgMTBAwKDAoFBAACBgUSAxMNEwoMCgUEAAIGARIDExQlCgwKBQQAAgYDEgMTKCkKCwoEBAACBxIDFAQpCgwKBQQAAgcEEgMUBAwKDAoFBAACBwUSAxQNEwoMCgUEAAIHARIDFBQkCgwKBQQAAgcDEgMUJygKCwoEBAACCBIDFQQfCgwKBQQAAggEEgMVBAwKDAoFBAACCAYSAxUNEwoMCgUEAAIIARIDFRQaCgwKBQQAAggDEgMVHR4KCwoEBAACCRIDFgQgCgwKBQQAAgkEEgMWBAwKDAoFBAACCQYSAxYNEwoMCgUEAAIJARIDFhQaCgwKBQQAAgkDEgMWHR8KCwoEBAACChIDFwQqCgwKBQQAAgoEEgMXBAwKDAoFBAACCgUSAxcNEgoMCgUEAAIKARIDFxMkCgwKBQQAAgoDEgMXJyl6wwwKFU1vZGVsR3JhcGhQb2ludC5wcm90bxIIUHJvdG9BcGkaJmdvb2dsZS9wcm90b2J1Zi9zd2lmdC1kZXNjcmlwdG9yLnByb3RvIr8BCgxCYWxhbmNlR3JhcGgSRAoLZ3JhbnVsYXJpdHkYASACKA4yIi5Qcm90b0FwaS5CYWxhbmNlR3JhcGguR3JhbnVsYXJpdHlSC2dyYW51bGFyaXR5EiwKBnBvaW50cxgCIAMoCzIULlByb3RvQXBpLkdyYXBoUG9pbnRSBnBvaW50cyIrCgtHcmFudWxhcml0eRIHCgNEQVkQABIICgRXRUVLEAESCQoFTU9OVEgQAjoOytu6EwIQAcrbuhMCGAEiUAoKR3JhcGhQb2ludBIcCgl0aW1lc3RhbXAYASACKAVSCXRpbWVzdGFtcBIUCgVwb2ludBgCIAIoAVIFcG9pbnQ6DsrbuhMCEAHK27oTAhgBQiUKIXJ1LnJvY2tldGJhbmsucHJvdG9tb2RlbC5Qcm90b0FwaVABSrwJCgYSBAAAGgEKCAoBDBIDAAASCgkKAgMAEgMCBy8KCAoBAhIDBAgQCggKAQgSAwUAOgoLCgQI5wcAEgMFADoKDAoFCOcHAAISAwUHEwoNCgYI5wcAAgASAwUHEwoOCgcI5wcAAgABEgMFBxMKDAoFCOcHAAcSAwUWOQoICgEIEgMGACIKCwoECOcHARIDBgAiCgwKBQjnBwECEgMGBxoKDQoGCOcHAQIAEgMGBxoKDgoHCOcHAQIAARIDBgcaCgwKBQjnBwEDEgMGHSEKCgoCBAASBAgAEwEKCgoDBAABEgMICBQKCgoDBAAHEgMJBFEKDQoGBAAH5wcAEgMJBFEKDgoHBAAH5wcAAhIDCQtJCg8KCAQAB+cHAAIAEgMJCzMKEAoJBAAH5wcAAgABEgMJDDIKDwoIBAAH5wcAAgESAwk0SQoQCgkEAAfnBwACAQESAwk0SQoOCgcEAAfnBwADEgMJTFAKCgoDBAAHEgMKBEoKDQoGBAAH5wcBEgMKBEoKDgoHBAAH5wcBAhIDCgtCCg8KCAQAB+cHAQIAEgMKCzMKEAoJBAAH5wcBAgABEgMKDDIKDwoIBAAH5wcBAgESAwo0QgoQCgkEAAfnBwECAQESAwo0QgoOCgcEAAfnBwEDEgMKRUkKDAoEBAAEABIECwIPAwoMCgUEAAQAARIDCwcSCg0KBgQABAACABIDDAQMCg4KBwQABAACAAESAwwEBwoOCgcEAAQAAgACEgMMCgsKDQoGBAAEAAIBEgMNBA0KDgoHBAAEAAIBARIDDQQICg4KBwQABAACAQISAw0LDAoNCgYEAAQAAgISAw4EDgoOCgcEAAQAAgIBEgMOBAkKDgoHBAAEAAICAhIDDgwNCgsKBAQAAgASAxECJwoMCgUEAAIABBIDEQIKCgwKBQQAAgAGEgMRCxYKDAoFBAACAAESAxEXIgoMCgUEAAIAAxIDESUmCgsKBAQAAgESAxICIQoMCgUEAAIBBBIDEgIKCgwKBQQAAgEGEgMSCxUKDAoFBAACAQESAxIWHAoMCgUEAAIBAxIDEh8gCgoKAgQBEgQVABoBCgoKAwQBARIDFQgSCgoKAwQBBxIDFgRRCg0KBgQBB+cHABIDFgRRCg4KBwQBB+cHAAISAxYLSQoPCggEAQfnBwACABIDFgszChAKCQQBB+cHAAIAARIDFgwyCg8KCAQBB+cHAAIBEgMWNEkKEAoJBAEH5wcAAgEBEgMWNEkKDgoHBAEH5wcAAxIDFkxQCgoKAwQBBxIDFwRKCg0KBgQBB+cHARIDFwRKCg4KBwQBB+cHAQISAxcLQgoPCggEAQfnBwECABIDFwszChAKCQQBB+cHAQIAARIDFwwyCg8KCAQBB+cHAQIBEgMXNEIKEAoJBAEH5wcBAgEBEgMXNEIKDgoHBAEH5wcBAxIDF0VJCgsKBAQBAgASAxgCHwoMCgUEAQIABBIDGAIKCgwKBQQBAgAFEgMYCxAKDAoFBAECAAESAxgRGgoMCgUEAQIAAxIDGB0eCgsKBAQBAgESAxkCHAoMCgUEAQIBBBIDGQIKCgwKBQQBAgEFEgMZCxEKDAoFBAECAQESAxkSFwoMCgUEAQIBAxIDGRobevcjChFNb2RlbFRhcmlmZi5wcm90bxIIUHJvdG9BcGkaJmdvb2dsZS9wcm90b2J1Zi9zd2lmdC1kZXNjcmlwdG9yLnByb3RvGhFNb2RlbERvbWFpbi5wcm90byLhAgoKQ2FyZFRhcmlmZhISCgR0eXBlGAEgAigJUgR0eXBlEhIKBG5hbWUYAiACKAlSBG5hbWUSJQoFcHJpY2UYAyACKAsyDy5Qcm90b0FwaS5Nb25leVIFcHJpY2USJwoGY29sb3JzGAQgAygLMg8uUHJvdG9BcGkuQ29sb3JSBmNvbG9ycxIsChF0YXJpZmZEZXNjcmlwdGlvbhgFIAIoCVIRdGFyaWZmRGVzY3JpcHRpb24SMgoUdGFyaWZmRGVzY3JpcHRpb25VcmwYBiACKAlSFHRhcmlmZkRlc2NyaXB0aW9uVXJsEi4KCGN1cnJlbmN5GAcgAigOMhIuUHJvdG9BcGkuQ3VycmVuY3lSCGN1cnJlbmN5EhIKBHJhdGUYCCACKAFSBHJhdGUSJQoJcGVybWFsaW5rGAkgAigJQgfS27oTAhABUglwZXJtYWxpbms6DsrbuhMCEAHK27oTAhgBIvABCg1EZXBvc2l0VGFyaWZmEi0KCW1pbkFtb3VudBgBIAIoCzIPLlByb3RvQXBpLk1vbmV5UgltaW5BbW91bnQSLQoJbWF4QW1vdW50GAIgASgLMg8uUHJvdG9BcGkuTW9uZXlSCW1heEFtb3VudBISCgRyYXRlGAMgAigBUgRyYXRlEhYKBnBlcmlvZBgEIAIoBVIGcGVyaW9kEh4KCnJlZmlsbGFibGUYBSACKAhSCnJlZmlsbGFibGUSJQoJcGVybWFsaW5rGAYgAigJQgfS27oTAhABUglwZXJtYWxpbms6DsrbuhMCEAHK27oTAhgBIo4BChFTYWZlQWNjb3VudFRhcmlmZhIuCghjdXJyZW5jeRgBIAIoDjISLlByb3RvQXBpLkN1cnJlbmN5UghjdXJyZW5jeRISCgRyYXRlGAIgAigBUgRyYXRlEiUKCXBlcm1hbGluaxgDIAIoCUIH0tu6EwIQAVIJcGVybWFsaW5rOg7K27oTAhABytu6EwIYASKaAgoHVGFyaWZmcxI2CgtjYXJkVGFyaWZmcxgBIAMoCzIULlByb3RvQXBpLkNhcmRUYXJpZmZSC2NhcmRUYXJpZmZzEj8KDmRlcG9zaXRUYXJpZmZzGAIgAygLMhcuUHJvdG9BcGkuRGVwb3NpdFRhcmlmZlIOZGVwb3NpdFRhcmlmZnMSSwoSc2FmZUFjY291bnRUYXJpZmZzGAMgAygLMhsuUHJvdG9BcGkuU2FmZUFjY291bnRUYXJpZmZSEnNhZmVBY2NvdW50VGFyaWZmcxI5ChNwcm9kdWN0c1RhcmlmZnNIYXNoGAQgAigJQgfS27oTAhABUhNwcm9kdWN0c1RhcmlmZnNIYXNoOg7K27oTAhABytu6EwIYAUIlCiFydS5yb2NrZXRiYW5rLnByb3RvbW9kZWwuUHJvdG9BcGlQAUrwGgoGEgQAADUBCggKAQwSAwAAEgoJCgIDABIDAgcvCgkKAgMBEgMDBxoKCAoBAhIDBQgQCggKAQgSAwYAOgoLCgQI5wcAEgMGADoKDAoFCOcHAAISAwYHEwoNCgYI5wcAAgASAwYHEwoOCgcI5wcAAgABEgMGBxMKDAoFCOcHAAcSAwYWOQoICgEIEgMHACIKCwoECOcHARIDBwAi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cXVpc2l0ZXMSPAoMZW5SZXF1aXNpdGVzGAggASgLMhYuUHJvdG9BcGkuRW5SZXF1aXNpdGVzSAFSDGVuUmVxdWlzaXRlcyI2CgtQcm9kdWN0VHlwZRILCgdERVBPU0lUEAASCAoEQ0FSRBABEhAKDFNBRkVfQUNDT1VOVBACOiHK27oTAhABytu6EwIYAcrbuhMOIgxSZWFsbVByb2R1Y3RCDAoKb25lUHJvZHVjdEIMCgpyZXF1aXNpdGVzIoEFCgRDYXJkEg4KAmlkGAEgAigJUgJpZBIpCgdiYWxhbmNlGAIgAigLMg8uUHJvdG9BcGkuTW9uZXlSB2JhbGFuY2USFAoFdGl0bGUYAyACKAlSBXRpdGxlEhAKA3BhbhgEIAEoCVIDcGFuEh4KCmNhcmRIb2xkZXIYBSABKAlSCmNhcmRIb2xkZXISMQoJdmFsaWRUaHJ1GAYgASgLMhMuUHJvdG9BcGkuVmFsaWRUaHJ1Ugl2YWxpZFRocnUSLQoGc3RhdHVzGAcgAigOMhUuUHJvdG9BcGkuQ2FyZC5TdGF0dXNSBnN0YXR1cxItCgZkZXNpZ24YCCACKA4yFS5Qcm90b0FwaS5DYXJkLkRlc2lnblIGZGVzaWduEhIKBG1haW4YCSACKAhSBG1haW4SGgoIb3BlbmVkQXQYCiACKAVSCG9wZW5lZEF0EhwKCWhhc0ZhaWxlZBgLIAEoCFIJaGFzRmFpbGVkEiwKBnRhcmlmZhgMIAEoCzIULlByb3RvQXBpLkNhcmRUYXJpZmZSBnRhcmlmZhJDCg9hdG1DYXNob3V0c0luZm8YDSACKAsyGS5Qcm90b0FwaS5BdG1DYXNob3V0c0luZm9SD2F0bUNhc2hvdXRzSW5mbyJHCgZTdGF0dXMSCgoGQUNUSVZFEAASEwoPQkxPQ0tFRF9CWV9VU0VSEAESEwoPQkxPQ0tFRF9CWV9CQU5LEAISBwoDTkVXEAMiSwoGRGVzaWduEgsKB0RFRkFVTFQQABIOCgpNRVRST1BPTElTEAESCgoGTEFNUEFTEAISCAoEU1RBUxADEg4KCk9ORVRXT1RSSVAQBDoOytu6EwIQAcrbuhMCGAEi6wIKB0RlcG9zaXQSDgoCaWQYASACKAlSAmlkEhQKBXRpdGxlGAIgAigJUgV0aXRsZRIpCgdiYWxhbmNlGAMgAigLMg8uUHJvdG9BcGkuTW9uZXlSB2JhbGFuY2USFAoFZW1vamkYBCACKAlSBWVtb2ppEhIKBHJhdGUYBSACKAFSBHJhdGUSFgoGcGVyaW9kGAYgAigFUgZwZXJpb2QSGgoIb3BlbmVkQXQYByACKAVSCG9wZW5lZEF0EhwKCWhhc0ZhaWxlZBgIIAEoCFIJaGFzRmFpbGVkEiUKBWNvbG9yGAkgAigLMg8uUHJvdG9BcGkuQ29sb3JSBWNvbG9yEisKCGdyYWRpZW50GAogAygLMg8uUHJvdG9BcGkuQ29sb3JSCGdyYWRpZW50Ei8KBnRhcmlmZhgLIAEoCzIXLlByb3RvQXBpLkRlcG9zaXRUYXJpZmZSBnRhcmlmZjoOytu6EwIQAcrbuhMCGAEixwIKC1NhZmVBY2NvdW50Eg4KAmlkGAEgAigJUgJpZBIpCgdiYWxhbmNlGAIgAigLMg8uUHJvdG9BcGkuTW9uZXlSB2JhbGFuY2USFAoFdGl0bGUYAyACKAlSBXRpdGxlEhQKBWVtb2ppGAQgAigJUgVlbW9qaRIaCghvcGVuZWRBdBgFIAIoBVIIb3BlbmVkQXQSHAoJaGFzRmFpbGVkGAYgASgIUgloYXNGYWlsZWQSJQoFY29sb3IYByACKAsyDy5Qcm90b0FwaS5Db2xvclIFY29sb3ISKwoIZ3JhZGllbnQYCCADKAsyDy5Qcm90b0FwaS5Db2xvclIIZ3JhZGllbnQSMwoGdGFyaWZmGAkgASgLMhsuUHJvdG9BcGkuU2FmZUFjY291bnRUYXJpZmZSBnRhcmlmZjoOytu6EwIQAcrbuhMCGAEiRQoJVmFsaWRUaHJ1EhIKBHllYXIYASACKAVSBHllYXISFAoFbW9udGgYAiACKAVSBW1vbnRoOg7K27oTAhABytu6EwIYASKJAQoPQXRtQ2FzaG91dHNJbmZvEiAKC21heENhc2hvdXRzGAEgAigFUgttYXhDYXNob3V0cxIiCgxsZWZ0Q2FzaG91dHMYAiACKAVSDGxlZnRDYXNob3V0cxIgCgtpc1VubGltaXRlZBgDIAIoCFILaXNVbmxpbWl0ZWQ6DsrbuhMCEAHK27oTAhgBQiUKIXJ1LnJvY2tldGJhbmsucHJvdG9tb2RlbC5Qcm90b0FwaVABSpQwCgYSBAAAcQEKCAoBDBIDAAAS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ZXJpb2QSPwoGcGVyaW9kGAEgASgLMiUuUHJvdG9BcGkuUmVtaXR0YW5jZS5UYXhQZXJpb2QuUGVyaW9kSABSBnBlcmlvZBIUCgRkYXRlGAIgASgFSABSBGRhdGUSGAoGY3VzdG9tGAMgASgJSABSBmN1c3RvbRrEAQoGUGVyaW9kElAKCnBlcmlvZFR5cGUYASACKA4yMC5Qcm90b0FwaS5SZW1pdHRhbmNlLlRheFBlcmlvZC5QZXJpb2QuUGVyaW9kVHlwZVIKcGVyaW9kVHlwZRIWCgZwZXJpb2QYAiABKAVSBnBlcmlvZBISCgR5ZWFyGAMgAigFUgR5ZWFyIjwKClBlcmlvZFR5cGUSCQoFTU9OVEgQABILCgdRVUFSVEVSEAESDAoISEFMRllFQVIQAhIICgRZRUFSEANCDQoLcGVyaW9kVmFsdWUafAoKQ29tbW9uRGF0YRIQCgNiaWMYASACKAlSA2JpYxIkCg1hY2NvdW50TnVtYmVyGAIgAigJUg1hY2NvdW50TnVtYmVyEhwKCXJlY2lwaWVudBgDIAIoCVIJcmVjaXBpZW50EhgKB3B1cnBvc2UYBCABKAlSB3B1cnBvc2UaRwoMUGVyc29uYWxEYXRhEjcKBmNvbW1vbhgBIAIoCzIfLlByb3RvQXBpLlJlbWl0dGFuY2UuQ29tbW9uRGF0YVIGY29tbW9uGmwKDUNvcnBvcmF0ZURhdGESNwoGY29tbW9uGAEgAigLMh8uUHJvdG9BcGkuUmVtaXR0YW5jZS5Db21tb25EYXRhUgZjb21tb24SEAoDaW5uGAIgAigJUgNpbm4SEAoDa3BwGAMgASgJUgNrcHAa9QIKCkJ1ZGdldERhdGESNwoGY29tbW9uGAEgAigLMh8uUHJvdG9BcGkuUmVtaXR0YW5jZS5Db21tb25EYXRhUgZjb21tb24SEAoDaW5uGAIgAigJUgNpbm4SEAoDa3BwGAMgAigJUgNrcHASEAoDa2JrGAQgASgJUgNrYmsSFAoFb2t0bW8YBSACKAlSBW9rdG1vEhAKA3VpbhgGIAEoCVIDdWluEjwKCXRheFN0YXR1cxgHIAEoDjIeLlByb3RvQXBpLlJlbWl0dGFuY2UuVGF4U3RhdHVzUgl0YXhTdGF0dXMSPAoJdGF4UmVhc29uGAggASgOMh4uUHJvdG9BcGku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Cg4KBwQAAwUCCAESA3EXIAoOCgcEAAMFAggDEgNxIyQKDQoGBAADBQIJEgNyBCAKDgoHBAADBQIJBBIDcgQMCg4KBwQAAwUCCQUSA3INEwoOCgcEAAMFAgkBEgNyFBoKDgoHBAADBQIJAxIDch0fevksChRNb2RlbFByb3ZpZGVycy5wcm90bxIIUHJvdG9BcGkaJmdvb2dsZS9wcm90b2J1Zi9zd2lmdC1kZXNjcmlwdG9yLnByb3RvGhFNb2RlbERvbWFpbi5wcm90byL3BgoPUGF5bWVudFByb3ZpZGVyEg4KAmlkGAEgAigJUgJpZBIbCgRuYW1lGAIgAigJQgfS27oTAggBUgRuYW1lEhgKB2ljb25VcmwYAyABKAlSB2ljb25VcmwSEAoDbWluGAQgAigBUgNtaW4SEAoDbWF4GAUgAigBUgNtYXgSJAoNZml4Q29tbWlzc2lvbhgGIAIoAVINZml4Q29tbWlzc2lvbhIsChFwZXJjZW50Q29tbWlzc2lvbhgHIAIoAVIRcGVyY2VudENvbW1pc3Npb24SNwoGZmllbGRzGAggAygLMh8uUHJvdG9BcGkuUGF5bWVudFByb3ZpZGVyLkZpZWxkUgZmaWVsZHMSGAoHd2l0aERvdBgJIAIoCFIHd2l0aERvdBIeCgp1c2FnZUNvdW50GAogAigDUgp1c2FnZUNvdW50GqEECgVGaWVsZBISCgRuYW1lGAEgAigJUgRuYW1lEiAKC2Rpc3BsYXlOYW1lGAIgASgJUgtkaXNwbGF5TmFtZRIaCghwcmlvcml0eRgEIAIoBVIIcHJpb3JpdHkSUAoMa2V5Ym9hcmRLaW5kGAUgASgOMiwuUHJvdG9BcGkuUGF5bWVudFByb3ZpZGVyLkZpZWxkLktleWJvYXJkS2luZFIMa2V5Ym9hcmRLaW5kEkcKCWZpZWxkS2luZBgGIAEoDjIpLlByb3RvQXBpLlBheW1lbnRQcm92aWRlci5GaWVsZC5GaWVsZEtpbmRSCWZpZWxkS2luZBIgCgtwbGFjZWhvbGRlchgHIAEoCVILcGxhY2Vob2xkZXISGgoIcmVxdWlyZWQYCCACKAhSCHJlcXVpcmVkEhgKB3Zpc2libGUYCSACKAhSB3Zpc2libGUSEAoDdGlwGAogASgJUgN0aXASGAoHcGF0dGVybhgLIAEo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chIcCglhdmFpbGFibGUYCCACKAhSCWF2YWlsYWJsZRIcCglzdHJ1Y3R1cmUYCSABKAlSCXN0cnVjdHVyZRI4CgVzaXplcxgKIAMoDjIiLlByb3RvQXBpLlJvY2tldHNob3AuU2hvcEl0ZW0uU2l6ZVIFc2l6ZXMSQAoJY2FydEltYWdlGAsgAigLMiIuUHJvdG9BcGkuUm9ja2V0c2hvcC5TaG9wSXRlbUltYWdlUgljYXJ0SW1hZ2USOgoGaW1hZ2VzGAwgAygLMiIuUHJvdG9BcGkuUm9ja2V0c2hvcC5TaG9wSXRlbUltYWdlUgZpbWFnZXMSJAoNc2l6ZXNUYWJsZVVybBgNIAEoCVINc2l6ZXNUYWJsZVVybBJACglmZWVkSW1hZ2UYDiABKAsyIi5Qcm90b0FwaS5Sb2NrZXRzaG9wLlNob3BJdGVtSW1hZ2VSCWZlZWRJbWFnZRJCCghmZWVkU2l6ZRgPIAIoDjImLlByb3RvQXBpLlJvY2tldHNob3AuU2hvcEl0ZW0uRmVlZFNpemVSCGZlZWRTaXplEi8KCmJhY2tncm91bmQYECADKAsyDy5Qcm90b0FwaS5Db2xvclIKYmFja2dyb3VuZBIaCghwb3NpdGlvbhgRIAEoBVIIcG9zaXRpb24SLQoJdGV4dENvbG9yGBIgAigLMg8uUHJvdG9BcGkuQ29sb3JSCXRleHRDb2xvciI0CgRTaXplEgYKAlhTEAASBQoBUxABEgUKAU0QAhIFCgFMEAMSBgoCWEwQBBIHCgNYWEwQBSIqCghGZWVkU2l6ZRIHCgNCSUcQABIKCgZNRURJVU0QARIJCgVTTUFMTBACGioKDVNob3BJdGVtSW1hZ2USGQoDdXJsGAEgAigJQgfS27oTAhABUgN1cmw6DsrbuhMCEAHK27oTAhgBIukECg9Sb2NrZXRzaG9wT3JkZXISDgoCaWQYASACKAlSAmlkEjUKDXJvY2tldHJvdWJsZXMYAiACKAsyDy5Qcm90b0FwaS5Nb25leVINcm9ja2V0cm91YmxlcxI5CgVpdGVtcxgDIAMoCzIjLlByb3RvQXBpLlJvY2tldHNob3BPcmRlci5PcmRlckl0ZW1SBWl0ZW1zEj0KBnN0YXR1cxgEIAIoDjIlLlByb3RvQXBpLlJvY2tldHNob3BPcmRlci5PcmRlclN0YXR1c1IGc3RhdHVzGqECCglPcmRlckl0ZW0SDgoCaWQYASACKAlSAmlkEhQKBWNvdW50GAIgAigFUgVjb3VudBIUCgV0aXRsZRgDIAIoCVIFdGl0bGUSLwoKYmFja2dyb3VuZBgEIAMoCzIPLlByb3RvQXBpLkNvbG9yUgpiYWNrZ3JvdW5kEjUKDXJvY2tldHJvdWJsZXMYBSACKAsyDy5Qcm90b0FwaS5Nb25leVINcm9ja2V0cm91YmxlcxI2CgRzaXplGAYgASgOMiIuUHJvdG9BcGkuUm9ja2V0c2hvcC5TaG9wSXRlbS5TaXplUgRzaXplEjgKBWltYWdlGAcgAigLMiIuUHJvdG9BcGkuUm9ja2V0c2hvcC5TaG9wSXRlbUltYWdlUgVpbWFnZSJhCgtPcmRlclN0YXR1cxINCglJTklUSUFURUQQABIKCgZQQUNLRUQQARIMCghDQU5DRUxFRBACEg4KCkRFTElWRVJJTkcQAxINCglERUxJVkVSRUQQBBIKCgZGQUlMRUQQBToOytu6EwIQAcrbuhMCGAFCJQohcnUucm9ja2V0YmFuay5wcm90b21vZGVsLlByb3RvQXBpUAFKuCIKBhIEAABTAQoICgEMEgMAABIKCQoCAwASAwIHLwoJCgIDARIDAwcaCggKAQISAwUIEAoICgEIEgMGADoKCwoECOcHABIDBgA6CgwKBQjnBwACEgMGBxMKDQoGCOcHAAIAEgMGBxMKDgoHCOcHAAIAARIDBgcTCgwKBQjnBwAHEgMGFjkKCAoBCBIDBwAiCgsKBAjnBwESAwcAIgoMCgUI5wcBAhIDBwcaCg0KBgjnBwECABIDBwcaCg4KBwjnBwECAAESAwcHGgoMCgUI5wcBAxIDBx0hCgoKAgQAEgQKADcBCgoKAwQAARIDCggSCgoKAwQABxIDCwJPCg0KBgQAB+cHABIDCwJPCg4KBwQAB+cHAAISAwsJRwoPCggEAAfnBwACABIDCwkxChAKCQQAB+cHAAIAARIDCwowCg8KCAQAB+cHAAIBEgMLMkcKEAoJBAAH5wcAAgEBEgMLMkcKDgoHBAAH5wcAAxIDC0pOCgoKAwQABxIDDAJICg0KBgQAB+cHARIDDAJICg4KBwQAB+cHAQISAwwJQAoPCggEAAfnBwECABIDDAkxChAKCQQAB+cHAQIAARIDDAowCg8KCAQAB+cHAQIBEgMMMkAKEAoJBAAH5wcBAgEBEgMMMkAKDgoHBAAH5wcBAxIDDENHCgwKBAQAAwASBA0CLwMKDAoFBAADAAESAw0KEgoOCgYEAAMABAASBA8GFgcKDgoHBAADAAQAARIDDwsPCg8KCAQAAwAEAAIAEgMQChEKEAoJBAADAAQAAgABEgMQCgwKEAoJBAADAAQAAgACEgMQDxAKDwoIBAADAAQAAgESAxEKEAoQCgkEAAMABAACAQESAxEKCwoQCgkEAAMABAACAQISAxEODwoPCggEAAMABAACAhIDEgoQChAKCQQAAwAEAAICARIDEgoLChAKCQQAAwAEAAICAhIDEg4PCg8KCAQAAwAEAAIDEgMTChAKEAoJBAADAAQAAgMBEgMTCgsKEAoJBAADAAQAAgMCEgMTDg8KDwoIBAADAAQAAgQSAxQKEQoQCgkEAAMABAACBAESAxQKDAoQCgkEAAMABAACBAISAxQPEAoPCggEAAMABAACBRIDFQoSChAKCQQAAwAEAAIFARIDFQoNChAKCQQAAwAEAAIFAhIDFRARCg4KBgQAAwAEARIEGAYcBwoOCgcEAAMABAEBEgMYCxMKDwoIBAADAAQBAgASAxkIEAoQCgkEAAMABAECAAESAxkICwoQCgkEAAMABAECAAISAxkODwoPCggEAAMABAECARIDGggTChAKCQQAAwAEAQIBARIDGggOChAKCQQAAwAEAQIBAhIDGhESCg8KCAQAAwAEAQICEgMbCBIKEAoJBAADAAQBAgIBEgMbCA0KEAoJBAADAAQBAgICEgMbEBEKDQoGBAADAAIAEgMeBh0KDgoHBAADAAIABBIDHgYOCg4KBwQAAwACAAUSAx4PFQoOCgcEAAMAAgABEgMeFhgKDgoHBAADAAIAAxIDHhscCg0KBgQAAwACARIDHwYgCg4KBwQAAwACAQQSAx8GDgoOCgcEAAMAAgEFEgMfDxUKDgoHBAADAAIBARIDHxYbCg4KBwQAAwACAQMSAx8eHwoNCgYEAAMAAgISAyAGKgoOCgcEAAMAAgIEEgMgBg4KDgoHBAADAAICBRIDIA8VCg4KBwQAAwACAgESAyAWJQoOCgcEAAMAAgIDEgMgKCkKDQoGBAADAAIDEgMhBioKDgoHBAADAAIDBBIDIQYOCg4KBwQAAwACAwUSAyEPFQoOCgcEAAMAAgMBEgMhFiUKDgoHBAADAAIDAxIDISgpCg0KBgQAAwACBBIDIgYgCg4KBwQAAwACBAQSAyIGDgoOCgcEAAMAAgQGEgMiDxQKDgoHBAADAAIEARIDIhUbCg4KBwQAAwACBAMSAyIeHwoNCgYEAAMAAgUSAyMGKAoOCgcEAAMAAgUEEgMjBg4KDgoHBAADAAIFBRIDIw8VCg4KBwQAAwACBQESAyMWIwoOCgcEAAMAAgUDEgMjJicKDQoGBAADAAIGEgMkBiIKDgoHBAADAAIGBBIDJAYOCg4KBwQAAwACBgUSAyQPEwoOCgcEAAMAAgYBEgMkFB0KDgoHBAADAAIGAxIDJCAhCg0KBgQAAwACBxIDJQYkCg4KBwQAAwACBwQSAyUGDgoOCgcEAAMAAgcFEgMlDxUKDgoHBAADAAIHARIDJRYfCg4KBwQAAwACBwMSAyUiIwoNCgYEAAMAAggSAyYGHwoOCgcEAAMAAggEEgMmBg4KDgoHBAADAAIIBhIDJg8TCg4KBwQAAwACCAESAyYUGQoOCgcEAAMAAggDEgMmHB4KDQoGBAADAAIJEgMnBiwKDgoHBAADAAIJBBIDJwYOCg4KBwQAAwACCQYSAycPHAoOCgcEAAMAAgkBEgMnHSYKDgoHBAADAAIJAxIDJykrCg0KBgQAAwACChIDKAYpCg4KBwQAAwACCgQSAygGDgoOCgcEAAMAAgoGEgMoDxwKDgoHBAADAAIKARIDKB0jCg4KBwQAAwACCgMSAygmKAoNCgYEAAMAAgsSAykGKQoOCgcEAAMAAgsEEgMpBg4KDgoHBAADAAILBRIDKQ8VCg4KBwQAAwACCwESAykWIwoOCgcEAAMAAgsDEgMpJigKDQoGBAADAAIMEgMqBiwKDgoHBAADAAIMBBIDKgYOCg4KBwQAAwACDAYSAyoPHAoOCgcEAAMAAgwBEgMqHSYKDgoHBAADAAIMAxIDKikrCg0KBgQAAwACDRIDKwYmCg4KBwQAAwACDQQSAysGDgoOCgcEAAMAAg0GEgMrDxcKDgoHBAADAAINARIDKxggCg4KBwQAAwACDQMSAysjJQoNCgYEAAMAAg4SAywGJQoOCgcEAAMAAg4EEgMsBg4KDgoHBAADAAIOBhIDLA8UCg4KBwQAAwACDgESAywVHwoOCgcEAAMAAg4DEgMsIiQKDQoGBAADAAIPEgMtBiMKDgoHBAADAAIPBBIDLQYOCg4KBwQAAwACDwUSAy0PFAoOCgcEAAMAAg8BEgMtFR0KDgoHBAADAAIPAxIDLSAiCg0KBgQAAwACEBIDLgYkCg4KBwQAAwACEAQSAy4GDgoOCgcEAAMAAhAGEgMuDxQKDgoHBAADAAIQARIDLhUeCg4KBwQAAwACEAMSAy4hIwoMCgQEAAMBEgQxAjMDCgwKBQQAAwEBEgMxChcKDQoGBAADAQIAEgMyBmAKDgoHBAADAQIABBIDMgYOCg4KBwQAAwECAAUSAzIPFQoOCgcEAAMBAgABEgMyFhkKDgoHBAADAQIAAxIDMhwdCg4KBwQAAwECAAgSAzIeXwoRCgoEAAMBAgAI5wcAEgMyH14KEgoLBAADAQIACOcHAAISAzIfVwoTCgwEAAMBAgAI5wcAAgASAzIfRQoUCg0EAAMBAgAI5wcAAgABEgMyIEQKEwoMBAADAQIACOcHAAIBEgMyRlcKFAoNBAADAQIACOcHAAIBARIDMkZXChIKCwQAAwECAAjnBwADEgMyWl4KCwoEBAACABIDNQJnCgwKBQQAAgAEEgM1AgoKDAoFBAACAAUSAzULEQoMCgUEAAIAARIDNRIgCgwKBQQAAgADEgM1IyQKDAoFBAACAAgSAzUlZgoPCggEAAIACOcHABIDNSZlChAKCQQAAgAI5wcAAhIDNSZeChEKCgQAAgAI5wcAAgASAzUmTAoSCgsEAAIACOcHAAIAARIDNSdLChEKCgQAAgAI5wcAAgESAzVNXgoSCgsEAAIACOcHAAIBARIDNU1eChAKCQQAAgAI5wcAAxIDNWFlCgsKBAQAAgESAzYCLQoMCgUEAAIBBBIDNgIKCgwKBQQAAgEGEgM2Cx4KDAoFBAACAQESAzYfKAoMCgUEAAIBAxIDNissCgoKAgQBEgQ5AFMBCgoKAwQBARIDOQgXCgoKAwQBBxIDOgRRCg0KBgQBB+cHABIDOgRRCg4KBwQBB+cHAAISAzoLSQoPCggEAQfnBwACABIDOgszChAKCQQBB+cHAAIAARIDOgwyCg8KCAQBB+cHAAIBEgM6NEkKEAoJBAEH5wcAAgEBEgM6NEkKDgoHBAEH5wcAAxIDOkxQCgoKAwQBBxIDOwRKCg0KBgQBB+cHARIDOwRKCg4KBwQBB+cHAQISAzsLQgoPCggEAQfnBwECABIDOwszChAKCQQBB+cHAQIAARIDOwwyCg8KCAQBB+cHAQIBEgM7NEIKEAoJBAEH5wcBAgEBEgM7NEIKDgoHBAEH5wcBAxIDO0VJCgwKBAQBAwASBDwERAUKDAoFBAEDAAESAzwMFQoNCgYEAQMAAgASAz0IHwoOCgcEAQMAAgAEEgM9CBAKDgoHBAEDAAIABRIDPREXCg4KBwQBAwACAAESAz0YGgoOCgcEAQMAAgADEgM9HR4KDQoGBAEDAAIBEgM+CCEKDgoHBAEDAAIBBBIDPggQCg4KBwQBAwACAQUSAz4RFgoOCgcEAQMAAgEBEgM+FxwKDgoHBAEDAAIBAxIDPh8gCg0KBgQBAwACAhIDPwgiCg4KBwQBAwACAgQSAz8IEAoOCgcEAQMAAgIFEgM/ERcKDgoHBAEDAAICARIDPxgdCg4KBwQBAwACAgMSAz8gIQoNCgYEAQMAAgMSA0AIJgoOCgcEAQMAAgMEEgNACBAKDgoHBAEDAAIDBhIDQBEWCg4KBwQBAwACAwESA0AXIQoOCgcEAQMAAgMDEgNAJCUKDQoGBAEDAAIEEgNBCCkKDgoHBAEDAAIEBBIDQQgQCg4KBwQBAwACBAYSA0ERFgoOCgcEAQMAAgQBEgNBFyQKDgoHBAEDAAIEAxIDQScoCg0KBgQBAwACBRIDQggzCg4KBwQBAwACBQQSA0IIEAoOCgcEAQMAAgUGEgNCESkKDgoHBAEDAAIFARIDQiouCg4KBwQBAwACBQMSA0IxMgoNCgYEAQMAAgYSA0MINAoOCgcEAQMAAgYEEgNDCBAKDgoHBAEDAAIGBhIDQxEpCg4KBwQBAwACBgESA0MqLwoOCgcEAQMAAgYDEgNDMjMKDAoEBAEEABIERgRNBQoMCgUEAQQAARIDRgkUCg0KBgQBBAACABIDRwgWCg4KBwQBBAACAAESA0cIEQoOCgcEAQQAAgACEgNHFBUKDQoGBAEEAAIBEgNICBMKDgoHBAEEAAIBARIDSAgOCg4KBwQBBAACAQISA0gREgoNCgYEAQQAAgISA0kIFQoOCgcEAQQAAgIBEgNJCBAKDgoHBAEEAAICAhIDSRMUCg0KBgQBBAACAxIDSggXCg4KBwQBBAACAwESA0oIEgoOCgcEAQQAAgMCEgNKFRYKDQoGBAEEAAIEEgNLCBYKDgoHBAEEAAIEARIDSwgRCg4KBwQBBAACBAISA0sUFQoNCgYEAQQAAgUSA0wIEwoOCgcEAQQAAgUBEgNMCA4KDgoHBAEEAAIFAhIDTBESCgsKBAQBAgASA08EGwoMCgUEAQIABBIDTwQMCgwKBQQBAgAFEgNPDRMKDAoFBAECAAESA08UFgoMCgUEAQIAAxIDTxkaCgsKBAQBAgESA1AEJQoMCgUEAQIBBBIDUAQMCgwKBQQBAgEGEgNQDRIKDAoFBAECAQESA1ATIAoMCgUEAQIBAxIDUCMkCgsKBAQBAgISA1EEIQoMCgUEAQICBBIDUQQMCgwKBQQBAgIGEgNRDRYKDAoFBAECAgESA1EXHAoMCgUEAQICAxIDUR8gCgsKBAQBAgMSA1IEJAoMCgUEAQIDBBIDUgQMCgwKBQQBAgMGEgNSDRgKDAoFBAECAwESA1IZHwoMCgUEAQIDAxIDUiIjepHZAwoUTW9kZWxPcGVyYXRpb24ucHJvdG8SCFByb3RvQXBpGiZnb29nbGUvcHJvdG9idWYvc3dpZnQtZGVzY3JpcHRvci5wcm90bxoRTW9kZWxEb21haW4ucHJvdG8aEU1vZGVsRnJpZW5kLnByb3RvGhNNb2RlbFByb2R1Y3RzLnByb3RvGhVNb2RlbFJlbWl0dGFuY2UucHJvdG8aFE1vZGVsUHJvdmlkZXJzLnByb3RvGhVNb2RlbFJvY2tldHNob3AucHJvdG8igQEKDFRlbXBsYXRlRGF0YRIOCgJpZBgBIAIoCVICaWQSEgoEbmFtZRgCIAIoCVIEbmFtZRIUCgVlbW9qaRgDIAEoCVIFZW1vamkSJwoGY29sb3JzGAQgAygLMg8uUHJvdG9BcGkuQ29sb3JSBmNvbG9yczoOytu6EwIQAcrbuhMCGAEiTwoRT3BlcmF0aW9uQ2F0ZWdvcnkSEgoEbmFtZRgBIAIoCVIEbmFtZRIWCgZlbW9kamkYAiACKAlSBmVtb2RqaToOytu6EwIQAcrbuhMCGAEiXAoHUmVjZWlwdBISCgRuYW1lGAEgAigJUgRuYW1lEhAKA21jYxgCIAIoBVIDbWNjEhsKCWF1dGhfY29kZRgDIAIoBVIIYXV0aENvZGU6DsrbuhMCEAHK27oTAhgBIsACCg5JbnRlcm5hbFBUb1BJbhIOCgJpZBgBIAIoCVICaWQSEAoDcGFuGAIgAigJUgNwYW4SJgoEYmFuaxgDIAIoCzISLlByb3RvQXBpLkNhcmRCYW5rUgRiYW5rEjUKDWRpc3BsYXlBbW91bnQYBCACKAsyDy5Qcm90b0FwaS5Nb25leVINZGlzcGxheUFtb3VudBI1Cg1hY2NvdW50QW1vdW50GAUgAigLMg8uUHJvdG9BcGkuTW9uZXlSDWFjY291bnRBbW91bnQSHAoJb2NjdXJlZEF0GAYgAigFUglvY2N1cmVkQXQSGAoHY29tbWVudBgHIAEoCVIHY29tbWVudBIuCghsb2NhdGlvbhgIIAEoCzISLlByb3RvQXBpLkxvY2F0aW9uUghsb2NhdGlvbjoOytu6EwIQAcrbuhMCGAEi4QIKD0ludGVybmFsUFRvUE91dBIOCgJpZBgBIAIoCVICaWQSEAoDcGFuGAIgAigJUgNwYW4SJgoEYmFuaxgDIAIoCzISLlByb3RvQXBpLkNhcmRCYW5rUgRiYW5rEjUKDWRpc3BsYXlBbW91bnQYBCACKAsyDy5Qcm90b0FwaS5Nb25leVINZGlzcGxheUFtb3VudBI1Cg1hY2NvdW50QW1vdW50GAUgAigLMg8uUHJvdG9BcGkuTW9uZXlSDWFjY291bnRBbW91bnQSHAoJb2NjdXJlZEF0GAYgAigFUglvY2N1cmVkQXQSGAoHY29tbWVudBgHIAEoCVIHY29tbWVudBIuCghsb2NhdGlvbhgIIAEoCzISLlByb3RvQXBpLkxvY2F0aW9uUghsb2NhdGlvbhIeCgpyZWNlaXB0VXJsGAkgASgJUgpyZWNlaXB0VXJsOg7K27oTAhABytu6EwIYASLmAgoJQXRtQ2FzaEluEg4KAmlkGAEgAigJUgJpZBIuCghtZXJjaGFudBgCIAIoCzISLlByb3RvQXBpLk1lcmNoYW50UghtZXJjaGFudBI1Cg1kaXNwbGF5QW1vdW50GAMgAigLMg8uUHJvdG9BcGkuTW9uZXlSDWRpc3BsYXlBbW91bnQSNQoNYWNjb3VudEFtb3VudBgEIAIoCzIPLlByb3RvQXBpLk1vbmV5Ug1hY2NvdW50QW1vdW50EhwKCW9jY3VyZWRBdBgFIAIoBVIJb2NjdXJlZEF0EhgKB2NvbW1lbnQYBiABKAlSB2NvbW1lbnQSLgoIbG9jYXRpb24YByABKAsyEi5Qcm90b0FwaS5Mb2NhdGlvblIIbG9jYXRpb24SMwoMcnVibGVzQW1vdW50GAggAigLMg8uUHJvdG9BcGkuTW9uZXlSDHJ1Ymxlc0Ftb3VudDoOytu6EwIQAcrbuhMCGAEioAMKCkF0bUNhc2hPdXQSDgoCaWQYASACKAlSAmlkEi4KCG1lcmNoYW50GAIgAigLMhIuUHJvdG9BcGkuTWVyY2hhbnRSCG1lcmNoYW50EjUKDWRpc3BsYXlBbW91bnQYAyACKAsyDy5Qcm90b0FwaS5Nb25leVINZGlzcGxheUFtb3VudBI1Cg1hY2NvdW50QW1vdW50GAQgAigLMg8uUHJvdG9BcGkuTW9uZXlSDWFjY291bnRBbW91bnQSHAoJb2NjdXJlZEF0GAUgAigFUglvY2N1cmVkQXQSGAoHY29tbWVudBgGIAEoCVIHY29tbWVudBIuCghsb2NhdGlvbhgHIAEoCzISLlByb3RvQXBpLkxvY2F0aW9uUghsb2NhdGlvbhI3CghjYXRlZ29yeRgIIAEoCzIbLlByb3RvQXBpLk9wZXJhdGlvbkNhdGVnb3J5UghjYXRlZ29yeRIzCgxydWJsZXNBbW91bnQYCSACKAsyDy5Qcm90b0FwaS5Nb25leVIMcnVibGVzQW1vdW50Og7K27oTAhABytu6EwIYASLpAgoMT2ZmaWNlQ2FzaEluEg4KAmlkGAEgAigJUgJpZBIuCghtZXJjaGFudBgCIAIoCzISLlByb3RvQXBpLk1lcmNoYW50UghtZXJjaGFudBI1Cg1kaXNwbGF5QW1vdW50GAMgAigLMg8uUHJvdG9BcGkuTW9uZXlSDWRpc3BsYXlBbW91bnQSNQoNYWNjb3VudEFtb3VudBgEIAIoCzIPLlByb3RvQXBpLk1vbmV5Ug1hY2NvdW50QW1vdW50EhwKCW9jY3VyZWRBdBgFIAIoBVIJb2NjdXJlZEF0EhgKB2NvbW1lbnQYBiABKAlSB2NvbW1lbnQSLgoIbG9jYXRpb24YByABKAsyEi5Qcm90b0FwaS5Mb2NhdGlvblIIbG9jYXRpb24SMwoMcnVibGVzQW1vdW50GAggAigLMg8uUHJvdG9BcGkuTW9uZXlSDHJ1Ymxlc0Ftb3VudDoOytu6EwIQAcrbuhMCGAEi6wIKDlRyYW5zZmVyQ2FzaEluEg4KAmlkGAEgAigJUgJpZBIuCghtZXJjaGFudBgCIAIoCzISLlByb3RvQXBpLk1lcmNoYW50UghtZXJjaGFudBI1Cg1kaXNwbGF5QW1vdW50GAMgAigLMg8uUHJvdG9BcGkuTW9uZXlSDWRpc3BsYXlBbW91bnQSNQoNYWNjb3VudEFtb3VudBgEIAIoCzIPLlByb3RvQXBpLk1vbmV5Ug1hY2NvdW50QW1vdW50EhwKCW9jY3VyZWRBdBgFIAIoBVIJb2NjdXJlZEF0EhgKB2NvbW1lbnQYBiABKAlSB2NvbW1lbnQSLgoIbG9jYXRpb24YByABKAsyEi5Qcm90b0FwaS5Mb2NhdGlvblIIbG9jYXRpb24SMwoMcnVibGVzQW1vdW50GAggAigLMg8uUHJvdG9BcGkuTW9uZXlSDHJ1Ymxlc0Ftb3VudDoOytu6EwIQAcrbuhMCGAEi7AIKD01jYkNsaWVudENhc2hJbhIOCgJpZBgBIAIoCVICaWQSLgoIbWVyY2hhbnQYAiACKAsyEi5Qcm90b0FwaS5NZXJjaGFudFIIbWVyY2hhbnQSNQoNZGlzcGxheUFtb3VudBgDIAIoCzIPLlByb3RvQXBpLk1vbmV5Ug1kaXNwbGF5QW1vdW50EjUKDWFjY291bnRBbW91bnQYBCACKAsyDy5Qcm90b0FwaS5Nb25leVINYWNjb3VudEFtb3VudBIcCglvY2N1cmVkQXQYBSACKAVSCW9jY3VyZWRBdBIYCgdjb21tZW50GAYgASgJUgdjb21tZW50Ei4KCGxvY2F0aW9uGAcgASgLMhIuUHJvdG9BcGkuTG9jYXRpb25SCGxvY2F0aW9uEjMKDHJ1Ymxlc0Ftb3VudBgIIAIoCzIPLlByb3RvQXBpLk1vbmV5UgxydWJsZXNBbW91bnQ6DsrbuhMCEAHK27oTAhgBIvICChVDYXJkVG9DYXJkQ2FzaEluT3RoZXISDgoCaWQYASACKAlSAmlkEi4KCG1lcmNoYW50GAIgAigLMhIuUHJvdG9BcGkuTWVyY2hhbnRSCG1lcmNoYW50EjUKDWRpc3BsYXlBbW91bnQYAyACKAsyDy5Qcm90b0FwaS5Nb25leVINZGlzcGxheUFtb3VudBI1Cg1hY2NvdW50QW1vdW50GAQgAigLMg8uUHJvdG9BcGkuTW9uZXlSDWFjY291bnRBbW91bnQSHAoJb2NjdXJlZEF0GAUgAigFUglvY2N1cmVkQXQSGAoHY29tbWVudBgGIAEoCVIHY29tbWVudBIuCghsb2NhdGlvbhgHIAEoCzISLlByb3RvQXBpLkxvY2F0aW9uUghsb2NhdGlvbhIzCgxydWJsZXNBbW91bnQYCCACKAsyDy5Qcm90b0FwaS5Nb25leVIMcnVibGVzQW1vdW50Og7K27oTAhABytu6EwIYASK1AgoNRW1vbmV5UGF5bWVudBIOCgJpZBgBIAIoCVICaWQSLgoIbWVyY2hhbnQYAiACKAsyEi5Qcm90b0FwaS5NZXJjaGFudFIIbWVyY2hhbnQSNQoNZGlzcGxheUFtb3VudBgDIAIoCzIPLlByb3RvQXBpLk1vbmV5Ug1kaXNwbGF5QW1vdW50EjUKDWFjY291bnRBbW91bnQYBCACKAsyDy5Qcm90b0FwaS5Nb25leVINYWNjb3VudEFtb3VudBIcCglvY2N1cmVkQXQYBSACKAVSCW9jY3VyZWRBdBIYCgdjb21tZW50GAYgASgJUgdjb21tZW50Ei4KCGxvY2F0aW9uGAcgASgLMhIuUHJvdG9BcGkuTG9jYXRpb25SCGxvY2F0aW9uOg7K27oTAhABytu6EwIYASLpAgoMR29sZGVuQ2FzaEluEg4KAmlkGAEgAigJUgJpZBIuCghtZXJjaGFudBgCIAIoCzISLlByb3RvQXBpLk1lcmNoYW50UghtZXJjaGFudBI1Cg1kaXNwbGF5QW1vdW50GAMgAigLMg8uUHJvdG9BcGkuTW9uZXlSDWRpc3BsYXlBbW91bnQSNQoNYWNjb3VudEFtb3VudBgEIAIoCzIPLlByb3RvQXBpLk1vbmV5Ug1hY2NvdW50QW1vdW50EhwKCW9jY3VyZWRBdBgFIAIoBVIJb2NjdXJlZEF0EhgKB2NvbW1lbnQYBiABKAlSB2NvbW1lbnQSLgoIbG9jYXRpb24YByABKAsyEi5Qcm90b0FwaS5Mb2NhdGlvblIIbG9jYXRpb24SMwoMcnVibGVzQW1vdW50GAggAigLMg8uUHJvdG9BcGkuTW9uZXlSDHJ1Ymxlc0Ftb3VudDoOytu6EwIQAcrbuhMCGAEi8AIKE01jYldpdGhDb21wZW5zYXRpb24SDgoCaWQYASACKAlSAmlkEi4KCG1lcmNoYW50GAIgAigLMhIuUHJvdG9BcGkuTWVyY2hhbnRSCG1lcmNoYW50EjUKDWRpc3BsYXlBbW91bnQYAyACKAsyDy5Qcm90b0FwaS5Nb25leVINZGlzcGxheUFtb3VudBI1Cg1hY2NvdW50QW1vdW50GAQgAigLMg8uUHJvdG9BcGkuTW9uZXlSDWFjY291bnRBbW91bnQSHAoJb2NjdXJlZEF0GAUgAigFUglvY2N1cmVkQXQSGAoHY29tbWVudBgGIAEoCVIHY29tbWVudBIuCghsb2NhdGlvbhgHIAEoCzISLlByb3RvQXBpLkxvY2F0aW9uUghsb2NhdGlvbhIzCgxydWJsZXNBbW91bnQYCCACKAsyDy5Qcm90b0FwaS5Nb25leVIMcnVibGVzQW1vdW50Og7K27oTAhABytu6EwIYASK6AgoST3ZlcmRyYWZ0Q29taXNzaW9uEg4KAmlkGAEgAigJUgJpZBIuCghtZXJjaGFudBgCIAIoCzISLlByb3RvQXBpLk1lcmNoYW50UghtZXJjaGFudBI1Cg1kaXNwbGF5QW1vdW50GAMgAigLMg8uUHJvdG9BcGkuTW9uZXlSDWRpc3BsYXlBbW91bnQSNQoNYWNjb3VudEFtb3VudBgEIAIoCzIPLlByb3RvQXBpLk1vbmV5Ug1hY2NvdW50QW1vdW50EhwKCW9jY3VyZWRBdBgFIAIoBVIJb2NjdXJlZEF0EhgKB2NvbW1lbnQYBiABKAlSB2NvbW1lbnQSLgoIbG9jYXRpb24YByABKAsyEi5Qcm90b0FwaS5Mb2NhdGlvblIIbG9jYXRpb246DsrbuhMCEAHK27oTAhgBIr0CChVPdmVyZHJhZnRDb21wZW5zYXRpb24SDgoCaWQYASACKAlSAmlkEi4KCG1lcmNoYW50GAIgAigLMhIuUHJvdG9BcGkuTWVyY2hhbnRSCG1lcmNoYW50EjUKDWRpc3BsYXlBbW91bnQYAyACKAsyDy5Qcm90b0FwaS5Nb25leVINZGlzcGxheUFtb3VudBI1Cg1hY2NvdW50QW1vdW50GAQgAigLMg8uUHJvdG9BcGkuTW9uZXlSDWFjY291bnRBbW91bnQSHAoJb2NjdXJlZEF0GAUgAigFUglvY2N1cmVkQXQSGAoHY29tbWVudBgGIAEoCVIHY29tbWVudBIuCghsb2NhdGlvbhgHIAEoCzISLlByb3RvQXBpLkxvY2F0aW9uUghsb2NhdGlvbjoOytu6EwIQAcrbuhMCGAEi9wIKEENhcmRUb0NhcmRDYXNoSW4SDgoCaWQYASACKAlSAmlkEhAKA3BhbhgCIAIoCVIDcGFuEiYKBGJhbmsYAyACKAsyEi5Qcm90b0FwaS5DYXJkQmFua1IEYmFuaxI1Cg1kaXNwbGF5QW1vdW50GAQgAigLMg8uUHJvdG9BcGkuTW9uZXlSDWRpc3BsYXlBbW91bnQSNQoNYWNjb3VudEFtb3VudBgFIAIoCzIPLlByb3RvQXBpLk1vbmV5Ug1hY2NvdW50QW1vdW50EhwKCW9jY3VyZWRBdBgGIAIoBVIJb2NjdXJlZEF0EhgKB2NvbW1lbnQYByABKAlSB2NvbW1lbnQSLgoIbG9jYXRpb24YCCABKAsyEi5Qcm90b0FwaS5Mb2NhdGlvblIIbG9jYXRpb24SMwoMcnVibGVzQW1vdW50GAkgAigLMg8uUHJvdG9BcGkuTW9uZXlSDHJ1Ymxlc0Ftb3VudDoOytu6EwIQAcrbuhMCGAEigQMKEUNhcmRUb0NhcmRDYXNoT3V0Eg4KAmlkGAEgAigJUgJpZBIQCgNwYW4YAiACKAlSA3BhbhImCgRiYW5rGAMgAigLMhIuUHJvdG9BcGkuQ2FyZEJhbmtSBGJhbmsSNQoNZGlzcGxheUFtb3VudBgEIAIoCzIPLlByb3RvQXBpLk1vbmV5Ug1kaXNwbGF5QW1vdW50EjUKDWFjY291bnRBbW91bnQYBSACKAsyDy5Qcm90b0FwaS5Nb25leVINYWNjb3VudEFtb3VudBIcCglvY2N1cmVkQXQYBiACKAVSCW9jY3VyZWRBdBIYCgdjb21tZW50GAcgASgJUgdjb21tZW50Ei4KCGxvY2F0aW9uGAggASgLMhIuUHJvdG9BcGkuTG9jYXRpb25SCGxvY2F0aW9uEhwKCWhhc0ZhaWxlZBgJIAEoCFIJaGFzRmFpbGVkEh4KCnJlY2VpcHRVcmwYCiABKAlSCnJlY2VpcHRVcmw6DsrbuhMCEAHK27oTAhgBIt4CChZDYXJkVG9DYXJkQ2FzaE91dE90aGVyEg4KAmlkGAEgAigJUgJpZBIuCghtZXJjaGFudBgCIAIoCzISLlByb3RvQXBpLk1lcmNoYW50UghtZXJjaGFudBI1Cg1kaXNwbGF5QW1vdW50GAMgAigLMg8uUHJvdG9BcGkuTW9uZXlSDWRpc3BsYXlBbW91bnQSNQoNYWNjb3VudEFtb3VudBgEIAIoCzIPLlByb3RvQXBpLk1vbmV5Ug1hY2NvdW50QW1vdW50EhwKCW9jY3VyZWRBdBgFIAIoBVIJb2NjdXJlZEF0EhgKB2NvbW1lbnQYBiABKAlSB2NvbW1lbnQSLgoIbG9jYXRpb24YByABKAsyEi5Qcm90b0FwaS5Mb2NhdGlvblIIbG9jYXRpb24SHgoKcmVjZWlwdFVybBgJIAIoCVIKcmVjZWlwdFVybDoOytu6EwIQAcrbuhMCGAEijgMKDU1pbGVzQ2FzaEJhY2sSDgoCaWQYASACKAlSAmlkEi4KCG1lcmNoYW50GAIgAigLMhIuUHJvdG9BcGkuTWVyY2hhbnRSCG1lcmNoYW50EjUKDWRpc3BsYXlBbW91bnQYAyACKAsyDy5Qcm90b0FwaS5Nb25leVINZGlzcGxheUFtb3VudBI1Cg1hY2NvdW50QW1vdW50GAQgAigLMg8uUHJvdG9BcGkuTW9uZXlSDWFjY291bnRBbW91bnQSHAoJb2NjdXJlZEF0GAUgAigFUglvY2N1cmVkQXQSGAoHY29tbWVudBgGIAEoCVIHY29tbWVudBIuCghsb2NhdGlvbhgHIAEoCzISLlByb3RvQXBpLkxvY2F0aW9uUghsb2NhdGlvbhI3Cgtwb3NTcGVuZGluZxgIIAEoCzIVLlByb3RvQXBpLlBvc1NwZW5kaW5nUgtwb3NTcGVuZGluZxIeCgpyZWNlaXB0VXJsGAkgASgJUgpyZWNlaXB0VXJsOg7K27oTAhABytu6EwIYASLEBgoLUG9zU3BlbmRpbmcSDgoCaWQYASACKAlSAmlkEi4KCG1lcmNoYW50GAIgAigLMhIuUHJvdG9BcGkuTWVyY2hhbnRSCG1lcmNoYW50EjUKDWRpc3BsYXlBbW91bnQYAyACKAsyDy5Qcm90b0FwaS5Nb25leVINZGlzcGxheUFtb3VudBI1Cg1hY2NvdW50QW1vdW50GAQgAigLMg8uUHJvdG9BcGkuTW9uZXlSDWFjY291bnRBbW91bnQSHAoJb2NjdXJlZEF0GAUgAigFUglvY2N1cmVkQXQSGAoHY29tbWVudBgGIAEoCVIHY29tbWVudBIuCghsb2NhdGlvbhgHIAEoCzISLlByb3RvQXBpLkxvY2F0aW9uUghsb2NhdGlvbhI1Cg1yb2NrZXRyb3VibGVzGAggASgLMg8uUHJvdG9BcGkuTW9uZXlSDXJvY2tldHJvdWJsZXMSNwoIY2F0ZWdvcnkYCSACKAsyGy5Qcm90b0FwaS5PcGVyYXRpb25DYXRlZ29yeVIIY2F0ZWdvcnkSWwoTY29tcGVuc2F0aW9uUmVxdWVzdBgKIAEoCzIpLlByb3RvQXBpLlBvc1NwZW5kaW5nLkNvbXBlbnNhdGlvblJlcXVlc3RSE2NvbXBlbnNhdGlvblJlcXVlc3QSPQoNbWlsZXNDYXNoQmFjaxgLIAEoCzIXLlByb3RvQXBpLk1pbGVzQ2FzaEJhY2tSDW1pbGVzQ2FzaEJhY2sSMwoMcnVibGVzQW1vdW50GAwgAigLMg8uUHJvdG9BcGkuTW9uZXlSDHJ1Ymxlc0Ftb3VudBIrCgdyZWNlaXB0GA0gAigLMhEuUHJvdG9BcGkuUmVjZWlwdFIHcmVjZWlwdBqgAQoTQ29tcGVuc2F0aW9uUmVxdWVzdBJICgZzdGF0dXMYASACKA4yMC5Qcm90b0FwaS5Qb3NTcGVuZGluZy5Db21wZW5zYXRpb25SZXF1ZXN0LlN0YXR1c1IGc3RhdHVzIj8KBlN0YXR1cxINCglBVkFJTEFCTEUQABILCgdQRU5ESU5HEAESCwoHU1VDQ0VTUxACEgwKCERFQ0xJTkVEEAM6DsrbuhMCEAHK27oTAhgBIoAEChNQb3NTcGVuZGluZ1JldmVyc2FsEg4KAmlkGAEgAigJUgJpZBIuCghtZXJjaGFudBgCIAIoCzISLlByb3RvQXBpLk1lcmNoYW50UghtZXJjaGFudBI1Cg1kaXNwbGF5QW1vdW50GAMgAigLMg8uUHJvdG9BcGkuTW9uZXlSDWRpc3BsYXlBbW91bnQSNQoNYWNjb3VudEFtb3VudBgEIAIoCzIPLlByb3RvQXBpLk1vbmV5Ug1hY2NvdW50QW1vdW50EhwKCW9jY3VyZWRBdBgFIAIoBVIJb2NjdXJlZEF0EhgKB2NvbW1lbnQYBiABKAlSB2NvbW1lbnQSLgoIbG9jYXRpb24YByABKAsyEi5Qcm90b0FwaS5Mb2NhdGlvblIIbG9jYXRpb24SNQoNcm9ja2V0cm91YmxlcxgIIAEoCzIPLlByb3RvQXBpLk1vbmV5Ug1yb2NrZXRyb3VibGVzEjcKCGNhdGVnb3J5GAkgAigLMhsuUHJvdG9BcGkuT3BlcmF0aW9uQ2F0ZWdvcnlSCGNhdGVnb3J5EjMKDHJ1Ymxlc0Ftb3VudBgKIAIoCzIPLlByb3RvQXBpLk1vbmV5UgxydWJsZXNBbW91bnQSHgoKcmVjZWlwdFVybBgLIAIoCVIKcmVjZWlwdFVybDoOytu6EwIQAcrbuhMCGAEiowMKD0ludGVybmFsQ2FzaE91dBIOCgJpZBgBIAIoCVICaWQSKAoGZnJpZW5kGAIgAigLMhAuUHJvdG9BcGkuRnJpZW5kUgZmcmllbmQSNQoNZGlzcGxheUFtb3VudBgDIAIoCzIPLlByb3RvQXBpLk1vbmV5Ug1kaXNwbGF5QW1vdW50EjUKDWFjY291bnRBbW91bnQYBCACKAsyDy5Qcm90b0FwaS5Nb25leVINYWNjb3VudEFtb3VudBIcCglvY2N1cmVkQXQYBSACKAVSCW9jY3VyZWRBdBIYCgdjb21tZW50GAYgASgJUgdjb21tZW50Ei4KCGxvY2F0aW9uGAcgASgLMhIuUHJvdG9BcGkuTG9jYXRpb25SCGxvY2F0aW9uEhwKCWhhc0ZhaWxlZBgIIAEoCFIJaGFzRmFpbGVkEjIKCHRlbXBsYXRlGAkgASgLMhYuUHJvdG9BcGkuVGVtcGxhdGVEYXRhUgh0ZW1wbGF0ZRIeCgpyZWNlaXB0VXJsGAogASgJUgpyZWNlaXB0VXJsOg7K27oTAhABytu6EwIYASL1AgoWSW50ZXJuYWxDYXNoT3V0UmVxdWVzdBIOCgJpZBgBIAIoCVICaWQSKAoGZnJpZW5kGAIgAigLMhAuUHJvdG9BcGkuRnJpZW5kUgZmcmllbmQSNQoNZGlzcGxheUFtb3VudBgDIAIoCzIPLlByb3RvQXBpLk1vbmV5Ug1kaXNwbGF5QW1vdW50EjUKDWFjY291bnRBbW91bnQYBCACKAsyDy5Qcm90b0FwaS5Nb25leVINYWNjb3VudEFtb3VudBIcCglvY2N1cmVkQXQYBSACKAVSCW9jY3VyZWRBdBIYCgdjb21tZW50GAYgASgJUgdjb21tZW50Ei4KCGxvY2F0aW9uGAcgASgLMhIuUHJvdG9BcGkuTG9jYXRpb25SCGxvY2F0aW9uEjsKBnN0YXR1cxgIIAIoDjIjLlByb3RvQXBpLkludGVybmFsQ2FzaFJlcXVlc3RTdGF0dXNSBnN0YXR1czoOytu6EwIQAcrbuhMCGAEisAIKDkludGVybmFsQ2FzaEluEg4KAmlkGAEgAigJUgJpZBIoCgZmcmllbmQYAiACKAsyEC5Qcm90b0FwaS5GcmllbmRSBmZyaWVuZBI1Cg1kaXNwbGF5QW1vdW50GAMgAigLMg8uUHJvdG9BcGkuTW9uZXlSDWRpc3BsYXlBbW91bnQSNQoNYWNjb3VudEFtb3VudBgEIAIoCzIPLlByb3RvQXBpLk1vbmV5Ug1hY2NvdW50QW1vdW50EhwKCW9jY3VyZWRBdBgFIAIoBVIJb2NjdXJlZEF0EhgKB2NvbW1lbnQYBiABKAlSB2NvbW1lbnQSLgoIbG9jYXRpb24YByABKAsyEi5Qcm90b0FwaS5Mb2NhdGlvblIIbG9jYXRpb246DsrbuhMCEAHK27oTAhgBIpIDChVJbnRlcm5hbENhc2hJblJlcXVlc3QSDgoCaWQYASACKAlSAmlkEigKBmZyaWVuZBgCIAIoCzIQLlByb3RvQXBpLkZyaWVuZFIGZnJpZW5kEjUKDWRpc3BsYXlBbW91bnQYAyACKAsyDy5Qcm90b0FwaS5Nb25leVINZGlzcGxheUFtb3VudBI1Cg1hY2NvdW50QW1vdW50GAQgAigLMg8uUHJvdG9BcGkuTW9uZXlSDWFjY291bnRBbW91bnQSHAoJb2NjdXJlZEF0GAUgAigFUglvY2N1cmVkQXQSGAoHY29tbWVudBgGIAEoCVIHY29tbWVudBIuCghsb2NhdGlvbhgHIAEoCzISLlByb3RvQXBpLkxvY2F0aW9uUghsb2NhdGlvbhI7CgZzdGF0dXMYCCACKA4yIy5Qcm90b0FwaS5JbnRlcm5hbENhc2hSZXF1ZXN0U3RhdHVzUgZzdGF0dXMSHAoJaGFzRmFpbGVkGAkgASgIUgloYXNGYWlsZWQ6DsrbuhMCEAHK27oTAhgBIrYCCg5DYXJkQ29tbWlzc2lvbhIOCgJpZBgBIAIoCVICaWQSLgoIbWVyY2hhbnQYAiACKAsyEi5Qcm90b0FwaS5NZXJjaGFudFIIbWVyY2hhbnQSNQoNZGlzcGxheUFtb3VudBgDIAIoCzIPLlByb3RvQXBpLk1vbmV5Ug1kaXNwbGF5QW1vdW50EjUKDWFjY291bnRBbW91bnQYBCACKAsyDy5Qcm90b0FwaS5Nb25leVINYWNjb3VudEFtb3VudBIcCglvY2N1cmVkQXQYBSACKAVSCW9jY3VyZWRBdBIYCgdjb21tZW50GAYgASgJUgdjb21tZW50Ei4KCGxvY2F0aW9uGAcgASgLMhIuUHJvdG9BcGkuTG9jYXRpb25SCGxvY2F0aW9uOg7K27oTAhABytu6EwIYASLnAgoKQ29tbWlzc2lvbhIOCgJpZBgBIAIoCVICaWQSLgoIbWVyY2hhbnQYAiACKAsyEi5Qcm90b0FwaS5NZXJjaGFudFIIbWVyY2hhbnQSNQoNZGlzcGxheUFtb3VudBgDIAIoCzIPLlByb3RvQXBpLk1vbmV5Ug1kaXNwbGF5QW1vdW50EjUKDWFjY291bnRBbW91bnQYBCACKAsyDy5Qcm90b0FwaS5Nb25leVINYWNjb3VudEFtb3VudBIcCglvY2N1cmVkQXQYBSACKAVSCW9jY3VyZWRBdBIYCgdjb21tZW50GAYgASgJUgdjb21tZW50Ei4KCGxvY2F0aW9uGAcgASgLMhIuUHJvdG9BcGkuTG9jYXRpb25SCGxvY2F0aW9uEjMKDHJ1Ymxlc0Ftb3VudBgIIAIoCzIPLlByb3RvQXBpLk1vbmV5UgxydWJsZXNBbW91bnQ6DsrbuhMCEAHK27oTAhgBIoYDCglRdWFzaUNhc2gSDgoCaWQYASACKAlSAmlkEi4KCG1lcmNoYW50GAIgAigLMhIuUHJvdG9BcGkuTWVyY2hhbnRSCG1lcmNoYW50EjUKDWRpc3BsYXlBbW91bnQYAyACKAsyDy5Qcm90b0FwaS5Nb25leVINZGlzcGxheUFtb3VudBI1Cg1hY2NvdW50QW1vdW50GAQgAigLMg8uUHJvdG9BcGkuTW9uZXlSDWFjY291bnRBbW91bnQSHAoJb2NjdXJlZEF0GAUgAigFUglvY2N1cmVkQXQSGAoHY29tbWVudBgGIAEoCVIHY29tbWVudBIuCghsb2NhdGlvbhgHIAEoCzISLlByb3RvQXBpLkxvY2F0aW9uUghsb2NhdGlvbhIzCgxydWJsZXNBbW91bnQYCCACKAsyDy5Qcm90b0FwaS5Nb25leVIMcnVibGVzQW1vdW50Eh4KCnJlY2VpcHRVcmwYCSACKAlSCnJlY2VpcHRVcmw6DsrbuhMCEAHK27oTAhgBIuoCCg1TdHJhbmdlSW5jb21lEg4KAmlkGAEgAigJUgJpZBIuCghtZXJjaGFudBgCIAIoCzISLlByb3RvQXBpLk1lcmNoYW50UghtZXJjaGFudBI1Cg1kaXNwbGF5QW1vdW50GAMgAigLMg8uUHJvdG9BcGkuTW9uZXlSDWRpc3BsYXlBbW91bnQSNQoNYWNjb3VudEFtb3VudBgEIAIoCzIPLlByb3RvQXBpLk1vbmV5Ug1hY2NvdW50QW1vdW50EhwKCW9jY3VyZWRBdBgFIAIoBVIJb2NjdXJlZEF0EhgKB2NvbW1lbnQYBiABKAlSB2NvbW1lbnQSLgoIbG9jYXRpb24YByABKAsyEi5Qcm90b0FwaS5Mb2NhdGlvblIIbG9jYXRpb24SMwoMcnVibGVzQW1vdW50GAggAigLMg8uUHJvdG9BcGkuTW9uZXlSDHJ1Ymxlc0Ftb3VudDoOytu6EwIQAcrbuhMCGAEirAQKC01pbGVzQ2hhcmdlEg4KAmlkGAEgAigJUgJpZBIuCghtZXJjaGFudBgCIAIoCzISLlByb3RvQXBpLk1lcmNoYW50UghtZXJjaGFudBIcCglvY2N1cmVkQXQYAyACKAVSCW9jY3VyZWRBdBIYCgdjb21tZW50GAQgASgJUgdjb21tZW50Ei4KCGxvY2F0aW9uGAUgASgLMhIuUHJvdG9BcGkuTG9jYXRpb25SCGxvY2F0aW9uEjUKDXJvY2tldHJvdWJsZXMYBiABKAsyDy5Qcm90b0FwaS5Nb25leVINcm9ja2V0cm91YmxlcxIuCgRraW5kGAcgASgOMhouUHJvdG9BcGkuTWlsZXNDaGFyZ2UuS2luZFIEa2luZCL9AQoES2luZBILCgdERVBPU0lUEAASCgoGUkVGSUxMEAESDgoKUlJfUEVSQ0VOVBACEgoKBlJFQVNPThADEg4KCklOVklUQVRJT04QBBILCgdQQVJLSU5HEAUSCQoFQURNSU4QBhIOCgpPQkVEX0JVRkVUEAcSDQoJT1BFTl9HQU1FEAgSCAoES0lOTxAJEgkKBVpFVFRBEAoSDQoJT1RUX09SREVSEAsSEgoOT1RUX0NPUlJFQ1RJT04QDBIOCgpTSE9QX09SREVSEA0SCwoHSU5WSVRFRBAOEg8KC09UVF9NT05USExZEA8SEwoPUk9DS0VUX1RSQU5TRkVSEBA6DsrbuhMCEAHK27oTAhgBIuoCCg1BdG1Db21taXNzaW9uEg4KAmlkGAEgAigJUgJpZBIuCghtZXJjaGFudBgCIAIoCzISLlByb3RvQXBpLk1lcmNoYW50UghtZXJjaGFudBI1Cg1kaXNwbGF5QW1vdW50GAMgAigLMg8uUHJvdG9BcGkuTW9uZXlSDWRpc3BsYXlBbW91bnQSNQoNYWNjb3VudEFtb3VudBgEIAIoCzIPLlByb3RvQXBpLk1vbmV5Ug1hY2NvdW50QW1vdW50EhwKCW9jY3VyZWRBdBgFIAIoBVIJb2NjdXJlZEF0EhgKB2NvbW1lbnQYBiABKAlSB2NvbW1lbnQSLgoIbG9jYXRpb24YByABKAsyEi5Qcm90b0FwaS5Mb2NhdGlvblIIbG9jYXRpb24SMwoMcnVibGVzQW1vdW50GAggAigLMg8uUHJvdG9BcGkuTW9uZXlSDHJ1Ymxlc0Ftb3VudDoOytu6EwIQAcrbuhMCGAEi9wMKF1RyYW5zZmVyQmV0d2VlblByb2R1Y3RzEg4KAmlkGAEgAigJUgJpZBI7ChBvdXREaXNwbGF5QW1vdW50GAIgAigLMg8uUHJvdG9BcGkuTW9uZXlSEG91dERpc3BsYXlBbW91bnQSOwoQb3V0QWNjb3VudEFtb3VudBgDIAIoCzIPLlByb3RvQXBpLk1vbmV5UhBvdXRBY2NvdW50QW1vdW50EjkKD2luRGlzcGxheUFtb3VudBgEIAIoCzIPLlByb3RvQXBpLk1vbmV5Ug9pbkRpc3BsYXlBbW91bnQSOQoPaW5BY2NvdW50QW1vdW50GAUgAigLMg8uUHJvdG9BcGkuTW9uZXlSD2luQWNjb3VudEFtb3VudBIcCglvY2N1cmVkQXQYBiACKAVSCW9jY3VyZWRBdBIzCgtmcm9tUHJvZHVjdBgHIAIoCzIRLlByb3RvQXBpLlByb2R1Y3RSC2Zyb21Qcm9kdWN0Ei8KCXRvUHJvZHVjdBgIIAIoCzIRLlByb3RvQXBpLlByb2R1Y3RSCXRvUHJvZHVjdBIuCghsb2NhdGlvbhgJIAEoCzISLlByb3RvQXBpLkxvY2F0aW9uUghsb2NhdGlvbhIYCgdjb21tZW50GAogASgJUgdjb21tZW50Og7K27oTAhABytu6EwIYASLXBAoTUmVtaXR0YW5jZU9wZXJhdGlvbhIOCgJpZBgBIAIoCVICaWQSNQoNZGlzcGxheUFtb3VudBgCIAIoCzIPLlByb3RvQXBpLk1vbmV5Ug1kaXNwbGF5QW1vdW50EjUKDWFjY291bnRBbW91bnQYAyACKAsyDy5Qcm90b0FwaS5Nb25leVINYWNjb3VudEFtb3VudBIcCglvY2N1cmVkQXQYBCACKAVSCW9jY3VyZWRBdBI/CghwZXJzb25hbBgFIAEoCzIhLlByb3RvQXBpLlJlbWl0dGFuY2UuUGVyc29uYWxEYXRhSABSCHBlcnNvbmFsEkIKCWNvcnBvcmF0ZRgGIAEoCzIiLlByb3RvQXBpLlJlbWl0dGFuY2UuQ29ycG9yYXRlRGF0YUgAUgljb3Jwb3JhdGUSOQoGYnVkZ2V0GAcgASgLMh8uUHJvdG9BcGkuUmVtaXR0YW5jZS5CdWRnZXREYXRhSABSBmJ1ZGdldBISCgRuYW1lGAggAigJUgRuYW1lEhgKB2ljb25VcmwYCSABKAlSB2ljb25VcmwSEgoEY29ychgLIAEoCVIEY29ychISCgRiZXNwGAwgAigIUgRiZXNwEjIKCHRlbXBsYXRlGA0gASgLMhYuUHJvdG9BcGkuVGVtcGxhdGVEYXRhUgh0ZW1wbGF0ZRIYCgdjb21tZW50GA4gASgJUgdjb21tZW50Eh4KCnJlY2VpcHRVcmwYDyABKAlSCnJlY2VpcHRVcmw6DsrbuhMCEAHK27oTAhgBQhAKDnJlbWl0dGFuY2VEYXRhIsECChVTYWxhcnlUYXJpZmZPcGVyYXRpb24SDgoCaWQYASACKAlSAmlkEhwKCW9jY3VyZWRBdBgCIAIoBVIJb2NjdXJlZEF0EhQKBXRpdGxlGAMgAigJUgV0aXRsZRIgCgtyZWd1bGFyVGV4dBgEIAIoCVILcmVndWxhclRleHQSPgoGYnV0dG9uGAcgAigLMiYuUHJvdG9BcGkuU2FsYXJ5VGFyaWZmT3BlcmF0aW9uLkJ1dHRvblIGYnV0dG9uGnIKBkJ1dHRvbhIWCgZhY3Rpb24YASACKAlSBmFjdGlvbhIUCgV0aXRsZRgCIAIoCVIFdGl0bGUSIAoLZG93bmxvYWRVcmwYAyACKAlSC2Rvd25sb2FkVXJsEhgKB2luZm9VcmwYBCACKAlSB2luZm9Vcmw6DsrbuhMCEAHK27oTAhgBIvMBChRUb3VyaXN0SGludE9wZXJhdGlvbhIOCgJpZBgBIAIoCVICaWQSHAoJb2NjdXJlZEF0GAIgAigFUglvY2N1cmVkQXQSFAoFdGl0bGUYAyACKAlSBXRpdGxlEhgKB2RldGFpbHMYBCABKAlSB2RldGFpbHMSPQoGYnV0dG9uGAUgAigLMiUuUHJvdG9BcGkuVG91cmlzdEhpbnRPcGVyYXRpb24uQnV0dG9uUgZidXR0b24aLgoGQnV0dG9uEhIKBHRleHQYASACKAlSBHRleHQSEAoDdXJsGAIgAigJUgN1cmw6DsrbuhMCEAHK27oTAhgBItEBChVCaWdDb21pc3Npb25PcGVyYXRpb24SDgoCaWQYASACKAlSAmlkEhwKCW9jY3VyZWRBdBgCIAIoBVIJb2NjdXJlZEF0EhIKBHRleHQYAyACKAlSBHRleHQSFAoFY29sb3IYBCABKAlSBWNvbG9yEiAKC3B1c2hNZXNzYWdlGAUgASgJUgtwdXNoTWVzc2FnZRouCgZCdXR0b24SEgoEdGV4dBgBIAIoCVIEdGV4dBIQCgN1cmwYAiACKAlSA3VybDoOytu6EwIQAcrbuhMCGAEitwEKD0dpc0dtcE9wZXJhdGlvbhIOCgJpZBgBIAIoCVICaWQSHAoJb2NjdXJlZEF0GAIgAigFUglvY2N1cmVkQXQSFAoFdGl0bGUYAyACKAlSBXRpdGxlEiAKC3B1c2hNZXNzYWdlGAQgAigJUgtwdXNoTWVzc2FnZRIuCghtZXJjaGFudBgFIAIoCzISLlByb3RvQXBpLk1lcmNoYW50UghtZXJjaGFudDoOytu6EwIQAcrbuhMCGAEi2QEKE1JlaXNzdWVQaW5PcGVyYXRpb24SDgoCaWQYASACKAlSAmlkEhwKCW9jY3VyZWRBdBgCIAIoBVIJb2NjdXJlZEF0EhIKBHRleHQYAyACKAlSBHRleHQSFAoFdG9rZW4YBCACKAlSBXRva2VuEjwKBmJ1dHRvbhgFIAIoCzIkLlByb3RvQXBpLlJlaXNzdWVQaW5PcGVyYXRpb24uQnV0dG9uUgZidXR0b24aHAoGQnV0dG9uEhIKBHRleHQYASACKAlSBHRleHQ6DsrbuhMCEAHK27oTAhgBIoMDChZNb250aENhc2hCYWNrT3BlcmF0aW9uEg4KAmlkGAEgAigJUgJpZBIcCglvY2N1cmVkQXQYAiACKAVSCW9jY3VyZWRBdBI/CgZzdGF0dXMYAyACKA4yJy5Qcm90b0FwaS5Nb250aENhc2hCYWNrT3BlcmF0aW9uLlN0YXR1c1IGc3RhdHVzEk0KCW1lcmNoYW50cxgEIAMoCzIvLlByb3RvQXBpLk1vbnRoQ2FzaEJhY2tPcGVyYXRpb24uQ2hvb3NlTWVyY2hhbnRSCW1lcmNoYW50cxIcCgloYXNGYWlsZWQYBSABKAhSCWhhc0ZhaWxlZBpaCg5DaG9vc2VNZXJjaGFudBIYCgdwZXJjZW50GAEgAigFUgdwZXJjZW50Ei4KCG1lcmNoYW50GAIgAigLMhIuUHJvdG9BcGkuTWVyY2hhbnRSCG1lcmNoYW50IiEKBlN0YXR1cxILCgdQRU5ESU5HEAASCgoGQ0hPU0VOEAE6DsrbuhMCEAHK27oTAhgBIscBChVBcHBsZXBheVB1c2hPcGVyYXRpb24SDgoCaWQYASACKAlSAmlkEhwKCW9jY3VyZWRBdBgCIAIoBVIJb2NjdXJlZEF0EhIKBHRleHQYAyACKAlSBHRleHQSPgoGYnV0dG9uGAQgAigLMiYuUHJvdG9BcGkuQXBwbGVwYXlQdXNoT3BlcmF0aW9uLkJ1dHRvblIGYnV0dG9uGhwKBkJ1dHRvbhISCgR0ZXh0GAEgAigJUgR0ZXh0Og7K27oTAhABytu6EwIYASJRChFEaXNjb3VudE9wZXJhdGlvbhIOCgJpZBgBIAIoCVICaWQSHAoJb2NjdXJlZEF0GAIgAigFUglvY2N1cmVkQXQ6DsrbuhMCEAHK27oTAhgBIlIKEkFwcFJldmlld09wZXJhdGlvbhIOCgJpZBgBIAIoCVICaWQSHAoJb2NjdXJlZEF0GAIgAigFUglvY2N1cmVkQXQ6DsrbuhMCEAHK27oTAhgBIr8BChFQYXNzcG9ydE9wZXJhdGlvbhIOCgJpZBgBIAIoCVICaWQSHAoJb2NjdXJlZEF0GAIgAigFUglvY2N1cmVkQXQSEgoEdGV4dBgDIAIoCVIEdGV4dBI6CgZidXR0b24YBCACKAsyIi5Qcm90b0FwaS5QYXNzcG9ydE9wZXJhdGlvbi5CdXR0b25SBmJ1dHRvbhocCgZCdXR0b24SEgoEdGV4dBgBIAIoCVIEdGV4dDoOytu6EwIQAcrbuhMCGAEi1QEKEURlbGl2ZXJ5T3BlcmF0aW9uEg4KAmlkGAEgAigJUgJpZBIcCglvY2N1cmVkQXQYAiACKAVSCW9jY3VyZWRBdBISCgR0ZXh0GAMgAigJUgR0ZXh0EhQKBXRva2VuGAQgAigJUgV0b2tlbhI6CgZidXR0b24YBSACKAsyIi5Qcm90b0FwaS5EZWxpdmVyeU9wZXJhdGlvbi5CdXR0b25SBmJ1dHRvbhocCgZCdXR0b24SEgoEdGV4dBgBIAIoCVIEdGV4dDoOytu6EwIQAcrbuhMCGAEi1QQKD1BheW1lbnRTcGVuZGluZxIOCgJpZBgBIAIoCVICaWQSNQoIcHJvdmlkZXIYAiACKAsyGS5Qcm90b0FwaS5QYXltZW50UHJvdmlkZXJSCHByb3ZpZGVyEjUKDWRpc3BsYXlBbW91bnQYAyACKAsyDy5Qcm90b0FwaS5Nb25leVINZGlzcGxheUFtb3VudBI1Cg1hY2NvdW50QW1vdW50GAQgAigLMg8uUHJvdG9BcGkuTW9uZXlSDWFjY291bnRBbW91bnQSHAoJb2NjdXJlZEF0GAUgAigFUglvY2N1cmVkQXQSSQoKcmVxdWlzaXRlcxgGIAMoCzIpLlByb3RvQXBpLlBheW1lbnRTcGVuZGluZy5SZXF1aXNpdGVzRW50cnlSCnJlcXVpc2l0ZXMSMgoIdGVtcGxhdGUYByABKAsyFi5Qcm90b0FwaS5UZW1wbGF0ZURhdGFSCHRlbXBsYXRlEi4KEmNsaWVudFBob25lUGF5bWVudBgIIAEoCFISY2xpZW50UGhvbmVQYXltZW50EjcKCGNhdGVnb3J5GAkgASgLMhsuUHJvdG9BcGkuT3BlcmF0aW9uQ2F0ZWdvcnlSCGNhdGVnb3J5EhgKB2NvbW1lbnQYCiABKAlSB2NvbW1lbnQSHgoKcmVjZWlwdFVybBgLIAEoCVIKcmVjZWlwdFVybBo9Cg9SZXF1aXNpdGVzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AToOytu6EwIQAcrbuhMCGAEizgEKE1JvY2tldHNob3BPcGVyYXRpb24SDgoCaWQYASACKAlSAmlkEhgKB2NvbW1lbnQYAiABKAlSB2NvbW1lbnQSHAoJb2NjdXJlZEF0GAMgAigFUglvY2N1cmVkQXQSLwoFb3JkZXIYBCACKAsyGS5Qcm90b0FwaS5Sb2NrZXRzaG9wT3JkZXJSBW9yZGVyEi4KCGxvY2F0aW9uGAUgASgLMhIuUHJvdG9BcGkuTG9jYXRpb25SCGxvY2F0aW9uOg7K27oTAhABytu6EwIYASL2AQoQUGVyY2VudE9wZXJhdGlvbhIOCgJpZBgBIAIoCVICaWQSNQoNZGlzcGxheUFtb3VudBgCIAIoCzIPLlByb3RvQXBpLk1vbmV5Ug1kaXNwbGF5QW1vdW50EjUKDWFjY291bnRBbW91bnQYAyACKAsyDy5Qcm90b0FwaS5Nb25leVINYWNjb3VudEFtb3VudBIYCgdjb21tZW50GAQgASgJUgdjb21tZW50EhwKCW9jY3VyZWRBdBgFIAIoBVIJb2NjdXJlZEF0EhwKCXByb2R1Y3RJZBgGIAIoCVIJcHJvZHVjdElkOg7K27oTAhABytu6EwIYASKPAgoSQ29tbWlzc2lvblJldmVyc2FsEg4KAmlkGAEgAigJUgJpZBI1Cg1kaXNwbGF5QW1vdW50GAIgAigLMg8uUHJvdG9BcGkuTW9uZXlSDWRpc3BsYXlBbW91bnQSNQoNYWNjb3VudEFtb3VudBgDIAIoCzIPLlByb3RvQXBpLk1vbmV5Ug1hY2NvdW50QW1vdW50EhgKB2NvbW1lbnQYBCABKAlSB2NvbW1lbnQSHAoJb2NjdXJlZEF0GAUgAigFUglvY2N1cmVkQXQSMwoMcnVibGVzQW1vdW50GAYgAigLMg8uUHJvdG9BcGkuTW9uZXlSDHJ1Ymxlc0Ftb3VudDoOytu6EwIQAcrbuhMCGAEqWAoZSW50ZXJuYWxDYXNoUmVxdWVzdFN0YXR1cxILCgdQRU5ESU5HEAASDQoJQ09ORklSTUVEEAESDAoIREVDTElORUQQ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V09fVFJJUBABEg8KC01FVFJPTFBPTElTEAIiUgoJUGVybWFsaW5rEhgKB2VuYWJsZWQYASACKAhSB2VuYWJsZWQSGwoEc2x1ZxgCIAIoCUIH0tu6EwIQAVIEc2x1ZzoOytu6EwIQAcrbuhMCGAEi7wIKCFNldHRpbmdzEjEKBnNvdW5kcxgBIAIoDjIZLlByb3RvQXBpLlNldHRpbmdzLlNvdW5kc1IGc291bmRzEhgKB3RvdWNoSWQYAiACKAhSB3RvdWNoSWQSHgoKcXVpY2tMb2dpbhgDIAIoCFIKcXVpY2tMb2dpbhI3CghncmVhdGluZxgEIAIoDjIbLlByb3RvQXBpLlNldHRpbmdzLkdyZWF0aW5nUghncmVhdGluZxIxCglwZXJtYWxpbmsYBSACKAsyEy5Qcm90b0FwaS5QZXJtYWxpbmtSCXBlcm1hbGluayJUCgZTb3VuZHMSDAoIREVGQVVMVFMQABIICgRPUktTEAESCgoGR05PTUVTEAISCQoFREVBVEgQAxILCgdTSUVORFVLEAQSDgoKUklDS19NT1JUWRAFIiQKCEdyZWF0aW5nEgoKBlBPTElURRAAEgwKCEZSSUVORExZEAE6DsrbuhMCEAHK27oTAhgBIqkFCgZDbGllbnQSHgoCaWQYASACKAlCDtLbuhMCEAHS27oTAggBUgJpZBIvCgZzdGF0dXMYAiACKA4yFy5Qcm90b0FwaS5DbGllbnQuU3RhdHVzUgZzdGF0dXMSHAoJZmlyc3ROYW1lGAMgASgJUglmaXJzdE5hbWUSGgoIbGFzdE5hbWUYBCABKAlSCGxhc3ROYW1lEiAKC21hc2tlZFBob25lGAUgASgJUgttYXNrZWRQaG9uZRIoCg9maXJzdE5hbWVEYXRpdmUYBiABKAlSD2ZpcnN0TmFtZURhdGl2ZRImCg5sYXN0TmFtZURhdGl2ZRgHIAEoCVIObGFzdE5hbWVEYXRpdmUSLAoRZmlyc3ROYW1lR2VuaXRpdmUYCCABKAlSEWZpcnN0TmFtZUdlbml0aXZlEioKEGxhc3ROYW1lR2VuaXRpdmUYCSABKAlSEGxhc3ROYW1lR2VuaXRpdmUSKAoGYXZhdGFyGAogAigLMhAuUHJvdG9BcGkuQXZhdGFyUgZhdmF0YXISKAoGZ2VuZGVyGAsgAigOMhAuUHJv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"
