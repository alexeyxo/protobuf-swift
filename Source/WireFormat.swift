// Protocol Buffers for Swift
//
// Copyright 2014 Alexey Khohklov(AlexeyXo).
// Copyright 2008 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License")
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

public enum WireFormatMessage:Int32 {
    case item = 1
    case `id` = 2
    case message = 3
}

enum ProtocolBuffersWireTypeError:Error {
    case invalidWireType
}

internal enum WireFormat:Int32 {
    case varint = 0
    case fixed64 = 1
    case lengthDelimited = 2
    case startGroup = 3
    case endGroup = 4
    case fixed32 = 5
    case tagTypeMask = 7
    
    internal func makeTag(fieldNumber:Int32) -> Int32 {
        let res:Int32 = fieldNumber << WireFormat.startGroup.rawValue
        return res | self.rawValue
    }
    
    internal static func getTagWireType(tag:Int32) -> Int32 {
        return tag &  WireFormat.tagTypeMask.rawValue
    }
    
    internal static func getTagFieldNumber(tag:Int32) -> Int32 {
        return WireFormat.logicalRightShift32(value: tag ,spaces: startGroup.rawValue)
    }
    
    
    ///Utilities
    
    internal static func convertTypes<T, ReturnType>(convertValue value:T, defaultValue:ReturnType) -> ReturnType {
        var retValue = defaultValue
        var curValue = value
        memcpy(&retValue, &curValue, MemoryLayout<T>.size)
        return retValue
    }
    
    internal static func logicalRightShift32(value aValue:Int32, spaces aSpaces:Int32) ->Int32 {
        var result:UInt32 = 0
        result = convertTypes(convertValue: aValue, defaultValue: result)
        let bytes:UInt32 = (result >> UInt32(aSpaces))
        var res:Int32 = 0
        res = convertTypes(convertValue: bytes, defaultValue: res)
        return res
    }
    
    internal static func logicalRightShift64(value aValue:Int64, spaces aSpaces:Int64) ->Int64 {
        var result:UInt64 = 0
        result = convertTypes(convertValue: aValue, defaultValue: result)
        let bytes:UInt64 = (result >> UInt64(aSpaces))
        var res:Int64 = 0
        res = convertTypes(convertValue: bytes, defaultValue: res)
        return res
    }
    
    internal static func  decodeZigZag32(n:Int32) -> Int32 {
        return logicalRightShift32(value: n, spaces: 1) ^ -(n & 1)
    }
    
    internal static func encodeZigZag32(n:Int32) -> Int32 {
        return (n << 1) ^ (n >> 31)
    }
    
    internal static func  decodeZigZag64(n:Int64) -> Int64 {
        return logicalRightShift64(value: n, spaces: 1) ^ -(n & 1)
    }
    
    internal static func encodeZigZag64(n:Int64) -> Int64 {
        return (n << 1) ^ (n >> 63)
    }
}

public protocol ProtobufWireProtocol {
    associatedtype BaseType
    func computeSizeWith(tag:Int32, value:BaseType) -> Int32
    func computeSizeWithoutTag(value:BaseType) -> Int32
    
    //Defaults
    func repeatedWithoutTag(value:Array<BaseType>) -> Int32
    func repeatedWith(tag:Int32, value:Array<BaseType>) -> Int32
}


//public protocol ProtobufDecoderStream:ProtobufDecoderProtocol {
//    var codedInputStream:CodedInputStream { get }
//}

public struct ProtobufWire {
    public enum `Types`:Int {
        case `int32` = 0
        case `uint32`
        case `sint32`
        case `fixed32`
        case `sfixed32`
        
        case `int64`
        case `uint64`
        case `sint64`
        case `fixed64`
        case `sfixed64`
        
        case `float`
        case `double`
        case `bool`
        case `enum`
        case `bytes`
        
        case `string`
        case `group`
        case `message`

    }

    
    public struct Size {}
    
