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
            case FieldDescriptor::TYPE_BYTES   : return "Data"  ;
            default                            : return NULL;
        }
        
        GOOGLE_LOG(FATAL) << "Can't get here.";
        return NULL;
    }
    
    
    OneofGenerator::~OneofGenerator() {
    }
    
    
    
    
    void OneofGenerator::GenerateSource(io::Printer* printer) {
        printer->Print("\n\n//OneOf declaration start\n\n");

        SourceLocation location;
        if (descriptor_->GetSourceLocation(&location)) {
            string comments = BuildCommentsString(location);
            printer->Print(comments.c_str());
        }

        string acControl = GetAccessControlType(descriptor_->containing_type()->file());

        printer->Print("$acontrol$ enum $classname$ {\n",
                       "classname", SafeName(UnderscoresToCapitalizedCamelCase(descriptor_->name())),
                       "acontrol", acControl);
        
        
        printer->Indent();
        printer->Print("case OneOf$classname$NotSet\n\n",
                       "classname",UnderscoresToCapitalizedCamelCase(descriptor_->name()));
        
        printer->Print("$acontrol$ func checkOneOfIsSet() -> Bool {\n"
                       "     switch self {\n"
                       "     case .OneOf$classname$NotSet:\n"
                       "          return false\n"
                       "     default:\n"
                       "          return true\n"
                       "     }\n"
                       "}\n",
                       "classname",UnderscoresToCapitalizedCamelCase(descriptor_->name()),
                       "name",UnderscoresToCapitalizedCamelCase(descriptor_->name()),
                      "acontrol", acControl);
        
        printer->Outdent();
        
        
        for (int i = 0; i < descriptor_->field_count(); i++) {
            
            const FieldDescriptor* fieldType = descriptor_->field(i);
            printer->Indent();
            if (GetSwiftType(fieldType) == SWIFTTYPE_MESSAGE) {
                
                string classNames = ClassNameReturedType(fieldType->message_type());
                printer->Print("case $name$($type$)\n\n",
                               "name",SafeName(UnderscoresToCapitalizedCamelCase(fieldType)),
                               "type",classNames);
                
                
                
                printer->Print("$acontrol$ ","acontrol", acControl);
                printer->Print("static func get$name$(_ value:$type$) -> $fieldType$? {\n"
                               "     switch value {\n"
                               "     case .$name$(let enumValue):\n"
                               "          return enumValue\n"
                               "     default:\n"
                               "          return nil\n"
                               "     }\n"
                               "}\n",
                               "name",SafeName(UnderscoresToCapitalizedCamelCase(fieldType)),
                               "fieldType",classNames,
                               "type",UnderscoresToCapitalizedCamelCase(descriptor_->name()));
            }
            else if (GetSwiftType(fieldType) == SWIFTTYPE_ENUM)
            {
                const FieldDescriptor* enumDesc = descriptor_->field(i);
                string type = ClassNameReturedType(enumDesc->enum_type());
                printer->Print("case $name$($type$)\n\n",
                               "name",UnderscoresToCapitalizedCamelCase(enumDesc->name()),
                               "type",type);
                
                printer->Print("$acontrol$ ","acontrol", acControl);
                printer->Print("static func get$name$(_ value:$type$) -> $fieldType$? {\n"
                               "     switch value {\n"
                               "     case .$name$(let enumValue):\n"
                               "          return enumValue\n"
                               "     default:\n"
                               "          return nil\n"
                               "     }\n"
                               "}\n",
                               "name",SafeName(UnderscoresToCapitalizedCamelCase(enumDesc->name())),
                               "fieldType",type,
                               "type",UnderscoresToCapitalizedCamelCase(descriptor_->name()));
            }
            else
            {
                printer->Print("case $name$($type$)\n\n",
                               "name",SafeName(UnderscoresToCapitalizedCamelCase(fieldType->name())),
                               "type",PrimitiveTypeName(fieldType));
                
                printer->Print("$acontrol$ ","acontrol", acControl);
                printer->Print("static func get$name$(_ value:$type$) -> $fieldType$? {\n"
                               "     switch value {\n"
                               "     case .$name$(let enumValue):\n"
                               "          return enumValue\n"
                               "     default:\n"
                               "          return nil\n"
                               "     }\n"
                               "}\n",
                               "name",SafeName(UnderscoresToCapitalizedCamelCase(fieldType->name())),
                               "fieldType",PrimitiveTypeName(fieldType),
                               "type",UnderscoresToCapitalizedCamelCase(descriptor_->name()));
            }
            printer->Outdent();
            
        }
        
        
        printer->Print("}\n");
        printer->Print("//OneOf declaration end\n\n");
        
    }
}  // namespace swift
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
