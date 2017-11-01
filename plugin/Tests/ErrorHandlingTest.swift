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
    
    func testEnumError() {
        do {
            try throwException()
        } catch let err as ServiceError where err == .internalServerError {
            XCTAssertTrue(true)
        } catch {
            XCTAssertTrue(false)
        }
    
    }
    
    func testMessageError() {
        do {
            try throwExceptionMessage()
        } catch let err as UserProfile.Exception {
            print(err)
            XCTAssertTrue(true)
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
    
    func throwExceptionMessage() throws {
        let exception = UserProfile.Exception.Builder()
        exception.errorCode = 403
        exception.errorDescription = "Bad Request"
        let exc = try exception.build()
        let data = try UserProfile.Response.Builder().setException(exc).build().data()
        let userError = try UserProfile.Response.parseFrom(data:data)
        if userError.hasException {
            throw userError.exception
        }
        
    }
    
}
