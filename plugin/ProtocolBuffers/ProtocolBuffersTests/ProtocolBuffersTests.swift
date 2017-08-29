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
//        let builder = AppSharedDialog.Builder()
//        builder.setId(123456789)
//        let build = try! builder.build()
//        let js = try! build.encode()
//        let js2 = try! AppSharedDialog.decode(jsonMap: js)
//        print(js2)
    
        
//        var originalBuilder = PBPerfomance.Builder()
//        originalBuilder.setInts(Int32(-32))
//                       .setInts64(Int64(-64))
//                       .setDoubles(Double(12.12))
//                       .setFloats(Float(123.123))
//                       .setStr("string")
//        let original = originalBuilder.build()
//
//        let original2 = PBPerfomance.parseFrom(original.data())
//        var builder = PBPerfomanceBatch.Builder()
//        
//        for in 0...2 {
//            builder.batch += [original]
//        }
//        
//        var user:PBUser! = nil
//        var group = PBGroup.Builder()
//        
//        group.getOwnerBuilder().setGroupName("asdfasdf")
//        
//        var bazBuilder = PBBaz.Builder()
//        bazBuilder.getBarBuilder().getFooBuilder().setVal(10)
        
        
        
//        let build = builder.build()
//        
        self.measure() {
//            var baz = bazBuilder.build()
//            var gg = group.build()
//            println(baz)
//            println(gg)

        }
    }
//
//    func testPerformanceJson()
//    {
//        
//        var dict:NSMutableDictionary = NSMutableDictionary()
//        
//        dict.setObject(NSNumber(int: 32), forKey: "ints")
//        
//        dict.setObject(NSNumber(integer: 64), forKey: "ints64")
//        
//        dict.setObject(NSNumber(float: 123.123), forKey: "floats")
//        
//        dict.setObject(NSNumber(double: 12.12), forKey: "double")
//        
//        dict.setObject("string", forKey: "string")
//        
//        var arr:Array<NSMutableDictionary> = []
//        for in 0...10000
//        {
//            arr += [dict]
//        }
//        
//        var res:NSMutableDictionary = NSMutableDictionary()
//        
//        res.setObject(arr, forKey: "object")
//
//        var error:NSError?
//        
//        var jsonobject = NSJSONSerialization.dataWithJSONObject(res, options: NSJSONWritingOptions.PrettyPrinted, error:&error)
//        
//        self.measureBlock() {
//            
//            for in 0...1 {
//                
//                var jsonErrorOptional:NSError?
//                let clone2: AnyObject! = NSJSONSerialization.JSONObjectWithData(jsonobject!, options: NSJSONReadingOptions(0), error: &jsonErrorOptional)
//            }
//            
//        }
//        
//    }
    
}
