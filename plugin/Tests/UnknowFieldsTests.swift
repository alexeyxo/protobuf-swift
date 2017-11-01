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
    
    var allFields:ProtobufUnittest.TestAllTypes = ProtobufUnittest.TestAllTypes()
    var emptyMessage:ProtobufUnittest.TestEmptyMessage = ProtobufUnittest.TestEmptyMessage()
    var unknownFields:UnknownFieldSet {
        return emptyMessage.unknownFields
    }
    
    override func setUp() {
        super.setUp()
        do {
            allFields = try TestUtilities.allSet()
        }
        catch {
            XCTFail("Fail set up data")
        }
        do {
            let data = try TestUtilities.allSet().data()
            do {
                emptyMessage = try ProtobufUnittest.TestEmptyMessage.parseFrom(data: data)
            }
            catch
            {
                XCTFail("Fail set up data")
            }

        }
        catch
        {
            XCTFail("Fail set up data")
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func getField(_ number:Int32) -> Field {
        return unknownFields.getField(number: number)
    }
    
    func getBizarroData() throws -> Data {
        let bizarroFields = UnknownFieldSet.Builder()
        let letintField = Field()
        letintField += Int32(1)
        let fixed32Field = Field()
        fixed32Field += UInt32(2)
    
        for key in unknownFields.fields.keys {
            
            let field = unknownFields.fields[key]!
            if (field.variantArray.count == 0) {
                try bizarroFields.addField(field: letintField, number: key)
            } else {
                try bizarroFields.addField(field: fixed32Field, number: key)
            }
        }
        return try bizarroFields.build().data()
    }
    
    func testSerialize() {
        let data = emptyMessage.data()
        let allFieldsData = allFields.data()
        XCTAssertTrue(allFieldsData == data, "")
    }
    
    func testCopyFrom() {
        do {
            let message = try ProtobufUnittest.TestEmptyMessage.Builder().mergeFrom(other: emptyMessage).build()
            XCTAssertTrue(emptyMessage.data() == message.data(), "")
        }
        catch
        {
            XCTFail("testCopyFrom")
        }
    }
    func testMergeFrom() {
        
        do {
            let set1Builder = UnknownFieldSet.Builder()
            let field1 = Field()
            field1 += Int32(2)
            try set1Builder.addField(field: field1, number: 2)
            let field2 = Field()
            field2 += Int32(4)
            try set1Builder.addField(field: field2, number: 3)
            let set1 = try set1Builder.build()
            
            let set2Builder = UnknownFieldSet.Builder()
            let field3 = Field()
            field3 += Int32(1)
            try set2Builder.addField(field: field3, number: 1)
            let field4 = Field()
            field4 += Int32(3)
            try set2Builder.addField(field: field4, number: 3)
            let set2 = try set2Builder.build()
            
            
            let set3Builder = UnknownFieldSet.Builder()
            let field5 = Field()
            field5 += Int32(1)
            try set3Builder.addField(field: field5, number: 1)
            let field6 = Field()
            field6 += Int32(4)
            try set3Builder.addField(field: field6, number: 3)
            let set3 = try set3Builder.build()
            
            let set4Builder = UnknownFieldSet.Builder()
            let field7 = Field()
            field7 += Int32(2)
            try set4Builder.addField(field: field7, number: 2)
            let field8 = Field()
            field8 += Int32(3)
            try set4Builder.addField(field: field8, number: 3)
            let set4 = try set4Builder.build()
            
            
            let source1Builder = ProtobufUnittest.TestEmptyMessage.Builder()
            source1Builder.unknownFields = set1
            let source1 = try source1Builder.build()
            
            let source2Builder = ProtobufUnittest.TestEmptyMessage.Builder()
            source2Builder.unknownFields = set2
            let source2 = try source2Builder.build()
            
            let source3Builder = ProtobufUnittest.TestEmptyMessage.Builder()
            source3Builder.unknownFields = set3
            let source3 = try source3Builder.build()
            
            let source4Builder = ProtobufUnittest.TestEmptyMessage.Builder()
            source4Builder.unknownFields = set4
            let source4 = try source4Builder.build()
            
            let destination1 = ProtobufUnittest.TestEmptyMessage.Builder()
            try destination1.mergeFrom(other: source1)
            try destination1.mergeFrom(other: source2)
            let mes1 = try destination1.build()
            
            let destination2 = ProtobufUnittest.TestEmptyMessage.Builder()
            try destination2.mergeFrom(other: source3)
            try destination2.mergeFrom(other: source4)
            let mes2 = try destination2.build()
            let rawData1 = mes1.data()
            let rawData2 = mes2.data()
            XCTAssertTrue(rawData1 == rawData2, "")
        }
        catch
        {
            XCTFail("testMergeFrom")
        }
        
    }
    
    func testClear() {
        do {
            let fields = try UnknownFieldSet.Builder().merge(unknownFields: unknownFields).clear().build()
            XCTAssertTrue(fields.fields.count == 0,"")
        }
        catch {
            XCTFail("testClear")
        }
    }
    
    
    func testClearMessage() {
        do {
            let message = try ProtobufUnittest.TestEmptyMessage.Builder().mergeFrom(other: emptyMessage).clear().build()
            XCTAssertTrue(0 == message.serializedSize(), "")
        }
        catch {
            XCTFail("testClearMessage")
        }
        
    }
    
    func testParseKnownAndUnknown() {
        do {
            // Test mixing known and unknown fields when parsing.
            let field = Field()
            field += Int32(654321)
            let fields = try UnknownFieldSet.builderWithUnknownFields(copyFrom: unknownFields).addField(field: field, number:123456).build()
            let data = try fields.data()
            let destination = try ProtobufUnittest.TestAllTypes.parseFrom(data: data)
            TestUtilities.assertAllFieldsSet(destination)
            XCTAssertTrue(1 == destination.unknownFields.fields.count, "")
            let uField = destination.unknownFields.getField(number: 123456)
            XCTAssertTrue(1 == uField.variantArray.count, "")
            XCTAssertTrue(654321 == field.variantArray[0], "")
        }
        catch {
            XCTFail("testParseKnownAndUnknown")
        }
        
        
    }
    func testWrongTypeTreatedAsUnknown() {
        do {
            // Test that fields of the wrong wire type are treated like unknown fields
            // when parsing.
            let bizarroDatas = try getBizarroData()
            let allTypesMessage = try  ProtobufUnittest.TestAllTypes.parseFrom(data: bizarroDatas)
            let emptyMessage = try ProtobufUnittest.TestEmptyMessage.parseFrom(data: bizarroDatas)
            // All fields should have been interpreted as unknown, so the debug strings
            // should be the same.
            XCTAssertTrue(emptyMessage.data() == allTypesMessage.data(), "")
        }
        catch {
            XCTFail("testWrongTypeTreatedAsUnknown")
        }
        
    }

    func testUnknownExtensions() {
        do {
            // Make sure fields are properly parsed to the UnknownFieldSet even when
            // they are declared as extension numbers.
            let message = try ProtobufUnittest.TestEmptyMessageWithExtensions.parseFrom(data: TestUtilities.allSet().data())
            XCTAssertTrue(unknownFields.fields.count ==  message.unknownFields.fields.count, "")
            let data = try TestUtilities.allSet().data()
            XCTAssertTrue(data == message.data(), "")
        }
        catch {
            XCTFail("testUnknownExtensions")
        }
        
    }
    
    func testWrongExtensionTypeTreatedAsUnknown() {
        do {
            // Test that fields of the wrong wire type are treated like unknown fields
            // when parsing extensions.
            let bizarroData = try getBizarroData()
            let allExtensionsMessage = try ProtobufUnittest.TestAllExtensions.parseFrom(data: bizarroData)
            let emptyMessage = try ProtobufUnittest.TestEmptyMessage.parseFrom(data: bizarroData)
            // All fields should have been interpreted as unknown, so the debug strings
            // should be the same.
            XCTAssertTrue(emptyMessage.data() == allExtensionsMessage.data(), "")
        }
        catch {
            XCTFail("testWrongExtensionTypeTreatedAsUnknown")
        }
    }
    
    
    func testLargeletint() {
        do {
            let field = Field()
            field += Int64(Int64.max)
            let data = try UnknownFieldSet.Builder().addField(field: field, number:1).build().data()
            let parsed = try UnknownFieldSet.parseFrom(data: data)
            let fields = parsed.getField(number: 1)
            XCTAssertTrue(1 == fields.variantArray.count, "")
            XCTAssertTrue(Int64(Int64.max) == field.variantArray[0], "")
        }
        catch {
            XCTFail("testLargeletint")
        }
    }
}
