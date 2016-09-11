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
        do {
            let mes1Builder = SwiftProtobufUnittest.MessageContainsMap.Builder()
            mes1Builder.mapInt32Int32 = [1:2]
            mes1Builder.mapInt64Int64 = [3:4]
            mes1Builder.mapStringString = ["a":"b"]
            mes1Builder.mapStringBytes = ["d":CodedInputStreamTests().bytesArray(from: [1,2,3,4])]
            let containingMessage = try SwiftProtobufUnittest.MapMessageValue.Builder().setValueInMapMessage(32).build()
            mes1Builder.mapStringMessage = ["c":containingMessage]
            let mes1 = try mes1Builder.build()
            let mes2 = try SwiftProtobufUnittest.MessageContainsMap.Builder().mergeFrom(other:mes1).build()
            XCTAssert(mes1 == mes2, "")
            XCTAssert(mes2.mapInt32Int32 == [1:2], "")
            XCTAssert(mes2.mapInt64Int64 == [3:4], "")
            XCTAssert(mes2.mapStringString == ["a":"b"], "")
            XCTAssert(mes2.mapStringMessage == ["c":containingMessage], "")
            XCTAssert(mes2.mapStringMessage["c"]?.valueInMapMessage == 32, "")
        }
        catch {
            XCTFail("testMapsFields")
        }

    }
    
}
