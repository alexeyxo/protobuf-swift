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

#include "swift_enum_field.h"

#include <map>
#include <string>

#include <google/protobuf/stubs/common.h>
#include <google/protobuf/io/printer.h>
#include <google/protobuf/wire_format.h>
#include <google/protobuf/stubs/strutil.h>

#include "swift_helpers.h"

namespace google { namespace protobuf { namespace compiler { namespace swift {
    
    namespace {
        void SetEnumVariables(const FieldDescriptor* descriptor, std::map<string, string>* variables) {
            
            const EnumValueDescriptor* default_value;
            default_value = descriptor->default_value_enum();
            
            std::string capname = UnderscoresToCapitalizedCamelCase(descriptor);
            std::string name = UnderscoresToCamelCase(descriptor);
            
            string type = ClassNameReturedType(descriptor->enum_type());
            string containing_class = ClassNameReturedType(descriptor->containing_type());
            
            (*variables)["name"]                  = name;
            (*variables)["name_reserved"]         = SafeName(name);
            (*variables)["capitalized_name"]      = capname;
            (*variables)["capitalized_name_reserved"] = SafeName(capname);
            (*variables)["number"] = SimpleItoa(descriptor->number());
            
            (*variables)["type"] = type;
            (*variables)["containing_class"] = containing_class;
            
            //JSON
            (*variables)["json_name"] = descriptor->json_name();
            (*variables)["to_json_value"] = ToJSONValue(descriptor, SafeName(name));
            (*variables)["to_json_value_repeated_storage_type"] = ToJSONValueRepeatedStorageType(descriptor);
            (*variables)["to_json_value_repeated"] = ToJSONValue(descriptor, "oneValue" + capname);
            (*variables)["from_json_value"] = FromJSONValue(descriptor, "jsonValue" + capname);
            (*variables)["from_json_value_repeated"] = FromJSONValue(descriptor, "oneValue" + capname);
            (*variables)["json_casting_type"] = JSONCastingValue(descriptor);
            ///
            
            (*variables)["default"] = EnumValueName(default_value);
            (*variables)["tag"] = SimpleItoa(internal::WireFormat::MakeTag(descriptor));
            (*variables)["tag_size"] = SimpleItoa(internal::WireFormat::TagSize(descriptor->number(), descriptor->type()));
            
            if (isOneOfField(descriptor)) {
                const OneofDescriptor* oneof = descriptor->containing_oneof();
                (*variables)["oneof_name"] = UnderscoresToCapitalizedCamelCase(oneof->name());
                (*variables)["oneof_class_name"] = ClassNameOneof(oneof);
            }
            (* variables)["acontrol"] = GetAccessControlTypeForFields(descriptor->file());
            (* variables)["acontrolFunc"] = GetAccessControlType(descriptor->file());
        }
    }  // namespace
    
    EnumFieldGenerator::EnumFieldGenerator(const FieldDescriptor* descriptor) : descriptor_(descriptor) {
        SetEnumVariables(descriptor, &variables_);
    }
    
    
    EnumFieldGenerator::~EnumFieldGenerator() {}
    
    
    void EnumFieldGenerator::GenerateExtensionSource(io::Printer* printer) const {
        printer->Print(variables_,"$acontrol$var $name_reserved$:$type$\n");
    }
    
    void EnumFieldGenerator::GenerateMembersSource(io::Printer* printer) const {
    }
    
    
    void EnumFieldGenerator::GenerateVariablesSource(io::Printer* printer) const {
        if (descriptor_->options().deprecated() && !IsDescriptorFile(descriptor_->file())) {
             printer->Print(variables_ ,"@available(*, deprecated:0.1, message:\"$name_reserved$ is marked as \\\"Deprecated\\\"\")\n");
        }
        if (isOneOfField(descriptor_)) {
            
            printer->Print(variables_,
                           "$acontrol$fileprivate(set) var $name_reserved$:$type$!{\n"
                           "    get {\n"
                           "        return $oneof_class_name$.get$capitalized_name$(storage$oneof_name$)\n"
                           "    }\n"
                           "    set (newvalue) {\n"
                           "        storage$oneof_name$ = $oneof_class_name$.$name$(newvalue)\n"
                           "    }\n"
                           "}\n");
            
            printer->Print(variables_,
                           "$acontrol$fileprivate(set) var has$capitalized_name$:Bool {\n"
                           "    get {\n"
                           "        return $oneof_class_name$.get$capitalized_name$(storage$oneof_name$) != nil\n"
                           "    }\n"
                           "    set(newValue) {\n"
                           "    }\n"
                           "}\n");
            
        
        }
        else
        {
            printer->Print(variables_,"$acontrol$fileprivate(set) var $name_reserved$:$type$ = $type$.$default$\n");
            printer->Print(variables_,"$acontrol$fileprivate(set) var has$capitalized_name$:Bool = false\n");
        }
    }
    
