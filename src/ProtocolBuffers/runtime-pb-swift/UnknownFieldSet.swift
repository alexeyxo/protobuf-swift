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

public func == (lhs: UnknownFieldSet, rhs: UnknownFieldSet) -> Bool
{
    return lhs.fields == rhs.fields
}

public class UnknownFieldSet:Hashable,Equatable
{
    public var fields:Dictionary<Int32,Field>

    convenience public init()
    {
        self.init(fields: Dictionary())
    }
   
    public init(fields:Dictionary<Int32,Field>)
    {
        self.fields = fields
    }
    public var hashValue:Int
    {
        get {
            var hashCode:Int = 0
            for value in fields.values
            {
                hashCode = (hashCode &* 31) &+ value.hashValue
            }
            return hashCode
        }
    }
    public func hasField(number:Int32) -> Bool
    {
        guard fields[number] != nil else
        {
            return false
        }
        return true        
    }
    public func getField(number:Int32) -> Field
    {
        if let field = fields[number]
        {
            return field
        }
        return Field()
    }
    public func writeToCodedOutputStream(output:CodedOutputStream) throws
    {
        var sortedKeys = Array(fields.keys)
        sortedKeys.sortInPlace { $0 < $1 }
        for number in sortedKeys
        {
            let value:Field = fields[number]!
            try value.writeTo(number, output: output)
        }
    }
    
    public func writeToOutputStream(output:NSOutputStream) throws
    {
        let codedOutput:CodedOutputStream = CodedOutputStream(output: output)
        try writeToCodedOutputStream(codedOutput)
        try codedOutput.flush()
    }
    
    public func writeDescriptionTo(inout output:String, indent:String)
    {
        var sortedKeys = Array(fields.keys)
        sortedKeys.sortInPlace { $0 < $1 }
        for number in sortedKeys
        {
            let value:Field = fields[number]!
            value.writeDescriptionFor(number, outputString: &output, indent: indent)
        }
    }
    
    public class func builder() -> UnknownFieldSet.Builder {
        return UnknownFieldSet.Builder()
    }
    
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> UnknownFieldSet {
        return try UnknownFieldSet.Builder().mergeFromCodedInputStream(input).build()
    }
    
    
    public class func parseFromData(data:NSData) throws -> UnknownFieldSet {
        return try UnknownFieldSet.Builder().mergeFromData(data).build()
    }
    
    
    public class func parseFromInputStream(input:NSInputStream) throws -> UnknownFieldSet
    {
        return try UnknownFieldSet.Builder().mergeFromInputStream(input).build()
    }

    public class func builderWithUnknownFields(copyFrom:UnknownFieldSet) throws -> UnknownFieldSet.Builder
    {
        return try UnknownFieldSet.Builder().mergeUnknownFields(copyFrom)
    }
    
    public func serializedSize()->Int32
    {
        var result:Int32 = 0
        for number in fields.keys
        {
            let field:Field = fields[number]!
            result += field.getSerializedSize(number)
        }
        return result
    }
    
    public func writeAsMessageSetTo(output:CodedOutputStream) throws
    {
        for number in fields.keys
        {
            let field:Field = fields[number]!
            try field.writeAsMessageSetExtensionTo(number, output:output)
        }
    }
    
    public func serializedSizeAsMessageSet() -> Int32
    {
        var result:Int32 = 0
        for number in fields.keys
        {
            let field:Field = fields[number]!
            result += field.getSerializedSizeAsMessageSetExtension(number)
        }
        return result
    }
    
    public func data() throws -> NSData
    {
        let size = serializedSize()
        let data = NSMutableData(length: Int(size))!
        let stream:CodedOutputStream = CodedOutputStream(data: data)
        try writeToCodedOutputStream(stream)
        return stream.buffer.buffer
    }
    
    public class Builder
    {
        private var fields:Dictionary<Int32,Field>
        private var lastFieldNumber:Int32
        private var lastField:Field?
        public init()
        {
            fields = Dictionary()
            lastFieldNumber = 0
        }
        
        public func addField(field:Field, number:Int32) throws -> UnknownFieldSet.Builder {
            
            guard number != 0 else
            {
                throw ProtocolBuffersError.IllegalArgument("Illegal Field Number")
            }
            if (lastField != nil && lastFieldNumber == number) {
                lastField = nil
                lastFieldNumber = 0
            }
            fields[number]=field
            return self
        }
        public func getFieldBuilder(number:Int32) throws -> Field?
        {
            if (lastField != nil) {
                if (number == lastFieldNumber) {
                    return lastField
                }
                try addField(lastField!, number:lastFieldNumber)
                
            }
            if (number == 0)
            {
                return nil
            }
            else
            {
                let existing = fields[number]
                lastFieldNumber = number
                lastField = Field()
                if (existing != nil) {
                    lastField?.mergeFromField(existing!)
                }
                return lastField
            }
        }
        
