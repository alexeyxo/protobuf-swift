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

#include "swift_primitive_field.h"

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
        
        const char* PrimitiveTypeName(const FieldDescriptor* field) {
            switch (field->type()) {
                case FieldDescriptor::TYPE_INT32   : return "Int32" ;
                case FieldDescriptor::TYPE_UINT32  : return "UInt32";
                case FieldDescriptor::TYPE_SINT32  : return "Int32" ;
                case FieldDescriptor::TYPE_FIXED32 : return "UInt32";
                case FieldDescriptor::TYPE_SFIXED32: return "Int32" ;
                    
                case FieldDescriptor::TYPE_INT64   : return "Int64" ;
                case FieldDescriptor::TYPE_UINT64  : return "UInt64";
                case FieldDescriptor::TYPE_SINT64  : return "Int64" ;
                case FieldDescriptor::TYPE_FIXED64 : return "UInt64";
                case FieldDescriptor::TYPE_SFIXED64: return "Int64" ;
                    
                case FieldDescriptor::TYPE_FLOAT   : return "Float" ;
                case FieldDescriptor::TYPE_DOUBLE  : return "Double" ;
                case FieldDescriptor::TYPE_BOOL    : return "Bool"    ;
                case FieldDescriptor::TYPE_STRING  : return "String";
                case FieldDescriptor::TYPE_BYTES   : return "Data"  ;
                default                            : return NULL;
            }
            
            GOOGLE_LOG(FATAL) << "Can't get here.";
            return NULL;
        }
        
        
        bool isNeedUseBase64(const FieldDescriptor* field) {
            switch (field->type()) {
                case FieldDescriptor::TYPE_BYTES   : return true;
                default : return false;
            }
        }
    
        
        // For encodings with fixed sizes, returns that size in bytes.  Otherwise
        // returns -1.
        int FixedSize(FieldDescriptor::Type type) {
            switch (type) {
                case FieldDescriptor::TYPE_INT32   : return -1;
                case FieldDescriptor::TYPE_INT64   : return -1;
                case FieldDescriptor::TYPE_UINT32  : return -1;
                case FieldDescriptor::TYPE_UINT64  : return -1;
                case FieldDescriptor::TYPE_SINT32  : return -1;
                case FieldDescriptor::TYPE_SINT64  : return -1;
                case FieldDescriptor::TYPE_FIXED32 : return WireFormatLite::kFixed32Size;
                case FieldDescriptor::TYPE_FIXED64 : return WireFormatLite::kFixed64Size;
                case FieldDescriptor::TYPE_SFIXED32: return WireFormatLite::kSFixed32Size;
                case FieldDescriptor::TYPE_SFIXED64: return WireFormatLite::kSFixed64Size;
                case FieldDescriptor::TYPE_FLOAT   : return WireFormatLite::kFloatSize;
                case FieldDescriptor::TYPE_DOUBLE  : return WireFormatLite::kDoubleSize;
                    
                case FieldDescriptor::TYPE_BOOL    : return WireFormatLite::kBoolSize;
                case FieldDescriptor::TYPE_ENUM    : return -1;
                    
                case FieldDescriptor::TYPE_STRING  : return -1;
                case FieldDescriptor::TYPE_BYTES   : return -1;
                case FieldDescriptor::TYPE_GROUP   : return -1;
                case FieldDescriptor::TYPE_MESSAGE : return -1;
                    
            }
            GOOGLE_LOG(FATAL) << "Can't get here.";
            return -1;
        }
        
        void SetPrimitiveVariables(const FieldDescriptor* descriptor, map<string, string>* variables) {
            std::string name = UnderscoresToCamelCase(descriptor);
            std::string capname = UnderscoresToCapitalizedCamelCase(descriptor);
            (*variables)["containing_class"] = ClassNameReturedType(descriptor->containing_type());
            
            (*variables)["name"] = name;
            (*variables)["name_reserved"] = SafeName(name);
            (*variables)["capitalized_name"] = capname;
            (*variables)["number"] = SimpleItoa(descriptor->number());
            (*variables)["type"] = PrimitiveTypeName(descriptor);
            
            //JSON
            (*variables)["json_name"] = descriptor->json_name();
            (*variables)["to_json_value"] = SafeName(ToJSONValue(descriptor, name));
            (*variables)["to_json_value_repeated_storage_type"] = ToJSONValueRepeatedStorageType(descriptor);
            (*variables)["to_json_value_repeated"] = ToJSONValue(descriptor, "oneValue" + capname);
            (*variables)["from_json_value"] = FromJSONValue(descriptor, "jsonValue" + capname);
            (*variables)["from_json_value_repeated"] = FromJSONValue(descriptor, "oneValue" + capname);
            (*variables)["json_casting_type"] = JSONCastingValue(descriptor);
            ///
            (*variables)["storage_type"] = PrimitiveTypeName(descriptor);
            (*variables)["storage_attribute"] = "";
            if (isOneOfField(descriptor)) {
                const OneofDescriptor* oneof = descriptor->containing_oneof();
                (*variables)["oneof_name"] = UnderscoresToCapitalizedCamelCase(oneof->name());
                (*variables)["oneof_class_name"] = ClassNameOneof(oneof);
            }
            
            (*variables)["default"] = DefaultValue(descriptor);
            (*variables)["capitalized_type"] = GetCapitalizedType(descriptor);
            
            (*variables)["tag"] = SimpleItoa(WireFormat::MakeTag(descriptor));
            (*variables)["tag_size"] = SimpleItoa(
                                                  WireFormat::TagSize(descriptor->number(), descriptor->type()));
            
            
            
            int fixed_size = FixedSize(descriptor->type());
            if (fixed_size != -1) {
                (*variables)["fixed_size"] = SimpleItoa(fixed_size);
            }
            (* variables)["acontrol"] = GetAccessControlTypeForFields(descriptor->containing_type()->file());
            (* variables)["acontrolFunc"] = GetAccessControlType(descriptor->containing_type()->file());

        }
    }  // namespace
    
    
    PrimitiveFieldGenerator::PrimitiveFieldGenerator(const FieldDescriptor* descriptor)
    : descriptor_(descriptor) {
        SetPrimitiveVariables(descriptor, &variables_);
    }
    
    
    
    PrimitiveFieldGenerator::~PrimitiveFieldGenerator() {
    }
    
    //TODO
    void PrimitiveFieldGenerator::GenerateExtensionSource(io::Printer* printer) const {
    }
    
    
    void PrimitiveFieldGenerator::GenerateVariablesSource(io::Printer* printer) const {
        SourceLocation location;
        if (descriptor_->GetSourceLocation(&location)) {
            string comments = BuildCommentsString(location);
            printer->Print(comments.c_str());
        }

        if (isOneOfField(descriptor_)) {
   
            printer->Print(variables_,"$acontrol$fileprivate(set) var $name_reserved$:$storage_type$!{\n"
                           "     get {\n"
                           "          return $oneof_class_name$.get$capitalized_name$(storage$oneof_name$)\n"
                           "     }\n"
                           "     set (newvalue) {\n"
                           "          storage$oneof_name$ = $oneof_class_name$.$capitalized_name$(newvalue)\n"
                           "     }\n"
                           "}\n");
            printer->Print(variables_,"$acontrol$fileprivate(set) var has$capitalized_name$:Bool {\n"
                           "      get {\n"
                           "            guard let _ = $oneof_class_name$.get$capitalized_name$(storage$oneof_name$) else {\n"
                           "                return false\n"
                           "            }\n"
                           "            return true\n"
                           "      }\n"
                           "      set(newValue) {\n"
                           "      }\n"
                           "}\n");
        }
        else
        {
            printer->Print(variables_,"$acontrol$fileprivate(set) var $name_reserved$:$storage_type$ = $default$\n");
            printer->Print(variables_,"$acontrol$fileprivate(set) var has$capitalized_name$:Bool = false\n\n");
        }
    }
    
    
    
    void PrimitiveFieldGenerator::GenerateInitializationSource(io::Printer* printer) const {
    }
    
    
    void PrimitiveFieldGenerator::GenerateMembersSource(io::Printer* printer) const {
    }
    
    void PrimitiveFieldGenerator::GenerateBuilderMembersSource(io::Printer* printer) const {
        
        printer->Print(variables_,
                       "$acontrol$var has$capitalized_name$:Bool {\n"
                       "     get {\n"
                       "          return builderResult.has$capitalized_name$\n"
                       "     }\n"
                       "}\n"
                       "$acontrol$var $name_reserved$:$storage_type$ {\n"
                       "     get {\n"
                       "          return builderResult.$name_reserved$\n"
                       "     }\n"
                       "     set (value) {\n"
                       "         builderResult.has$capitalized_name$ = true\n"
                       "         builderResult.$name_reserved$ = value\n"
                       "     }\n"
                       "}\n"
                       "@discardableResult\n"
                       "$acontrol$func set$capitalized_name$(_ value:$storage_type$) -> $containing_class$.Builder {\n"
                       "  self.$name_reserved$ = value\n"
                       "  return self\n"
                       "}\n"
                       "@discardableResult\n"
                       "$acontrolFunc$ func clear$capitalized_name$() -> $containing_class$.Builder{\n"
                       "     builderResult.has$capitalized_name$ = false\n"
                       "     builderResult.$name_reserved$ = $default$\n"
                       "     return self\n"
                       "}\n");
        
    }
    
    
    void PrimitiveFieldGenerator::GenerateMergingCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if other.has$capitalized_name$ {\n"
                       "     $name_reserved$ = other.$name_reserved$\n"
                       "}\n");
    }
    
    void PrimitiveFieldGenerator::GenerateBuildingCodeSource(io::Printer* printer) const {
    }
    
    void PrimitiveFieldGenerator::GenerateParsingCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "$name_reserved$ = try codedInputStream.read$capitalized_type$()\n");
    }
    
    void PrimitiveFieldGenerator::GenerateSerializationCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if has$capitalized_name$ {\n"
                       "  try codedOutputStream.write$capitalized_type$(fieldNumber: $number$, value:$name_reserved$)\n"
                       "}\n");
    }
    
    void PrimitiveFieldGenerator::GenerateSerializedSizeCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if has$capitalized_name$ {\n"
                       "  serialize_size += $name_reserved$.compute$capitalized_type$Size(fieldNumber: $number$)\n"
                       "}\n");
    }
    
    void PrimitiveFieldGenerator::GenerateDescriptionCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if has$capitalized_name$ {\n"
                       "  output += \"\\(indent) $name$: \\($name_reserved$) \\n\"\n");
        printer->Print(variables_,
                       "}\n");
    }
    
    void PrimitiveFieldGenerator::GenerateJSONEncodeCodeSource(io::Printer* printer) const {
            printer->Print(variables_,
                           "if has$capitalized_name$ {\n"
                           "  jsonMap[\"$json_name$\"] = $to_json_value$\n"
                           "}\n");
    }
    
    void PrimitiveFieldGenerator::GenerateJSONDecodeCodeSource(io::Printer* printer) const {
            printer->Print(variables_,
                           "if let jsonValue$capitalized_name$ = jsonMap[\"$json_name$\"] as? $json_casting_type$ {\n"
                           "  resultDecodedBuilder.$name_reserved$ = $from_json_value$\n"
                           "}\n");
    }
    
    void PrimitiveFieldGenerator::GenerateIsEqualCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "(lhs.has$capitalized_name$ == rhs.has$capitalized_name$) && (!lhs.has$capitalized_name$ || lhs.$name_reserved$ == rhs.$name_reserved$)");
        
    }
    
    void PrimitiveFieldGenerator::GenerateHashCodeSource(io::Printer* printer) const {
            printer->Print(variables_,
                           "if has$capitalized_name$ {\n"
                           "   hashCode = (hashCode &* 31) &+ $name_reserved$.hashValue\n"
                           "}\n");
    }
    
    RepeatedPrimitiveFieldGenerator::RepeatedPrimitiveFieldGenerator(const FieldDescriptor* descriptor)
    : descriptor_(descriptor) {
        SetPrimitiveVariables(descriptor, &variables_);
    }
    
    
    RepeatedPrimitiveFieldGenerator::~RepeatedPrimitiveFieldGenerator() {
    }
    
    
    //TODO
    void RepeatedPrimitiveFieldGenerator::GenerateExtensionSource(io::Printer* printer) const {
        
    }
    
    
    void RepeatedPrimitiveFieldGenerator::GenerateVariablesSource(io::Printer* printer) const {
        SourceLocation location;
        if (descriptor_->GetSourceLocation(&location)) {
            string comments = BuildCommentsString(location);
            printer->Print(comments.c_str());
        }

        printer->Print(variables_, "$acontrol$fileprivate(set) var $name_reserved$:Array<$storage_type$> = Array<$storage_type$>()\n");
        if (isPackedTypeProto3(descriptor_)) {
            printer->Print(variables_,"private var $name$MemoizedSerializedSize:Int32 = -1\n");
        }
    }
    
    void RepeatedPrimitiveFieldGenerator::GenerateInitializationSource(io::Printer* printer) const {;
    }
    
    void RepeatedPrimitiveFieldGenerator::GenerateMembersSource(io::Printer* printer) const {
        
  
    }
    
    void RepeatedPrimitiveFieldGenerator::GenerateBuilderMembersSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "$acontrol$var $name_reserved$:Array<$storage_type$> {\n"
                       "     get {\n"
                       "         return builderResult.$name_reserved$\n"
                       "     }\n"
                       "     set (array) {\n"
                       "         builderResult.$name_reserved$ = array\n"
                       "     }\n"
                       "}\n"
                       "@discardableResult\n"
                       "$acontrol$func set$capitalized_name$(_ value:Array<$storage_type$>) -> $containing_class$.Builder {\n"
                       "  self.$name_reserved$ = value\n"
                       "  return self\n"
                       "}\n"
                       "@discardableResult\n"
                       "$acontrolFunc$ func clear$capitalized_name$() -> $containing_class$.Builder {\n"
                       "   builderResult.$name_reserved$.removeAll(keepingCapacity: false)\n"
                       "   return self\n"
                       "}\n");
    }
    
    void RepeatedPrimitiveFieldGenerator::GenerateMergingCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "if !other.$name_reserved$.isEmpty {\n"
                       "    builderResult.$name_reserved$ += other.$name_reserved$\n"
                       "}\n");
    }
    
    
    void RepeatedPrimitiveFieldGenerator::GenerateBuildingCodeSource(io::Printer* printer) const {
    }
    
    
    void RepeatedPrimitiveFieldGenerator::GenerateParsingCodeSource(io::Printer* printer) const {
        
        if (isPackedTypeProto3(descriptor_)) {
            printer->Print(variables_,
                           "let length = Int(try codedInputStream.readRawVarint32())\n"
                           "let limit = try codedInputStream.pushLimit(byteLimit: length)\n"
                           "while (codedInputStream.bytesUntilLimit() > 0) {\n"
                           "  builderResult.$name_reserved$.append(try codedInputStream.read$capitalized_type$())\n"
                           "}\n"
                           "codedInputStream.popLimit(oldLimit: limit)\n");
        }
        else
        {
            printer->Print(variables_,
                           "$name_reserved$ += [try codedInputStream.read$capitalized_type$()]\n");
        }
    }
    
    
    void RepeatedPrimitiveFieldGenerator::GenerateSerializationCodeSource(io::Printer* printer) const {
        
        printer->Print(variables_,"if !$name_reserved$.isEmpty {\n");
        printer->Indent();
        
        if (isPackedTypeProto3(descriptor_)) {
            printer->Print(variables_,
                           "try codedOutputStream.writeRawVarint32(value: $tag$)\n"
                           "try codedOutputStream.writeRawVarint32(value: $name$MemoizedSerializedSize)\n"
                           "for oneValue$name$ in $name_reserved$ {\n"
                           "  try codedOutputStream.write$capitalized_type$NoTag(value: oneValue$name$)\n"
                           "}\n");
        } else {
            printer->Print(variables_,
                           "for oneValue$name$ in $name_reserved$ {\n"
                           "  try codedOutputStream.write$capitalized_type$(fieldNumber: $number$, value:oneValue$name_reserved$)\n"
                           "}\n");
        }
        printer->Outdent();
        printer->Print("}\n");
    }
    
    
    void RepeatedPrimitiveFieldGenerator::GenerateSerializedSizeCodeSource(io::Printer* printer) const {
        
        printer->Print(variables_,
                       "var dataSize$capitalized_name$:Int32 = 0\n");
        
        if (FixedSize(descriptor_->type()) == -1) {
            printer->Print(variables_,
                           "for oneValue$name$ in $name_reserved$ {\n"
                           "    dataSize$capitalized_name$ += oneValue$name$.compute$capitalized_type$SizeNoTag()\n"
                           "}\n");
        } else {
            printer->Print(variables_,
                           "dataSize$capitalized_name$ = $fixed_size$ * Int32($name_reserved$.count)\n");
        }
        
        printer->Print(variables_,"serialize_size += dataSize$capitalized_name$\n");
        
         if (isPackedTypeProto3(descriptor_)) {
            printer->Print(variables_,
                           "if !$name_reserved$.isEmpty {\n"
                           "  serialize_size += $tag_size$\n"
                           "  serialize_size += dataSize$capitalized_name$.computeInt32SizeNoTag()\n"
                           "}\n"
                           "$name_reserved$MemoizedSerializedSize = dataSize$capitalized_name$\n");
        } else {
            printer->Print(variables_,
                           "serialize_size += $tag_size$ * Int32($name_reserved$.count)\n");
        }
        
        
    }
    
    
    void RepeatedPrimitiveFieldGenerator::GenerateDescriptionCodeSource(io::Printer* printer) const {
        
        printer->Print(variables_,
                       "var $name$ElementIndex:Int = 0\n"
                       "for oneValue$capitalized_name$ in $name_reserved$  {\n"
                       "    output += \"\\(indent) $name$[\\($name$ElementIndex)]: \\(oneValue$capitalized_name$)\\n\"\n"
                       "    $name$ElementIndex += 1\n"
                       "}\n");
    }
    
    void RepeatedPrimitiveFieldGenerator::GenerateJSONEncodeCodeSource(io::Printer* printer) const {
        
        if (ToJSONValueRepeatedStorageType(descriptor_) != "") {
            printer->Print(variables_,
                           "if !$name_reserved$.isEmpty {\n"
                           "  var jsonArray$capitalized_name$:Array<$to_json_value_repeated_storage_type$> = []\n"
                           "    for oneValue$capitalized_name$ in $name_reserved$ {\n"
                           "      jsonArray$capitalized_name$.append($to_json_value_repeated$)\n"
                           "    }\n"
                           "  jsonMap[\"$json_name$\"] = jsonArray$capitalized_name$\n"
                           "}\n");
        } else {
            printer->Print(variables_,
                           "if !$name_reserved$.isEmpty {\n"
                           "  jsonMap[\"$json_name$\"] = $name_reserved$\n"
                           "}\n");
        }
    }
    
    void RepeatedPrimitiveFieldGenerator::GenerateJSONDecodeCodeSource(io::Printer* printer) const {
        
        if (ToJSONValueRepeatedStorageType(descriptor_) != "") {
            printer->Print(variables_,
                           "if let jsonValue$capitalized_name$ = jsonMap[\"$json_name$\"] as? Array<$json_casting_type$> {\n"
                           "  var jsonArray$capitalized_name$:Array<$storage_type$> = []\n"
                           "  for oneValue$capitalized_name$ in jsonValue$capitalized_name$ {\n"
                           "    jsonArray$capitalized_name$.append($from_json_value_repeated$)\n"
                           "  }\n"
                           "  resultDecodedBuilder.$name_reserved$ = jsonArray$capitalized_name$\n"
                           "}\n");
        } else {
            printer->Print(variables_,
                           "if let jsonValue$capitalized_name$ = jsonMap[\"$json_name$\"] as? Array<$json_casting_type$> {\n"
                           "  resultDecodedBuilder.$name_reserved$ = $from_json_value$\n"
                           "}\n");
        }
    }
    
    void RepeatedPrimitiveFieldGenerator::GenerateIsEqualCodeSource(io::Printer* printer) const {
        printer->Print(variables_,
                       "(lhs.$name_reserved$ == rhs.$name_reserved$)");
    }
    
    
    void RepeatedPrimitiveFieldGenerator::GenerateHashCodeSource(io::Printer* printer) const {
            printer->Print(variables_,
                           "for oneValue$capitalized_name$ in $name_reserved$ {\n"
                           "    hashCode = (hashCode &* 31) &+ oneValue$capitalized_name$.hashValue\n"
                           "}\n");
        
    }
}  // namespace swift
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
