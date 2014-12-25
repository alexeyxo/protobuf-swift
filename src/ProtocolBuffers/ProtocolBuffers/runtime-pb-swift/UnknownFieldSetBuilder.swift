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
public class UnknownFieldSetBuilder
{
    private var fields:Dictionary<Int32,Field>
    private var lastFieldNumber:Int32
    private var lastField:Field?
    public init()
    {
        fields = Dictionary()
        lastFieldNumber = 0
    }
    
    public func addField(field:Field, number:Int32) ->UnknownFieldSetBuilder {
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
    public func setUnknownFields(unknownFields:UnknownFieldSet) -> UnknownFieldSetBuilder?
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
    
    public func mergeField(field:Field, number:Int32) -> UnknownFieldSetBuilder
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
    
    public func mergeUnknownFields(other:UnknownFieldSet) -> UnknownFieldSetBuilder
    {
        for number in other.fields.keys
        {
            var field:Field = other.fields[number]!
            mergeField(field ,number:number)
        }
        return self
    }
    
    
    public func mergeFromData(data:NSData) -> UnknownFieldSetBuilder
    {
        var input:CodedInputStream = CodedInputStream(data: data)
        mergeFromCodedInputStream(input)
        input.checkLastTagWas(0)
        return self
    }
    
    public func mergeFromInputStream(input:NSInputStream) -> UnknownFieldSetBuilder
    {
        NSException(name:"UnsupportedMethod", reason:"", userInfo: nil).raise()
        return UnknownFieldSetBuilder()
    }
    public func mergeFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) -> UnknownFieldSetBuilder
    {
        NSException(name:"UnsupportedMethod", reason:"", userInfo: nil).raise()
        return UnknownFieldSetBuilder()
    }
    
    public func mergeVarintField(number:Int32, value:Int64) -> UnknownFieldSetBuilder
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
            let subBuilder:UnknownFieldSetBuilder = UnknownFieldSetBuilder()
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
    

    public func mergeFromCodedInputStream(input:CodedInputStream) -> UnknownFieldSetBuilder {
        while (true) {
            var tag:Int32 = input.readTag()
            if tag == 0 || !mergeFieldFrom(tag, input:input)
            {
                break
            }
        }
        return self
    }
    
    public func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> UnknownFieldSetBuilder
    {
        NSException(name:"UnsupportedMethod", reason:"", userInfo: nil).raise()
        return UnknownFieldSetBuilder()
    }
    
    public func mergeFromData(data:NSData, extensionRegistry:ExtensionRegistry) ->UnknownFieldSetBuilder
    {
        var input = CodedInputStream(data: data)
         mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry)
        input.checkLastTagWas(0)
        return self
    }
    
    public func clear() ->UnknownFieldSetBuilder
    {
        fields = Dictionary()
        lastFieldNumber = 0
        lastField = nil
        return self
    }    
}