        public func build() throws -> UnknownFieldSet
        {
            try getFieldBuilder(0)
            var result:UnknownFieldSet
            if (fields.count == 0) {
                result = UnknownFieldSet(fields: Dictionary())
                
            }
            else
            {
                
                result = UnknownFieldSet(fields: fields)
                
            }
            fields.removeAll(keepCapacity: false)
            return result
        }
        
        public func buildPartial() throws -> UnknownFieldSet?
        {
            throw ProtocolBuffersError.Obvious("UnsupportedMethod")
        }
        
        public func clone() throws -> UnknownFieldSet?
        {
            throw ProtocolBuffersError.Obvious("UnsupportedMethod")
        }
        
        public func isInitialized() -> Bool
        {
            return true
        }
        public func unknownFields() throws -> UnknownFieldSet {
            return try build()
        }
        public func setUnknownFields(unknownFields:UnknownFieldSet) throws -> UnknownFieldSet.Builder?
        {
            throw ProtocolBuffersError.Obvious("UnsupportedMethod")
        }
        public func hasField(number:Int32) throws -> Bool
        {
            guard number != 0 else
            {
                throw ProtocolBuffersError.IllegalArgument("Illegal Field Number")
            }
            
            return number == lastFieldNumber || (fields[number] != nil)
        }
        
        public func mergeField(field:Field, number:Int32) throws -> UnknownFieldSet.Builder
        {
            guard number != 0 else
            {
                throw ProtocolBuffersError.IllegalArgument("Illegal Field Number")
            }
            if (try hasField(number)) {
                try getFieldBuilder(number)?.mergeFromField(field)
            }
            else
            {
                try addField(field, number:number)
            }
            return self
        }
        
        public func mergeUnknownFields(other:UnknownFieldSet) throws -> UnknownFieldSet.Builder
        {
            for number in other.fields.keys
            {
                let field:Field = other.fields[number]!
                try mergeField(field ,number:number)
            }
            return self
        }
        
        
        public func mergeFromData(data:NSData) throws -> UnknownFieldSet.Builder
        {
            let input:CodedInputStream = CodedInputStream(data: data)
            try mergeFromCodedInputStream(input)
            try input.checkLastTagWas(0)
            return self
        }
        
        public func mergeFromInputStream(input:NSInputStream) throws -> UnknownFieldSet.Builder
        {
            throw ProtocolBuffersError.Obvious("UnsupportedMethod")
        }
        public func mergeFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> UnknownFieldSet.Builder
        {
            throw ProtocolBuffersError.Obvious("UnsupportedMethod")
        }
        
        public func mergeVarintField(number:Int32, value:Int64) throws -> UnknownFieldSet.Builder
        {
            guard number != 0 else
            {
                throw ProtocolBuffersError.IllegalArgument("Illegal Field Number: Zero is not a valid field number.")
            }
            try getFieldBuilder(number)?.variantArray.append(value)
            return self
        }
        
        public func mergeFieldFrom(tag:Int32, input:CodedInputStream) throws -> Bool
        {
            
            let number = WireFormat.getTagFieldNumber(tag)
            let tags = WireFormat.getTagWireType(tag)
            let format:WireFormat? = WireFormat(rawValue: tags)
            
            guard let _ = format else {
                 throw ProtocolBuffersError.InvalidProtocolBuffer("Invalid Wire Type")
            }
            switch format! {
            case .Varint:
                try getFieldBuilder(number)?.variantArray.append(try input.readInt64())
                return true
            case .Fixed32:
                let value = try input.readFixed32()
                try getFieldBuilder(number)?.fixed32Array.append(value)
                return true
            case .Fixed64:
                let value = try input.readFixed64()
                try getFieldBuilder(number)?.fixed64Array.append(value)
                return true
            case .LengthDelimited:
                try getFieldBuilder(number)?.lengthDelimited.append(try input.readData())
                return true
            case .StartGroup:
                let subBuilder:UnknownFieldSet.Builder = UnknownFieldSet.Builder()
                try input.readUnknownGroup(number, builder:subBuilder)
                try getFieldBuilder(number)?.groupArray.append(subBuilder.build())
                return true
            case .EndGroup:
                return false
            default:
                throw ProtocolBuffersError.InvalidProtocolBuffer("Invalid Wire Type")
            }
        }
        
        
        public func mergeFromCodedInputStream(input:CodedInputStream) throws -> UnknownFieldSet.Builder {
            while (true) {
                let tag:Int32 = try input.readTag()
                let mergeField = try mergeFieldFrom(tag, input:input)
                if tag == 0 || !(mergeField)
                {
                    break
                }
            }
            return self
        }
        
        public func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> UnknownFieldSet.Builder
        {
            throw ProtocolBuffersError.Obvious("UnsupportedMethod")
        }
        
        public func mergeFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> UnknownFieldSet.Builder
        {
            let input = CodedInputStream(data: data)
            try mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry)
            try input.checkLastTagWas(0)
            return self
        }
        
        public func clear() ->UnknownFieldSet.Builder
        {
            fields = Dictionary()
            lastFieldNumber = 0
            lastField = nil
            return self
        }
    }
}
