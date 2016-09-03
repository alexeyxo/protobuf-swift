//
//  ErrorHandlingTest.swift
//  ProtocolBuffers
//
//  Created by Alexey Khokhlov on 03.09.16.
//  Copyright © 2016 alexeyxo. All rights reserved.
//

import XCTest
import ProtocolBuffers
class ErrorHandlingTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
       
    }
    
    override func tearDown() {
    
        super.tearDown()
    }
    
    func testExample() {
        do {
            try throwException()
        } catch let err as ServiceError {
            if err == .internalServerError {
                XCTAssertTrue(true)
            } else {
                XCTAssertTrue(false)
            }
        } catch {
            XCTAssertTrue(false)
        }
    
    }
    
    func throwException() throws {
        let user = UserProfile.Response.Builder()
        user.error = .internalServerError
        let data = try user.build().data()
        let userError = try UserProfile.Response.parseFrom(data:data)
        if userError.hasError {
            throw userError.error
        }
        
    }
    
}