    void EnumFieldGenerator::GenerateSubscript(io::Printer* printer) const {
            printer->Print(variables_,"case \"$name_reserved$\": return self.$name_reserved$\n");
    }
    
    void EnumFieldGenerator::GenerateSetSubscript(io::Printer* printer) const {
        
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
    
    
    void EnumFieldGenerator::GenerateInitializationSource(io::Printer* printer) const {}
    
    void EnumFieldGenerator::GenerateBuilderMembersSource(io::Printer* printer) const {
        SourceLocation location;
        if (descriptor_->GetSourceLocation(&location)) {
            string comments;
            comments = BuildCommentsString(location);
            printer->Print(comments.c_str());
        }
        printer->Print(variables_,
                       "    $acontrol$var $name_reserved$:$type$ {\n"
                       "        get {\n"
                       "            return builderResult.$name_reserved$\n"
                       "        }\n"
                       "        set (value) {\n"
                       "            builderResult.has$capitalized_name$ = true\n"
                       "            builderResult.$name_reserved$ = value\n"
                       "        }\n"
                       "    }\n"
                       "    $acontrol$var has$capitalized_name$:Bool{\n"
                       "        get {\n"
                       "            return builderResult.has$capitalized_name$\n"
                       "        }\n"
                       "    }\n");
        
        printer->Print(variables_,
                       "@discardableResult\n"
                       "    $acontrolFunc$ func set$capitalized_name$(_ value:$type$) -> $containing_class$.Builder {\n"
                       "      self.$name_reserved$ = value\n"
                       "      return self\n"
                       "    }\n"
                       "@discardableResult\n"
                       "    $acontrolFunc$ func clear$capitalized_name$() -> $containing_class$.Builder {\n"
                       "       builderResult.has$capitalized_name$ = false\n"
                       "       builderResult.$name_reserved$ = .$default$\n"
                       "       return self\n"
                       "    }\n");
    }
    
    
    
    void EnumFieldGenerator::GenerateMergingCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if other.has$capitalized_name$ {\n"
                       "    $name_reserved$ = other.$name_reserved$\n"
                       "}\n");
    }
    
    
    void EnumFieldGenerator::GenerateBuildingCodeSource(io::Printer* printer) const {}
    
    void EnumFieldGenerator::GenerateParsingCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       
                       "let valueInt$name$ = try codedInputStream.readEnum()\n"
                       "if let enums$name$ = $type$(rawValue:valueInt$name$){\n"
                       "    $name_reserved$ = enums$name$\n"
                       "} else {\n"
                       "    try unknownFieldsBuilder.mergeVarintField(fieldNumber: $number$, value:Int64(valueInt$name$))\n"
                       "}\n");
    }
    
