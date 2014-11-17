//
//  UnknowFieldsTests.swift
//  ProtocolBuffers
//
//  Created by Alexey Khokhlov on 14.11.14.
//  Copyright (c) 2014 alexeyxo. All rights reserved.
//

import Foundation
import XCTest
import ProtocolBuffers
class UnknowFieldsTests: XCTestCase {
    
    var allFields:TestAllTypes =  TestUtilities.allSet()
    var emptyMessage:TestEmptyMessage = TestEmptyMessage.parseFromData(TestUtilities.allSet().data())
    var unknownFields:UnknownFieldSet {
        return emptyMessage.unknownFields
    }

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func getField(number:Int32) -> Field {
        return unknownFields.getField(number)
    }
    
    func getBizarroData() -> [Byte] {
        var bizarroFields = UnknownFieldSet.builder()
        var varintField = Field()
        varintField += Int32(1)
        var fixed32Field = Field()
        fixed32Field += UInt32(2)
    
        for key in unknownFields.fields.keys {
            var field = unknownFields.fields[key]!
            if (field.variantArray.count == 0) {
                bizarroFields.addField(varintField, number: key)
            } else {
                bizarroFields.addField(fixed32Field, number: key)
            }
        }
        return bizarroFields.build().data()
    }
    
    func testSerialize() {
        var data = emptyMessage.data()
        var allFieldsData = allFields.data()
        XCTAssertTrue(allFieldsData == data, "")
    }
    
    func testCopyFrom() {
        var message = TestEmptyMessage.builder().mergeFrom(emptyMessage).build()
        XCTAssertTrue(emptyMessage.data() == message.data(), "")
    }
    func testMergeFrom() {
        var set1Builder = UnknownFieldSet.builder()
        var field1 = Field()
        field1 += Int32(2)
        set1Builder.addField(field1, number: 2)
        var field2 = Field()
        field2 += Int32(4)
        set1Builder.addField(field2, number: 3)
        var set1 = set1Builder.build()
        
        var set2Builder = UnknownFieldSet.builder()
        var field3 = Field()
        field3 += Int32(1)
        set2Builder.addField(field3, number: 1)
        var field4 = Field()
        field4 += Int32(3)
        set2Builder.addField(field4, number: 3)
        var set2 = set2Builder.build()
        
        
        var set3Builder = UnknownFieldSet.builder()
        var field5 = Field()
        field5 += Int32(1)
        set3Builder.addField(field5, number: 1)
        var field6 = Field()
        field6 += Int32(4)
        set3Builder.addField(field6, number: 3)
        var set3 = set3Builder.build()
        
        var set4Builder = UnknownFieldSet.builder()
        var field7 = Field()
        field7 += Int32(2)
        set4Builder.addField(field7, number: 2)
        var field8 = Field()
        field8 += Int32(3)
        set4Builder.addField(field8, number: 3)
        var set4 = set4Builder.build()
    
    
        var source1Builder = TestEmptyMessage.builder()
        source1Builder.unknownFields = set1
        var source1 = source1Builder.build()
        
        var source2Builder = TestEmptyMessage.builder()
        source2Builder.unknownFields = set2
        var source2 = source2Builder.build()

        var source3Builder = TestEmptyMessage.builder()
        source3Builder.unknownFields = set3
        var source3 = source3Builder.build()
        
        var source4Builder = TestEmptyMessage.builder()
        source4Builder.unknownFields = set4
        var source4 = source4Builder.build()
    
        var destination1 = TestEmptyMessage.builder()
        destination1.mergeFrom(source1)
        destination1.mergeFrom(source2)
        var mes1 = destination1.build()
        
        var destination2 = TestEmptyMessage.builder()
        destination2.mergeFrom(source3)
        destination2.mergeFrom(source4)
        var mes2 = destination2.build()
        let rawData1 = mes1.data()
        let rawData2 = mes2.data()
        XCTAssertTrue(rawData1 == rawData2, "")
    }
    
    func testClear() {
        var fields = UnknownFieldSet.builder().mergeUnknownFields(unknownFields).clear().build()
        XCTAssertTrue(fields.fields.count == 0,"")
    }
    
    
    func testClearMessage() {
        var message = TestEmptyMessage.builder().mergeFrom(emptyMessage).clear().build()
        XCTAssertTrue(0 == message.serializedSize(), "")
    }
    
    func testParseKnownAndUnknown() {
        // Test mixing known and unknown fields when parsing.
        var field = Field()
        field += Int32(654321)
        var fields = UnknownFieldSet.builderWithUnknownFields(unknownFields).addField(field, number:123456).build()
        var data = fields.data()
        var destination = TestAllTypes.parseFromData(data)
        TestUtilities.assertAllFieldsSet(destination)
        XCTAssertTrue(1 == destination.unknownFields.fields.count, "")
        var uField = destination.unknownFields.getField(123456)
        XCTAssertTrue(1 == uField.variantArray.count, "")
        XCTAssertTrue(654321 == field.variantArray[0], "")
        
    }
    func testWrongTypeTreatedAsUnknown() {
        // Test that fields of the wrong wire type are treated like unknown fields
        // when parsing.
        var bizarroDatas = getBizarroData()
        var allTypesMessage = TestAllTypes.parseFromData(bizarroDatas)
        var emptyMessage_ = TestEmptyMessage.parseFromData(bizarroDatas)
        // All fields should have been interpreted as unknown, so the debug strings
        // should be the same.
        XCTAssertTrue(emptyMessage_.data() == allTypesMessage.data(), "")
    }

    func testUnknownExtensions() {
        // Make sure fields are properly parsed to the UnknownFieldSet even when
        // they are declared as extension numbers.
        var message = TestEmptyMessageWithExtensions.parseFromData(TestUtilities.allSet().data())
        XCTAssertTrue(unknownFields.fields.count ==  message.unknownFields.fields.count, "")
        XCTAssertTrue(TestUtilities.allSet().data() == message.data(), "")
    }
    
    func testWrongExtensionTypeTreatedAsUnknown() {
        // Test that fields of the wrong wire type are treated like unknown fields
        // when parsing extensions.
        var bizarroData = getBizarroData()
        var allExtensionsMessage = TestAllExtensions.parseFromData(bizarroData)
        var emptyMessage_ = TestEmptyMessage.parseFromData(bizarroData)
        // All fields should have been interpreted as unknown, so the debug strings
        // should be the same.
        XCTAssertTrue(emptyMessage_.data() == allExtensionsMessage.data(), "")
    }
    
    
    func testLargeVarint() {
        var field = Field()
        field += Int64(0x7FFFFFFFFFFFFFFF)
        var data = UnknownFieldSet.builder().addField(field, number:1).build().data()
        var parsed = UnknownFieldSet.parseFromData(data)
        var fields = parsed.getField(1)
        XCTAssertTrue(1 == fields.variantArray.count, "")
        XCTAssertTrue(Int64(0x7FFFFFFFFFFFFFFF) == field.variantArray[0], "")
    }
}
