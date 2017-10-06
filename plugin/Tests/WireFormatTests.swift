//
//  WireFormatTests.swift
//  ProtocolBuffers
//
//  Created by Alexey Khokhlov on 12.11.14.
//  Copyright (c) 2014 alexeyxo. All rights reserved.
//

import Foundation
import XCTest
import ProtocolBuffers

class WireFormatTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    func testSerialization() {
        do {
            let message = try TestUtilities.allSet()
            let rawBytes = message.data()
            XCTAssertTrue(rawBytes.count == Int(message.serializedSize()), "")
            let message2 = try ProtobufUnittest.TestAllTypes.parseFrom(data:rawBytes)
            TestUtilities.assertAllFieldsSet(message2)
        }
        catch
        {
            XCTFail("testSerialization")
        }
        
    }
    
    func testSerializationPacked() {
        do {
            let message = try TestUtilities.packedSet()
            let rawBytes = message.data()
            XCTAssertTrue(rawBytes.count == Int(message.serializedSize()), "")
            let message2 = try ProtobufUnittest.TestPackedTypes.parseFrom(data:rawBytes)
            TestUtilities.assertPackedFieldsSet(message2)
        }
        catch {
            XCTFail("testSerializationPacked")
        }
        
    }
    
    func testSerializeExtensions() {
        do {
            let message = try TestUtilities.allExtensionsSet()
            let rawBytes = message.data()
            XCTAssertTrue(rawBytes.count == Int(message.serializedSize()), "")
            let message2 = try ProtobufUnittest.TestAllTypes.parseFrom(data:rawBytes)
            TestUtilities.assertAllFieldsSet(message2)
        }
        catch {
            XCTFail("testSerializeExtensions")
        }
    }
    func testSerializePackedExtensions() {
        do {
            // TestPackedTypes and TestPackedExtensions should have compatible wire
            // formats check that they serialize to the same string.
            let message = try TestUtilities.packedExtensionsSet()
            let rawBytes = message.data()
            let message2 = try TestUtilities.packedSet()
            let rawBytes2 = message2.data()
            XCTAssertTrue(rawBytes == rawBytes2, "")
        }
        catch {
            XCTFail("testSerializePackedExtensions")
        }
        
    }
    
    func testParseExtensions() {
        do {
            // TestAllTypes and TestAllExtensions should have compatible wire formats,
            // so if we serealize a TestAllTypes then parse it as TestAllExtensions
            // it should work.
            let message = try TestUtilities.allSet()
            let rawBytes = message.data()
            let registry = ExtensionRegistry()
            TestUtilities.registerAllExtensions(registry)
            let message2 = try ProtobufUnittest.TestAllExtensions.parseFrom(data:rawBytes, extensionRegistry:registry)
            TestUtilities.assertAllExtensionsSet(message2)
        }
        catch {
            XCTFail("testParseExtensions")
        }
        
    }
    
    func testExtensionsSerializedSize() {
        
        do {
            let allset = try TestUtilities.allSet().serializedSize()
            let extSet = try TestUtilities.allExtensionsSet().serializedSize()
            XCTAssertTrue(allset == extSet, "")
        }
        catch {
            XCTFail("testExtensionsSerializedSize")
        }
        
    }
    
    func testParsePackedExtensions() {
        do {
            let message = try TestUtilities.packedExtensionsSet()
            let rawBytes = message.data()
            let registry = TestUtilities.extensionRegistry()
            let message2 = try ProtobufUnittest.TestPackedExtensions.parseFrom(data:rawBytes, extensionRegistry:registry)
            TestUtilities.assertPackedExtensionsSet(message2)
        }
        catch {
            XCTFail("testParsePackedExtensions")
        }
    }
}
