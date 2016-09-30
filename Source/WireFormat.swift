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

public protocol ProtobufDecoderProtocol {
    associatedtype ReadValueOfType
    var wireType: ProtobufWire.Types { get }
    func read() throws -> ReadValueOfType
}

public protocol ProtobufDecoderStream:ProtobufDecoderProtocol {
    var codedInputStream:CodedInputStream { get }
}

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
        
        case `string`
        case `group`
        case `message`

    }

    public struct Size {
        fileprivate let wireType: ProtobufWire.Types
        public init(wireType:ProtobufWire.Types) {
            self.wireType = wireType
        }
    }

    public func sum() {
        let a = try? ProtobufDecoder<Int32>(input:CodedInputStream(data: Data()), wireType: .int32).read()
    }

}

public struct ProtobufDecoder<T>:ProtobufDecoderStream {
    public typealias ReadValueOfType = T
    public var codedInputStream:CodedInputStream
    init(input:CodedInputStream, wireType: ProtobufWire.Types) {
        self.codedInputStream = input
        self.wireType = wireType
    }
    public func readTag() throws -> Int32 {
        return try self.codedInputStream.readTag()
    }
    public let wireType: ProtobufWire.Types
    public func read() throws -> T {
        throw ProtocolBuffersWireTypeError.invalidWireType
    }
}

public extension ProtobufDecoderStream where ReadValueOfType == Int32 {
    public func read() throws -> ReadValueOfType {
        switch self.wireType {
        case .int32: return try self.codedInputStream.readInt32()
        default: throw ProtocolBuffersWireTypeError.invalidWireType
        }
    }
}

public extension ProtobufWire.Size {
    public func repeatedWithoutTag<T>(value:Array<T>) throws -> Int32 {
        var size:Int32 = 0
        for val in value {
            size += try self.withoutTag(value: val)
        }
        return size
    }

    public func repeatedWith<T>(tag:Int32, value:Array<T>) throws -> Int32 {
        var size:Int32 = 0
        for val in value {
            size += try self.with(tag: tag, value: val)
        }
        return size
    }

    public func with(tag:Int32, value:Any) throws -> Int32 {

        switch self.wireType {
        case .`int32`:
            guard let val = value as? Int32 else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeInt32Size(tag: tag, value: val)
        case .`uint32`:
            guard let val = value as? UInt32 else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeUInt32Size(tag: tag, value: val)
        case .`sint32`:
            guard let val = value as? Int32 else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeSInt32Size(tag: tag, value: val)
        case .`fixed32`:
            guard let _ = value as? UInt32 else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeFixed32Size(tag: tag)
        case .`sfixed32`:
            guard let val = value as? Int32 else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeSFixed32Size(tag: tag, value: val)
        case .`int64`:
            guard let val = value as? Int64 else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeInt64Size(tag: tag, value: val)
        case .`uint64`:
            guard let val = value as? UInt64 else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeUInt64Size(tag: tag, value: val)
        case .`sint64`:
            guard let val = value as? Int64 else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeSInt64Size(tag: tag, value: val)
        case .`fixed64`:
            guard let val = value as? UInt64 else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeFixed64Size(tag: tag, value: val)
        case .`sfixed64`:
            guard let val = value as? Int64 else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeSFixed64Size(tag: tag, value: val)
        case .`float`:
            guard let val = value as? Float else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeFloatSize(tag: tag, value: val)
        case .`double`:
            guard let val = value as? Double else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeDoubleSize(tag:tag, value: val)
        case .`bool`:
            guard let _ = value as? Bool else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeBoolSize(tag: tag)
        case .`enum`:
            guard let val = value as? Int32 else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return self.computeEnumSize(tag: tag, value: val)

        case .`string`:
            guard let val = value as? String else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return self.computeStringSize(tag: tag, value: val)
        case .`group`:
            guard let val = value as? ProtocolBuffersMessage else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return try self.computeGroupSize(tag: tag, value: val)
        case .`message`:
            guard let val = value as? ProtocolBuffersMessage else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return try self.computeMessageSize(tag: tag, value: val)
        }
    }

