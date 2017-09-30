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

#include "swift_message_field.h"

#include <map>
#include <string>

#include <google/protobuf/io/printer.h>
#include <google/protobuf/wire_format.h>
#include <google/protobuf/stubs/strutil.h>

#include "swift_helpers.h"

namespace google { namespace protobuf { namespace compiler { namespace swift {
    
    namespace {
        void SetMessageVariables(const FieldDescriptor* descriptor, std::map<string, string>* variables) {
            
            std::string name = UnderscoresToCamelCase(descriptor);
            std::string capname = UnderscoresToCapitalizedCamelCase(descriptor);
            (*variables)["name"] = name;
            (*variables)["name_reserved"] = SafeName(name);
            (*variables)["capitalized_name"] = capname;
            (*variables)["number"] = SimpleItoa(descriptor->number());
            
            string containing_class = ClassNameReturedType(descriptor->containing_type());
            string type = ClassNameReturedType(descriptor->message_type());
            
            (*variables)["type"] = type;
            (*variables)["containing_class"] = containing_class;
            (*variables)["storage_attribute"] = "";
            
            //JSON
            (*variables)["json_name"] = descriptor->json_name();
            (*variables)["to_json_value"] = ToJSONValue(descriptor, name);
            (*variables)["to_json_value_repeated_storage_type"] = ToJSONValueRepeatedStorageType(descriptor);
            (*variables)["to_json_value_repeated"] = ToJSONValue(descriptor, "oneValue" + capname);
            (*variables)["from_json_value"] = FromJSONValue(descriptor, "jsonValue" + capname);
            (*variables)["from_json_value_repeated"] = FromJSONValue(descriptor, "oneValue" + capname);
            (*variables)["json_casting_type"] = JSONCastingValue(descriptor);
            
            
            //
            (*variables)["group_or_message"] = (descriptor->type() == FieldDescriptor::TYPE_GROUP) ? "Group" : "Message";
            
            (* variables)["acontrol"] = GetAccessControlTypeForFields(descriptor->file());
            (* variables)["acontrolFunc"] = GetAccessControlType(descriptor->file());
            
            if (isOneOfField(descriptor)) {
                const OneofDescriptor* oneof = descriptor->containing_oneof();
                (*variables)["oneof_name"] = UnderscoresToCapitalizedCamelCase(oneof->name());
                (*variables)["oneof_class_name"] = ClassNameOneof(oneof);
            }
        }
    }  // namespace
    
    
    MessageFieldGenerator::MessageFieldGenerator(const FieldDescriptor* descriptor)
    : descriptor_(descriptor) {
        SetMessageVariables(descriptor, &variables_);
    }
    
    
    MessageFieldGenerator::~MessageFieldGenerator() {
    }
    
    
    void MessageFieldGenerator::GenerateExtensionSource(io::Printer* printer) const {
        
    }
    
    
    void MessageFieldGenerator::GenerateVariablesSource(io::Printer* printer) const {
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
        else {
            printer->Print(variables_, "$acontrol$fileprivate(set) var $name_reserved$:$type$!\n");
            printer->Print(variables_, "$acontrol$fileprivate(set) var has$capitalized_name$:Bool = false\n");
        }
        
    }
    
    void MessageFieldGenerator::GenerateSubscript(io::Printer* printer) const {
        printer->Print(variables_,"case \"$name_reserved$\": return self.$name_reserved$\n");
    }
    
