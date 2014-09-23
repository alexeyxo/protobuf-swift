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
final public class Field:NSObject
{
    public var variantArray:Array<Int64>
    public var fixed32Array:Array<Int32>
    public var fixed64Array:Array<Int64>
    public var lengthDelimited:Array<Array<Byte>>
    public var groupArray:Array<UnknownFieldSet>
    
    override init()
    {
        
        variantArray = [Int64](count: 0, repeatedValue: 0)
        fixed32Array = [Int32](count: 0, repeatedValue: 0)
        fixed64Array = [Int64](count: 0, repeatedValue: 0)
        lengthDelimited = Array<Array<Byte>>()
        groupArray = Array<UnknownFieldSet>()
        super.init()
    }
    
    public func getSerializedSize(fieldNumber:Int32) -> Int32
    {
        var result:Int32 = 0
        

        for (var i:Int = 0; i < variantArray.count; ++i)
        {
            result += WireFormat.computeInt64Size(fieldNumber, value: variantArray[i])
        }
        for (var i:Int = 0; i < fixed32Array.count; ++i)
        {
            result += WireFormat.computeFixed32Size(fieldNumber, value: fixed32Array[i])
        }
        for (var i:Int = 0; i < fixed64Array.count; ++i)
        {
            result += WireFormat.computeFixed64Size(fieldNumber, value: fixed64Array[i])
        }

        for value in lengthDelimited
        {
            result += WireFormat.computeDataSize(fieldNumber, value: value)
        }

        for  value in groupArray
        {
            result += WireFormat.computeUnknownGroupSize(fieldNumber, value: value)
        }
        
        return result
    }
    
    public func getSerializedSizeAsMessageSetExtension(fieldNumber:Int32) -> Int32 {
        var result:Int32 = 0
        for value in lengthDelimited {
            result += WireFormat.computeRawMessageSetExtensionSize(fieldNumber, value:value)
        }
        return result
    }
    
    public func writeTo(fieldNumber:Int32, output:CodedOutputStream)
    {

        for (var i:Int = 0; i < variantArray.count; ++i)
        {
            output.writeInt64(fieldNumber, value:variantArray[i])
        }
        for (var i:Int = 0; i < fixed32Array.count; ++i)
        {
            output.writeFixed32(fieldNumber, value: fixed32Array[i])
        }
        for (var i:Int = 0; i < fixed64Array.count; ++i)
        {
            output.writeFixed64(fieldNumber, value: fixed64Array[i])
        }
        for value in lengthDelimited
        {
            output.writeData(fieldNumber, value: value)
        }
        for value in groupArray
        {
            output.writeUnknownGroup(fieldNumber, value:value)
        }

    }
    
    public func writeDescriptionFor(fieldNumber:Int32,  inout outputString:String, indent:String)
    {
        
        for (var i:Int = 0; i < variantArray.count; ++i)
        {
            outputString += "\(indent)\(fieldNumber): \(variantArray[i])\n"
        }

 
        for (var i:Int = 0; i < fixed32Array.count; ++i)
        {
            outputString += "\(indent)\(fieldNumber): \(fixed32Array[i])\n"
        }

        for (var i:Int = 0; i < fixed64Array.count; ++i)
        {
            outputString += "\(indent)\(fieldNumber): \(fixed64Array[i])\n"
        }
        
        for value in lengthDelimited
        {
            outputString += "\(indent)\(fieldNumber): \(value)\n"
        }
        
        for value in groupArray
        {
            outputString += "\(indent)\(fieldNumber)[\n"
            value.writeDescriptionTo(&outputString, indent: indent)
            outputString += "\(indent)]"
        }

    }
    
    public func writeAsMessageSetExtensionTo(fieldNumber:Int32, output:CodedOutputStream)
    {
        for value in lengthDelimited
        {
            output.writeRawMessageSetExtension(fieldNumber, value: value)
        }
    }
}

public extension Field
{
    public func clear()
    {
        variantArray.removeAll(keepCapacity: false)
        fixed32Array.removeAll(keepCapacity: false)
        fixed64Array.removeAll(keepCapacity: false)
        groupArray.removeAll(keepCapacity: false)
        lengthDelimited.removeAll(keepCapacity: false)
    }
    
    public func mergeFromField(other:Field) -> Field
    {
        if (other.variantArray.count > 0)
        {
            variantArray += other.variantArray
        }
        if (other.fixed32Array.count > 0)
        {
            fixed32Array += other.fixed32Array
        }
        if (other.fixed64Array.count > 0)
        {
            fixed64Array += other.fixed64Array
        }
        if (other.lengthDelimited.count > 0)
        {
            lengthDelimited += other.lengthDelimited
        }
        if (other.groupArray.count > 0)
        {
            groupArray += other.groupArray
        }
        
        return self;
    }
    
}