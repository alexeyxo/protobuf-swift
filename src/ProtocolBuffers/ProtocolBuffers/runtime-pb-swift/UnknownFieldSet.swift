// Protocol Buffers for Swift
//
// Copyright 2014 Alexey Khohklov(AlexeyXo).
// Copyright 2008 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
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

        for number in fields.keys
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
        var sortedKeys = fields.keys
        for number in sortedKeys
        {
            let value:Field = fields[number]!
            value.writeDescriptionFor(number, outputString: &output, indent: indent)
        }
    }
    
    public class func builder() -> UnknownFieldSetBuilder {
        return UnknownFieldSetBuilder()
    }
    
    public class func parseFromCodedInputStream(input:CodedInputStream) -> UnknownFieldSet {
        return UnknownFieldSet.builder().mergeFromCodedInputStream(input).build()
    }
    
    
    public class func parseFromData(data:[Byte]) -> UnknownFieldSet {
        return UnknownFieldSet.builder().mergeFromData(data).build()
    }
    
    
    public class func parseFromInputStream(input:NSInputStream) -> UnknownFieldSet
    {
        return UnknownFieldSet.builder().mergeFromInputStream(input).build()
    }
    

    
    public class func builderWithUnknownFields(copyFrom:UnknownFieldSet) -> UnknownFieldSetBuilder
    {
        return UnknownFieldSet.builder().mergeUnknownFields(copyFrom)
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
    
    public func data() ->[Byte]
    {
        var bytes:[Byte] = [Byte](count:Int(serializedSize()), repeatedValue: 0)
        var output:CodedOutputStream = CodedOutputStream(data: bytes)
        writeToCodedOutputStream(output)
        return bytes
    }
    
    
}