    void MessageFieldGenerator::GenerateSetSubscript(io::Printer* printer) const {
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
    
    void MessageFieldGenerator::GenerateInitializationSource(io::Printer* printer) const {
    }
    
    void MessageFieldGenerator::GenerateBuilderMembersSource(io::Printer* printer) const {
        SourceLocation location;
        if (descriptor_->GetSourceLocation(&location)) {
            string comments;
            comments = BuildCommentsString(location);
            printer->Print(comments.c_str());
        }
        printer->Print(variables_,
                       "$acontrol$var $name_reserved$:$type$! {\n"
                       "    get {\n"
                       "        if $name$Builder_ != nil {\n"
                       "            builderResult.$name_reserved$ = $name$Builder_.getMessage()\n"
                       "        }\n"
                       "        return builderResult.$name_reserved$\n"
                       "    }\n"
                       "    set (value) {\n"
                       "        builderResult.has$capitalized_name$ = value != nil\n"
                       "        builderResult.$name_reserved$ = value\n"
                       "    }\n"
                       "}\n"
                       "$acontrol$var has$capitalized_name$:Bool {\n"
                       "    get {\n"
                       "        return builderResult.has$capitalized_name$\n"
                       "    }\n"
                       "}\n"
                       "fileprivate var $name$Builder_:$type$.Builder! {\n"
                       "    didSet {\n"
                       "        builderResult.has$capitalized_name$ = true\n"
                       "    }\n"
                       "}\n"
                       "$acontrolFunc$ func get$capitalized_name$Builder() -> $type$.Builder {\n"
                       "    if $name$Builder_ == nil {\n"
                       "        $name$Builder_ = $type$.Builder()\n"
                       "        builderResult.$name_reserved$ = $name$Builder_.getMessage()\n"
                       "        if $name_reserved$ != nil {\n"
                       "            try! $name$Builder_.mergeFrom(other: $name_reserved$)\n"
                       "        }\n"
                       "    }\n"
                       "    return $name$Builder_\n"
                       "}\n"
                       "@discardableResult\n"
                       "$acontrol$func set$capitalized_name$(_ value:$type$!) -> $containing_class$.Builder {\n"
                       "    self.$name_reserved$ = value\n"
                       "    return self\n"
                       "}\n"
                       "@discardableResult\n"
                       "$acontrolFunc$ func merge$capitalized_name$(value:$type$) throws -> $containing_class$.Builder {\n"
                       "    if builderResult.has$capitalized_name$ {\n"
                       "        builderResult.$name_reserved$ = try $type$.builderWithPrototype(prototype:builderResult.$name_reserved$).mergeFrom(other: value).buildPartial()\n"
                       "    } else {\n"
                       "        builderResult.$name_reserved$ = value\n"
                       "    }\n"
                       "    builderResult.has$capitalized_name$ = true\n"
                       "    return self\n"
                       "}\n"
                       "@discardableResult\n"
                       "$acontrolFunc$ func clear$capitalized_name$() -> $containing_class$.Builder {\n"
                       "    $name$Builder_ = nil\n"
                       "    builderResult.has$capitalized_name$ = false\n"
                       "    builderResult.$name_reserved$ = nil\n"
                       "    return self\n"
                       "}\n"
                       );
    }
    
    void MessageFieldGenerator::GenerateMergingCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if (other.has$capitalized_name$) {\n"
                       "    try merge$capitalized_name$(value: other.$name_reserved$)\n"
                       "}\n");
    }
    
    
    
    void MessageFieldGenerator::GenerateBuildingCodeSource(io::Printer* printer) const {
    }
    
    void MessageFieldGenerator::GenerateParsingCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "let subBuilder:$type$.Builder = $type$.Builder()\n"
                       "if has$capitalized_name$ {\n"
                       "    try subBuilder.mergeFrom(other: $name_reserved$)\n"
                       "}\n");
        
        if (descriptor_->type() == FieldDescriptor::TYPE_GROUP) {
            printer->Print(variables_,
                           "try codedInputStream.readGroup(fieldNumber: $number$, builder:subBuilder, extensionRegistry:extensionRegistry)\n");
        } else {
            printer->Print(variables_,
                           "try codedInputStream.readMessage(builder: subBuilder, extensionRegistry:extensionRegistry)\n");
        }
        