    void EnumFieldGenerator::GenerateSerializationCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if has$capitalized_name$ {\n"
                       "    try codedOutputStream.writeEnum(fieldNumber: $number$, value:$name_reserved$.rawValue)\n"
                       "}\n");
    }
    
    
    void EnumFieldGenerator::GenerateSerializedSizeCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if (has$capitalized_name$) {\n"
                       "    serialize_size += $name_reserved$.rawValue.computeEnumSize(fieldNumber: $number$)\n"
                       "}\n");
    }
    
    
    void EnumFieldGenerator::GenerateDescriptionCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if (has$capitalized_name$) {\n"
                       "    output += \"\\(indent) $name$: \\($name_reserved$.description)\\n\"\n"
                       "}\n");
    }
    
    void EnumFieldGenerator::GenerateJSONEncodeCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if has$capitalized_name$ {\n"
                       "    jsonMap[\"$json_name$\"] = $to_json_value$\n"
                       "}\n");
    }
    
    void EnumFieldGenerator::GenerateJSONDecodeCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if let jsonValue$capitalized_name$ = jsonMap[\"$json_name$\"] as? $json_casting_type$ {\n"
                       "    resultDecodedBuilder.$name_reserved$ = $from_json_value$\n"
                       "}\n");
    }
    
    
    void EnumFieldGenerator::GenerateIsEqualCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "(lhs.has$capitalized_name$ == rhs.has$capitalized_name$) && (!lhs.has$capitalized_name$ || lhs.$name_reserved$ == rhs.$name_reserved$)");
    }
    
    
    void EnumFieldGenerator::GenerateHashCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if has$capitalized_name$ {\n"
                       "     hashCode = (hashCode &* 31) &+ $name_reserved$.hashValue\n"
                       "}\n");
    }
    
    
    string EnumFieldGenerator::GetBoxedType() const {
        return ClassName(descriptor_->enum_type());
    }
    
    
    RepeatedEnumFieldGenerator::RepeatedEnumFieldGenerator(const FieldDescriptor* descriptor)
    : descriptor_(descriptor) {
        SetEnumVariables(descriptor, &variables_);
    }
    
    
    RepeatedEnumFieldGenerator::~RepeatedEnumFieldGenerator() {
    }
    
    
    
    void RepeatedEnumFieldGenerator::GenerateExtensionSource(io::Printer* printer) const {
        printer->Print(variables_,"$acontrol$var $name_reserved$:[$type$] = [$type$]()\n");
    }
    
    void RepeatedEnumFieldGenerator::GenerateVariablesSource(io::Printer* printer) const {
        if (descriptor_->options().deprecated() && !IsDescriptorFile(descriptor_->file())) {
            printer->Print(variables_ ,"@available(*, deprecated:0.1, message:\"$name_reserved$ is marked as \\\"Deprecated\\\"\")\n");
        }
        printer->Print(variables_,
                       "private var $name$MemoizedSerializedSize:Int32 = 0\n");
        printer->Print(variables_,
                       "$acontrol$fileprivate(set) var $name_reserved$:Array<$type$> = Array<$type$>()\n");
    }
    
    void RepeatedEnumFieldGenerator::GenerateSubscript(io::Printer* printer) const {
        printer->Print(variables_,"case \"$name_reserved$\": return self.$name_reserved$\n");
    }
    void RepeatedEnumFieldGenerator::GenerateSetSubscript(io::Printer* printer) const {
        printer->Print(variables_,"case \"$name_reserved$\":\n");
        XCodeStandartIndent(printer);
        printer->Print(variables_,"guard let newSubscriptValue = newSubscriptValue as? Array<$type$> else {\n");
        XCodeStandartIndent(printer);
        printer->Print(variables_,"return\n");
        XCodeStandartOutdent(printer);
        printer->Print(variables_,"}\n");
        printer->Print(variables_,"self.$name_reserved$ = newSubscriptValue\n");
        XCodeStandartOutdent(printer);
    }
    
    void RepeatedEnumFieldGenerator::GenerateInitializationSource(io::Printer* printer) const {
    }
    
    void RepeatedEnumFieldGenerator::GenerateMembersSource(io::Printer* printer) const {
    }
    
    void RepeatedEnumFieldGenerator::GenerateBuilderMembersSource(io::Printer* printer) const {
        
        SourceLocation location;
        if (descriptor_->GetSourceLocation(&location)) {
            string comments;
            comments = BuildCommentsString(location);
            printer->Print(comments.c_str());
        }
        printer->Print(variables_,
                       "$acontrol$var $name_reserved$:Array<$type$> {\n"
                       "    get {\n"
                       "        return builderResult.$name_reserved$\n"
                       "    }\n"
                       "    set (value) {\n"
                       "        builderResult.$name_reserved$ = value\n"
                       "    }\n"
                       "}\n"
                       "@discardableResult\n"
                       "$acontrol$func set$capitalized_name$(_ value:Array<$type$>) -> $containing_class$.Builder {\n"
                       "    self.$name_reserved$ = value\n"
                       "    return self\n"
                       "}\n"
                       "@discardableResult\n"
                       "$acontrolFunc$ func clear$capitalized_name$() -> $containing_class$.Builder {\n"
                       "    builderResult.$name_reserved$.removeAll(keepingCapacity: false)\n"
                       "    return self\n"
                       "}\n");
    }
    
    void RepeatedEnumFieldGenerator::GenerateMergingCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if !other.$name_reserved$.isEmpty {\n"
                       "     builderResult.$name_reserved$ += other.$name_reserved$\n"
                       "}\n"
                       );
    }
    
    void RepeatedEnumFieldGenerator::GenerateBuildingCodeSource(io::Printer* printer) const {
    }
    
    void RepeatedEnumFieldGenerator::GenerateParsingCodeSource(io::Printer* printer) const {
        // If packed, set up the while loop
        if (isPackedTypeProto3(descriptor_)) {
            printer->Print(variables_,
                           "let length = Int(try codedInputStream.readRawVarint32())\n"
                           "let oldLimit = try codedInputStream.pushLimit(byteLimit: length)\n"
                           "while codedInputStream.bytesUntilLimit() > 0 {\n");
            
        }
        
        printer->Print(variables_,
                       "let valueInt$name$ = try codedInputStream.readEnum()\n"
                       "if let enums$name$ = $type$(rawValue:valueInt$name$) {\n"
                       "    builderResult.$name_reserved$.append(enums$name$)\n"
                       "} else {\n"
                       "    try unknownFieldsBuilder.mergeVarintField(fieldNumber: $number$, value:Int64(valueInt$name$))\n"
                       "}\n");
        
        if (isPackedTypeProto3(descriptor_)) {
            
            printer->Print(variables_,
                           "}\n"
                           "codedInputStream.popLimit(oldLimit: oldLimit)\n");
        }
    }
    
    void RepeatedEnumFieldGenerator::GenerateSerializationCodeSource(io::Printer* printer) const {
        
        if (isPackedTypeProto3(descriptor_)) {
            printer->Print(variables_,
                           "if !$name_reserved$.isEmpty {\n"
                           "    try codedOutputStream.writeRawVarint32(value: $tag$)\n"
                           "    try codedOutputStream.writeRawVarint32(value: $name$MemoizedSerializedSize)\n"
                           "}\n"
                           "for oneValueOf$name$ in $name_reserved$ {\n"
                           "      try codedOutputStream.writeEnumNoTag(value: oneValueOf$name$.rawValue)\n"
                           "}\n");
        } else {
            printer->Print(variables_,
                           "for oneValueOf$name$ in $name_reserved$ {\n"
                           "      try codedOutputStream.writeEnum(fieldNumber: $number$, value:oneValueOf$name_reserved$.rawValue)\n"
                           "}\n");
        }
    }
    
    
    void RepeatedEnumFieldGenerator::GenerateSerializedSizeCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "var dataSize$name$:Int32 = 0\n");
        
        
        printer->Print(variables_,
                       "for oneValueOf$name$ in $name_reserved$ {\n"
                       "    dataSize$name$ += oneValueOf$name$.rawValue.computeEnumSizeNoTag()\n"
                       "}\n");
        
        printer->Print(variables_,"serialize_size += dataSize$name$\n");
        
        if (isPackedTypeProto3(descriptor_)) {
            
            printer->Print(variables_,
                           "if !$name_reserved$.isEmpty {\n"
                           "    serialize_size += $tag_size$\n"
                           "    serialize_size += dataSize$name$.computeRawVarint32Size()\n"
                           "}\n");
            
        } else {
            printer->Print(variables_,
                           "serialize_size += ($tag_size$ * Int32($name_reserved$.count))\n");
        }
        
        if (isPackedTypeProto3(descriptor_)) {
            printer->Print(variables_,
                           "$name$MemoizedSerializedSize = dataSize$name$\n");
        }
        
    }
    
    
    void RepeatedEnumFieldGenerator::GenerateDescriptionCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "var $name$ElementIndex:Int = 0\n"
                       "for oneValueOf$name$ in $name_reserved$ {\n"
                       "    output += \"\\(indent) $name$[\\($name$ElementIndex)]: \\(oneValueOf$name$.description)\\n\"\n"
                       "    $name$ElementIndex += 1\n"
                       "}\n");
    }
    
    void RepeatedEnumFieldGenerator::GenerateJSONEncodeCodeSource(io::Printer* printer) const {
        
        printer->Print(variables_,
                           "if !$name_reserved$.isEmpty {\n"
                           "    var jsonArray$capitalized_name$:Array<$to_json_value_repeated_storage_type$> = []\n"
                           "    for oneValue$capitalized_name$ in $name_reserved$ {\n"
                           "        jsonArray$capitalized_name$.append($to_json_value_repeated$)\n"
                           "    }\n"
                           "    jsonMap[\"$json_name$\"] = jsonArray$capitalized_name$\n"
                           "}\n");
        
    }
    
    void RepeatedEnumFieldGenerator::GenerateJSONDecodeCodeSource(io::Printer* printer) const {
        
            printer->Print(variables_,
                           "if let jsonValue$capitalized_name$ = jsonMap[\"$json_name$\"] as? Array<$json_casting_type$> {\n"
                           "    var jsonArray$capitalized_name$:Array<$type$> = []\n"
                           "    for oneValue$capitalized_name$ in jsonValue$capitalized_name$ {\n"
                           "        let enumFromString$capitalized_name$ = $from_json_value_repeated$\n"
                           "        jsonArray$capitalized_name$.append(enumFromString$capitalized_name$)\n"
                           "    }\n"
                           "    resultDecodedBuilder.$name_reserved$ = jsonArray$capitalized_name$\n"
                           "}\n");
      
    }
    
    
    void RepeatedEnumFieldGenerator::GenerateIsEqualCodeSource(io::Printer* printer) const {
        printer->Print(variables_, "(lhs.$name_reserved$ == rhs.$name_reserved$)");
    }
    
    
    void RepeatedEnumFieldGenerator::GenerateHashCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "for oneValueOf$name$ in $name_reserved$ {\n"
                       "    hashCode = (hashCode &* 31) &+ oneValueOf$name$.hashValue\n"
                       "}\n");
    }
}  // namespace swift
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
