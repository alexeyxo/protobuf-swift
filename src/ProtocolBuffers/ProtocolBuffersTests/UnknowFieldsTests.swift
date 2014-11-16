//
//  UnknowFieldsTests.swift
//  ProtocolBuffers
//
//  Created by Alexey Khokhlov on 14.11.14.
//  Copyright (c) 2014 alexeyxo. All rights reserved.
//

import UIKit
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
        varintField.variantArray += [1]
        var fixed32Field = Field()
        fixed32Field.fixed32Array += [2]
    
        for key in unknownFields.fields.keys {
            var field = unknownFields.fields[key]!
            if (field.variantArray.count == 0) {
                bizarroFields.fields[key] = varintField
            } else {
                bizarroFields.fields[key] = fixed32Field
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
        field1.variantArray += [2]
        set1Builder.fields[2] = field1
        var field2 = Field()
        field2.variantArray += [3]
        set1Builder.fields[3] = field2
        var set1 = set1Builder.build()
        
        var set2Builder = UnknownFieldSet.builder()
        var field3 = Field()
        field3.variantArray += [1]
        set1Builder.fields[1] = field3
        var field4 = Field()
        field4.variantArray += [3]
        set2Builder.fields[3] = field4
        var set2 = set2Builder.build()
        
        
        var set3Builder = UnknownFieldSet.builder()
        var field5 = Field()
        field5.variantArray += [1]
        set3Builder.fields[1] = field5
        var field6 = Field()
        field6.variantArray += [4]
        set3Builder.fields[3] = field6
        var set3 = set3Builder.build()
        
        var set4Builder = UnknownFieldSet.builder()
        var field7 = Field()
        field7.variantArray += [2]
        set4Builder.fields[2] = field7
        var field8 = Field()
        field8.variantArray += [3]
        set4Builder.fields[3] = field8
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
        XCTAssertTrue(mes1.data() == mes2.data(), "")
    }
}
