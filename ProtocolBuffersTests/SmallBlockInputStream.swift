//
//  SmallBlockInputStream.swift
//  ProtocolBuffers
//
//  Created by Alexey Khokhlov on 03.08.14.
//  Copyright (c) 2014 Alexey Khokhlov. All rights reserved.
//

import Foundation

class SmallBlockInputStream:InputStream {
    var underlyingStream:InputStream?
    var blockSize:Int32 = 0
    
    func setup(data aData:Data, blocksSize:Int32) {
        underlyingStream = InputStream(data: aData)
        blockSize = blocksSize
    }
    
    override func open() {
        underlyingStream!.open()
    }
    override func close() {
        underlyingStream!.close()
    }
    override func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        return underlyingStream!.read(buffer, maxLength:min(len, Int(blockSize)))
    }
    
    override internal func getBuffer(_ buffer: UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>, length len: UnsafeMutablePointer<Int>) -> Bool {
        return underlyingStream!.getBuffer(buffer, length: len)
    }
    
    override var hasBytesAvailable:Bool {
        get {
            return underlyingStream!.hasBytesAvailable
        }
    }
    
}
