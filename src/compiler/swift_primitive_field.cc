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
        case FieldDescriptor::TYPE_BYTES   : return "[Byte]"  ;
        default                            : return NULL;
      }

      GOOGLE_LOG(FATAL) << "Can't get here.";
      return NULL;
    }


    const char* GetCapitalizedArrayValueTypeName(const FieldDescriptor* field) {
      switch (field->type()) {
        case FieldDescriptor::TYPE_INT32   : return "Int32" ;
        case FieldDescriptor::TYPE_UINT32  : return "Uint32";
        case FieldDescriptor::TYPE_SINT32  : return "Int32" ;
        case FieldDescriptor::TYPE_FIXED32 : return "Uint32";
        case FieldDescriptor::TYPE_SFIXED32: return "Int32" ;
        case FieldDescriptor::TYPE_INT64   : return "Int64" ;
        case FieldDescriptor::TYPE_UINT64  : return "Uint64";
        case FieldDescriptor::TYPE_SINT64  : return "Int64" ;
        case FieldDescriptor::TYPE_FIXED64 : return "Uint64";
        case FieldDescriptor::TYPE_SFIXED64: return "Int64" ;
        case FieldDescriptor::TYPE_FLOAT   : return "Float" ;
        case FieldDescriptor::TYPE_DOUBLE  : return "Double";
        case FieldDescriptor::TYPE_BOOL    : return "Bool"  ;
        case FieldDescriptor::TYPE_STRING  : return "Object";
        case FieldDescriptor::TYPE_BYTES   : return "Object";
        case FieldDescriptor::TYPE_ENUM    : return "Object";
        case FieldDescriptor::TYPE_GROUP   : return "Object";
        case FieldDescriptor::TYPE_MESSAGE : return "Object";
      }

      GOOGLE_LOG(FATAL) << "Can't get here.";
      return NULL;
    }

    const char* GetCapitalizedType(const FieldDescriptor* field) {
      switch (field->type()) {
        case FieldDescriptor::TYPE_INT32   : return "Int32"   ;
        case FieldDescriptor::TYPE_UINT32  : return "UInt32"  ;
        case FieldDescriptor::TYPE_SINT32  : return "SInt32"  ;
        case FieldDescriptor::TYPE_FIXED32 : return "Fixed32" ;
        case FieldDescriptor::TYPE_SFIXED32: return "SFixed32";
        case FieldDescriptor::TYPE_INT64   : return "Int64"   ;
        case FieldDescriptor::TYPE_UINT64  : return "UInt64"  ;
        case FieldDescriptor::TYPE_SINT64  : return "SInt64"  ;
        case FieldDescriptor::TYPE_FIXED64 : return "Fixed64" ;
        case FieldDescriptor::TYPE_SFIXED64: return "SFixed64";
        case FieldDescriptor::TYPE_FLOAT   : return "Float"   ;
        case FieldDescriptor::TYPE_DOUBLE  : return "Double"  ;
        case FieldDescriptor::TYPE_BOOL    : return "Bool"    ;
        case FieldDescriptor::TYPE_STRING  : return "String"  ;
        case FieldDescriptor::TYPE_BYTES   : return "Data"    ;
        case FieldDescriptor::TYPE_ENUM    : return "Enum"    ;
        case FieldDescriptor::TYPE_GROUP   : return "Group"   ;
        case FieldDescriptor::TYPE_MESSAGE : return "Message" ;
      }

      GOOGLE_LOG(FATAL) << "Can't get here.";
      return NULL;
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

      // No default because we want the compiler to complain if any new
      // types are added.
      }
      GOOGLE_LOG(FATAL) << "Can't get here.";
      return -1;
    }

    void SetPrimitiveVariables(const FieldDescriptor* descriptor,
      map<string, string>* variables) {
        std::string name = UnderscoresToCamelCase(descriptor);
        (*variables)["classname"] = ClassName(descriptor->containing_type());
        (*variables)["name"] = name;
        (*variables)["capitalized_name"] = UnderscoresToCapitalizedCamelCase(descriptor);
//        (*variables)["list_name"] = UnderscoresToCamelCase(descriptor) + "Array";
        (*variables)["number"] = SimpleItoa(descriptor->number());
        (*variables)["type"] = PrimitiveTypeName(descriptor);

//        if (IsPrimitiveType(GetSwiftType(descriptor))) {
        (*variables)["storage_type"] = PrimitiveTypeName(descriptor);
        (*variables)["storage_attribute"] = "";
//        } else {
//          (*variables)["storage_type"] = string(PrimitiveTypeName(descriptor));
//          if (IsRetainedName(name)) {
//            (*variables)["storage_attribute"] = " NS_RETURNS_NOT_RETAINED";
//          } else {
//            (*variables)["storage_attribute"] = "";
//          }
//        }


//        if(!isObjectArray(descriptor))
//        {
//        (*variables)["array_value_type"] = GetArrayValueType(descriptor);
//		(*variables)["array_value_type_name"] = GetArrayValueTypeName(descriptor);
//        (*variables)["array_value_type_name_cap"] = GetCapitalizedArrayValueTypeName(descriptor);
//	}

        (*variables)["default"] = DefaultValue(descriptor);
        (*variables)["capitalized_type"] = GetCapitalizedType(descriptor);

        (*variables)["tag"] = SimpleItoa(WireFormat::MakeTag(descriptor));
        (*variables)["tag_size"] = SimpleItoa(
          WireFormat::TagSize(descriptor->number(), descriptor->type()));

        int fixed_size = FixedSize(descriptor->type());
        if (fixed_size != -1) {
          (*variables)["fixed_size"] = SimpleItoa(fixed_size);
        }
    }
  }  // namespace


  PrimitiveFieldGenerator::PrimitiveFieldGenerator(const FieldDescriptor* descriptor)
    : descriptor_(descriptor) {
      SetPrimitiveVariables(descriptor, &variables_);
  }


  PrimitiveFieldGenerator::~PrimitiveFieldGenerator() {
  }
    void PrimitiveFieldGenerator::GenerateExtensionSource(io::Printer* printer) const {
//    if (IsReferenceType(GetSwiftType(descriptor_))) {
//        printer->Print(variables_,"@property (strong)$storage_attribute$ $storage_type$ $name$;\n");
//
//    } else {
//      printer->Print(variables_,
//        "@property $storage_type$ $name$;\n");
//    }
  }


  void PrimitiveFieldGenerator::GenerateSynthesizeSource(io::Printer* printer) const {
    printer->Print(variables_,
         "private(set) var has$capitalized_name$:Bool = false\n"
      );
      printer->Print(variables_, "private(set) var $name$:$storage_type$ = $default$\n\n");
  }



  void PrimitiveFieldGenerator::GenerateInitializationSource(io::Printer* printer) const {
  }


  void PrimitiveFieldGenerator::GenerateMembersSource(io::Printer* printer) const {
  }

  void PrimitiveFieldGenerator::GenerateBuilderMembersSource(io::Printer* printer) const {
    printer->Print(variables_,
      "var has$capitalized_name$:Bool {\n"
      "     get {\n"
      "          return result.has$capitalized_name$\n"
      "     }\n"
      "}\n"
      "var $name$:$storage_type$ {\n"
      "     get {\n"
      "          return result.$name$\n"
      "     }\n"
      "     set (value) {\n"
      "         result.has$capitalized_name$ = true\n"
      "         result.$name$ = value\n"
      "     }\n"
      "}\n"
      "func clear$capitalized_name$() -> $classname$Builder{\n"
      "     result.has$capitalized_name$ = false\n"
      "     result.$name$ = $default$\n"
      "     return self\n"
      "}\n");
  }


  void PrimitiveFieldGenerator::GenerateMergingCodeSource(io::Printer* printer) const {
    printer->Print(variables_,
      "if other.has$capitalized_name$ {\n"
      "     $name$ = other.$name$\n"
      "}\n");
  }

  void PrimitiveFieldGenerator::GenerateBuildingCodeSource(io::Printer* printer) const {
  }

  void PrimitiveFieldGenerator::GenerateParsingCodeSource(io::Printer* printer) const {
    printer->Print(variables_,
      "$name$ = input.read$capitalized_type$()\n");
  }

  void PrimitiveFieldGenerator::GenerateSerializationCodeSource(io::Printer* printer) const {
    printer->Print(variables_,
      "if has$capitalized_name$ {\n"
      "  output.write$capitalized_type$($number$, value:$name$)\n"
      "}\n");
  }

  void PrimitiveFieldGenerator::GenerateSerializedSizeCodeSource(io::Printer* printer) const {
    printer->Print(variables_,
      "if has$capitalized_name$ {\n"
      "  size += WireFormat.compute$capitalized_type$Size($number$, value:$name$)\n"
      "}\n");
  }

  void PrimitiveFieldGenerator::GenerateDescriptionCodeSource(io::Printer* printer) const {
    printer->Print(variables_,
      "if has$capitalized_name$ {\n"
      "  output += \"\\(indent) $name$: \\($name$) \\n\"\n");
    printer->Print(variables_,
      "}\n");
  }

  void PrimitiveFieldGenerator::GenerateIsEqualCodeSource(io::Printer* printer) const {
    printer->Print(variables_,
      "(lhs.has$capitalized_name$ == rhs.has$capitalized_name$) && (!lhs.has$capitalized_name$ || lhs.$name$ == rhs.$name$)");

  }

  void PrimitiveFieldGenerator::GenerateHashCodeSource(io::Printer* printer) const {
    printer->Print(variables_,
      "if has$capitalized_name$ {\n"
      "   hashCode = (hashCode &* 31) &+ $name$.hashValue\n"
      "}\n");
  }

  RepeatedPrimitiveFieldGenerator::RepeatedPrimitiveFieldGenerator(const FieldDescriptor* descriptor)
    : descriptor_(descriptor) {
      SetPrimitiveVariables(descriptor, &variables_);
  }


  RepeatedPrimitiveFieldGenerator::~RepeatedPrimitiveFieldGenerator() {
  }

  void RepeatedPrimitiveFieldGenerator::GenerateExtensionSource(io::Printer* printer) const {
//    if(isObjectArray(descriptor_))
//    {
//      printer->Print(variables_, "@property (strong) NSMutableArray * $list_name$;\n");
//    }
//    else
//    {
//      printer->Print(variables_, "@property (strong) PBAppendableArray * $list_name$;\n");
//    }

  }


  void RepeatedPrimitiveFieldGenerator::GenerateSynthesizeSource(io::Printer* printer) const {
//    printer->Print(variables_, "var $name$:[$storage_type$]\n");
  }


  void RepeatedPrimitiveFieldGenerator::GenerateInitializationSource(io::Printer* printer) const {;
  }

  void RepeatedPrimitiveFieldGenerator::GenerateMembersSource(io::Printer* printer) const {

      printer->Print(variables_, "private(set) var $name$:[$storage_type$] = [$storage_type$]()\n");
      if (descriptor_->options().packed()) {
          printer->Print(variables_,"private var $name$MemoizedSerializedSize:Int32 = -1\n");
      }
  }

  void RepeatedPrimitiveFieldGenerator::GenerateBuilderMembersSource(io::Printer* printer) const {
		printer->Print(variables_,
	      "var $name$:[$storage_type$] {\n"
          "     get {\n"
          "         return result.$name$\n"
          "     }\n"
          "     set (array) {\n"
          "         result.$name$ = array\n"
          "     }\n"
	      "}\n"
	      "func clear$capitalized_name$() -> $classname$Builder {\n"
	      "   result.$name$.removeAll(keepCapacity: false)\n"
	      "   return self\n"
	      "}\n");
  }

  void RepeatedPrimitiveFieldGenerator::GenerateMergingCodeSource(io::Printer* printer) const {
   	 printer->Print(variables_,
	      "if !other.$name$.isEmpty {\n"
	      "    result.$name$ += other.$name$\n"
	      "}\n");
  }


  void RepeatedPrimitiveFieldGenerator::GenerateBuildingCodeSource(io::Printer* printer) const {
  }


  void RepeatedPrimitiveFieldGenerator::GenerateParsingCodeSource(io::Printer* printer) const {
      if (descriptor_->options().packed())
      {
          printer->Print(variables_,
                         "var length:Int32 = input.readRawVarint32()\n"
                         "var limit:Int32 = input.pushLimit(length)\n"
                         "while (input.bytesUntilLimit() > 0) {\n"
                         "  result.$name$ += [input.read$capitalized_type$()]\n"
                         "}\n"
                         "input.popLimit(limit)\n");
      }
      else
      {
          printer->Print(variables_,
                         "$name$ += [input.read$capitalized_type$()]\n");
      }
}


  void RepeatedPrimitiveFieldGenerator::GenerateSerializationCodeSource(io::Printer* printer) const {

      printer->Print(variables_,
                     "if !$name$.isEmpty {\n");
      printer->Indent();

      if (descriptor_->options().packed()) {
        printer->Print(variables_,
          "output.writeRawVarint32($tag$)\n"
          "output.writeRawVarint32($name$MemoizedSerializedSize)\n"
          "for value in $name$ {\n"
          "  output.write$capitalized_type$NoTag(value)\n"
          "}\n");
      } else {
        printer->Print(variables_,
          "for value in $name$ {\n"
          "  output.write$capitalized_type$($number$, value:value)\n"
          "}\n");
      }
      printer->Outdent();
      printer->Print("}\n");
  }


  void RepeatedPrimitiveFieldGenerator::GenerateSerializedSizeCodeSource(io::Printer* printer) const {
    printer->Indent();
    printer->Print(variables_,
      "var dataSize$capitalized_name$:Int32 = 0\n");

      if (FixedSize(descriptor_->type()) == -1) {
          printer->Print(variables_,
                         "for element in $name$ {\n"
                         "    dataSize$capitalized_name$ += WireFormat.compute$capitalized_type$SizeNoTag(element)\n"
                         "}\n");
      } else {
        printer->Print(variables_,
          "dataSize$capitalized_name$ = $fixed_size$ * Int32($name$.count)\n");
      }

    printer->Print(variables_,"size += dataSize$capitalized_name$\n");

    if (descriptor_->options().packed()) {
      printer->Print(variables_,
        "if !$name$.isEmpty {\n"
        "  size += $tag_size$\n"
        "  size += WireFormat.computeInt32SizeNoTag(dataSize$capitalized_name$)\n"
        "}\n"
        "$name$MemoizedSerializedSize = dataSize$capitalized_name$\n");
    } else {
      printer->Print(variables_,
        "size += $tag_size$ * Int32($name$.count)\n");
    }

    printer->Outdent();
//    printer->Print("}\n");
  }


  void RepeatedPrimitiveFieldGenerator::GenerateDescriptionCodeSource(io::Printer* printer) const {

        printer->Print(variables_,
        "var $name$ElementIndex:Int = 0\n"
        "for element in $name$  {\n"
        "    output += \"\\(indent) $name$[\\($name$ElementIndex)]: \\(element)\\n\"\n"
        "    $name$ElementIndex++\n"
        "}\n");
  }


  void RepeatedPrimitiveFieldGenerator::GenerateIsEqualCodeSource(io::Printer* printer) const {
    printer->Print(variables_,
      "(lhs.$name$ == rhs.$name$)");
  }


  void RepeatedPrimitiveFieldGenerator::GenerateHashCodeSource(io::Printer* printer) const {
    if (ReturnsPrimitiveType(descriptor_)) {
      printer->Print(variables_,
      "for element in $name$ {\n"
      "    hashCode = (hashCode &* 31) &+ element.hashValue\n");
     printer->Print("}\n");

    } else {
      printer->Print(variables_,
      "for element in $name$ {\n"
      "    hashCode = (hashCode &* 31) &+ element.hashValue\n");
      printer->Print("}\n");

    }
  }
}  // namespace swift
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
