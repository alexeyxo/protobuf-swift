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

public func ==(lhs:Field, rhs:Field) -> Bool
{
    var check = (lhs.variantArray == rhs.variantArray)
    check = check && (lhs.fixed32Array == rhs.fixed32Array)
    check = check && (lhs.fixed64Array == rhs.fixed64Array)
    check = check && (lhs.groupArray == rhs.groupArray)
    check = check && (lhs.lengthDelimited == rhs.lengthDelimited)
    return check
}

public func ==(lhs:Array<Array<Byte>>, rhs:Array<Array<Byte>>) -> Bool
{
    if lhs.count == rhs.count
    {
        for (var i = 0; i < lhs.count; i++)
        {
            var lbytes = lhs[i]
            var rbytes = rhs[i]
            
            if lbytes.count == rbytes.count
            {
                if lbytes == rbytes
                {
                    continue
                }
                else
                {
                    return false
                }
            }
            else
            {
                return false
            }
        }
        return true
    }
    return false
}

public func ==(lhs:Array<Byte>, rhs:Array<Byte>) -> Bool
{
    if lhs.count == rhs.count
    {
        for (var i = 0; i < lhs.count; i++)
        {
            var lbytes = lhs[i]
            var rbytes = rhs[i]
            if lbytes == rbytes
            {
                continue
            }
            else
            {
                return false
            }
        }
        return true
    }
    return false
}

final public class Field:Equatable,Hashable
{
    public var variantArray:Array<Int64>
    public var fixed32Array:Array<UInt32>
    public var fixed64Array:Array<UInt64>
    public var lengthDelimited:Array<Array<Byte>>
    public var groupArray:Array<UnknownFieldSet>
    
    public init()
    {
        
        variantArray = [Int64](count: 0, repeatedValue: 0)
        fixed32Array = [UInt32](count: 0, repeatedValue: 0)
        fixed64Array = [UInt64](count: 0, repeatedValue: 0)
        lengthDelimited = Array<Array<Byte>>()
        groupArray = Array<UnknownFieldSet>()
    }
    
    public func getSerializedSize(fieldNumber:Int32) -> Int32
    {
        var result:Int32 = 0
    
        for value in variantArray
        {
            result += WireFormat.computeInt64Size(fieldNumber, value: value)
        }
        
        for value in fixed32Array
        {
            result += WireFormat.computeFixed32Size(fieldNumber, value: value)
        }
        
        for value in fixed64Array
        {
            result += WireFormat.computeFixed64Size(fieldNumber, value: value)
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

        for value in variantArray
        {
            output.writeInt64(fieldNumber, value:value)
        }
        for value in fixed32Array
        {
            output.writeFixed32(fieldNumber, value: value)
        }
        for value in fixed64Array
        {
            output.writeFixed64(fieldNumber, value:value)
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
        
        for value in variantArray
        {
            outputString += "\(indent)\(fieldNumber): \(value)\n"
        }

        for value in fixed32Array
        {
            outputString += "\(indent)\(fieldNumber): \(value)\n"
        }

        for value in fixed64Array
        {
            outputString += "\(indent)\(fieldNumber): \(value)\n"
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
    
    public var hashValue:Int {
        get {
            var hashCode = 0
            
            for value in variantArray
            {
                hashCode = (hashCode &* 31) &+ value.hashValue
            }
            for value in fixed32Array
            {
                hashCode = (hashCode &* 31) &+ value.hashValue
            }
            for value in fixed64Array
            {
                hashCode = (hashCode &* 31) &+ value.hashValue
            }
            for value in lengthDelimited
            {
                for byteVal in value
                {
                    hashCode = (hashCode &* 31) &+ byteVal.hashValue
                }
            }
            for value in groupArray
            {
                hashCode = (hashCode &* 31) &+ value.hashValue
            }
            return hashCode
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