    public func withoutTag(value:Any) throws -> Int32 {

        switch self.wireType {
        case .`int32`:
            guard let val = value as? Int32 else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeInt32SizeNoTag(value: val)
        case .`uint32`:
            guard let val = value as? UInt32 else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeUInt32SizeNoTag(value: val)
        case .`sint32`:
            guard let val = value as? Int32 else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeSInt32SizeNoTag(value: val)
        case .`fixed32`:
            guard let _ = value as? UInt32 else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeFixed32SizeNoTag()
        case .`sfixed32`:
            guard let _ = value as? Int32 else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeSFixed32SizeNoTag()
        case .`int64`:
            guard let val = value as? Int64 else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeInt64SizeNoTag(value: val)
        case .`uint64`:
            guard let val = value as? UInt64 else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeUInt64SizeNoTag(value: val)
        case .`sint64`:
            guard let val = value as? Int64 else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeSInt64SizeNoTag(value: val)
        case .`fixed64`:
            guard let _ = value as? UInt64 else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeFixed64SizeNoTag()
        case .`sfixed64`:
            guard let _ = value as? Int64 else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeSFixed64SizeNoTag()
        case .`float`:
            guard let _ = value as? Float else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeFloatSizeNoTag()
        case .`double`:
            guard let _ = value as? Double else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeDoubleSizeNoTag()
        case .`bool`:
            guard let _ = value as? Bool else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return computeBoolSizeNoTag()
        case .`enum`:
            guard let val = value as? Int32 else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return self.computeEnumSizeNoTag(value: val)

        case .`string`:
            guard let val = value as? String else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return self.computeStringSizeNoTag(value: val)
        case .`group`:
            guard let val = value as? ProtocolBuffersMessage else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return try self.computeGroupSizeNoTag(value: val)
        case .`message`:
            guard let val = value as? ProtocolBuffersMessage else {
                throw ProtocolBuffersWireTypeError.invalidWireType
            }
            return try self.computeMessageSizeNoTag(value: val)
        }
    }
}

