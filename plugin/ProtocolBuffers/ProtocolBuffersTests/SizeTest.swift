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
        XCTAssertTrue(4 == MemoryLayout<Int32>.size)
        XCTAssertTrue(8 == MemoryLayout<Int64>.size)
        XCTAssertTrue(8 == MemoryLayout<UInt64>.size)
        XCTAssertTrue(4 == MemoryLayout<UInt32>.size)
        XCTAssertTrue(4 == MemoryLayout<Float>.size)
        XCTAssertTrue(8 == MemoryLayout<Double>.size)
        XCTAssertTrue(1 == MemoryLayout<Bool>.size)
    }

}
