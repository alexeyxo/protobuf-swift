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
        if let unwrappedValue = fields[number] {
            return true
        }
        return false
    }
    public func getField(number:Int32) -> Field
    {
        if let field = fields[number]
        {
            return field
        }
        return Field()
    }
    public func writeToCodedOutputStream(output:CodedOutputStream)
    {
        var sortedKeys = Array(fields.keys)
        sortedKeys.sort { $0 < $1 }
        for number in sortedKeys
        {
            let value:Field = fields[number]!
            value.writeTo(number, output: output)
        }
    }
    
    public func writeToOutputStream(output:NSOutputStream)
    {
        let codedOutput:CodedOutputStream = CodedOutputStream(output: output)
        writeToCodedOutputStream(codedOutput)
        codedOutput.flush()
    }
    
    public func writeDescriptionTo(inout output:String, indent:String)
    {
        var sortedKeys = Array(fields.keys)
        sortedKeys.sort { $0 < $1 }
        for number in sortedKeys
        {
            let value:Field = fields[number]!
            value.writeDescriptionFor(number, outputString: &output, indent: indent)
        }
    }
    
    public class func builder() -> UnknownFieldSet.Builder {
        return UnknownFieldSet.Builder()
    }
    
    public class func parseFromCodedInputStream(input:CodedInputStream) -> UnknownFieldSet {
        return UnknownFieldSet.Builder().mergeFromCodedInputStream(input).build()
    }
    
    
    public class func parseFromData(data:NSData) -> UnknownFieldSet {
        return UnknownFieldSet.Builder().mergeFromData(data).build()
    }
    
    
    public class func parseFromInputStream(input:NSInputStream) -> UnknownFieldSet
    {
        return UnknownFieldSet.Builder().mergeFromInputStream(input).build()
    }
    

    
    public class func builderWithUnknownFields(copyFrom:UnknownFieldSet) -> UnknownFieldSet.Builder
    {
        return UnknownFieldSet.Builder().mergeUnknownFields(copyFrom)
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
    
    public func writeAsMessageSetTo(output:CodedOutputStream)
    {
        for number in fields.keys
        {
            let field:Field = fields[number]!
            field.writeAsMessageSetExtensionTo(number, output:output)
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
    
    public func data() -> NSData
    {
        var size = serializedSize()
        let data = NSMutableData(length: Int(size))!
        var stream:CodedOutputStream = CodedOutputStream(data: data)
        writeToCodedOutputStream(stream)
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
        
        public func addField(field:Field, number:Int32) ->UnknownFieldSet.Builder {
            if (number == 0) {
                NSException(name:"IllegalArgument", reason:"", userInfo: nil).raise()
            }
            if (lastField != nil && lastFieldNumber == number) {
                lastField = nil
                lastFieldNumber = 0
            }
            fields[number]=field
            return self
        }
        public func getFieldBuilder(number:Int32) ->Field?
        {
            if (lastField != nil) {
                if (number == lastFieldNumber) {
                    return lastField
                }
                addField(lastField!, number:lastFieldNumber)
                
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
        
        public func build() -> UnknownFieldSet
        {
            getFieldBuilder(0)
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
        
        public func buildPartial() -> UnknownFieldSet?
        {
            NSException(name:"UnsupportedMethod", reason:"", userInfo: nil).raise()
            return  nil
        }
        
        public func clone() -> UnknownFieldSet?
        {
            NSException(name:"UnsupportedMethod", reason:"", userInfo: nil).raise()
            return nil
        }
        
        public func isInitialized() -> Bool
        {
            return true
        }
        public func unknownFields() -> UnknownFieldSet {
            return  build()
        }
        public func setUnknownFields(unknownFields:UnknownFieldSet) -> UnknownFieldSet.Builder?
        {
            NSException(name:"UnsupportedMethod", reason:"", userInfo: nil).raise()
            return nil
        }
        public func hasField(number:Int32) ->Bool
        {
            if (number == 0) {
                NSException(name:"IllegalArgument", reason:"", userInfo: nil).raise()
            }
            
            return number == lastFieldNumber || (fields[number] != nil)
        }
        
        public func mergeField(field:Field, number:Int32) -> UnknownFieldSet.Builder
        {
            if (number == 0) {
                NSException(name:"IllegalArgument", reason:"", userInfo: nil).raise()
            }
            if (hasField(number)) {
                getFieldBuilder(number)?.mergeFromField(field)
            }
            else
            {
                addField(field, number:number)
            }
            return self
        }
        
        public func mergeUnknownFields(other:UnknownFieldSet) -> UnknownFieldSet.Builder
        {
            for number in other.fields.keys
            {
                var field:Field = other.fields[number]!
                mergeField(field ,number:number)
            }
            return self
        }
        
        
        public func mergeFromData(data:NSData) -> UnknownFieldSet.Builder
        {
            var input:CodedInputStream = CodedInputStream(data: data)
            mergeFromCodedInputStream(input)
            input.checkLastTagWas(0)
            return self
        }
        
        public func mergeFromInputStream(input:NSInputStream) -> UnknownFieldSet.Builder
        {
            NSException(name:"UnsupportedMethod", reason:"", userInfo: nil).raise()
            return UnknownFieldSet.Builder()
        }
        public func mergeFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) -> UnknownFieldSet.Builder
        {
            NSException(name:"UnsupportedMethod", reason:"", userInfo: nil).raise()
            return UnknownFieldSet.Builder()
        }
        
        public func mergeVarintField(number:Int32, value:Int64) -> UnknownFieldSet.Builder
        {
            if (number == 0) {
                NSException(name:"IllegalArgument", reason:"Zero is not a valid field number.", userInfo: nil).raise()
            }
            getFieldBuilder(number)?.variantArray.append(value)
            return self
        }
        
        public func mergeFieldFrom(tag:Int32, input:CodedInputStream) -> Bool
        {
            
            let number:Int32 = WireFormat.wireFormatGetTagFieldNumber(tag)
            var tags:Int32 = WireFormat.wireFormatGetTagWireType(tag)
            let format = WireFormat(rawValue: tags)
            if (format == WireFormat.WireFormatVarint)
            {
                getFieldBuilder(number)?.variantArray.append(input.readInt64())
                return true
            }
            else if (format == WireFormat.WireFormatFixed32)
            {
                var value = input.readFixed32()
                getFieldBuilder(number)?.fixed32Array.append(value)
                return true
            }
            else if (format == WireFormat.WireFormatFixed64)
            {
                var value = input.readFixed64()
                getFieldBuilder(number)?.fixed64Array.append(value)
                return true
            }
            else if (format == WireFormat.WireFormatLengthDelimited)
            {
                getFieldBuilder(number)?.lengthDelimited.append(input.readData())
                return true
            }
            else if (format == WireFormat.WireFormatStartGroup)
            {
                let subBuilder:UnknownFieldSet.Builder = UnknownFieldSet.Builder()
                input.readUnknownGroup(number, builder:subBuilder)
                getFieldBuilder(number)?.groupArray.append(subBuilder.build())
                return true
            }
            else if (format == WireFormat.WireFormatEndGroup)
            {
                return false
            }
            else
            {
                NSException(name:"InvalidProtocolBuffer", reason:"", userInfo: nil).raise()
            }
            
            return false
        }
        
        
        public func mergeFromCodedInputStream(input:CodedInputStream) -> UnknownFieldSet.Builder {
            while (true) {
                var tag:Int32 = input.readTag()
                if tag == 0 || !mergeFieldFrom(tag, input:input)
                {
                    break
                }
            }
            return self
        }
        
        public func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> UnknownFieldSet.Builder
        {
            NSException(name:"UnsupportedMethod", reason:"", userInfo: nil).raise()
            return UnknownFieldSet.Builder()
        }
        
        public func mergeFromData(data:NSData, extensionRegistry:ExtensionRegistry) ->UnknownFieldSet.Builder
        {
            var input = CodedInputStream(data: data)
            mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry)
            input.checkLastTagWas(0)
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
