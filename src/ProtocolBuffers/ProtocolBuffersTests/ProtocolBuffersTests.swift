//
//  ProtocolBuffersTests.swift
//  ProtocolBuffersTests
//
//  Created by Alexey Khokhlov on 15.09.14.
//  Copyright (c) 2014 alexeyxo. All rights reserved.
//

import Foundation
import XCTest

class ProtocolBuffersTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testExample() {
//        // This is an example of a functional test case.
//        XCTAssert(true, "Pass")
//    }
    
    func testPerformance() {
        var originalBuilder:PerfomanceBuilder = Perfomance.builder()
        originalBuilder.ints = Int32(32)
        originalBuilder.ints64 = Int64(64)
        originalBuilder.doubles = Double(12.12)
        originalBuilder.floats = Float(123.123)
        originalBuilder.str = "string"
        let original = originalBuilder.build()
        self.measureBlock() {
            for _ in 0...10000 {
                var clone = Perfomance.parseFromData(original.data())
            }
        }
    }
    
}