fileprivate extension ProtobufWire.Size {
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

fileprivate extension ProtobufWire.Size {
    func computeInt32SizeNoTag(value:Int32) -> Int32 {
        if value >= 0 {
            return computeRawVarint32Size(value: value)
        } else {
            return 10
        }
    }

    func computeSFixed32SizeNoTag() -> Int32 {
        return Int32(MemoryLayout<Int32>.size)
    }
    func computeSInt32SizeNoTag(value:Int32) -> Int32 {
        let wire = WireFormat.encodeZigZag32(n: value)
        return computeRawVarint32Size(value: wire)
    }
    func computeInt32Size(tag:Int32, value:Int32) -> Int32 {
        return computeTagSize(tag: tag) + computeInt32SizeNoTag(value: value)
    }

    func computeSFixed32Size(tag:Int32, value:Int32) -> Int32 {
        return computeTagSize(tag: tag) + computeSFixed32SizeNoTag()
    }

    func computeSInt32Size(tag:Int32, value:Int32) -> Int32 {
        return computeTagSize(tag: tag) + computeSInt32SizeNoTag(value: value)
    }
}

fileprivate extension ProtobufWire.Size {
    func computeFixed32SizeNoTag() ->Int32 {
        return Int32(MemoryLayout<Int32>.size)
    }
    func computeUInt32SizeNoTag(value:UInt32) -> Int32 {
        var retvalue:Int32 = 0
        retvalue = WireFormat.convertTypes(convertValue: value, defaultValue: retvalue)
        return computeRawVarint32Size(value: retvalue)
    }
    func computeFixed32Size(tag:Int32) -> Int32 {
        return computeTagSize(tag: tag) + computeFixed32SizeNoTag()
    }
    func computeUInt32Size(tag:Int32, value: UInt32) -> Int32 {
        return computeTagSize(tag: tag) + computeUInt32SizeNoTag(value: value)
    }
}

fileprivate extension ProtobufWire.Size {
    func computeEnumSizeNoTag(value:Int32) -> Int32 {
        return computeRawVarint32Size(value:value)
    }
    func computeEnumSize(tag:Int32, value:Int32) -> Int32 {
        return computeTagSize(tag: tag) + computeEnumSizeNoTag(value: value)
    }
}

fileprivate extension ProtobufWire.Size {
    func computeInt64SizeNoTag(value:Int64) -> Int32 {
        return computeRawVarint64Size(value: value)
    }

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

    func computeSInt64SizeNoTag(value:Int64) -> Int32 {
        let wire = WireFormat.encodeZigZag64(n: value)
        return computeRawVarint64Size(value: wire)
    }

    func computeInt64Size(tag:Int32, value:Int64) -> Int32 {
        return computeTagSize(tag: tag) + computeInt64SizeNoTag(value: value)
    }

    func computeSFixed64SizeNoTag() -> Int32 {
        return Int32(MemoryLayout<Int64>.size)
    }

    func computeSFixed64Size(tag:Int32, value:Int64) -> Int32 {
        return computeTagSize(tag: tag) + computeSFixed64SizeNoTag()
    }

    func computeSInt64Size(tag:Int32, value:Int64) ->Int32 {
        let wire = WireFormat.encodeZigZag64(n: value)
        return computeTagSize(tag:tag) + computeRawVarint64Size(value: wire)
    }
}

fileprivate extension ProtobufWire.Size {
    func computeDoubleSizeNoTag() -> Int32 {
        return Int32(MemoryLayout<Int64>.size)
    }
    
    func computeDoubleSize(tag:Int32, value:Double) ->Int32 {
        return computeTagSize(tag: tag) + self.computeDoubleSizeNoTag()
    }
}
fileprivate extension ProtobufWire.Size {
    func computeFloatSizeNoTag() -> Int32 {
        return Int32(MemoryLayout<Int32>.size)
    }
    func computeFloatSize(tag:Int32, value:Float) -> Int32 {
        return computeTagSize(tag: tag) + self.computeFloatSizeNoTag()
    }
}

fileprivate extension ProtobufWire.Size
{
    func computeFixed64SizeNoTag() ->Int32 {
        return Int32(MemoryLayout<Int64>.size)
    }
    
    func computeUInt64SizeNoTag(value:UInt64) -> Int32 {
        var retvalue:Int64 = 0
        retvalue = WireFormat.convertTypes(convertValue: value, defaultValue:retvalue)
        return computeRawVarint64Size(value: retvalue)
    }

    func computeUInt64Size(tag:Int32, value: UInt64) -> Int32 {
        return computeTagSize(tag: tag) + computeUInt64SizeNoTag(value: value)
    }
    
    func computeFixed64Size(tag:Int32, value:UInt64) ->Int32 {
        return computeTagSize(tag: tag) + computeFixed64SizeNoTag()
    }

}

fileprivate extension ProtobufWire.Size {
    func computeBoolSizeNoTag() -> Int32 {
        return 1
    }
    func computeBoolSize(tag:Int32) ->Int32 {
        return computeTagSize(tag: tag) + computeBoolSizeNoTag()
    }
}

fileprivate extension ProtobufWire.Size {
    func computeStringSizeNoTag(value:String) -> Int32 {
        let length = value.lengthOfBytes(using: String.Encoding.utf8)
        return computeRawVarint32Size(value: Int32(length)) + Int32(length)
    }
    
    func computeStringSize(tag:Int32, value:String) -> Int32 {
        return computeTagSize(tag: tag) + computeStringSizeNoTag(value: value)
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
    func computeGroupSizeNoTag(value:ProtocolBuffersMessage) throws -> Int32 {
        return try value.serializedSize()
    }
    
    func computeMessageSizeNoTag(value:ProtocolBuffersMessage) throws ->Int32 {
        let size:Int32  = try value.serializedSize()
        return computeRawVarint32Size(value: size) + size
    }
    
    func computeGroupSize(tag:Int32, value:ProtocolBuffersMessage) throws -> Int32 {
        return try computeTagSize(tag: tag) * 2 + computeGroupSizeNoTag(value: value)
    }
    
    func computeMessageSize(tag:Int32, value:ProtocolBuffersMessage) throws -> Int32 {
        return try computeTagSize(tag: tag) + computeMessageSizeNoTag(value: value)
    }
    
    func computeMessageSetExtensionSize(tag:Int32, value:ProtocolBuffersMessage) throws -> Int32 {
        let wire = WireFormatMessage.item.rawValue
        let tag = UInt32(tag)
        return try computeTagSize(tag: wire) * 2 + computeUInt32Size(tag: WireFormatMessage.id.rawValue, value: tag) + computeMessageSize(tag: WireFormatMessage.message.rawValue, value:value)
    }
}

fileprivate extension ProtobufWire.Size {
    func computeDataSizeNoTag(value:Data) -> Int32 {
        let counts = Int32(value.count)
        return computeRawVarint32Size(value: counts) + counts
    }
    func computeDataSize(tag:Int32, value:Data) -> Int32 {
        return computeTagSize(tag: tag) + computeDataSizeNoTag(value: value)
    }
    
    func computeRawMessageSetExtensionSize(tag:Int32, value:Data) -> Int32 {
        let field = UInt32(tag)
        return computeTagSize(tag: WireFormatMessage.item.rawValue) * 2 + computeUInt32Size(tag: WireFormatMessage.id.rawValue, value: field) + computeDataSize(tag: WireFormatMessage.message.rawValue, value: value)
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





