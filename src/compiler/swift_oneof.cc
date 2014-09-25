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

#include "swift_oneof.h"

#include <map>
#include <string>

#include <google/protobuf/io/printer.h>
#include <google/protobuf/descriptor.pb.h>
#include <google/protobuf/stubs/strutil.h>

#include "swift_helpers.h"

namespace google { namespace protobuf { namespace compiler { namespace swift {

  OneofGenerator::OneofGenerator(const OneofDescriptor* descriptor)
    : descriptor_(descriptor) {
  }
    
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


  OneofGenerator::~OneofGenerator() {
  }




  void OneofGenerator::GenerateSource(io::Printer* printer) {
      printer->Print("\n\n//OneOf declaration start\n\n");
      
      printer->Print("enum $classname$ {\n",
                     "classname",UnderscoresToCapitalizedCamelCase(descriptor_->name()));
      
      
      printer->Indent();
      printer->Print("case $classname$NotSet(ONEOF_NOT_SET)\n\n",
                     "classname",UnderscoresToCapitalizedCamelCase(descriptor_->name()));
      
      printer->Print("static func check$name$Set(value:$name$) -> Bool {\n"
                     "     switch value {\n"
                     "     case .$name$NotSet(let enumValue):\n"
                     "          return true\n"
                     "     default:\n"
                     "          return false\n"
                     "     }\n"
                     "}\n",
                     "name",UnderscoresToCapitalizedCamelCase(descriptor_->name()));
     printer->Outdent();
      for (int i = 0; i < descriptor_->field_count(); i++) {
          
          const FieldDescriptor* fieldType = descriptor_->field(i);
          printer->Indent();
          if (GetSwiftType(fieldType) == SWIFTTYPE_MESSAGE) {
              
              printer->Print("case $name$($type$)\n\n",
                             "name",UnderscoresToCapitalizedCamelCase(fieldType->name()),
                             "type",ClassName(fieldType->message_type()));
              
              printer->Print("static func get$name$(value:$type$) ->$fieldType$? {\n"
                             "     switch value {\n"
                             "     case .$name$(let enumValue):\n"
                             "          return enumValue\n"
                             "     default:\n"
                             "          return nil\n"
                             "     }\n"
                             "}\n",
                             "name",UnderscoresToCapitalizedCamelCase(fieldType->name()),
                             "fieldType",ClassName(fieldType->message_type()),
                             "type",UnderscoresToCapitalizedCamelCase(descriptor_->name()));
          }
          else
          {
              printer->Print("case $name$($type$)\n\n",
                             "name",UnderscoresToCapitalizedCamelCase(fieldType->name()),
                             "type",PrimitiveTypeName(fieldType));
              
              printer->Print("static func get$name$(value:$type$) ->$fieldType$? {\n"
                             "     switch value {\n"
                             "     case .$name$(let enumValue):\n"
                             "          return enumValue\n"
                             "     default:\n"
                             "          return nil\n"
                             "     }\n"
                             "}\n",
                             "name",UnderscoresToCapitalizedCamelCase(fieldType->name()),
                             "fieldType",PrimitiveTypeName(fieldType),
                             "type",UnderscoresToCapitalizedCamelCase(descriptor_->name()));
          }
          printer->Outdent();
      
      }
      
      
      printer->Print("}\n");
      
      printer->Print("\n");
      printer->Print("\n\n//OneOf declaration end\n\n");
     
  }
}  // namespace swift
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
