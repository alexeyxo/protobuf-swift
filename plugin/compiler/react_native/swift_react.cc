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

#include "swift_react.h"

#include <algorithm>
#include <google/protobuf/stubs/hash.h>
#include <google/protobuf/stubs/strutil.h>
#include <google/protobuf/io/printer.h>
#include <google/protobuf/io/coded_stream.h>
#include <google/protobuf/wire_format.h>
#include <google/protobuf/wire_format_lite_inl.h>
#include <google/protobuf/descriptor.pb.h>
#include "swift_helpers_react.h"
#include "swift_helpers.h"
#include "swift_react_enums.h"
namespace google { namespace protobuf { namespace compiler { namespace swift {
    
    using internal::WireFormat;
    using internal::WireFormatLite;
    
    namespace {
        
        void SetMapVariables(const Descriptor* descriptor, std::map<string, string>* variables) {
            (*variables)["classNameReaсt"] = ClassNameReact(descriptor);
            
      
        }
        
    }  // namespace
    
    
    ReactGenerator::ReactGenerator(const Descriptor* descriptor) : descriptor_(descriptor) {
        SetMapVariables(descriptor, &variables_);
    }
    
    
    ReactGenerator::~ReactGenerator() {
        
    }

    void ReactGenerator::GenerateSourceImport(io::Printer* printer) {
        if (NeedGenerateReactType(descriptor_)) {
            printer->Print(variables_,"$classNameReaсt$");
        }
    }
    
    void ReactGenerator::GenerateSource(io::Printer* printer) {
        
        //Nested Types
        for (int i = 0; i < descriptor_->nested_type_count(); i++) {
            
            ReactGenerator(descriptor_->nested_type(i)).GenerateSource(printer);
        }
        
        for (int i = 0; i < descriptor_->enum_type_count(); i++) {
            ReactEnumGenerator(descriptor_->enum_type(i)).GenerateSource(printer);
        }
        
        printer->Print(variables_,"export class $classNameReaсt$ {\n");
        XCodeStandartIndent(printer);

        for (int i = 0; i < descriptor_->nested_type_count(); i++) {
            const Descriptor* field = descriptor_->nested_type(i);
            GenerateStaticInnerTypes(printer, field);
        }
        for (int i = 0; i < descriptor_->enum_type_count(); i++) {
            const EnumDescriptor* field = descriptor_->enum_type(i);
            GenerateStaticInnerTypes(printer, field);
        }

        GeneratePrimitiveTypes(printer);
        GenerateConstructor(printer);
        XCodeStandartOutdent(printer);
        printer->Print("}\n\n");
        
    }
    
    
    void ReactGenerator::GeneratePrimitiveTypes(io::Printer* printer) {
        for (int i = 0; i < descriptor_->field_count(); i++) {
            
            
            const FieldDescriptor* field = descriptor_->field(i);
            if (field->is_repeated()) {
                
                switch (GetSwiftType(field)) {
                    case SWIFT_TYPE_MESSAGE:
                        printer->Print("$name$:Array<$type$>\n",
                                       "name", UnderscoresToCamelCase(field),
                                       "type", ClassNameReactReturnType(field->message_type())
                                       );
                        break;
                    case SWIFT_TYPE_MAP: break;
                    case SWIFT_TYPE_ENUM:
                        printer->Print("$name$:Array<$type$>\n",
                                       "name", UnderscoresToCamelCase(field),
                                       "type", ClassNameReactReturnType(field->enum_type())
                                       );
                        break;
                    default:
                        printer->Print("$name$:Array<$type$>\n",
                                       "name", UnderscoresToCamelCase(field),
                                       "type", PrimitiveTypeReact(field)
                                       );
                }
                
            } else {
                switch (GetSwiftType(field)) {
                    case SWIFT_TYPE_MESSAGE:
                        printer->Print("$name$:$type$\n",
                                       "name", UnderscoresToCamelCase(field),
                                       "type", ClassNameReactReturnType(field->message_type())
                                       );
                        break;
                    case SWIFT_TYPE_MAP: break;
                    case SWIFT_TYPE_ENUM:
                            printer->Print("$name$:$type$\n",
                                           "name", UnderscoresToCamelCase(field),
                                           "type", ClassNameReactReturnType(field->enum_type())
                                           );
                        break;
                    default:
                            printer->Print("$name$:$type$\n",
                                           "name", UnderscoresToCamelCase(field),
                                           "type", PrimitiveTypeReact(field)
                                           );
                }

            }
            
        }
    }
    void ReactGenerator::GenerateStaticInnerTypes(io::Printer* printer, const Descriptor* field) {
        printer->Print("static $innerType$ = $type$\n",
                       "innerType", ClassName(field),
                       "type", ClassNameReact(field)
                       );
        
    }
    
    void ReactGenerator::GenerateStaticInnerTypes(io::Printer* printer, const EnumDescriptor* field) {
        printer->Print("static $innerType$ = $type$\n",
                       "innerType", ClassName(field),
                       "type", ClassNameReact(field)
                       );
        
    }
    void ReactGenerator::GenerateConstructor(io::Printer* printer) {
        printer->Print("constructor(params:Object) {\n");
        XCodeStandartIndent(printer);
        printer->Print("Object.assign(this, params)\n");
        for (int i = 0; i < descriptor_->field_count(); i++) {
            const FieldDescriptor* field = descriptor_->field(i);
            if (field->is_repeated()) {
                
                switch (GetSwiftType(field)) {
                    case SWIFT_TYPE_MESSAGE:
                        printer->Print("this.$name$ = params.$name$ && params.$name$.map(param => new $type$(param))\n",
                                       "name", UnderscoresToCamelCase(field),
                                       "type", ClassNameReactReturnType(field->message_type())
                                       );
                        break;
                    case SWIFT_TYPE_MAP: break;
                    default: continue;
                }
                
                
            } else {
                switch (GetSwiftType(field)) {
                    case SWIFT_TYPE_MESSAGE:
                        printer->Print("this.$name$ = new $type$(params.$name$)\n",
                                       "name", UnderscoresToCamelCase(field),
                                       "type", ClassNameReactReturnType(field->message_type())
                                       );
                        break;
                    case SWIFT_TYPE_MAP: break;
                    default:
                        continue;
                }
                
            }
        }
        XCodeStandartOutdent(printer);
        printer->Print("}\n");
    }
}  // namespace swift
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
