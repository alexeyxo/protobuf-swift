//
//  SizeTest.swift
//  ProtocolBuffers
//
//  Created by Alexey Khokhlov on 10.11.14.
//  Copyright (c) 2014 alexeyxo. All rights reserved.
//

import Foundation
import XCTest

class SizeTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTypeSizes() {
        XCTAssertTrue(4 == sizeof(Int32))
        XCTAssertTrue(8 == sizeof(Int64))
        XCTAssertTrue(8 == sizeof(UInt64))
        XCTAssertTrue(4 == sizeof(UInt32))
        XCTAssertTrue(4 == sizeof(Float))
        XCTAssertTrue(8 == sizeof(Double))
        XCTAssertTrue(1 == sizeof(Bool))
    }

}
