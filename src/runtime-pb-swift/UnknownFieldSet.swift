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

func == (lhs: UnknownFieldSet, rhs: UnknownFieldSet) -> Bool
{
    return lhs.fields == rhs.fields
}

class UnknownFieldSet:Hashable,Equatable
{
    var fields:Dictionary<Int32,Field>

    convenience init()
    {
        self.init(fields: Dictionary())
    }
   
    init(fields:Dictionary<Int32,Field>)
    {
        self.fields = fields
    }
    var hashValue:Int
    {
        get {
            return 0
        }
        
    }
    
    func hasField(number:Int32) -> Bool
    {
        if let unwrappedValue = fields[number] {
            return true
        }
        return false
    }
    func getField(number:Int32) -> Field
    {
        if let field = fields[number]
        {
            return field
        }
        return Field()
    }
    func writeToCodedOutputStream(output:CodedOutputStream)
    {

        var sortedKeys = Array(fields.keys)
        for number in sortedKeys
        {
            let value:Field = fields[number]!
            value.writeTo(number, output: output)
        }
    }
    
    func writeToOutputStream(output:NSOutputStream)
    {
        let codedOutput:CodedOutputStream = CodedOutputStream(output: output)
        writeToCodedOutputStream(codedOutput)
        codedOutput.flush()
    }
    
    func writeDescriptionTo(inout output:String, indent:String)
    {
        var sortedKeys = fields.keys
        for number in sortedKeys
        {
            let value:Field = fields[number]!
            value.writeDescriptionFor(number, outputString: &output, indent: indent)
        }
    }
    
    class func builder() -> UnknownFieldSetBuilder {
        return UnknownFieldSetBuilder()
    }
    
    class func parseFromCodedInputStream(input:CodedInputStream) -> UnknownFieldSet {
        return UnknownFieldSet.builder().mergeFromCodedInputStream(input).build()
    }
    
    
    class func parseFromData(data:[Byte]) -> UnknownFieldSet {
        return UnknownFieldSet.builder().mergeFromData(data).build()
    }
    
    
    class func parseFromInputStream(input:NSInputStream) -> UnknownFieldSet
    {
        return UnknownFieldSet.builder().mergeFromInputStream(input).build()
    }
    

    
    class func builderWithUnknownFields(copyFrom:UnknownFieldSet) -> UnknownFieldSetBuilder
    {
        return UnknownFieldSet.builder().mergeUnknownFields(copyFrom)
    }
    
    func serializedSize()->Int32
    {
        var result:Int32 = 0
        for number in fields.keys
        {
            let field:Field = fields[number]!
            result += field.getSerializedSize(number)
        }
        return result
    }
    
    func writeAsMessageSetTo(output:CodedOutputStream)
    {
        for number in fields.keys
        {
            let field:Field = fields[number]!
            field.writeAsMessageSetExtensionTo(number, output:output)
        }
    }
    
    func serializedSizeAsMessageSet() -> Int32
    {
        var result:Int32 = 0
        for number in fields.keys
        {
            let field:Field = fields[number]!
            result += field.getSerializedSizeAsMessageSetExtension(number)
        }
        return result
    }
    
    func data() ->[Byte]
    {
        var bytes:[Byte] = [Byte](count:Int(serializedSize()), repeatedValue: 0)
        var output:CodedOutputStream = CodedOutputStream(data: bytes)
        writeToCodedOutputStream(output)
        return bytes
    }
    
}
