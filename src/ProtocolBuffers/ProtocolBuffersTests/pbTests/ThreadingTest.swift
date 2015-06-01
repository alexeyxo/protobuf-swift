//
//  TheradingTest.swift
//  ProtocolBuffers
//
//  Created by Alexey Khokhlov on 01.06.15.
//  Copyright (c) 2015 alexeyxo. All rights reserved.
//

import UIKit
import ProtocolBuffers
import XCTest

class Threading {
    
    let queue = dispatch_queue_create("test.testThread", DISPATCH_QUEUE_SERIAL)
    
    init() {
    }
    func send(message:GeneratedMessageBuilder?) {
        if let messageBuilder = message {
            queueToThread() {
                messageBuilder.build().data()
                println("\(messageBuilder.build().data())")
            }
        }
    }
    func queueToThread(runnable:() -> Void) {
        dispatch_async(queue) {
            runnable()
        }
    }   
}

class ThreadingTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testThreading() {
        
        var message = ThreadingMessagesBuilder()
        message.testString = "sadfasdfa"
        let threading = Threading()
        threading.send(message)
    }

}
