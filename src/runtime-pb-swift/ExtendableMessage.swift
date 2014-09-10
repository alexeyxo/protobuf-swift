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
class ExtendableMessage : GeneratedMessage
{
    var extensionMap:[Int32:ExtensionField] = [Int32:ExtensionField]()
    var extensionRegistry:[Int32:ExtensionField] = [Int32:ExtensionField]()
    
    
    required init()
    {
        super.init()
    }
    
    func isInitialized(object:Any) -> Bool
    {
        if let array = object as? Array<Any>
        {
            for child in array
            {
                if (!isInitialized(child))
                {
                    return false
                }
            }
        }
        else if  let mes = object as? GeneratedMessage
        {
            return mes.isInitialized()
        }
        return true
    }
    
    func extensionsAreInitialized() -> Bool {
        return isInitialized(extensionMap.values)
    }
    
    func ensureExtensionIsRegistered(extensions:ExtensionField)
    {
        extensionRegistry[extensions.fieldNumber] = extensions
    }
    
    func getExtension(extensions:ExtensionField) -> Any
    {
        ensureExtensionIsRegistered(extensions)
        
        if let value = extensionMap[extensions.fieldNumber]
        {
            return value
        }
        return extensions.initialize()
    }
    func hasExtension(extensions:ExtensionField) -> Bool
    {
        if let ext = extensionMap[extensions.fieldNumber]
        {
            return true
        }
        return false
    }
    func writeExtensionsToCodedOutputStream(output:CodedOutputStream, startInclusive:Int32, endExclusive:Int32)
    {
        for fieldNumber in extensionMap.keys {
            if (fieldNumber >= startInclusive && fieldNumber < endExclusive) {
                let extensions = extensionRegistry[fieldNumber]!
                let value = extensionMap[fieldNumber]!
//                if let extensionss =  extensions as? ConcreteExtensionField
//                {
//                    extensionss.writeValueIncludingTagToCodedOutputStream(value, output: output)
//                }
                
            }
        }
    }
    
    func writeExtensionDescription(inout output:String, startInclusive:Int32 ,endExclusive:Int32, indent:String) {
        for fieldNumber in extensionMap.keys {
        
            if (fieldNumber >= startInclusive && fieldNumber < endExclusive) {
                let extensions = extensionRegistry[fieldNumber]!
                let value = extensionMap[fieldNumber]!
                
//                if let extensionss =  extensions as? ConcreteExtensionField
//                {
//                    extensionss.writeDescriptionOf(value, output: &output, indent: indent)
//                }
//                
            }
            
        }
    }
    
    func isEqualExtensionsInOther(otherMessage:ExtendableMessage, startInclusive:Int32, endExclusive:Int32) -> Bool {

        for fieldNumber in extensionMap.keys {
            if (fieldNumber >= startInclusive && fieldNumber < endExclusive) {
                let value = extensionMap[fieldNumber]!
                let otherValue = otherMessage.extensionMap[fieldNumber]!
//                if (value as? ConcreteExtensionField) == (otherValue as? ConcreteExtensionField) {
//                    return false;
//                }
            }
        }
        
        return true;
    }
    
    func hashExtensionsFrom(startInclusive:Int32, endExclusive:Int32) ->UInt32 {
        var hashCode:UInt32 = 0
        for fieldNumber in extensionMap.keys {
            if (fieldNumber >= startInclusive && fieldNumber < endExclusive) {
                let value = extensionMap[fieldNumber]
                
//                if let values =  value as? ConcreteExtensionField
//                {
//                    hashCode = hashCode &* 31 &+ values.hashValue
//                }

            }
        }
        return hashCode;
    }
    
    
    func extensionsSerializedSize() ->Int32 {
        var size:Int32 = 0
        for fieldNumber in extensionMap.keys {
            let extensions = extensionRegistry[fieldNumber]
            let value = extensionMap[fieldNumber]
//            if let values =  extensions as? ConcreteExtensionField
//            {
//                size += values.computeSerializedSizeIncludingTag(value)
//            }
        }
        return size
    }
    
}



