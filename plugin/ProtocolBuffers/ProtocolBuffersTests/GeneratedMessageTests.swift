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
        let builder = ProtobufUnittest.TestAllTypes.Builder()
        do {
            try TestUtilities.setAllFields(builder)
            let message = try builder.build()
            TestUtilities.assertAllFieldsSet(message)
        }
        catch {
            XCTFail("testAccessors")
        }
        
    }
    
    func testRepeatedAppend()
    {
        
        let builder = ProtobufUnittest.TestAllTypes.Builder()
        builder.repeatedInt32 = [1,2,3,4]
        builder.repeatedForeignEnum = [ProtobufUnittest.ForeignEnum.foreignBaz]
        let foreignMessageBuilder = ProtobufUnittest.ForeignMessage.Builder()
        foreignMessageBuilder.c = 12
        
        do {
            let foreignMessage = try foreignMessageBuilder.build()
            builder.repeatedForeignMessage = [foreignMessage]
        
            let message = try builder.build()
            XCTAssertTrue(1 == message.repeatedForeignMessage.count, "")
            XCTAssertTrue(12 == message.repeatedForeignMessage[0].c, "")
        }
        catch
        {
            XCTFail("testRepeatedAppend")
        }
    }
    func testClearExtension()
    {
        let  builder1 = ProtobufUnittest.TestAllExtensions.Builder()
        do {
            try builder1.setExtension(extensions:ProtobufUnittest.UnittestRoot.optionalInt32Extension(), value:Int32(1))
            XCTAssertTrue(builder1.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalInt32Extension()), "")
            builder1.clearExtension(extensions: ProtobufUnittest.UnittestRoot.optionalInt32Extension())
            XCTAssertFalse(builder1.hasExtension(extensions:ProtobufUnittest.UnittestRoot.optionalInt32Extension()), "")
            
            let builder2 = ProtobufUnittest.TestAllExtensions.Builder()
            try builder2.addExtension(extensions: ProtobufUnittest.UnittestRoot.repeatedInt32Extension(), value:Int32(1))
            if let val = builder2.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedInt32Extension()) as? [Int32]
            {
                XCTAssertTrue(1 == val.count, "")
            }
            else
            {
                XCTAssertTrue(false, "")
            }
            builder2.clearExtension(extensions: ProtobufUnittest.UnittestRoot.repeatedInt32Extension())
            
            if let val = builder2.getExtension(extensions:ProtobufUnittest.UnittestRoot.repeatedInt32Extension()) as? [Int32]
            {
                XCTAssertTrue(0 == val.count, "")
            }
            else
            {
                XCTAssertTrue(false, "")
            }
        }
        catch
        {
            XCTFail("testClearExtension")
        }
        
    }
    
    func testExtensionAccessors()
    {
        let builder = ProtobufUnittest.TestAllExtensions.Builder()
        do {
            try TestUtilities.setAllExtensions(builder)
            let message = try builder.build()
            TestUtilities.assertAllExtensionsSet(message)
        }
        catch {
            XCTFail("testExtensionAccessors")
        }
    }
    
    
    func testExtensionRepeatedSetters()
    {
        let builder = ProtobufUnittest.TestAllExtensions.Builder()
        do {
            try TestUtilities.setAllExtensions(builder)
            try TestUtilities.modifyRepeatedExtensions(builder)
            let message = try builder.build()
            TestUtilities.assertRepeatedExtensionsModified(message)
        }
        catch {
            XCTFail("testExtensionRepeatedSetters")
        }
    }
    
    func testExtensionRepeatedSettersMerge()
    {
        let builder = ProtobufUnittest.TestAllExtensions.Builder()
        do {
            try TestUtilities.setAllExtensions(builder)
            try TestUtilities.modifyRepeatedExtensions(builder)
            let message = try builder.build()
            TestUtilities.assertRepeatedExtensionsModified(message)
            let message2 = try ProtobufUnittest.TestAllExtensions.Builder().mergeFrom(other:message).build()
            TestUtilities.assertRepeatedExtensionsModified(message2)
        }
        catch {
            XCTFail("testExtensionRepeatedSettersMerge")
        }
        
    }

    func testExtensionDefaults()
    {
        do {
            TestUtilities.assertExtensionsClear(ProtobufUnittest.TestAllExtensions())
            TestUtilities.assertExtensionsClear(try ProtobufUnittest.TestAllExtensions.Builder().build())
        }
        catch {
            XCTFail("testExtensionDefaults")
        }
        
    }
}
