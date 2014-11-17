//
//  MessageTests.swift
//  ProtocolBuffers
//
//  Created by Alexey Khokhlov on 11.11.14.
//  Copyright (c) 2014 alexeyxo. All rights reserved.
//

import Foundation
import XCTest

class MessageTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func mergeSource() -> TestAllTypes
    {
        var builder = TestAllTypes.builder()
        builder.optionalInt32 = 1
        builder.optionalString = "foo"
        builder.optionalForeignMessage = ForeignMessage.builder().build()
        builder.repeatedString += ["bar"]
        return builder.build()
    }
    func mergeDestination() -> TestAllTypes
    {
        var builder = TestAllTypes.builder()
        builder.optionalInt64 = 2
        builder.optionalString = "baz"
        var foreign = ForeignMessage.builder()
        foreign.c = 3
        builder.optionalForeignMessage = foreign.build()
        builder.repeatedString += ["qux"]
        return builder.build()
    }
    func mergeResult() -> TestAllTypes
    {
        var builder = TestAllTypes.builder()
        builder.optionalInt32 = 1
            builder.optionalInt64 = 2
        builder.optionalString = "foo"
        var foreign = ForeignMessage.builder()
        foreign.c = 3
        builder.optionalForeignMessage = foreign.build()
        builder.repeatedString += ["qux","bar"]
        return builder.build()
    }
    
    func testMergeFrom() {
        var result = TestAllTypes.builderWithPrototype(mergeDestination()).mergeFrom(mergeSource()).build()
        XCTAssertTrue(result.data() == mergeResult().data(), "")
    }
    
    func testRequiredUninitialized() -> TestRequired {
        return TestRequired()
    }
    
    func testRequiredInitialized() -> TestRequired {
        var mes = TestRequired.builder()
        mes.a = 1
        mes.b = 2
        mes.c = 3
        return mes.build()
    }
    
    func testRequired()
    {
        var builder = TestRequired.builder()
        XCTAssertFalse(builder.isInitialized(), "")
        builder.a = 1
        XCTAssertFalse(builder.isInitialized(), "")
        builder.b = 1
        XCTAssertFalse(builder.isInitialized(), "")
        builder.c = 1
        XCTAssertTrue(builder.isInitialized(), "")
    }
    
    func testRequiredForeign() {
        var builder = TestRequiredForeign.builder()
        
        XCTAssertTrue(builder.isInitialized(), "")
        
        builder.optionalMessage = testRequiredUninitialized()
        XCTAssertFalse(builder.isInitialized(), "")
        
        builder.optionalMessage = testRequiredInitialized()
        XCTAssertTrue(builder.isInitialized(), "")
        
        builder.repeatedMessage += [testRequiredUninitialized()]
        XCTAssertFalse(builder.isInitialized(), "")
    }
    
    func testRequiredExtension() {
        var builder = TestAllExtensions.builder()
        XCTAssertTrue(builder.isInitialized(), "")
        
        builder.setExtension(TestRequired.single(), value:testRequiredUninitialized())
        XCTAssertFalse(builder.isInitialized(), "")
        
        builder.setExtension(TestRequired.single(), value:testRequiredInitialized())
        XCTAssertTrue(builder.isInitialized(), "")
        
        builder.addExtension(TestRequired.multi(), value:testRequiredUninitialized())
        XCTAssertFalse(builder.isInitialized(), "")
        
        builder.setExtension(TestRequired.multi(), index:0, value:testRequiredInitialized())
        XCTAssertTrue(builder.isInitialized(), "")
    }
    
    func testBuildPartial() {
        var message = TestRequired.builder().buildPartial()
        XCTAssertFalse(message.isInitialized(), "")
    }
    
    func testBuildNestedPartial() {
    
        var message = TestRequiredForeign.builder()
        message.optionalMessage = testRequiredUninitialized()
        message.repeatedMessage += [testRequiredUninitialized()]
        message.repeatedMessage += [testRequiredUninitialized()]
        XCTAssertFalse(message.buildPartial().isInitialized(), "")
    }
    
}
