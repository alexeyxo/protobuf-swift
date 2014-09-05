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

#include "swift_extension.h"

#include <google/protobuf/descriptor.pb.h>
#include <google/protobuf/stubs/strutil.h>
#include <google/protobuf/io/printer.h>

#include "swift_extension.h"
#include "swift_helpers.h"

namespace google { namespace protobuf { namespace compiler { namespace swift {

  ExtensionGenerator::ExtensionGenerator(string classname, const FieldDescriptor* descriptor)
    : classname_(classname),
    descriptor_(descriptor) {
  }


  ExtensionGenerator::~ExtensionGenerator() {
  }


//  void ExtensionGenerator::GenerateMembersHeader(io::Printer* printer) {
//      map<string, string> vars;
//      vars["name"] = UnderscoresToCamelCase(descriptor_);
//  }


  void ExtensionGenerator::GenerateFieldsSource(io::Printer* printer) {
    map<string, string> vars;
    vars["name"] = UnderscoresToCamelCase(descriptor_);
    vars["containing_type"] = classname_;

    SwiftType java_type = GetSwiftType(descriptor_);
    string singular_type;
    switch (java_type) {
      case SWIFTTYPE_MESSAGE:
          vars["type"] = ClassName(descriptor_->message_type());
          break;
      default:
          vars["type"] = BoxedPrimitiveTypeName(java_type);
          break;
  }

    vars["extended_type"] = ClassName(descriptor_->containing_type());

    printer->Print(vars,
      "private var $containing_type$_$name$:ConcreteExtensionField<$type$,$extended_type$>\n");
  }


  void ExtensionGenerator::GenerateMembersSource(io::Printer* printer) {
    map<string, string> vars;
    vars["name"] = UnderscoresToCamelCase(descriptor_);
    vars["containing_type"] = classname_;

    printer->Print(vars,
      "var $name$:ExtensionField {\n"
      "     get {\n"
      "         return $containing_type$_$name$\n"
      "     }\n"
      "}\n");
  }

  void ExtensionGenerator::GenerateInitializationSource(io::Printer* printer) {
    map<string, string> vars;
    vars["name"] = UnderscoresToCamelCase(descriptor_);
    vars["containing_type"] = classname_;
    vars["extended_type"] = ClassName(descriptor_->containing_type());
    vars["number"] = SimpleItoa(descriptor_->number());

    const bool isPacked = descriptor_->options().packed();
    vars["is_repeated"] = descriptor_->is_repeated() ? "true" : "false";
    vars["is_packed"] = isPacked ? "true" : "false";
    vars["is_wire_format"] = descriptor_->containing_type()->options().message_set_wire_format() ? "true" : "false";

    SwiftType java_type = GetSwiftType(descriptor_);
    string singular_type;
    switch (java_type) {
    case SWIFTTYPE_MESSAGE:
      vars["type"] = ClassName(descriptor_->message_type());
      break;
    default:
      vars["type"] = BoxedPrimitiveTypeName(java_type);
      break;
    }

    switch (descriptor_->type()) {
      case FieldDescriptor::TYPE_INT32:
        vars["extension_type"] = "ExtensionType.ExtensionTypeInt32";
        break;
      case FieldDescriptor::TYPE_UINT32:
        vars["extension_type"] = "ExtensionType.ExtensionTypeUInt32";
        break;
      case FieldDescriptor::TYPE_SINT32:
        vars["extension_type"] = "ExtensionType.ExtensionTypeSInt32";
        break;
      case FieldDescriptor::TYPE_FIXED32:
        vars["extension_type"] = "ExtensionType.ExtensionTypeFixed32";
        break;
      case FieldDescriptor::TYPE_SFIXED32:
        vars["extension_type"] = "ExtensionType.ExtensionTypeSFixed32";
        break;
      case FieldDescriptor::TYPE_INT64:
        vars["extension_type"] = "ExtensionType.ExtensionTypeInt64";
        break;
      case FieldDescriptor::TYPE_UINT64:
        vars["extension_type"] = "ExtensionType.ExtensionTypeUInt64";
        break;
      case FieldDescriptor::TYPE_SINT64:
        vars["extension_type"] = "ExtensionType.ExtensionTypeSInt64";
        break;
      case FieldDescriptor::TYPE_FIXED64:
        vars["extension_type"] = "ExtensionType.ExtensionTypeFixed64";
        break;
      case FieldDescriptor::TYPE_SFIXED64:
        vars["extension_type"] = "ExtensionType.ExtensionTypeSFixed64";
        break;
      case FieldDescriptor::TYPE_FLOAT:
        vars["extension_type"] = "ExtensionType.ExtensionTypeFloat";
        break;
      case FieldDescriptor::TYPE_DOUBLE:
        vars["extension_type"] = "ExtensionType.ExtensionTypeDouble";
        break;
      case FieldDescriptor::TYPE_BOOL:
        vars["extension_type"] = "ExtensionType.ExtensionTypeBool";
        break;
      case FieldDescriptor::TYPE_STRING:
        vars["extension_type"] = "ExtensionType.ExtensionTypeString";
        break;
      case FieldDescriptor::TYPE_BYTES:
        vars["extension_type"] = "ExtensionType.ExtensionTypeBytes";
        break;
      case FieldDescriptor::TYPE_MESSAGE:
        vars["extension_type"] = "ExtensionType.ExtensionTypeMessage";
        break;
      case FieldDescriptor::TYPE_ENUM:
        vars["extension_type"] = "ExtensionType.ExtensionTypeEnum";
        break;
      case FieldDescriptor::TYPE_GROUP:
        vars["extension_type"] = "ExtensionType.ExtensionTypeGroup";
        break;
    }

    	if(descriptor_->is_repeated())
        {
			vars["default"] = string("[$type$]()");
		}
        else
        {
            vars["default"] =  DefaultValue(descriptor_);
        }



    printer->Print(
      vars,
      "$containing_type$_$name$ = ConcreteExtensionField(type:$extension_type$, fieldNumber:$number$, defaultValue:$default$, isRepeated:$is_repeated$, isPacked:$is_packed$, isMessageSetWireFormat:$is_wire_format$)\n");

  }

  void ExtensionGenerator::GenerateRegistrationSource(io::Printer* printer) {
    printer->Print(
      "registry.addExtension($scope$_$name$)\n",
      "scope", classname_,
      "name", UnderscoresToCamelCase(descriptor_));
  }
}  // namespace swift
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