    struct `int32`:ProtobufWireProtocol {
        typealias BaseType = Int32
        func computeSizeWith(tag:Int32, value:BaseType) -> Int32 {
            return ProtobufWire.Size().computeTagSize(tag: tag) + computeSizeWithoutTag(value: value)
        }
        func computeSizeWithoutTag(value:BaseType) -> Int32 {
            if value >= 0 {
                return ProtobufWire.Size().computeRawVarint32Size(value: value)
            } else {
                return 10
            }
        }
    }
    struct `uint32`:ProtobufWireProtocol {
        typealias BaseType = UInt32
        func computeSizeWith(tag:Int32, value:BaseType) -> Int32 {
            return  ProtobufWire.Size().computeTagSize(tag: tag) + computeSizeWithoutTag(value: value)
        }
        func computeSizeWithoutTag(value:BaseType) -> Int32 {
            var retvalue:Int32 = 0
            retvalue = WireFormat.convertTypes(convertValue: value, defaultValue: retvalue)
            return ProtobufWire.Size().computeRawVarint32Size(value: retvalue)
        }
    
    }
    struct `sint32`:ProtobufWireProtocol {
        typealias BaseType = Int32
        func computeSizeWith(tag:Int32, value:BaseType) -> Int32 {
            return ProtobufWire.Size().computeTagSize(tag: tag) + computeSizeWithoutTag(value: value)
        }
        func computeSizeWithoutTag(value:BaseType) -> Int32 {
            let wire = WireFormat.encodeZigZag32(n: value)
            return  ProtobufWire.Size().computeRawVarint32Size(value: wire)
        }
        
    }
    struct `fixed32`:ProtobufWireProtocol {
        typealias BaseType = UInt32
        func computeSizeWith(tag:Int32, value:BaseType) -> Int32 {
            return  ProtobufWire.Size().computeTagSize(tag: tag) + computeSizeWithoutTag(value: value)
        }
        func computeSizeWithoutTag(value:BaseType) -> Int32 {
            return Int32(MemoryLayout<Int32>.size)
        }
    }
    struct `sfixed32`:ProtobufWireProtocol {
        typealias BaseType = Int32
        func computeSizeWith(tag:Int32, value:BaseType) -> Int32 {
            return ProtobufWire.Size().computeTagSize(tag: tag) + computeSizeWithoutTag(value: value)
        }
        func computeSizeWithoutTag(value:BaseType) -> Int32 {
            return Int32(MemoryLayout<Int32>.size)
        }

    }

    struct `int64`:ProtobufWireProtocol {
        typealias BaseType = Int64
        func computeSizeWith(tag:Int32, value:BaseType) -> Int32 {
            return ProtobufWire.Size().computeTagSize(tag: tag) + computeSizeWithoutTag(value: value)
        }
        func computeSizeWithoutTag(value:BaseType) -> Int32 {
            return ProtobufWire.Size().computeRawVarint64Size(value: value)
        }
    }
    struct `uint64`:ProtobufWireProtocol {
        typealias BaseType = UInt64
        func computeSizeWith(tag:Int32, value:BaseType) -> Int32 {
            return ProtobufWire.Size().computeTagSize(tag: tag) + computeSizeWithoutTag(value: value)
        }
        func computeSizeWithoutTag(value:BaseType) -> Int32 {
            var retvalue:Int64 = 0
            retvalue = WireFormat.convertTypes(convertValue: value, defaultValue:retvalue)
            return ProtobufWire.Size().computeRawVarint64Size(value: retvalue)
        }
        
    }
    struct `sint64`:ProtobufWireProtocol {
        typealias BaseType = Int64
        func computeSizeWith(tag:Int32, value:BaseType) -> Int32 {
            
        }
        func computeSizeWithoutTag(value:BaseType) -> Int32 {
            let wire = WireFormat.encodeZigZag64(n: value)
            return ProtobufWire.Size().computeRawVarint64Size(value: wire)
        }
        
    }
    struct `fixed64`:ProtobufWireProtocol {
        typealias BaseType = UInt64
        func computeSizeWith(tag:Int32, value:BaseType) -> Int32 {
            return ProtobufWire.Size().computeTagSize(tag: tag) + computeSizeWithoutTag(value: value)
        }
        func computeSizeWithoutTag(value:BaseType) -> Int32 {
            return Int32(MemoryLayout<Int64>.size)
        }
        
    }
    struct `sfixed64`:ProtobufWireProtocol {
        typealias BaseType = Int64
        func computeSizeWith(tag:Int32, value:BaseType) -> Int32 {
            return ProtobufWire.Size().computeTagSize(tag: tag) + computeSizeWithoutTag(value: value)
        }
        func computeSizeWithoutTag(value:BaseType) -> Int32 {
            return Int32(MemoryLayout<Int64>.size)
        }
        
    }
    
