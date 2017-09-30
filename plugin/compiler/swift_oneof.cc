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
        
        
        XCodeStandartIndent(printer);
        printer->Print("case oneOf$classname$NotSet\n\n",
                       "classname",UnderscoresToCapitalizedCamelCase(descriptor_->name()));
        
        printer->Print("$acontrol$ func checkOneOfIsSet() -> Bool {\n"
                       "    switch self {\n"
                       "    case .oneOf$classname$NotSet: return false\n"
                       "    default: return true\n"
                       "    }\n"
                       "}\n",
                       "classname",UnderscoresToCapitalizedCamelCase(descriptor_->name()),
                       "name",UnderscoresToCapitalizedCamelCase(descriptor_->name()),
                      "acontrol", acControl);
        
        XCodeStandartOutdent(printer);
        
        
        for (int i = 0; i < descriptor_->field_count(); i++) {
            
            const FieldDescriptor* fieldType = descriptor_->field(i);
            XCodeStandartIndent(printer);
            if (GetSwiftType(fieldType) == SWIFT_TYPE_MESSAGE) {
                
                string classNames = ClassNameReturedType(fieldType->message_type());
                printer->Print("case $name$($type$)\n\n",
                               "name",SafeName(UnderscoresToCamelCase(fieldType)),
                               "type",classNames);
                
                
                
                printer->Print("$acontrol$ ","acontrol", acControl);
                printer->Print("static func get$camelCaseName$(_ value:$type$) -> $fieldType$? {\n"
                               "    switch value {\n"
                               "    case .$name$(let messageValue): return messageValue\n"
                               "    default: return nil\n"
                               "    }\n"
                               "}\n",
                               "name",SafeName(UnderscoresToCamelCase(fieldType)),
                               "camelCaseName",SafeName(UnderscoresToCapitalizedCamelCase(fieldType)),
                               "fieldType",classNames,
                               "type",UnderscoresToCapitalizedCamelCase(descriptor_->name()));
                printer->Print("$acontrol$ ","acontrol", acControl);
                printer->Print("func get$camelCaseName$() -> $fieldType$? {\n"
                               "    switch self {\n"
                               "    case .$name$(let messageValue): return messageValue\n"
                               "    default: return nil\n"
                               "    }\n"
                               "}\n",
                               "name",SafeName(UnderscoresToCamelCase(fieldType)),
                               "camelCaseName",SafeName(UnderscoresToCapitalizedCamelCase(fieldType)),
                               "fieldType",classNames,
                               "type",UnderscoresToCapitalizedCamelCase(descriptor_->name()));
            }
            else if (GetSwiftType(fieldType) == SWIFT_TYPE_ENUM)
            {
                const FieldDescriptor* enumDesc = descriptor_->field(i);
                string type = ClassNameReturedType(enumDesc->enum_type());
                printer->Print("case $name$($type$)\n\n",
                               "name",UnderscoresToCamelCase(enumDesc),
                               "type",type);
                
                printer->Print("$acontrol$ ","acontrol", acControl);
                printer->Print("static func get$camelCaseName$(_ value:$type$) -> $fieldType$? {\n"
                               "    switch value {\n"
                               "    case .$name$(let enumValue): return enumValue\n"
                               "    default: return nil\n"
                               "    }\n"
                               "}\n",
                               "name",SafeName(UnderscoresToCamelCase(enumDesc)),
                               "camelCaseName",SafeName(UnderscoresToCapitalizedCamelCase(fieldType)),
                               "fieldType",type,
                               "type",UnderscoresToCapitalizedCamelCase(descriptor_->name()));
                printer->Print("$acontrol$ ","acontrol", acControl);
                printer->Print("func get$camelCaseName$() -> $fieldType$? {\n"
                               "    switch self {\n"
                               "    case .$name$(let enumValue): return enumValue\n"
                               "    default: return nil\n"
                               "    }\n"
                               "}\n",
                               "name",SafeName(UnderscoresToCamelCase(enumDesc)),
                               "camelCaseName",SafeName(UnderscoresToCapitalizedCamelCase(fieldType)),
                               "fieldType",type,
                               "type",UnderscoresToCapitalizedCamelCase(descriptor_->name()));
            }
            else
            {
                printer->Print("case $name$($type$)\n\n",
                               "name",SafeName(UnderscoresToCamelCase(fieldType)),
                               "type",PrimitiveTypeName(fieldType));
                
                printer->Print("$acontrol$ ","acontrol", acControl);
                printer->Print("static func get$camelCaseName$(_ value:$type$) -> $fieldType$? {\n"
                               "    switch value {\n"
                               "    case .$name$(let otherValue): return otherValue\n"
                               "    default: return nil\n"
                               "    }\n"
                               "}\n",
                               "name",SafeName(UnderscoresToCamelCase(fieldType)),
                               "camelCaseName",SafeName(UnderscoresToCapitalizedCamelCase(fieldType)),
                               "fieldType",PrimitiveTypeName(fieldType),
                               "type",UnderscoresToCapitalizedCamelCase(descriptor_->name()));
                printer->Print("$acontrol$ ","acontrol", acControl);
                printer->Print("func get$camelCaseName$() -> $fieldType$? {\n"
                               "    switch self {\n"
                               "    case .$name$(let otherValue): return otherValue\n"
                               "    default: return nil\n"
                               "    }\n"
                               "}\n",
                               "name",SafeName(UnderscoresToCamelCase(fieldType)),
                               "camelCaseName",SafeName(UnderscoresToCapitalizedCamelCase(fieldType)),
                               "fieldType",PrimitiveTypeName(fieldType),
                               "type",UnderscoresToCapitalizedCamelCase(descriptor_->name()));
            }
            XCodeStandartOutdent(printer);
            
        }
        
        
        printer->Print("}\n");
        printer->Print("//OneOf declaration end\n\n");
        
    }
}  // namespace swift
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
