//
//  GeneratedMessageTests.swift
//  ProtocolBuffers
//
//  Created by Alexey Khokhlov on 04.11.14.
//  Copyright (c) 2014 alexeyxo. All rights reserved.
//

import Foundation
import XCTest

class GeneratedMessageTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDefaultInstance()
    {
        XCTAssertTrue(ProtobufUnittest.TestAllTypes() == ProtobufUnittest.TestAllTypes(), "")
    }
    
    
    func testAccessors()
    {
        var builder = ProtobufUnittest.TestAllTypes.builder()
        TestUtilities.setAllFields(builder)
        var message = builder.build()
        TestUtilities.assertAllFieldsSet(message)
    }
    
    func testRepeatedAppend()
    {
        var builder = ProtobufUnittest.TestAllTypes.builder()
        builder.repeatedInt32 = [1,2,3,4]
        builder.repeatedForeignEnum = [ProtobufUnittest.ForeignEnum.ForeignBaz]
        var foreignMessageBuilder = ProtobufUnittest.ForeignMessage.builder()
        foreignMessageBuilder.c = 12
        var foreignMessage =  foreignMessageBuilder.build()
        builder.repeatedForeignMessage = [foreignMessage]
    
        var message = builder.build()
        XCTAssertTrue(1 == message.repeatedForeignMessage.count, "")
        XCTAssertTrue(12 == message.repeatedForeignMessage[0].c, "")
    }
    func testClearExtension()
    {
        var  builder1 = ProtobufUnittest.TestAllExtensions.builder()
        builder1.setExtension(ProtobufUnittest.UnittestRoot.optionalInt32Extension(), value:Int32(1))
        
        XCTAssertTrue(builder1.hasExtension(ProtobufUnittest.UnittestRoot.optionalInt32Extension()), "")
        builder1.clearExtension(ProtobufUnittest.UnittestRoot.optionalInt32Extension())
        XCTAssertFalse(builder1.hasExtension(ProtobufUnittest.UnittestRoot.optionalInt32Extension()), "")
        
        var builder2 = ProtobufUnittest.TestAllExtensions.builder()
        builder2.addExtension(ProtobufUnittest.UnittestRoot.repeatedInt32Extension(), value:Int32(1))
        if let val = builder2.getExtension(ProtobufUnittest.UnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(1 == val.count, "")
        }
        else
        {
            XCTAssertTrue(false, "")
        }
        builder2.clearExtension(ProtobufUnittest.UnittestRoot.repeatedInt32Extension())
        
        if let val = builder2.getExtension(ProtobufUnittest.UnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(0 == val.count, "")
        }
        else
        {
            XCTAssertTrue(false, "")
        }
        
    }
    
    func testExtensionAccessors()
    {
        var builder = ProtobufUnittest.TestAllExtensions.builder()
        TestUtilities.setAllExtensions(builder)
        var message = builder.build()
        TestUtilities.assertAllExtensionsSet(message)
    }
    
    
    func testExtensionRepeatedSetters()
    {
        var builder = ProtobufUnittest.TestAllExtensions.builder()
        TestUtilities.setAllExtensions(builder)
        TestUtilities.modifyRepeatedExtensions(builder)
        var message = builder.build()
        TestUtilities.assertRepeatedExtensionsModified(message)
    }
    
    func testExtensionRepeatedSettersMerge()
    {
        var builder = ProtobufUnittest.TestAllExtensions.builder()
        TestUtilities.setAllExtensions(builder)
        TestUtilities.modifyRepeatedExtensions(builder)
        var message = builder.build()
        TestUtilities.assertRepeatedExtensionsModified(message)
        var message2 = ProtobufUnittest.TestAllExtensions.builder().mergeFrom(message).build()
        TestUtilities.assertRepeatedExtensionsModified(message2)
    }

    func testExtensionDefaults()
    {
        TestUtilities.assertExtensionsClear(ProtobufUnittest.TestAllExtensions())
        TestUtilities.assertExtensionsClear(ProtobufUnittest.TestAllExtensions.builder().build())
    }
}
