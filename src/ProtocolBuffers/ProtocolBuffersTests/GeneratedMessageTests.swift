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
        XCTAssertTrue(TestAllTypes() == TestAllTypes(), "")
    }
    
    
    func testAccessors()
    {
        var builder = TestAllTypes.builder()
        TestUtilities.setAllFields(builder)
        var message = builder.build()
        TestUtilities.assertAllFieldsSet(message)
    }
    
    func testRepeatedAppend()
    {
        var builder = TestAllTypes.builder()
        builder.repeatedInt32 = [1,2,3,4]
        builder.repeatedForeignEnum = [ForeignEnum.ForeignBaz]
        var foreignMessageBuilder = ForeignMessage.builder()
        foreignMessageBuilder.c = 12
        var foreignMessage =  foreignMessageBuilder.build()
        builder.repeatedForeignMessage = [foreignMessage]
    
        var message = builder.build()
        XCTAssertTrue(1 == message.repeatedForeignMessage.count, "")
        XCTAssertTrue(12 == message.repeatedForeignMessage[0].c, "")
    }
    func testClearExtension()
    {
        var  builder1 = TestAllExtensions.builder()
        builder1.setExtension(UnittestRoot.optionalInt32Extension(), value:Int32(1))
        
        XCTAssertTrue(builder1.hasExtension(UnittestRoot.optionalInt32Extension()), "")
        builder1.clearExtension(UnittestRoot.optionalInt32Extension())
        XCTAssertFalse(builder1.hasExtension(UnittestRoot.optionalInt32Extension()), "")
        
        var builder2 = TestAllExtensions.builder()
        builder2.addExtension(UnittestRoot.repeatedInt32Extension(), value:Int32(1))
        if let val = builder2.getExtension(UnittestRoot.repeatedInt32Extension()) as? [Int32]
        {
            XCTAssertTrue(1 == val.count, "")
        }
        else
        {
            XCTAssertTrue(false, "")
        }
        builder2.clearExtension(UnittestRoot.repeatedInt32Extension())
        
        if let val = builder2.getExtension(UnittestRoot.repeatedInt32Extension()) as? [Int32]
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
        var builder = TestAllExtensions.builder()
        TestUtilities.setAllExtensions(builder)
        var message = builder.build()
        TestUtilities.assertAllExtensionsSet(message)
    }
    
    
    func testExtensionRepeatedSetters()
    {
        var builder = TestAllExtensions.builder()
        TestUtilities.setAllExtensions(builder)
        TestUtilities.modifyRepeatedExtensions(builder)
        var message = builder.build()
        TestUtilities.assertRepeatedExtensionsModified(message)
    }
    
    func testExtensionRepeatedSettersMerge()
    {
        var builder = TestAllExtensions.builder()
        TestUtilities.setAllExtensions(builder)
        TestUtilities.modifyRepeatedExtensions(builder)
        var message = builder.build()
        TestUtilities.assertRepeatedExtensionsModified(message)
        var message2 = TestAllExtensions.builder().mergeFrom(message).build()
        TestUtilities.assertRepeatedExtensionsModified(message2)
    }

    func testExtensionDefaults()
    {
        TestUtilities.assertExtensionsClear(TestAllExtensions())
        TestUtilities.assertExtensionsClear(TestAllExtensions.builder().build())
    }
}