    struct `float`:ProtobufWireProtocol {
        typealias BaseType = Float
        
        func computeSizeWith(tag:Int32, value:BaseType) -> Int32 {
            return ProtobufWire.Size().computeTagSize(tag: tag) + computeSizeWithoutTag(value: value)
        }
        func computeSizeWithoutTag(value:BaseType) -> Int32 {
            return Int32(MemoryLayout<Int32>.size)
        }
    }
    struct `double`:ProtobufWireProtocol {
        typealias BaseType = Double
        
        func computeSizeWith(tag:Int32, value:BaseType) -> Int32 {
            return ProtobufWire.Size().computeTagSize(tag: tag) + computeSizeWithoutTag(value: value)
        }
        func computeSizeWithoutTag(value:BaseType) -> Int32 {
            return Int32(MemoryLayout<Int64>.size)
        }
        
    }
    struct `bool`:ProtobufWireProtocol {
        typealias BaseType = Bool
        
        func computeSizeWith(tag:Int32, value:BaseType) -> Int32 {
            return ProtobufWire.Size().computeTagSize(tag: tag) + computeSizeWithoutTag(value: value)
        }
        func computeSizeWithoutTag(value:BaseType) -> Int32 {
            return 1
        }
    }
    struct `enum`:ProtobufWireProtocol {

        typealias BaseType = Int32
        func computeSizeWith(tag:Int32, value:BaseType) -> Int32 {
            return ProtobufWire.Size().computeTagSize(tag: tag) + computeSizeWithoutTag(value: value)
        }
        func computeSizeWithoutTag(value:BaseType) -> Int32 {
            return ProtobufWire.Size().computeRawVarint32Size(value:value)
        }
        
    }
    
    struct `string`:ProtobufWireProtocol {
        typealias BaseType = String
    
        func computeSizeWith(tag:Int32, value:BaseType) -> Int32 {
            return ProtobufWire.Size().computeTagSize(tag: tag) + computeSizeWithoutTag(value: value)
        }
        func computeSizeWithoutTag(value:BaseType) -> Int32 {
            let length = value.lengthOfBytes(using: String.Encoding.utf8)
            return ProtobufWire.Size().computeRawVarint32Size(value: Int32(length)) + Int32(length)
        }
        
    }
    struct `group`:ProtobufWireProtocol {
        typealias BaseType = ProtocolBuffersMessage
        func computeSizeWith(tag:Int32, value:BaseType) -> Int32 {
            return ProtobufWire.Size().computeTagSize(tag: tag) * 2 + computeSizeWithoutTag(value: value)
        }
        func computeSizeWithoutTag(value:BaseType) -> Int32 {
             return try! value.serializedSize()
        }
        
    }
    struct `message`:ProtobufWireProtocol {
        typealias BaseType = ProtocolBuffersMessage
        func computeSizeWith(tag:Int32, value:BaseType) -> Int32 {
             return ProtobufWire.Size().computeTagSize(tag: tag) + computeSizeWithoutTag(value: value)
        }
        func computeSizeWithoutTag(value:BaseType) -> Int32 {
            let size:Int32  = try! value.serializedSize()
            return ProtobufWire.Size().computeRawVarint32Size(value: size) + size
        }
        
