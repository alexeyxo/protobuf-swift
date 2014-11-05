//
//  SmallBlockInputStream.swift
//  ProtocolBuffers
//
//  Created by Alexey Khokhlov on 03.08.14.
//  Copyright (c) 2014 Alexey Khokhlov. All rights reserved.
//

import Foundation

class SmallBlockInputStream:NSInputStream
{
    var underlyingStream:NSInputStream?
    var blockSize:Int32 = 0
    
    
    func setup(data aData:NSData, blocksSize:Int32)
    {
        underlyingStream = NSInputStream(data: aData)
        blockSize = blocksSize
    }
    
    override func open()
    {
        underlyingStream!.open()
    }
    override func close()
    {
        underlyingStream!.close()
    }
    override func read(buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int
    {
        return underlyingStream!.read(buffer, maxLength:min(len, Int(blockSize)))
    }
    
    override func getBuffer(buffer: UnsafeMutablePointer<UnsafeMutablePointer<UInt8>>, length len: UnsafeMutablePointer<Int>) -> Bool {
        return underlyingStream!.getBuffer(buffer, length: len)
    }
    
    
    func hasBytesAvailable() -> Bool {
        return underlyingStream!.hasBytesAvailable
    }
}