        printer->Print(variables_,
                       "$name_reserved$ = subBuilder.buildPartial()\n");
    }
    
    
    void MessageFieldGenerator::GenerateSerializationCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if has$capitalized_name$ {\n"
                       "    try codedOutputStream.write$group_or_message$(fieldNumber: $number$, value:$name_reserved$)\n"
                       "}\n");
    }
    
    
    void MessageFieldGenerator::GenerateSerializedSizeCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if has$capitalized_name$ {\n"
                       "    if let varSize$name$ = $name_reserved$?.compute$group_or_message$Size(fieldNumber: $number$) {\n"
                       "        serialize_size += varSize$name$\n"
                       "    }\n"
                       "}\n");
    }
    
    
    void MessageFieldGenerator::GenerateDescriptionCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if has$capitalized_name$ {\n"
                       "    output += \"\\(indent) $name$ {\\n\"\n"
                       "    if let outDesc$capitalized_name$ = $name_reserved$ {\n"
                       "        output += try outDesc$capitalized_name$.getDescription(indent: \"\\(indent)  \")\n"
                       "    }\n"
                       "    output += \"\\(indent) }\\n\"\n"
                       "}\n");
    }
    
    
    void MessageFieldGenerator::GenerateJSONEncodeCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if has$capitalized_name$ {\n"
                       "    jsonMap[\"$json_name$\"] = try $name_reserved$.encode()\n");
        printer->Print(variables_,
                       "}\n");
    }
    
    void MessageFieldGenerator::GenerateJSONDecodeCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if let jsonValue$capitalized_name$ = jsonMap[\"$json_name$\"] as? $json_casting_type$ {\n"
                       "    resultDecodedBuilder.$name_reserved$ = $from_json_value$\n");
        printer->Print(variables_,
                       "}\n");
    }
    
    
    void MessageFieldGenerator::GenerateIsEqualCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "(lhs.has$capitalized_name$ == rhs.has$capitalized_name$) && (!lhs.has$capitalized_name$ || lhs.$name_reserved$ == rhs.$name_reserved$)");
    }
    
    
    void MessageFieldGenerator::GenerateHashCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if has$capitalized_name$ {\n"
                       "    if let hashValue$name$ = $name_reserved$?.hashValue {\n"
                       "        hashCode = (hashCode &* 31) &+ hashValue$name$\n"
                       "    }\n"
                       "}\n");
    }
    
    
    void MessageFieldGenerator::GenerateMembersSource(io::Printer* printer) const {
        
    }
    
    
    string MessageFieldGenerator::GetBoxedType() const {
        return ClassName(descriptor_->message_type());
    }
    
    
    RepeatedMessageFieldGenerator::RepeatedMessageFieldGenerator(const FieldDescriptor* descriptor)
    : descriptor_(descriptor) {
        SetMessageVariables(descriptor, &variables_);
    }
    
    
    RepeatedMessageFieldGenerator::~RepeatedMessageFieldGenerator() {
    }
    
    void RepeatedMessageFieldGenerator::GenerateExtensionSource(io::Printer* printer) const {
    }
    
    
    void RepeatedMessageFieldGenerator::GenerateVariablesSource(io::Printer* printer) const {
        if (descriptor_->options().deprecated() && !IsDescriptorFile(descriptor_->file())) {
            printer->Print(variables_ ,"@available(*, deprecated:0.1, message:\"$name_reserved$ is marked as \\\"Deprecated\\\"\")\n");
        }
        printer->Print(variables_, "$acontrol$fileprivate(set) var $name_reserved$:Array<$type$>  = Array<$type$>()\n");
    }
    
    void RepeatedMessageFieldGenerator::GenerateSubscript(io::Printer* printer) const {
        printer->Print(variables_,"case \"$name_reserved$\": return self.$name_reserved$\n");
    }
    
    void RepeatedMessageFieldGenerator::GenerateSetSubscript(io::Printer* printer) const {
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
    
    
    void RepeatedMessageFieldGenerator::GenerateInitializationSource(io::Printer* printer) const {
        
    }
    
    
    void RepeatedMessageFieldGenerator::GenerateMembersSource(io::Printer* printer) const {
        
        
    }
    
    
    void RepeatedMessageFieldGenerator::GenerateBuilderMembersSource(io::Printer* printer) const {
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
    
    void RepeatedMessageFieldGenerator::GenerateMergingCodeSource(io::Printer* printer) const {
        
        printer->Print(variables_,
                       "if !other.$name_reserved$.isEmpty  {\n"
                       "     builderResult.$name_reserved$ += other.$name_reserved$\n"
                       "}\n");
    }
    
    
    void RepeatedMessageFieldGenerator::GenerateBuildingCodeSource(io::Printer* printer) const {
    }
    
    void RepeatedMessageFieldGenerator::GenerateParsingCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "let subBuilder = $type$.Builder()\n");
        
        if (descriptor_->type() == FieldDescriptor::TYPE_GROUP) {
            printer->Print(variables_,
                           "try codedInputStream.readGroup(fieldNumber:$number$, builder:subBuilder,extensionRegistry:extensionRegistry)\n");
        } else {
            printer->Print(variables_,
                           "try codedInputStream.readMessage(builder: subBuilder,extensionRegistry:extensionRegistry)\n");
        }
        
        printer->Print(variables_,
                       "$name_reserved$.append(subBuilder.buildPartial())\n");
    }
    
    void RepeatedMessageFieldGenerator::GenerateSerializationCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "for oneElement$capitalized_name$ in $name_reserved$ {\n"
                       "      try codedOutputStream.write$group_or_message$(fieldNumber: $number$, value:oneElement$capitalized_name$)\n"
                       "}\n");
    }
    
    void RepeatedMessageFieldGenerator::GenerateSerializedSizeCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "for oneElement$capitalized_name$ in $name_reserved$ {\n"
                       "    serialize_size += oneElement$capitalized_name$.compute$group_or_message$Size(fieldNumber: $number$)\n"
                       "}\n");
    }
    
    void RepeatedMessageFieldGenerator::GenerateDescriptionCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "var $name$ElementIndex:Int = 0\n"
                       "for oneElement$capitalized_name$ in $name_reserved$ {\n"
                       "    output += \"\\(indent) $name$[\\($name$ElementIndex)] {\\n\"\n"
                       "    output += try oneElement$capitalized_name$.getDescription(indent: \"\\(indent)  \")\n"
                       "    output += \"\\(indent)}\\n\"\n"
                       "    $name$ElementIndex += 1\n"
                       "}\n");
    }
    
    void RepeatedMessageFieldGenerator::GenerateJSONEncodeCodeSource(io::Printer* printer) const {
        
        printer->Print(variables_,
                       "if !$name_reserved$.isEmpty {\n"
                       "    var jsonArray$capitalized_name$:Array<$json_casting_type$> = []\n"
                       "    for oneValue$capitalized_name$ in $name_reserved$ {\n"
                       "        let ecodedMessage$capitalized_name$ = $to_json_value_repeated$\n"
                       "        jsonArray$capitalized_name$.append(ecodedMessage$capitalized_name$)\n"
                       "    }\n"
                       "    jsonMap[\"$json_name$\"] = jsonArray$capitalized_name$\n"
                       "}\n");
        
    }
    
    void RepeatedMessageFieldGenerator::GenerateJSONDecodeCodeSource(io::Printer* printer) const {
        
        printer->Print(variables_,
                       "if let jsonValue$capitalized_name$ = jsonMap[\"$json_name$\"] as? Array<$json_casting_type$> {\n"
                       "    var jsonArray$capitalized_name$:Array<$type$> = []\n"
                       "    for oneValue$capitalized_name$ in jsonValue$capitalized_name$ {\n"
                       "        let messageFromString$capitalized_name$ = $from_json_value_repeated$\n"
                       "        jsonArray$capitalized_name$.append(messageFromString$capitalized_name$)\n"
                       "    }\n"
                       "    resultDecodedBuilder.$name_reserved$ = jsonArray$capitalized_name$\n"
                       "}\n");
        
    }
    
    void RepeatedMessageFieldGenerator::GenerateIsEqualCodeSource(io::Printer* printer) const {
        printer->Print(variables_, "(lhs.$name_reserved$ == rhs.$name_reserved$)");
    }
    
    void RepeatedMessageFieldGenerator::GenerateHashCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "for oneElement$capitalized_name$ in $name_reserved$ {\n"
                       "    hashCode = (hashCode &* 31) &+ oneElement$capitalized_name$.hashValue\n"
                       "}\n");
    }
    
    string RepeatedMessageFieldGenerator::GetBoxedType() const {
        return ClassName(descriptor_->message_type());
    }
}  // namespace swift
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
