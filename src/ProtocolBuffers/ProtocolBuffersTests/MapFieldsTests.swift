//
//  MapFieldsTests.swift
//  ProtocolBuffers
//
//  Created by Alexey Khokhlov on 20.05.15.
//  Copyright (c) 2015 alexeyxo. All rights reserved.
//

import XCTest
import Foundation
import ProtocolBuffers
class MapFieldsTests: XCTestCase {
    
    func testMapsFields()
    {
        var mes1Builder = SwiftProtobufUnittest.MessageContainsMap.builder()
        mes1Builder.mapInt32Int32 = [1:2]
        mes1Builder.mapInt64Int64 = [3:4]
        mes1Builder.mapStringString = ["a":"b"]
        mes1Builder.mapStringBytes = ["d":CodedInputStreamTests().bytesArray([1,2,3,4])]
        var containingMessage = SwiftProtobufUnittest.MapMessageValue.builder().setValueInMapMessage(32).build()
        mes1Builder.mapStringMessage = ["c":containingMessage]
        var mes1 = mes1Builder.build()
        var mes2 = SwiftProtobufUnittest.MessageContainsMap.builder().mergeFrom(mes1).build()
        XCTAssert(mes1 == mes2, "")
        XCTAssert(mes2.mapInt32Int32 == [1:2], "")
        XCTAssert(mes2.mapInt64Int64 == [3:4], "")
        XCTAssert(mes2.mapStringString == ["a":"b"], "")
        XCTAssert(mes2.mapStringMessage == ["c":containingMessage], "")
        XCTAssert(mes2.mapStringMessage["c"]?.valueInMapMessage == 32, "")

    }
    
}
