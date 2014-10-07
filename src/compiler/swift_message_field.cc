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
    void SetMessageVariables(const FieldDescriptor* descriptor,
      map<string, string>* variables) {
        std::string name = UnderscoresToCamelCase(descriptor);
        (*variables)["classname"] = ClassName(descriptor->containing_type());
        (*variables)["name"] = name;
        (*variables)["capitalized_name"] = UnderscoresToCapitalizedCamelCase(descriptor);
        (*variables)["number"] = SimpleItoa(descriptor->number());
        (*variables)["type"] = ClassName(descriptor->message_type());
        if (IsPrimitiveType(GetSwiftType(descriptor))) {
          (*variables)["storage_type"] = ClassName(descriptor->message_type());
          (*variables)["storage_attribute"] = "";
        } else {
          (*variables)["storage_type"] = string(ClassName(descriptor->message_type()));
          (*variables)["storage_attribute"] = "";
        }
        (*variables)["group_or_message"] =
          (descriptor->type() == FieldDescriptor::TYPE_GROUP) ?
          "Group" : "Message";
        
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
//
//      printer->Print(variables_,"@property (strong)$storage_attribute$ $storage_type$ $name$;\n");
  }



  void MessageFieldGenerator::GenerateSynthesizeSource(io::Printer* printer) const {
      if (isOneOfField(descriptor_)) {
          
          printer->Print(variables_,"private(set) var has$capitalized_name$:Bool {\n"
                         "      get {\n"
                         "           if $oneof_class_name$.get$capitalized_name$(storage$oneof_name$) == nil {\n"
                         "               return false\n"
                         "           }\n"
                         "           return true\n"
                         "      }\n"
                         "      set(newValue) {\n"
                         "      }\n"
                         "}\n");
          
          printer->Print(variables_,"private(set) var $name$:$type$!{\n"
                         "     get {\n"
                         "          return $oneof_class_name$.get$capitalized_name$(storage$oneof_name$)\n"
                         "     }\n"
                         "     set (newvalue) {\n"
                         "          storage$oneof_name$ = $oneof_class_name$.$capitalized_name$(newvalue)\n"
                         "     }\n"
                         "}\n");
      }
      else {
          printer->Print(variables_, "private(set) var has$capitalized_name$:Bool = false\n");
          printer->Print(variables_, "private(set) var $name$:$type$ = $type$()\n");
      }

  }

  void MessageFieldGenerator::GenerateInitializationSource(io::Printer* printer) const {
  }

  void MessageFieldGenerator::GenerateBuilderMembersSource(io::Printer* printer) const {
    printer->Print(variables_,
      "var has$capitalized_name$:Bool {\n"
      "     get {\n"
      "         return builderResult.has$capitalized_name$\n"
      "     }\n"
      "}\n"
      "var $name$:$storage_type$ {\n"
      "     get {\n"
      "         return builderResult.$name$\n"
      "     }\n"
      "     set (value) {\n"
      "         builderResult.has$capitalized_name$ = true\n"
      "         builderResult.$name$ = value\n"
      "     }\n"
      "}\n"
      "func set$capitalized_name$Builder(builderForValue:$type$Builder) -> $classname$Builder {\n"
      "  $name$ = builderForValue.build()\n"
      "  return self\n"
      "}\n"
      "func merge$capitalized_name$(value:$storage_type$) -> $classname$Builder {\n"
      "  if (builderResult.has$capitalized_name$ && builderResult.$name$ != $type$()) {\n"
      "    builderResult.$name$ = $type$.builderWithPrototype(builderResult.$name$).mergeFrom(value).buildPartial()\n"
      "  } else {\n"
      "    builderResult.$name$ = value\n"
      "  }\n"
      "  builderResult.has$capitalized_name$ = true\n"
      "  return self\n"
      "}\n"
      "func clear$capitalized_name$() -> $classname$Builder {\n"
      "  builderResult.has$capitalized_name$ = false\n"
      "  builderResult.$name$ = $type$()\n"
      "  return self\n"
      "}\n");
  }

  void MessageFieldGenerator::GenerateMergingCodeSource(io::Printer* printer) const {
    printer->Print(variables_,
      "if (other.has$capitalized_name$) {\n"
      "    merge$capitalized_name$(other.$name$)\n"
      "}\n");
  }



  void MessageFieldGenerator::GenerateBuildingCodeSource(io::Printer* printer) const {
  }

  void MessageFieldGenerator::GenerateParsingCodeSource(io::Printer* printer) const {
    printer->Print(variables_,
      "var subBuilder:$type$Builder = $type$.builder()\n"
      "if has$capitalized_name$ {\n"
      "  subBuilder.mergeFrom($name$)\n"
      "}\n");

    if (descriptor_->type() == FieldDescriptor::TYPE_GROUP) {
      printer->Print(variables_,
        "input.readGroup($number$, builder:subBuilder, extensionRegistry:extensionRegistry)\n");
    } else {
      printer->Print(variables_,
        "input.readMessage(subBuilder, extensionRegistry:extensionRegistry)\n");
    }

    printer->Print(variables_,
      "$name$ = subBuilder.buildPartial()\n");
  }


  void MessageFieldGenerator::GenerateSerializationCodeSource(io::Printer* printer) const {
    printer->Print(variables_,
      "if has$capitalized_name$ {\n"
      "  output.write$group_or_message$($number$, value:$name$)\n"
      "}\n");
  }


  void MessageFieldGenerator::GenerateSerializedSizeCodeSource(io::Printer* printer) const {
    printer->Print(variables_,
      "if has$capitalized_name$ {\n"
      "  size += WireFormat.compute$group_or_message$Size($number$, value:$name$)\n"
      "}\n");
  }


  void MessageFieldGenerator::GenerateDescriptionCodeSource(io::Printer* printer) const {
    printer->Print(variables_,
      "if has$capitalized_name$ {\n"
      "  output += \"\\(indent) $name$ {\\n\"\n"
      "  $name$.writeDescriptionTo(&output, indent:\"\\(indent)  \")\n"
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
      "  hashCode = (hashCode &* 31) &+ $name$.hashValue\n"
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
//       	if(isObjectArray(descriptor_))
//        {
//
//            printer->Print(variables_,
//      			"@property (strong) NSMutableArray * $list_name$;\n");
//
//        }
//        else
//        {
//			printer->Print(variables_,
//		      "@property (strong) PBAppendableArray * $list_name$;\n");
//
//        }

  }


  void RepeatedMessageFieldGenerator::GenerateSynthesizeSource(io::Printer* printer) const {

  }


  void RepeatedMessageFieldGenerator::GenerateInitializationSource(io::Printer* printer) const {
//      printer->Print(variables_, "$name$ = [$storage_type$]()\n");
  }



  void RepeatedMessageFieldGenerator::GenerateMembersSource(io::Printer* printer) const {

          printer->Print(variables_, "private(set) var $name$:Array<$storage_type$>  = Array<$storage_type$>()\n");
  }


  void RepeatedMessageFieldGenerator::GenerateBuilderMembersSource(io::Printer* printer) const {
    printer->Print(variables_,
      "var $name$:Array<$storage_type$> {\n"
      "     get {\n"
      "         return builderResult.$name$\n"
      "     }\n"
      "     set (value) {\n"
      "         builderResult.$name$ = value\n"
      "     }\n"
      "}\n"
      "func clear$capitalized_name$() -> $classname$Builder {\n"
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
      "var subBuilder = $type$.builder()\n");

    if (descriptor_->type() == FieldDescriptor::TYPE_GROUP) {
      printer->Print(variables_,
        "input.readGroup($number$,builder:subBuilder,extensionRegistry:extensionRegistry)\n");
    } else {
      printer->Print(variables_,
        "input.readMessage(subBuilder,extensionRegistry:extensionRegistry)\n");
    }

    printer->Print(variables_,
        "$name$ += [subBuilder.buildPartial()]\n");
  }

  void RepeatedMessageFieldGenerator::GenerateSerializationCodeSource(io::Printer* printer) const {
    printer->Print(variables_,
    "for element in $name$ {\n"
    "    output.write$group_or_message$($number$, value:element)\n"
    "}\n");
  }

  void RepeatedMessageFieldGenerator::GenerateSerializedSizeCodeSource(io::Printer* printer) const {
    printer->Print(variables_,
    "for element in $name$ {\n"
    "    size += WireFormat.compute$group_or_message$Size($number$, value:element)\n"
    "}\n");
  }

  void RepeatedMessageFieldGenerator::GenerateDescriptionCodeSource(io::Printer* printer) const {
    printer->Print(variables_,
    "var $name$ElementIndex:Int = 0\n"
    "for element in $name$ {\n"
    "    output += \"\\(indent) $name$[\\($name$ElementIndex)] {\\n\"\n"
    "    element.writeDescriptionTo(&output, indent:\"\\(indent)  \")\n"
    "    output += \"\\(indent)}\\n\"\n"
    "    $name$ElementIndex++\n"
    "}\n");
  }

  void RepeatedMessageFieldGenerator::GenerateIsEqualCodeSource(io::Printer* printer) const {
    printer->Print(variables_, "(lhs.$name$ == rhs.$name$)");
  }

  void RepeatedMessageFieldGenerator::GenerateHashCodeSource(io::Printer* printer) const {
    printer->Print(variables_,
    "for element in $name$ {\n"
    "    hashCode = (hashCode &* 31) &+ element.hashValue\n"
    "}\n");
  }

  string RepeatedMessageFieldGenerator::GetBoxedType() const {
    return ClassName(descriptor_->message_type());
  }
}  // namespace swift
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
