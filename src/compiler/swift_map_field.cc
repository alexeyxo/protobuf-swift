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
        
        
        // For encodings with fixed sizes, returns that size in bytes.  Otherwise
        // returns -1.
//        int FixedSize(FieldDescriptor::Type type) {
//            switch (type) {
//                case FieldDescriptor::TYPE_INT32   : return -1;
//                case FieldDescriptor::TYPE_INT64   : return -1;
//                case FieldDescriptor::TYPE_UINT32  : return -1;
//                case FieldDescriptor::TYPE_UINT64  : return -1;
//                case FieldDescriptor::TYPE_SINT32  : return -1;
//                case FieldDescriptor::TYPE_SINT64  : return -1;
//                case FieldDescriptor::TYPE_FIXED32 : return WireFormatLite::kFixed32Size;
//                case FieldDescriptor::TYPE_FIXED64 : return WireFormatLite::kFixed64Size;
//                case FieldDescriptor::TYPE_SFIXED32: return WireFormatLite::kSFixed32Size;
//                case FieldDescriptor::TYPE_SFIXED64: return WireFormatLite::kSFixed64Size;
//                case FieldDescriptor::TYPE_FLOAT   : return WireFormatLite::kFloatSize;
//                case FieldDescriptor::TYPE_DOUBLE  : return WireFormatLite::kDoubleSize;
//                    
//                case FieldDescriptor::TYPE_BOOL    : return WireFormatLite::kBoolSize;
//                case FieldDescriptor::TYPE_ENUM    : return -1;
//                    
//                case FieldDescriptor::TYPE_STRING  : return -1;
//                case FieldDescriptor::TYPE_BYTES   : return -1;
//                case FieldDescriptor::TYPE_GROUP   : return -1;
//                case FieldDescriptor::TYPE_MESSAGE : return -1;
//                    
//                    // No default because we want the compiler to complain if any new
//                    // types are added.
//            }
//            GOOGLE_LOG(FATAL) << "Can't get here.";
//            return -1;
//        }
        
        void SetMapVariables(const FieldDescriptor* descriptor, map<string, string>* variables) {
            std::string name = UnderscoresToCamelCase(descriptor);
            
          
//

//
//            (*variables)["storage_type"] = MapKeyName(descriptor);
//            (*variables)["storage_attribute"] = "";
//            if (isOneOfField(descriptor)) {
//                const OneofDescriptor* oneof = descriptor->containing_oneof();
//                (*variables)["oneof_name"] = UnderscoresToCapitalizedCamelCase(oneof->name());
//                (*variables)["oneof_class_name"] = ClassNameOneof(oneof);
//            }
//            
            

//
      
            
            const FieldDescriptor* key_descriptor = descriptor->message_type()->FindFieldByName("key");
            const FieldDescriptor* value_descriptor = descriptor->message_type()->FindFieldByName("value");
            
            (*variables)["capitalized_name"] = UnderscoresToCapitalizedCamelCase(descriptor);
            (*variables)["keyType"] = MapKeyName(key_descriptor);
            (*variables)["valueType"] = MapValueName(value_descriptor);
            (*variables)["containing_class"] = ClassNameReturedType(descriptor->containing_type());
            (*variables)["capitalized_type_key"] = GetCapitalizedType(key_descriptor);
            (*variables)["capitalized_type_value"] = GetCapitalizedType(value_descriptor);
            (*variables)["name"] = name;
            (*variables)["default"] = DefaultValue(descriptor);
            (*variables)["number"] = SimpleItoa(descriptor->number());
            (*variables)["backward_class"] = ClassNameReturedType(descriptor->message_type());
//            (*variables)["containing_class"] = ClassNameReturedType(descriptor->containing_type());
            (* variables)["acontrol"] = GetAccessControlTypeForFields(descriptor->containing_type()->file());
            (* variables)["acontrolFunc"] = GetAccessControlType(descriptor->containing_type()->file());
            (* variables)["type"] =  "Dictionary<" + MapKeyName(key_descriptor) + "," + MapValueName(value_descriptor) + ">";
           
//            (*variables)["tag"] = SimpleItoa(WireFormat::MakeTag(descriptor));
//            (*variables)["tag_size"] = SimpleItoa(WireFormat::TagSize(descriptor->number(), descriptor->type()));

        }
    }  // namespace
    
    
    MapFieldGenerator::MapFieldGenerator(const FieldDescriptor* descriptor)
    : descriptor_(descriptor) {
        SetMapVariables(descriptor, &variables_);
    }
    
    MapFieldGenerator::~MapFieldGenerator() {
    }
    
    void MapFieldGenerator::GenerateSynthesizeSource(io::Printer* printer) const
    {
        printer->Print(variables_,"$acontrol$private(set) var has$capitalized_name$:Bool = false\n");
        printer->Print(variables_,"$acontrol$private(set) var $name$:$type$ = $default$\n\n");
    }
    
    void MapFieldGenerator::GenerateExtensionSource(io::Printer* printer) const {}
    void MapFieldGenerator::GenerateInitializationSource(io::Printer* printer) const {}
    void MapFieldGenerator::GenerateMembersSource(io::Printer* printer) const {}
    void MapFieldGenerator::GenerateBuilderMembersSource(io::Printer* printer) const {
        
        printer->Print(variables_,
                       "$acontrol$var has$capitalized_name$:Bool {\n"
                       "     get {\n"
                       "          return builderResult.has$capitalized_name$\n"
                       "     }\n"
                       "}\n"
                       "$acontrol$var $name$:$type$ {\n"
                       "     get {\n"
                       "          return builderResult.$name$\n"
                       "     }\n"
                       "     set (value) {\n"
                       "         builderResult.has$capitalized_name$ = true\n"
                       "         builderResult.$name$ = value\n"
                       "     }\n"
                       "}\n"
                       "$acontrol$func set$capitalized_name$(value:$type$)-> $containing_class$Builder {\n"
                       "  self.$name$ = value\n"
                       "  return self\n"
                       "}\n"
                       "$acontrolFunc$ func clear$capitalized_name$() -> $containing_class$Builder{\n"
                       "     builderResult.has$capitalized_name$ = false\n"
                       "     builderResult.$name$ = $default$\n"
                       "     return self\n"
                       "}\n");
        
    }
    
    
    void MapFieldGenerator::GenerateMergingCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if other.has$capitalized_name$ {\n"
                       "     $name$ = other.$name$\n"
                       "}\n");
    }
    
    void MapFieldGenerator::GenerateBuildingCodeSource(io::Printer* printer) const {
    }
    
    void MapFieldGenerator::GenerateParsingCodeSource(io::Printer* printer) const {

        printer->Print(variables_,
                       "var subBuilder = $backward_class$.builder()\n");
        printer->Print(variables_,
                       "input.readMessage(subBuilder,extensionRegistry:extensionRegistry)\n");
        printer->Print(variables_,
                       "let buildOf$capitalized_name$ = subBuilder.buildPartial()\n"
                       "$name$[buildOf$capitalized_name$.key] = buildOf$capitalized_name$.value\n");
    }
    
    void MapFieldGenerator::GenerateSerializationCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if has$capitalized_name$ {\n"
                       "    for (key$capitalized_name$, value$capitalized_name$) in $name$ {\n"
                       "        var valueOf$capitalized_name$ = $backward_class$.builder().setKey(key$capitalized_name$).setValue(value$capitalized_name$).build()\n"
                       "        output.writeMessage($number$, value:valueOf$capitalized_name$)\n"
                       "    }\n"
                       "}\n");
    }
    
    void MapFieldGenerator::GenerateSerializedSizeCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if has$capitalized_name$ {\n"
                       "    for (key$capitalized_name$, value$capitalized_name$) in $name$ {\n"
                       "        var valueOf$capitalized_name$ = $backward_class$.builder().setKey(key$capitalized_name$).setValue(value$capitalized_name$).build()\n"
                       "        serialize_size += valueOf$capitalized_name$.computeMessageSize($number$)\n"
                       "    }\n"
                       "}\n");
    }
    
    void MapFieldGenerator::GenerateDescriptionCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if has$capitalized_name$ {\n"
                       "  output += \"\\(indent) $name$: \\($name$) \\n\"\n"
                       "}\n");
    }
    
    void MapFieldGenerator::GenerateIsEqualCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "(lhs.has$capitalized_name$ == rhs.has$capitalized_name$) && (!lhs.has$capitalized_name$ || lhs.$name$ == rhs.$name$)");
        
    }
    
    void MapFieldGenerator::GenerateHashCodeSource(io::Printer* printer) const {
            printer->Print(variables_,
                           "if has$capitalized_name$ {\n"
                           "    for (key$capitalized_name$, value$capitalized_name$) in $name$ {\n"
                           "        hashCode = (hashCode &* 31) &+ key$capitalized_name$.hashValue\n"
                           "        hashCode = (hashCode &* 31) &+ value$capitalized_name$.hashValue\n"
                           "    }\n"
                           "}\n");
    }
    
}  // namespace swift
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
