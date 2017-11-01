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

#include "swift_map_field.h"

#include <map>
#include <string>

#include <google/protobuf/stubs/common.h>
#include <google/protobuf/io/printer.h>
#include <google/protobuf/wire_format.h>
#include <google/protobuf/wire_format_lite_inl.h>
#include <google/protobuf/stubs/strutil.h>
#include <google/protobuf/stubs/substitute.h>

#include "swift_helpers.h"

namespace google { namespace protobuf { namespace compiler { namespace swift {
    
    using internal::WireFormat;
    using internal::WireFormatLite;
    
    namespace {
        
        void SetMapVariables(const FieldDescriptor* descriptor, std::map<string, string>* variables) {
            
            
            std::string name = UnderscoresToCamelCase(descriptor);
            std::string capname = UnderscoresToCapitalizedCamelCase(descriptor);
            
            const FieldDescriptor* key_descriptor = descriptor->message_type()->FindFieldByName("key");
            const FieldDescriptor* value_descriptor = descriptor->message_type()->FindFieldByName("value");
            
            (*variables)["capitalized_name"] = capname;
            (*variables)["keyType"] = MapKeyName(key_descriptor);
            if (MapKeyName(key_descriptor) != "String") {
                (*variables)["keyTypeInit"] = MapKeyName(key_descriptor) + "(key" + capname + ")";
            }
            (*variables)["valueType"] = MapValueName(value_descriptor);
            (*variables)["containing_class"] = ClassNameReturedType(descriptor->containing_type());
            (*variables)["capitalized_type_key"] = GetCapitalizedType(key_descriptor);
            (*variables)["capitalized_type_value"] = GetCapitalizedType(value_descriptor);
            (*variables)["name"] = name;
            (*variables)["name_reserved"] = SafeName(name);
            (*variables)["default"] = DefaultValue(descriptor);
            (*variables)["number"] = SimpleItoa(descriptor->number());
            (*variables)["backward_class"] = ClassNameReturedType(descriptor->message_type());
            (* variables)["acontrol"] = GetAccessControlTypeForFields(descriptor->containing_type()->file());
            (* variables)["acontrolFunc"] = GetAccessControlType(descriptor->containing_type()->file());
            (* variables)["type"] =  "Dictionary<" + MapKeyName(key_descriptor) + "," + MapValueName(value_descriptor) + ">";
            
            //JSON
            (*variables)["json_name"] = descriptor->json_name();
//            (*variables)["to_json_value_key"] = ToJSONValue(key_descriptor, name);
            (*variables)["to_json_value_value"] = ToJSONValueRepeated(value_descriptor, "value" + capname);
            (*variables)["from_json_value"] = FromJSONValue(value_descriptor, "value" + capname);
            (*variables)["from_json_key_value"] = FromJSONMapKeyValue(key_descriptor, "key" + capname);
            (*variables)["json_casting_type_value"] = JSONCastingValue(value_descriptor);
            ///
           
        }
    }  // namespace
    
    
    MapFieldGenerator::MapFieldGenerator(const FieldDescriptor* descriptor)
    : descriptor_(descriptor) {
        SetMapVariables(descriptor, &variables_);
    }
    
    MapFieldGenerator::~MapFieldGenerator() {
    }
    
    void MapFieldGenerator::GenerateVariablesSource(io::Printer* printer) const
    {
        SourceLocation location;
        if (descriptor_->GetSourceLocation(&location)) {
            string comments;
            comments = BuildCommentsString(location);
            printer->Print(comments.c_str());
        }
        if (descriptor_->options().deprecated() && !IsDescriptorFile(descriptor_->file())) {
             printer->Print(variables_ ,"@available(*, deprecated:0.1, message:\"$name_reserved$ is marked as \\\"Deprecated\\\"\")\n");
        }
        printer->Print(variables_,"$acontrol$fileprivate(set) var $name_reserved$:$type$ = $default$\n\n");
        printer->Print(variables_,"$acontrol$fileprivate(set) var has$capitalized_name$:Bool = false\n");
    }
    
    void MapFieldGenerator::GenerateSubscript(io::Printer* printer) const {
        printer->Print(variables_,"case \"$name_reserved$\": return self.$name_reserved$\n");
    }
    
    void MapFieldGenerator::GenerateSetSubscript(io::Printer* printer) const {
        printer->Print(variables_,"case \"$name_reserved$\":\n");
        XCodeStandartIndent(printer);
        printer->Print(variables_,"guard let newSubscriptValue = newSubscriptValue as? $type$ else {\n");
        XCodeStandartIndent(printer);
        printer->Print(variables_,"return\n");
        XCodeStandartOutdent(printer);
        printer->Print(variables_,"}\n");
        printer->Print(variables_,"self.$name_reserved$ = newSubscriptValue\n");
        XCodeStandartOutdent(printer);
    }
    
