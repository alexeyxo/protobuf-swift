//
//  MessageTests.swift
//  ProtocolBuffers
//
//  Created by Alexey Khokhlov on 11.11.14.
//  Copyright (c) 2014 alexeyxo. All rights reserved.
//

import Foundation
import XCTest


func == (lhs: RegularPoint, rhs: RegularPoint) -> Bool {
    return lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude
}

class RegularPoint: Equatable {
    var latitude:Float = Float(0)
    var longitude:Float = Float(0)
}

class MessageTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func mergeSource() -> ProtobufUnittest.TestAllTypes
    {
        var builder = ProtobufUnittest.TestAllTypes.Builder()
        builder.optionalInt32 = 1
        builder.optionalString = "foo"
        builder.optionalForeignMessage = ProtobufUnittest.ForeignMessage.Builder().build()
        builder.repeatedString += ["bar"]
        return builder.build()
    }
    func mergeDestination() -> ProtobufUnittest.TestAllTypes
    {
        var builder = ProtobufUnittest.TestAllTypes.Builder()
        builder.optionalInt64 = 2
        builder.optionalString = "baz"
        var foreign = ProtobufUnittest.ForeignMessage.Builder()
        foreign.c = 3
        builder.optionalForeignMessage = foreign.build()
        builder.repeatedString += ["qux"]
        return builder.build()
    }
    func mergeResult() -> ProtobufUnittest.TestAllTypes
    {
        var builder = ProtobufUnittest.TestAllTypes.Builder()
        builder.optionalInt32 = 1
            builder.optionalInt64 = 2
        builder.optionalString = "foo"
        var foreign = ProtobufUnittest.ForeignMessage.Builder()
        foreign.c = 3
        builder.optionalForeignMessage = foreign.build()
        builder.repeatedString += ["qux","bar"]
        return builder.build()
    }
    
    func testMergeFrom() {
        var result = ProtobufUnittest.TestAllTypes.builderWithPrototype(mergeDestination()).mergeFrom(mergeSource()).build()
        XCTAssertTrue(result.data() == mergeResult().data(), "")
    }
    
    func testRequiredUninitialized() -> ProtobufUnittest.TestRequired {
        return ProtobufUnittest.TestRequired()
    }
    
    func testRequiredInitialized() -> ProtobufUnittest.TestRequired {
        var mes = ProtobufUnittest.TestRequired.Builder()
        mes.a = 1
        mes.b = 2
        mes.c = 3
        return mes.build()
    }
    
    func testRequired()
    {
        var builder = ProtobufUnittest.TestRequired.Builder()
        XCTAssertFalse(builder.isInitialized(), "")
        builder.a = 1
        XCTAssertFalse(builder.isInitialized(), "")
        builder.b = 1
        XCTAssertFalse(builder.isInitialized(), "")
        builder.c = 1
        XCTAssertTrue(builder.isInitialized(), "")
    }
    
    func testRequiredForeign() {
        var builder = ProtobufUnittest.TestRequiredForeign.Builder()
        
        XCTAssertTrue(builder.isInitialized(), "")
        
        builder.optionalMessage = testRequiredUninitialized()
        XCTAssertFalse(builder.isInitialized(), "")
        
        builder.optionalMessage = testRequiredInitialized()
        XCTAssertTrue(builder.isInitialized(), "")
        
        builder.repeatedMessage += [testRequiredUninitialized()]
        XCTAssertFalse(builder.isInitialized(), "")
    }
    
    func testRequiredExtension() {
        var builder = ProtobufUnittest.TestAllExtensions.Builder()
        XCTAssertTrue(builder.isInitialized(), "")
        
        builder.setExtension(ProtobufUnittest.TestRequired.single(), value:testRequiredUninitialized())
        XCTAssertFalse(builder.isInitialized(), "")
        
        builder.setExtension(ProtobufUnittest.TestRequired.single(), value:testRequiredInitialized())
        XCTAssertTrue(builder.isInitialized(), "")
        
        builder.addExtension(ProtobufUnittest.TestRequired.multi(), value:testRequiredUninitialized())
        XCTAssertFalse(builder.isInitialized(), "")
        
        builder.setExtension(ProtobufUnittest.TestRequired.multi(), index:0, value:testRequiredInitialized())
        XCTAssertTrue(builder.isInitialized(), "")
    }
    
    func testBuildPartial() {
        var message = ProtobufUnittest.TestRequired.Builder().buildPartial()
        XCTAssertFalse(message.isInitialized(), "")
    }
    
    func testBuildNestedPartial() {
    
        var message = ProtobufUnittest.TestRequiredForeign.Builder()
        message.optionalMessage = testRequiredUninitialized()
        message.repeatedMessage += [testRequiredUninitialized()]
        message.repeatedMessage += [testRequiredUninitialized()]
        XCTAssertFalse(message.buildPartial().isInitialized(), "")
    }
    
    
    ///Issue #61 
    func testProtoPointWorks() {
        var point1 = PBProtoPoint.Builder().setLatitude(1.0).setLongitude(1.0).build()
        var point2 = PBProtoPoint.Builder().setLatitude(2.0).setLongitude(2.0).build()
        
        XCTAssert(point1.latitude == 1.0, "")
        XCTAssert(point2.latitude == 2.0, "")
        
        // Succeeds, calls the == function from ProtoPoint.pb.swift as expected
        XCTAssert(!(point1 == point2), "")
    }
    
    func testProtoPointShouldWork() {
        var point1 = PBProtoPoint.Builder().setLatitude(1.0).setLongitude(1.0).build()
        var point2 = PBProtoPoint.Builder().setLatitude(2.0).setLongitude(2.0).build()
        
        XCTAssert(point1.latitude == 1.0, "")
        XCTAssert(point2.latitude == 2.0, "")
        
        // Fails, should call the == function from ProtoPoint.pb.swift and take the inverse just like the testRegularPoint() does. But that doesn't happen.
        XCTAssert(point1 != point2, "")
    }
}

class RegularPointEqualityTest: XCTestCase {
    func testRegularPoint() {
        var point1 = RegularPoint()
        point1.latitude = 1.0
        point1.longitude = 1.0
        
        var point2 = RegularPoint()
        point2.latitude = 2.0
        point2.longitude = 2.0
        
        // works fine, calls the == function and takes the inverse implicitly (put break point to check)
        XCTAssert(point1 != point2, "")
    }
}
