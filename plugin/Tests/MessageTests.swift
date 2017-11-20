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
    
    func mergeSource() throws -> ProtobufUnittest.TestAllTypes
    {
        let builder = ProtobufUnittest.TestAllTypes.Builder()
        builder.optionalInt32 = 1
        builder.optionalString = "foo"
        builder.optionalForeignMessage = try ProtobufUnittest.ForeignMessage.Builder().build()
        builder.repeatedString += ["bar"]
        return try builder.build()
    }
    func mergeDestination() throws -> ProtobufUnittest.TestAllTypes
    {
        let builder = ProtobufUnittest.TestAllTypes.Builder()
        builder.optionalInt64 = 2
        builder.optionalString = "baz"
        let foreign = ProtobufUnittest.ForeignMessage.Builder()
        foreign.c = 3
        builder.optionalForeignMessage = try foreign.build()
        builder.repeatedString += ["qux"]
        return try builder.build()
    }
    func mergeResult() throws -> ProtobufUnittest.TestAllTypes
    {
        let builder = ProtobufUnittest.TestAllTypes.Builder()
        builder.optionalInt32 = 1
            builder.optionalInt64 = 2
        builder.optionalString = "foo"
        let foreign = ProtobufUnittest.ForeignMessage.Builder()
        foreign.c = 3
        builder.optionalForeignMessage = try foreign.build()
        builder.repeatedString += ["qux","bar"]
        return try builder.build()
    }
    
    func testMergeFrom() {
        do {
            let result = try ProtobufUnittest.TestAllTypes.builderWithPrototype(prototype: mergeDestination()).mergeFrom(other: mergeSource()).build()
            let data = try mergeResult().data()
            XCTAssertTrue(result.data() == data, "")
        }
        catch {
            XCTFail("testMergeFrom")
        }
        
    }
    
    func testRequiredUninitialized() -> ProtobufUnittest.TestRequired {
        return ProtobufUnittest.TestRequired()
    }
    
    func testRequiredInitialized() throws -> ProtobufUnittest.TestRequired {
        let mes = ProtobufUnittest.TestRequired.Builder()
        mes.a = 1
        mes.b = 2
        mes.c = 3
        return try mes.build()
    }
    
    func testRequired()
    {
        let builder = ProtobufUnittest.TestRequired.Builder()
        try XCTAssertThrowsError(builder.isInitialized())
        builder.a = 1
        try XCTAssertThrowsError(builder.isInitialized())
        builder.b = 1
        try XCTAssertThrowsError(builder.isInitialized())
        builder.c = 1
        try XCTAssertNoThrow(builder.isInitialized())
    }
    
    func testRequiredForeign() {
        
        let builder = ProtobufUnittest.TestRequiredForeign.Builder()
        
        try XCTAssertNoThrow(builder.isInitialized())
        
        builder.optionalMessage = testRequiredUninitialized()
        try XCTAssertThrowsError(builder.isInitialized())
        
        do {
            builder.optionalMessage = try testRequiredInitialized()
            try XCTAssertNoThrow(builder.isInitialized())
        } catch {
            XCTAssertFalse(true)
        }
    
        
        builder.repeatedMessage += [testRequiredUninitialized()]
        try XCTAssertThrowsError(builder.isInitialized())
    }
    
    func testRequiredExtension() {
        let builder = ProtobufUnittest.TestAllExtensions.Builder()
        try XCTAssertNoThrow(builder.isInitialized())
        
        do {
            _ = try builder.setExtension(extensions: ProtobufUnittest.TestRequired.single(), value:testRequiredUninitialized())
            try XCTAssertThrowsError(builder.isInitialized())
        
            _ = try builder.setExtension(extensions: ProtobufUnittest.TestRequired.single(), value:testRequiredInitialized())
            try XCTAssertNoThrow(builder.isInitialized())
        
            _ = try builder.addExtension(extensions: ProtobufUnittest.TestRequired.multi(), value:testRequiredUninitialized())
            try XCTAssertThrowsError(builder.isInitialized())
        
            _ = try builder.setExtension(extensions:ProtobufUnittest.TestRequired.multi(), index:0, value:testRequiredInitialized())
            try XCTAssertNoThrow(builder.isInitialized())
        }
        catch {
            XCTFail("testRequiredExtension")
        }
    }
    
    func testBuildPartial() {
        let message = ProtobufUnittest.TestRequired.Builder().buildPartial()
        try XCTAssertThrowsError(message.isInitialized())
    }
    
    func testBuildNestedPartial() {
    
        let message = ProtobufUnittest.TestRequiredForeign.Builder()
        message.optionalMessage = testRequiredUninitialized()
        message.repeatedMessage += [testRequiredUninitialized()]
        message.repeatedMessage += [testRequiredUninitialized()]
        try XCTAssertThrowsError(message.buildPartial().isInitialized())
    }
    
    
    ///Issue #61 
    func testProtoPointWorks() {
        do {
            let point1 = try PBProtoPoint.Builder().setLatitude(1.0).setLongitude(1.0).build()
            let point2 = try PBProtoPoint.Builder().setLatitude(2.0).setLongitude(2.0).build()
            XCTAssert(point1.latitude == 1.0, "")
            XCTAssert(point2.latitude == 2.0, "")
            
            // Succeeds, calls the == function from ProtoPoint.pb.swift as expected
            XCTAssert(!(point1 == point2), "")
        }
        catch
        {
            XCTFail("testProtoPointWorks")
        }
        
        
        
    }
    
    func testProtoPointShouldWork() {
        
        do {
            let point1 = try PBProtoPoint.Builder().setLatitude(1.0).setLongitude(1.0).build()
            let point2 = try PBProtoPoint.Builder().setLatitude(2.0).setLongitude(2.0).build()
        
            XCTAssert(point1.latitude == 1.0, "")
            XCTAssert(point2.latitude == 2.0, "")
        
            // Fails, should call the == function from ProtoPoint.pb.swift and take the inverse just like the testRegularPoint() does. But that doesn't happen.
            XCTAssert(point1 != point2, "")
        }
        catch
        {
            XCTFail("testProtoPointShouldWork")
        }
    }
    
    func testProtoJsonWork() {
        
        do {
            let point1 = try PBProtoPoint.Builder().setLatitude(1.0).setLongitude(2.0).build().toJSON()
            
            let point2 = try PBProtoPoint.fromJSON(data: point1)
            
            XCTAssert(point2.longitude == 2.0, "")
            XCTAssert(point2.latitude == 1.0, "")
            
            // Fails, should call the == function from ProtoPoint.pb.swift and take the inverse just like the testRegularPoint() does. But that doesn't happen.
        }
        catch
        {
            XCTFail("testProtoJsonWork")
        }
    }
    
    func testProtoJsonWorkAdditional() {
        
        do {
            let point1 = try PBProtoPoint.Builder().setLatitude(1.0).setLongitude(2.0).build().toJSON()
            
            guard var dict = try JSONSerialization.jsonObject(with: point1, options: .mutableContainers) as? [String:Any] else {
                XCTFail("testProtoJsonWork")
                return
            }
            dict["latitude"] = "1.0"
            dict["longitude"] = "2.0"
            let dd = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let point2 = try PBProtoPoint.fromJSON(data: dd)
            
            XCTAssert(point2.longitude == 2.0, "")
            XCTAssert(point2.latitude == 1.0, "")
            
            // Fails, should call the == function from ProtoPoint.pb.swift and take the inverse just like the testRegularPoint() does. But that doesn't happen.
        }
        catch
        {
            XCTFail("testProtoJsonWork")
        }
    }
}

class RegularPointEqualityTest: XCTestCase {
    func testRegularPoint() {
        let point1 = RegularPoint()
        point1.latitude = 1.0
        point1.longitude = 1.0
        
        let point2 = RegularPoint()
        point2.latitude = 2.0
        point2.longitude = 2.0
        
        // works fine, calls the == function and takes the inverse implicitly (put break point to check)
        XCTAssert(point1 != point2, "")
    }
}