    void MapFieldGenerator::GenerateExtensionSource(io::Printer* printer) const {}
    void MapFieldGenerator::GenerateInitializationSource(io::Printer* printer) const {}
    void MapFieldGenerator::GenerateMembersSource(io::Printer* printer) const {}
    void MapFieldGenerator::GenerateBuilderMembersSource(io::Printer* printer) const {
        SourceLocation location;
        if (descriptor_->GetSourceLocation(&location)) {
            string comments;
            comments = BuildCommentsString(location);
            printer->Print(comments.c_str());
        }
        printer->Print(variables_,
                       "$acontrol$var has$capitalized_name$:Bool {\n"
                       "    get {\n"
                       "        return builderResult.has$capitalized_name$\n"
                       "    }\n"
                       "}\n"
                       "$acontrol$var $name_reserved$:$type$ {\n"
                       "    get {\n"
                       "        return builderResult.$name_reserved$\n"
                       "    }\n"
                       "    set (value) {\n"
                       "        builderResult.has$capitalized_name$ = true\n"
                       "        builderResult.$name_reserved$ = value\n"
                       "    }\n"
                       "}\n"
                       "@discardableResult\n"
                       "$acontrol$func set$capitalized_name$(_ value:$type$) -> $containing_class$.Builder {\n"
                       "    self.$name_reserved$ = value\n"
                       "    return self\n"
                       "}\n"
                       "@discardableResult\n"
                       "$acontrolFunc$ func clear$capitalized_name$() -> $containing_class$.Builder{\n"
                       "    builderResult.has$capitalized_name$ = false\n"
                       "    builderResult.$name_reserved$ = $default$\n"
                       "    return self\n"
                       "}\n");
        
    }
    
    
    void MapFieldGenerator::GenerateMergingCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if other.has$capitalized_name$ {\n"
                       "    $name_reserved$ = other.$name_reserved$\n"
                       "}\n");
    }
    
    void MapFieldGenerator::GenerateBuildingCodeSource(io::Printer* printer) const {
    }
    
    void MapFieldGenerator::GenerateParsingCodeSource(io::Printer* printer) const {

        printer->Print(variables_,
                       "let subBuilder = $backward_class$.Builder()\n");
        printer->Print(variables_,
                       "try codedInputStream.readMessage(builder: subBuilder, extensionRegistry:extensionRegistry)\n");
        printer->Print(variables_,
                       "let buildOf$capitalized_name$ = subBuilder.buildPartial()\n"
                       "$name_reserved$[buildOf$capitalized_name$.key] = buildOf$capitalized_name$.value\n");
    }
    
    void MapFieldGenerator::GenerateSerializationCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if has$capitalized_name$ {\n"
                       "    for (key$capitalized_name$, value$capitalized_name$) in $name_reserved$ {\n"
                       "        let valueOf$capitalized_name$ = try! $backward_class$.Builder().setKey(key$capitalized_name$).setValue(value$capitalized_name$).build()\n"
                       "          try codedOutputStream.writeMessage(fieldNumber: $number$, value:valueOf$capitalized_name$)\n"
                       "      }\n"
                       "}\n");
    }
    
    void MapFieldGenerator::GenerateSerializedSizeCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if has$capitalized_name$ {\n"
                       "      for (key$capitalized_name$, value$capitalized_name$) in $name_reserved$ {\n"
                       "          let valueOf$capitalized_name$ = try! $backward_class$.Builder().setKey(key$capitalized_name$).setValue(value$capitalized_name$).build()\n"
                       "    serialize_size += valueOf$capitalized_name$.computeMessageSize(fieldNumber: $number$)\n"
                       "    }\n"
                       "}\n");
    }
    
    void MapFieldGenerator::GenerateDescriptionCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if has$capitalized_name$ {\n"
                       "    output += \"\\(indent) $name$: \\($name_reserved$) \\n\"\n"
                       "}\n");
    }
    
    void MapFieldGenerator::GenerateJSONEncodeCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if has$capitalized_name$ {\n"
                       "    var map$capitalized_name$ = Dictionary<String, $json_casting_type_value$>()\n"
                       "    for (key$capitalized_name$, value$capitalized_name$) in $name_reserved$ {\n"
                       "        map$capitalized_name$[\"\\(key$capitalized_name$)\"] = $to_json_value_value$\n"
                       "    }\n"
                       "    jsonMap[\"$json_name$\"] = map$capitalized_name$\n"
                       "}\n");
    }
    
    void MapFieldGenerator::GenerateJSONDecodeCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if let jsonValue$capitalized_name$ = jsonMap[\"$json_name$\"] as? Dictionary<String, $json_casting_type_value$> {\n"
                       "    var map$capitalized_name$ = Dictionary<$keyType$, $valueType$>()\n"
                       "    for (key$capitalized_name$, value$capitalized_name$) in jsonValue$capitalized_name$ {\n");
        if (variables_.find("keyTypeInit") != variables_.end()) {
            printer->Print(variables_,"        guard let keyFrom$capitalized_name$ = $keyType$(key$capitalized_name$) else {\n"
                           "            throw ProtocolBuffersError.invalidProtocolBuffer(\"Invalid JSON data\")\n"
                           "        }\n");
            printer->Print(variables_,
                           "        map$capitalized_name$[keyFrom$capitalized_name$] = $from_json_value$\n"
                           "    }\n"
                           "    resultDecodedBuilder.$name_reserved$ = map$capitalized_name$\n"
                           "}\n");
        } else {
            printer->Print(variables_,
                           "        map$capitalized_name$[key$capitalized_name$] = $from_json_value$\n"
                           "    }\n"
                           "    resultDecodedBuilder.$name_reserved$ = map$capitalized_name$\n"
                           "}\n");
        }
        
        
    }
    
    
    void MapFieldGenerator::GenerateIsEqualCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "(lhs.has$capitalized_name$ == rhs.has$capitalized_name$) && (!lhs.has$capitalized_name$ || lhs.$name_reserved$ == rhs.$name_reserved$)");
        
    }
    
    void MapFieldGenerator::GenerateHashCodeSource(io::Printer* printer) const {
            printer->Print(variables_,
                           "if has$capitalized_name$ {\n"
                           "    for (key$capitalized_name$, value$capitalized_name$) in $name_reserved$ {\n"
                           "        hashCode = (hashCode &* 31) &+ key$capitalized_name$.hashValue\n"
                           "        hashCode = (hashCode &* 31) &+ value$capitalized_name$.hashValue\n"
                           "    }\n"
                           "}\n");
    }
    
}  // namespace swift
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
