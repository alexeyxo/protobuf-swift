//
//  ProtocolBuffersTests.swift
//  ProtocolBuffersTests
//
//  Created by Alexey Khokhlov on 15.09.14.
//  Copyright (c) 2014 alexeyxo. All rights reserved.
//

import Foundation
import XCTest
import ProtocolBuffers
class ProtocolBuffersTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPerformance() {
        var originalBuilder = ProtoPerfomance.builder()
        originalBuilder.ints = Int32(32)
        originalBuilder.ints64 = Int64(64)
        originalBuilder.doubles = Double(12.12)
        originalBuilder.floats = Float(123.123)
        originalBuilder.str = "string"
        originalBuilder.bytes = [1,2,3,4]
        let original = originalBuilder.build()
        
        self.measureBlock() {
            for _ in 0...10000 {
                var clone = ProtoPerfomance.parseFromData(original.data())
            }
        }
    }
    
}
