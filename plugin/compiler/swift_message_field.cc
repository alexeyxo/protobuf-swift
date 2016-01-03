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
        void SetMessageVariables(const FieldDescriptor* descriptor, map<string, string>* variables) {

            std::string name = UnderscoresToCamelCase(descriptor);
            (*variables)["name"] = name;
            (*variables)["capitalized_name"] = UnderscoresToCapitalizedCamelCase(descriptor);
            (*variables)["number"] = SimpleItoa(descriptor->number());
            
            string containing_class = ClassNameReturedType(descriptor->containing_type());
            string type = ClassNameReturedType(descriptor->message_type());
            
            (*variables)["type"] = type;
            (*variables)["containing_class"] = containing_class;
            (*variables)["storage_attribute"] = "";
            
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
        if (isOneOfField(descriptor_)) {
            
            printer->Print(variables_,
                           "$acontrol$private(set) var has$capitalized_name$:Bool {\n"
                           "      get {\n"
                           "           if $oneof_class_name$.get$capitalized_name$(storage$oneof_name$) == nil {\n"
                           "               return false\n"
                           "           }\n"
                           "           return true\n"
                           "      }\n"
                           "      set(newValue) {\n"
                           "      }\n"
                           "}\n");
            
            printer->Print(variables_,
                           "$acontrol$private(set) var $name$:$type$!{\n"
                           "     get {\n"
                           "          return $oneof_class_name$.get$capitalized_name$(storage$oneof_name$)\n"
                           "     }\n"
                           "     set (newvalue) {\n"
                           "          storage$oneof_name$ = $oneof_class_name$.$capitalized_name$(newvalue)\n"
                           "     }\n"
                           "}\n");
        }
        else {
            printer->Print(variables_, "$acontrol$private(set) var has$capitalized_name$:Bool = false\n");
            printer->Print(variables_, "$acontrol$private(set) var $name$:$type$!\n");
        }
        
    }
    
    void MessageFieldGenerator::GenerateInitializationSource(io::Printer* printer) const {
    }
    
    void MessageFieldGenerator::GenerateBuilderMembersSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "$acontrol$var has$capitalized_name$:Bool {\n"
                       "     get {\n"
                       "         return builderResult.has$capitalized_name$\n"
                       "     }\n"
                       "}\n"
                       "$acontrol$var $name$:$type$! {\n"
                       "     get {\n"
                       "         if $name$Builder_ != nil {\n"
                       "            builderResult.$name$ = $name$Builder_.getMessage()\n"
                       "         }\n"
                       "         return builderResult.$name$\n"
                       "     }\n"
                       "     set (value) {\n"
                       "         builderResult.has$capitalized_name$ = true\n"
                       "         builderResult.$name$ = value\n"
                       "     }\n"
                       "}\n"
                       "private var $name$Builder_:$type$.Builder! {\n"
                       "     didSet {\n"
                       "        builderResult.has$capitalized_name$ = true\n"
                       "     }\n"
                       "}\n"
                       "$acontrolFunc$ func get$capitalized_name$Builder() -> $type$.Builder {\n"
                       "  if $name$Builder_ == nil {\n"
                       "     $name$Builder_ = $type$.Builder()\n"
                       "     builderResult.$name$ = $name$Builder_.getMessage()\n"
                       "     if $name$ != nil {\n"
                       "        try! $name$Builder_.mergeFrom($name$)\n"
                       "     }\n"
                       "  }\n"
                       "  return $name$Builder_\n"
                       "}\n"
                       "$acontrol$func set$capitalized_name$(value:$type$!) -> $containing_class$.Builder {\n"
                       "  self.$name$ = value\n"
                       "  return self\n"
                       "}\n"
                       "$acontrolFunc$ func merge$capitalized_name$(value:$type$) throws -> $containing_class$.Builder {\n"
                       "  if builderResult.has$capitalized_name$ {\n"
                       "    builderResult.$name$ = try $type$.builderWithPrototype(builderResult.$name$).mergeFrom(value).buildPartial()\n"
                       "  } else {\n"
                       "    builderResult.$name$ = value\n"
                       "  }\n"
                       "  builderResult.has$capitalized_name$ = true\n"
                       "  return self\n"
                       "}\n"
                       "$acontrolFunc$ func clear$capitalized_name$() -> $containing_class$.Builder {\n"
                       "  $name$Builder_ = nil\n"
                       "  builderResult.has$capitalized_name$ = false\n"
                       "  builderResult.$name$ = nil\n"
                       "  return self\n"
                       "}\n"
                       );
    }
    
    void MessageFieldGenerator::GenerateMergingCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if (other.has$capitalized_name$) {\n"
                       "    try merge$capitalized_name$(other.$name$)\n"
                       "}\n");
    }
    
    
    
    void MessageFieldGenerator::GenerateBuildingCodeSource(io::Printer* printer) const {
    }
    
    void MessageFieldGenerator::GenerateParsingCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "let subBuilder:$type$.Builder = $type$.Builder()\n"
                       "if has$capitalized_name$ {\n"
                       "  try subBuilder.mergeFrom($name$)\n"
                       "}\n");
        
        if (descriptor_->type() == FieldDescriptor::TYPE_GROUP) {
            printer->Print(variables_,
                           "try input.readGroup($number$, builder:subBuilder, extensionRegistry:extensionRegistry)\n");
        } else {
            printer->Print(variables_,
                           "try input.readMessage(subBuilder, extensionRegistry:extensionRegistry)\n");
        }
        
        printer->Print(variables_,
                       "$name$ = subBuilder.buildPartial()\n");
    }
    
    
    void MessageFieldGenerator::GenerateSerializationCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if has$capitalized_name$ {\n"
                       "  try output.write$group_or_message$($number$, value:$name$)\n"
                       "}\n");
    }
    
    
    void MessageFieldGenerator::GenerateSerializedSizeCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if has$capitalized_name$ {\n"
                       "    if let varSize$name$ = $name$?.compute$group_or_message$Size($number$) {\n"
                       "        serialize_size += varSize$name$\n"
                       "    }\n"
                       "}\n");
    }
    
    
    void MessageFieldGenerator::GenerateDescriptionCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if has$capitalized_name$ {\n"
                       "  output += \"\\(indent) $name$ {\\n\"\n"
                       "  try $name$?.writeDescriptionTo(&output, indent:\"\\(indent)  \")\n"
                       "  output += \"\\(indent) }\\n\"\n"
                       "}\n");
    }
    
    
    void MessageFieldGenerator::GenerateIsEqualCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "(lhs.has$capitalized_name$ == rhs.has$capitalized_name$) && (!lhs.has$capitalized_name$ || lhs.$name$ == rhs.$name$)");
    }
    
    
    void MessageFieldGenerator::GenerateHashCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if has$capitalized_name$ {\n"
                       "    if let hashValue$name$ = $name$?.hashValue {\n"
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
           printer->Print(variables_, "$acontrol$private(set) var $name$:Array<$type$>  = Array<$type$>()\n");
    }
    
    
    void RepeatedMessageFieldGenerator::GenerateInitializationSource(io::Printer* printer) const {

    }
        
    
    void RepeatedMessageFieldGenerator::GenerateMembersSource(io::Printer* printer) const {
        
     
    }
    
    
    void RepeatedMessageFieldGenerator::GenerateBuilderMembersSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "$acontrol$var $name$:Array<$type$> {\n"
                       "     get {\n"
                       "         return builderResult.$name$\n"
                       "     }\n"
                       "     set (value) {\n"
                       "         builderResult.$name$ = value\n"
                       "     }\n"
                       "}\n"
                       "$acontrol$func set$capitalized_name$(value:Array<$type$>) -> $containing_class$.Builder {\n"
                       "  self.$name$ = value\n"
                       "  return self\n"
                       "}\n"
                       "$acontrolFunc$ func clear$capitalized_name$() -> $containing_class$.Builder {\n"
                       "  builderResult.$name$.removeAll(keepCapacity: false)\n"
                       "  return self\n"
                       "}\n");
    }
    
    void RepeatedMessageFieldGenerator::GenerateMergingCodeSource(io::Printer* printer) const {
        
        printer->Print(variables_,
                       "if !other.$name$.isEmpty  {\n"
                       "   builderResult.$name$ += other.$name$\n"
                       "}\n");
    }
    
    
    void RepeatedMessageFieldGenerator::GenerateBuildingCodeSource(io::Printer* printer) const {
    }
    
    void RepeatedMessageFieldGenerator::GenerateParsingCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "let subBuilder = $type$.Builder()\n");
        
        if (descriptor_->type() == FieldDescriptor::TYPE_GROUP) {
            printer->Print(variables_,
                           "try input.readGroup($number$,builder:subBuilder,extensionRegistry:extensionRegistry)\n");
        } else {
            printer->Print(variables_,
                           "try input.readMessage(subBuilder,extensionRegistry:extensionRegistry)\n");
        }
        
        printer->Print(variables_,
                       "$name$ += [subBuilder.buildPartial()]\n");
    }
    
    void RepeatedMessageFieldGenerator::GenerateSerializationCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "for oneElement$name$ in $name$ {\n"
                       "    try output.write$group_or_message$($number$, value:oneElement$name$)\n"
                       "}\n");
    }
    
    void RepeatedMessageFieldGenerator::GenerateSerializedSizeCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "for oneElement$name$ in $name$ {\n"
                       "    serialize_size += oneElement$name$.compute$group_or_message$Size($number$)\n"
                       "}\n");
    }
    
    void RepeatedMessageFieldGenerator::GenerateDescriptionCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "var $name$ElementIndex:Int = 0\n"
                       "for oneElement$name$ in $name$ {\n"
                       "    output += \"\\(indent) $name$[\\($name$ElementIndex)] {\\n\"\n"
                       "    try oneElement$name$.writeDescriptionTo(&output, indent:\"\\(indent)  \")\n"
                       "    output += \"\\(indent)}\\n\"\n"
                       "    $name$ElementIndex++\n"
                       "}\n");
    }
    
    void RepeatedMessageFieldGenerator::GenerateIsEqualCodeSource(io::Printer* printer) const {
        printer->Print(variables_, "(lhs.$name$ == rhs.$name$)");
    }
    
    void RepeatedMessageFieldGenerator::GenerateHashCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "for oneElement$name$ in $name$ {\n"
                       "    hashCode = (hashCode &* 31) &+ oneElement$name$.hashValue\n"
                       "}\n");
    }
    
    string RepeatedMessageFieldGenerator::GetBoxedType() const {
        return ClassName(descriptor_->message_type());
    }
}  // namespace swift
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