        func computeMessageSetExtensionSize(tag:Int32, value:ProtocolBuffersMessage) -> Int32 {
            let wire = WireFormatMessage.item.rawValue
            let tag = UInt32(tag)
            return ProtobufWire.Size().computeTagSize(tag: wire) * 2 + ProtobufWire.uint32().computeSizeWith(tag: WireFormatMessage.id.rawValue, value: tag) + computeSizeWith(tag: WireFormatMessage.message.rawValue, value:value)
        }
    }
    
    struct `bytes`:ProtobufWireProtocol {
        typealias BaseType = Data
        func computeSizeWith(tag:Int32, value:BaseType) -> Int32 {
            return ProtobufWire.Size().computeTagSize(tag: tag) + computeSizeWithoutTag(value: value)

        }
        func computeSizeWithoutTag(value:BaseType) -> Int32 {
            let counts = Int32(value.count)
            return ProtobufWire.Size().computeRawVarint32Size(value: counts) + counts
        }
        func computeRawMessageSetExtensionSize(tag:Int32, value:Data) -> Int32 {
            let field = UInt32(tag)
            return ProtobufWire.Size().computeTagSize(tag: WireFormatMessage.item.rawValue) * 2 + ProtobufWire.uint32().computeSizeWith(tag: WireFormatMessage.id.rawValue, value: field) + computeSizeWith(tag: WireFormatMessage.message.rawValue, value: value)
        }
    }
}

fileprivate extension ProtobufWire.Size {
   
    func computeRawVarint64Size(value:Int64) -> Int32 {
        if ((value & (0xfffffffffffffff <<  7)) == 0){return 1}
        if ((value & (0xfffffffffffffff << 14)) == 0){return 2}
        if ((value & (0xfffffffffffffff << 21)) == 0){return 3}
        if ((value & (0xfffffffffffffff << 28)) == 0){return 4}
        if ((value & (0xfffffffffffffff << 35)) == 0){return 5}
        if ((value & (0xfffffffffffffff << 42)) == 0){return 6}
        if ((value & (0xfffffffffffffff << 49)) == 0){return 7}
        if ((value & (0xfffffffffffffff << 56)) == 0){return 8}
        if ((value & (0xfffffffffffffff << 63)) == 0){return 9}
        return 10
    }
    
    func computeRawVarint32Size(value:Int32) -> Int32 {
        if (value & (0xfffffff <<  7)) == 0 {
            return 1
        }
        if (value & (0xfffffff << 14)) == 0 {
            return 2
        }
        if (value & (0xfffffff << 21)) == 0 {
            return 3
        }
        if (value & (0xfffffff << 28)) == 0 {
            return 4
        }
        return 5
    }
    
    func computeTagSize(tag:Int32) ->Int32 {
        let wireType = WireFormat.varint.makeTag(fieldNumber: tag)
        return computeRawVarint32Size(value: wireType)
    }
}



public extension ProtobufWireProtocol  {
    public func repeatedWithoutTag(value:Array<BaseType>) -> Int32 {
        var size:Int32 = 0
        for val in value {
            size += self.computeSizeWithoutTag(value: val)
        }
        return size
    }

    public func repeatedWith(tag:Int32, value:Array<BaseType>) -> Int32 {
        var size:Int32 = 0
        for val in value {
            size += self.computeSizeWith(tag: tag, value: val)
        }
        return size
    }
}

public extension String {
    public func utf8ToData() -> Data {
        let bytes = [UInt8]() + self.utf8
        let data = Data(bytes: UnsafePointer<UInt8>(bytes), count:bytes.count)
        return data
    }
}

fileprivate extension ProtobufWire.Size {
    func computeUnknownGroupSizeNoTag(value: UnknownFieldSet) ->Int32 {
        return value.serializedSize()
    }
    func computeUnknownGroupSize(tag:Int32, value: UnknownFieldSet) ->Int32 {
        return computeTagSize(tag: tag) * 2 + computeUnknownGroupSizeNoTag(value: value)
    }
}





