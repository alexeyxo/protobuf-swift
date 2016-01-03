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
        void SetEnumVariables(const FieldDescriptor* descriptor, map<string, string>* variables) {
            
            const EnumValueDescriptor* default_value;
            default_value = descriptor->default_value_enum();
           
            string type = ClassNameReturedType(descriptor->enum_type());
            string containing_class = ClassNameReturedType(descriptor->containing_type());
            
            (*variables)["name"]                  = UnderscoresToCamelCase(descriptor);
            (*variables)["capitalized_name"]      = UnderscoresToCapitalizedCamelCase(descriptor);
            (*variables)["number"] = SimpleItoa(descriptor->number());
            
            (*variables)["type"] = type;
            (*variables)["containing_class"] = containing_class;
            
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
        printer->Print(variables_,"$acontrol$var $name$:$type$\n");
    }
    
    void EnumFieldGenerator::GenerateMembersSource(io::Printer* printer) const {
    }
    
    
    void EnumFieldGenerator::GenerateVariablesSource(io::Printer* printer) const {
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
        else
        {
            printer->Print(variables_, "$acontrol$private(set) var $name$:$type$ = $type$.$default$\n");
            printer->Print(variables_,"$acontrol$private(set) var has$capitalized_name$:Bool = false\n");
        }
    }
    
    
    
    
    void EnumFieldGenerator::GenerateInitializationSource(io::Printer* printer) const {}

    void EnumFieldGenerator::GenerateBuilderMembersSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "  $acontrol$var has$capitalized_name$:Bool{\n"
                       "      get {\n"
                       "          return builderResult.has$capitalized_name$\n"
                       "      }\n"
                       "  }\n"
                       "  $acontrol$var $name$:$type$ {\n"
                       "      get {\n"
                       "          return builderResult.$name$\n"
                       "      }\n"
                       "      set (value) {\n"
                       "          builderResult.has$capitalized_name$ = true\n"
                       "          builderResult.$name$ = value\n"
                       "      }\n"
                       "  }\n");
        
        printer->Print(variables_,
                       "  $acontrolFunc$ func set$capitalized_name$(value:$type$) -> $containing_class$.Builder {\n"
                       "    self.$name$ = value\n"
                       "    return self\n"
                       "  }\n"
                       "  $acontrolFunc$ func clear$capitalized_name$() -> $containing_class$.Builder {\n"
                       "     builderResult.has$capitalized_name$ = false\n"
                       "     builderResult.$name$ = .$default$\n"
                       "     return self\n"
                       "  }\n");
    }
    
    
    
    void EnumFieldGenerator::GenerateMergingCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if other.has$capitalized_name$ {\n"
                       "     $name$ = other.$name$\n"
                       "}\n");
    }
    
    
    void EnumFieldGenerator::GenerateBuildingCodeSource(io::Printer* printer) const {}
    
    void EnumFieldGenerator::GenerateParsingCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       
                       "let valueInt$name$ = try input.readEnum()\n"
                       "if let enums$name$ = $type$(rawValue:valueInt$name$){\n"
                       "     $name$ = enums$name$\n"
                       "} else {\n"
                       "     try unknownFieldsBuilder.mergeVarintField($number$, value:Int64(valueInt$name$))\n"
                       "}\n");
    }
    
    void EnumFieldGenerator::GenerateSerializationCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if has$capitalized_name$ {\n"
                       "  try output.writeEnum($number$, value:$name$.rawValue)\n"
                       "}\n");
    }
    
    
    void EnumFieldGenerator::GenerateSerializedSizeCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if (has$capitalized_name$) {\n"
                       "  serialize_size += $name$.rawValue.computeEnumSize($number$)\n"
                       "}\n");
    }
    
    
    void EnumFieldGenerator::GenerateDescriptionCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if (has$capitalized_name$) {\n"
                       "  output += \"\\(indent) $name$: \\($name$.rawValue)\\n\"\n"
                       "}\n");
    }
    
    
    void EnumFieldGenerator::GenerateIsEqualCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "(lhs.has$capitalized_name$ == rhs.has$capitalized_name$) && (!lhs.has$capitalized_name$ || lhs.$name$ == rhs.$name$)");
    }
    
    
    void EnumFieldGenerator::GenerateHashCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if has$capitalized_name$ {\n"
                       "   hashCode = (hashCode &* 31) &+ Int($name$.rawValue)\n"
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
        printer->Print(variables_,"$acontrol$var $name$:[$type$] = [$type$]()\n");
    }
    
    void RepeatedEnumFieldGenerator::GenerateVariablesSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "private var $name$MemoizedSerializedSize:Int32 = 0\n");
        printer->Print(variables_,
                       "$acontrol$private(set) var $name$:Array<$type$> = Array<$type$>()\n");
    }

    void RepeatedEnumFieldGenerator::GenerateInitializationSource(io::Printer* printer) const {
    }
    
    void RepeatedEnumFieldGenerator::GenerateMembersSource(io::Printer* printer) const {
    }
    
    void RepeatedEnumFieldGenerator::GenerateBuilderMembersSource(io::Printer* printer) const {
        
        printer->Print(variables_,
                       "$acontrol$var $name$:Array<$type$> {\n"
                       "    get {\n"
                       "        return builderResult.$name$\n"
                       "    }\n"
                       "    set (value) {\n"
                       "        builderResult.$name$ = value\n"
                       "    }\n"
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
    
    void RepeatedEnumFieldGenerator::GenerateMergingCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if !other.$name$.isEmpty {\n"
                       "   builderResult.$name$ += other.$name$\n"
                       "}\n"
                       );
    }
    
    void RepeatedEnumFieldGenerator::GenerateBuildingCodeSource(io::Printer* printer) const {
    }
    
    void RepeatedEnumFieldGenerator::GenerateParsingCodeSource(io::Printer* printer) const {
        // If packed, set up the while loop
        if (descriptor_->options().packed()) {
            printer->Print(variables_,
                           "let length:Int32 = try input.readRawVarint32()\n"
                           "let oldLimit:Int32 = try input.pushLimit(length)\n"
                           "while input.bytesUntilLimit() > 0 {\n");
            
        }
        
        printer->Print(variables_,
                       "let valueInt$name$ = try input.readEnum()\n"
                       "if let enums$name$ = $type$(rawValue:valueInt$name$) {\n"
                       "     builderResult.$name$ += [enums$name$]\n"
                       "} else {\n"
                       "     try unknownFieldsBuilder.mergeVarintField($number$, value:Int64(valueInt$name$))\n"
                       "}\n");
        
        if (descriptor_->options().packed()) {
            
            printer->Print(variables_,
                           "}\n"
                           "input.popLimit(oldLimit)\n");
        }
    }
    
    void RepeatedEnumFieldGenerator::GenerateSerializationCodeSource(io::Printer* printer) const {
        
        if (descriptor_->options().packed()) {
            printer->Print(variables_,
                           "if !$name$.isEmpty {\n"
                           "  try output.writeRawVarint32($tag$)\n"
                           "  try output.writeRawVarint32($name$MemoizedSerializedSize)\n"
                           "}\n"
                           "for oneValueOf$name$ in $name$ {\n"
                           "    try output.writeEnumNoTag(oneValueOf$name$.rawValue)\n"
                           "}\n");
        } else {
            printer->Print(variables_,
                           "for oneValueOf$name$ in $name$ {\n"
                           "    try output.writeEnum($number$, value:oneValueOf$name$.rawValue)\n"
                           "}\n");
        }
    }
    
    
    void RepeatedEnumFieldGenerator::GenerateSerializedSizeCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "var dataSize$name$:Int32 = 0\n");
        
        
        printer->Print(variables_,
                       "for oneValueOf$name$ in $name$ {\n"
                       "    dataSize$name$ += oneValueOf$name$.rawValue.computeEnumSizeNoTag()\n"
                       "}\n");
        
        printer->Print(variables_,"serialize_size += dataSize$name$\n");
        
        if (descriptor_->options().packed()) {
            
            printer->Print(variables_,
                           "if !$name$.isEmpty {\n"
                           "  serialize_size += $tag_size$\n"
                           "  serialize_size += dataSize$name$.computeRawVarint32Size()\n"
                           "}\n");
            
        } else {
            printer->Print(variables_,
                           "serialize_size += ($tag_size$ * Int32($name$.count))\n");
        }
        
        if (descriptor_->options().packed()) {
            printer->Print(variables_,
                           "$name$MemoizedSerializedSize = dataSize$name$\n");
        }
        
    }
    
    
    void RepeatedEnumFieldGenerator::GenerateDescriptionCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "var $name$ElementIndex:Int = 0\n"
                       "for oneValueOf$name$ in $name$ {\n"
                       "    output += \"\\(indent) $name$[\\($name$ElementIndex)]: \\(oneValueOf$name$.rawValue)\\n\"\n"
                       "    $name$ElementIndex++\n"
                       "}\n");
    }
    
    
    void RepeatedEnumFieldGenerator::GenerateIsEqualCodeSource(io::Printer* printer) const {
        printer->Print(variables_, "(lhs.$name$ == rhs.$name$)");
    }
    
    
    void RepeatedEnumFieldGenerator::GenerateHashCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "for oneValueOf$name$ in $name$ {\n"
                       "    hashCode = (hashCode &* 31) &+ Int(oneValueOf$name$.rawValue)\n"
                       "}\n");
    }
}  // namespace swift
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
