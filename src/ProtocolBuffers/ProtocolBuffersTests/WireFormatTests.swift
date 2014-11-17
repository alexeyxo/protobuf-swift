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
        var message = TestUtilities.allSet()
        var rawBytes = message.data()
        XCTAssertTrue(rawBytes.count == Int(message.serializedSize()), "")
        var message2 = TestAllTypes.parseFromData(rawBytes)
        TestUtilities.assertAllFieldsSet(message2)
    }
    
    func testSerializationPacked() {
        var message = TestUtilities.packedSet()
        var rawBytes = message.data()
        XCTAssertTrue(rawBytes.count == Int(message.serializedSize()), "")
        var message2 = TestPackedTypes.parseFromData(rawBytes)
        TestUtilities.assertPackedFieldsSet(message2)
    }
    
    func testSerializeExtensions() {
        var message = TestUtilities.allExtensionsSet()
        var rawBytes = message.data()
        XCTAssertTrue(rawBytes.count == Int(message.serializedSize()), "")
        var message2 = TestAllTypes.parseFromData(rawBytes)
        TestUtilities.assertAllFieldsSet(message2)
    }
    func testSerializePackedExtensions() {
        // TestPackedTypes and TestPackedExtensions should have compatible wire
        // formats check that they serialize to the same string.
        var message = TestUtilities.packedExtensionsSet()
        var rawBytes = message.data()
        var message2 = TestUtilities.packedSet()
        var rawBytes2 = message2.data()
        XCTAssertTrue(rawBytes == rawBytes2, "")
    }
    
    func testParseExtensions() {
        // TestAllTypes and TestAllExtensions should have compatible wire formats,
        // so if we serealize a TestAllTypes then parse it as TestAllExtensions
        // it should work.
        var message = TestUtilities.allSet()
        var rawBytes = message.data()
        var registry = ExtensionRegistry()
        TestUtilities.registerAllExtensions(registry)
        var message2 = TestAllExtensions.parseFromData(rawBytes, extensionRegistry:registry)
        TestUtilities.assertAllExtensionsSet(message2)
    }
    
    func testExtensionsSerializedSize() {
        XCTAssertTrue(TestUtilities.allSet().serializedSize() == TestUtilities.allExtensionsSet().serializedSize(), "")
    }
    
    func testParsePackedExtensions() {
        var message = TestUtilities.packedExtensionsSet()
        var rawBytes = message.data()
        var registry = TestUtilities.extensionRegistry()
        var message2 = TestPackedExtensions.parseFromData(rawBytes, extensionRegistry:registry)
        TestUtilities.assertPackedExtensionsSet(message2)
    }
}
