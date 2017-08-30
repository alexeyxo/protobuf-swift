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

#include "swift_message_realm.h"

#include <algorithm>
#include <google/protobuf/stubs/hash.h>
#include <google/protobuf/stubs/strutil.h>
#include <google/protobuf/io/printer.h>
#include <google/protobuf/io/coded_stream.h>
#include <google/protobuf/wire_format.h>
#include <google/protobuf/wire_format_lite_inl.h>
#include <google/protobuf/descriptor.pb.h>
#include "swift_helpers_realm.h"
#include "swift_helpers.h"
#include "swift_enum_realm.h"

namespace google { namespace protobuf { namespace compiler { namespace swift {
    
    using internal::WireFormat;
    using internal::WireFormatLite;
    
    namespace {
        
        void SetMapVariables(const Descriptor* descriptor, std::map<string, string>* variables) {
            (*variables)["acontrol"] = GetAccessControlType(descriptor->file());
            (*variables)["errorType"] = HasOptionForGenerateErrors(descriptor) ? ", Error" : "";
            (*variables)["classNameReturnedType"] = ClassNameReturedType(descriptor);
            (*variables)["classNameRealmReturned"] = ClassNameRealmReturned(descriptor);
            (*variables)["classNameRealm"] = ClassNameRealm(descriptor);
            (*variables)["fileName"] = FileClassName(descriptor->file());
        }
        
    }  // namespace
    
    
    RealmMessageGenerator::RealmMessageGenerator(const Descriptor* descriptor) : descriptor_(descriptor) {
        SetMapVariables(descriptor, &variables_);
    }
    
    
    RealmMessageGenerator::~RealmMessageGenerator() {
        
    }

    
    
    void RealmMessageGenerator::GenerateSource(io::Printer* printer) {
        
        for (int i = 0; i < descriptor_->enum_type_count(); i++) {
            const EnumDescriptor* desc = descriptor_->enum_type(i);
            RealmEnumGenerator(desc).GenerateSource(printer);
        }
        
        printer->Print(variables_,"$acontrol$ class $classNameRealm$:Object {\n");
        XCodeStandartIndent(printer);
        for (int i = 0; i < descriptor_->nested_type_count(); i++) {
            const Descriptor* field = descriptor_->nested_type(i);
            GenerateStaticInnerTypes(printer, field);
        }
        for (int i = 0; i < descriptor_->enum_type_count(); i++) {
            const EnumDescriptor* desc = descriptor_->enum_type(i);
            GenerateStaticInnerTypes(printer, desc);
        }
        GeneratePrimaryKey(printer);
        GenerateIndexedProperties(printer);
        GeneratePrimitiveTypes(printer);
        XCodeStandartOutdent(printer);
        printer->Print("}\n\n");
        
        //Nested Types
        for (int i = 0; i < descriptor_->nested_type_count(); i++) {
            RealmMessageGenerator(descriptor_->nested_type(i)).GenerateSource(printer);
        }
        GeneratePBToRealmExtension(printer);
        
    }
    
    void RealmMessageGenerator::GeneratePrimitiveTypes(io::Printer* printer) {
        for (int i = 0; i < descriptor_->field_count(); i++) {
            
            
            const FieldDescriptor* field = descriptor_->field(i);
            if (field->is_repeated()) {
                
                switch (GetSwiftType(field)) {
                    case SWIFT_TYPE_MESSAGE:
                        printer->Print("let $name$:List<$type$> = List<$type$>()\n",
                                       "name", UnderscoresToCamelCase(field),
                                       "type", ClassNameRealmReturned(field->message_type())
                                       );
                        break;
                    case SWIFT_TYPE_ENUM:
                        printer->Print("let $name$:List<$type$> = List<$type$>()\n",
                                       "name", UnderscoresToCamelCase(field),
                                       "type", ClassNameRealm(field->enum_type())
                                       );
                    default:
                        continue;
                }

                
            } else {
                switch (GetSwiftType(field)) {
                    case SWIFT_TYPE_MESSAGE:
                        printer->Print("dynamic var $name$:$type$?\n",
                                       "name", UnderscoresToCamelCase(field),
                                       "type", ClassNameRealmReturned(field->message_type())
                                       );
                        break;
                    case SWIFT_TYPE_ENUM:
//                        if (field->has_default_value()) {
                        
                            printer->Print("dynamic var $name$:$type$?\n",
                                           "name", UnderscoresToCamelCase(field),
                                           "type", ClassNameRealm(field->enum_type())
                                           );
//                        } else {
//                            printer->Print("dynamic var $name$:$type$ = $type$(rawValue:.$default$)\n",
//                                           "name", UnderscoresToCamelCase(field),
//                                           "default", DefaultValueRealm(field),
//                                           "type", ClassNameRealm(field->enum_type())
//                                           );
//                        }
                        break;
                    default:
                        if (field->is_required()) {
                            printer->Print("dynamic var $name$:$type$ = $default$\n",
                                           "name", UnderscoresToCamelCase(field),
                                           "type", PrimitiveTypeRealm(field),
                                           "default", DefaultValueRealm(field)
                                           );
                        } else {
                            printer->Print("$primitiveTypeRealmOptional$\n",
                                           "primitiveTypeRealmOptional",
                                           PrimitiveTypeRealmOptionalVariable(field));
                        }
                }

            }
            
        }
    }
    
    void RealmMessageGenerator::GenerateStaticInnerTypes(io::Printer* printer, const Descriptor* field) {
        printer->Print(variables_, "$acontrol$ ");
        printer->Print("typealias $innerType$ = $type$\n",
                       "innerType", ClassName(field),
                       "type",  ClassNameRealm(field)
                       );
        
    }
    
    void RealmMessageGenerator::GenerateStaticInnerTypes(io::Printer* printer, const EnumDescriptor* field) {
        printer->Print(variables_, "$acontrol$ ");
        printer->Print("typealias $innerType$ = $type$\n",
                       "innerType", ClassName(field),
                       "type",  ClassNameRealm(field)
                       );
        
    }
    
    void RealmMessageGenerator::GeneratePrimaryKey(io::Printer* printer) {
        if (RealmPrimaryKey(descriptor_) != "") {
            printer->Print(variables_, "$acontrol$ override class func primaryKey() -> String? {\n");
            XCodeStandartIndent(printer);
            printer->Print("return \"$primaryKey$\"\n",
                           "primaryKey",
                           RealmPrimaryKey(descriptor_)
                           );
            XCodeStandartOutdent(printer);
            printer->Print("}\n");
        }
    }
    void RealmMessageGenerator::GenerateIndexedProperties(io::Printer* printer) {
        if (RealmIndexedPropertie(descriptor_) != "") {
            printer->Print(variables_, "$acontrol$ override class func indexedProperties() -> [String] {\n");
            XCodeStandartIndent(printer);
            printer->Print("return [$indexedProperties$]\n",
                           "indexedProperties",
                           RealmIndexedPropertie(descriptor_)
                           );
            XCodeStandartOutdent(printer);
            printer->Print("}\n");
        }
    }
    void RealmMessageGenerator::GeneratePBToRealmExtension(io::Printer* printer) {
        printer->Print(variables_,"extension $classNameRealm$:ProtoRealm {\n");
        XCodeStandartIndent(printer);
        printer->Print(variables_,"$acontrol$ typealias PBType = $classNameReturnedType$\n");
        printer->Print(variables_,"$acontrol$ typealias RMObject = $classNameRealm$\n");
        printer->Print(variables_,"$acontrol$ static func map(_ proto: $classNameReturnedType$) -> $classNameRealmReturned$ {\n");
        XCodeStandartIndent(printer);
        printer->Print(variables_, "let rmModel = $classNameRealm$()\n");
        for (int i = 0; i < descriptor_->field_count(); i++) {
            const FieldDescriptor* field = descriptor_->field(i);
            switch (GetSwiftType(field)) {
                case SWIFT_TYPE_MESSAGE:
                    if (!field->is_repeated()) {
                        printer->Print("if proto.$name$ != nil {\n",
                                       "name",UnderscoresToCamelCase(field));
                        XCodeStandartIndent(printer);
                        printer->Print("rmModel.$name$ = $rmType$.map(proto.$name$)\n",
                                       "name", UnderscoresToCamelCase(field),
                                       "rmType", ClassNameRealm(field->message_type())
                                       );
                    } else {
                        printer->Print("rmModel.$name$.append(objectsIn:$rmType$.map(proto.$name$))\n",
                                       "name", UnderscoresToCamelCase(field),
                                       "rmType", ClassNameRealm(field->message_type())
                                       );
                    }
                    
                    if (!field->is_repeated()) {
                        XCodeStandartOutdent(printer);
                        printer->Print("}\n");
                    }
                    break;
                case SWIFT_TYPE_ENUM:
                    if (!field->is_repeated()) {
//                        printer->Print("if proto.$name$ != nil {\n",
//                                       "name",UnderscoresToCamelCase(field));
//                        XCodeStandartIndent(printer);
                        printer->Print("rmModel.$name$ = $rmType$.map(proto.$name$)\n",
                                       "name", UnderscoresToCamelCase(field),
                                       "rmType", ClassNameRealm(field->enum_type())
                                       );
                    } else {
                        printer->Print("rmModel.$name$.append(objectsIn:$rmType$.map(proto.$name$))\n",
                                       "name", UnderscoresToCamelCase(field),
                                       "rmType", ClassNameRealm(field->enum_type())
                                       );
                    }
//                    if (!field->is_repeated()) {
//                        XCodeStandartOutdent(printer);
//                        printer->Print("}\n");
//                    }
                    break;
                    break;
                default:
                    if (field->is_repeated()) {
                        continue;
                    }
                    printer->Print("if proto.$name$ != nil {\n",
                                   "name",
                                   UnderscoresToCamelCase(field));
                    XCodeStandartIndent(printer);
                    string castType = PrimitiveTypeCastingRealm(field);
                    printer->Print("rmModel.$name$$castType$\n",
                                       "castType", castType,
                                       "name", UnderscoresToCamelCase(field)
                                       );
                    XCodeStandartOutdent(printer);
                    printer->Print("}\n");
                    
            }
        }
        printer->Print("return rmModel\n");
        XCodeStandartOutdent(printer);
        printer->Print("}\n");
        GenerateRealmRepresenterExtension(printer);
        XCodeStandartOutdent(printer);
        printer->Print("}\n\n");
    }
    
    void RealmMessageGenerator::GenerateRealmRepresenterExtension(io::Printer* printer) {
        printer->Print(variables_,"$acontrol$ func represent() -> [String:Any] {\n");
        XCodeStandartIndent(printer);
        printer->Print("var res = [String:Any]()\n");
        for (int i = 0; i < descriptor_->field_count(); i++) {
            
            const FieldDescriptor* field = descriptor_->field(i);
            if (field->is_repeated()) {
                switch (GetSwiftType(field)) {
                    case SWIFT_TYPE_MESSAGE:
                        printer->Print("if self.$name$.count > 0 {\n",
                                       "name", UnderscoresToCamelCase(field));
                        XCodeStandartIndent(printer);
                        printer->Print("var sequince = [Dictionary<String,Any>]()\n");
                        printer->Print("$name$.forEach { element in \n",
                                       "name", UnderscoresToCamelCase(field));
                        XCodeStandartIndent(printer);
                        printer->Print("sequince.append(element.represent())\n");
                        XCodeStandartOutdent(printer);
                        printer->Print("}\n");
                        printer->Print("res[\"$name$\"] = sequince\n",
                                       "name", UnderscoresToCamelCase(field)
                                       );
                        XCodeStandartOutdent(printer);
                        printer->Print("}\n");
                        break;
                    case SWIFT_TYPE_ENUM:
                        printer->Print("if self.$name$.count > 0 {\n",
                                       "name", UnderscoresToCamelCase(field));
                        XCodeStandartIndent(printer);
                        printer->Print("var sequince = [String]()\n");
                        printer->Print("$name$.forEach { element in \n",
                                       "name", UnderscoresToCamelCase(field));
                        XCodeStandartIndent(printer);
                        printer->Print("sequince.append(element.represent())\n");
                        XCodeStandartOutdent(printer);
                        printer->Print("}\n");
                        printer->Print("res[\"$name$\"] = sequince\n",
                                       "name", UnderscoresToCamelCase(field)
                                       );
                        XCodeStandartOutdent(printer);
                        printer->Print("}\n");
                        break;
                    default:
                        if (field->is_repeated()) {
                            continue;
                        }
                }
            } else {
                switch (GetSwiftType(field)) {
                    case SWIFT_TYPE_MESSAGE:
                        printer->Print("if let $name$Scope = self.$name$ {\n",
                                       "name", UnderscoresToCamelCase(field));
                        XCodeStandartIndent(printer);
                        printer->Print("res[\"$name$\"] = $name$Scope.represent()\n",
                                       "name", UnderscoresToCamelCase(field)
                                       );
                        XCodeStandartOutdent(printer);
                        printer->Print("}\n");
                        break;
                    case SWIFT_TYPE_ENUM:
                        
                        printer->Print("if let $name$Scope = self.$name$ {\n",
                                       "name", UnderscoresToCamelCase(field));
                        XCodeStandartIndent(printer);
                        printer->Print("res[\"$name$\"] = $name$Scope.represent()\n",
                                       "name", UnderscoresToCamelCase(field)
                                       );
                        XCodeStandartOutdent(printer);
                        printer->Print("}\n");
                        
                        break;
                    default:
                        if (field->is_optional()) {
                            printer->Print("if let $name$Scope = self.$name$$castType$ {\n",
                                           "name", UnderscoresToCamelCase(field),
                                           "castType", PrimitiveTypeCastingRealmRepresent(field));
                            XCodeStandartIndent(printer);
                            printer->Print("res[\"$name$\"] = $name$Scope\n",
                                           "name", UnderscoresToCamelCase(field)
                                           );
                            XCodeStandartOutdent(printer);
                            printer->Print("}\n");
                        } else {
                            printer->Print("res[\"$name$\"] = self.$name$\n",
                                           "name", UnderscoresToCamelCase(field)
                                           );
                            break;
                        }
                }
            }
        }
        printer->Print("return res\n");
        XCodeStandartOutdent(printer);
        printer->Print("}\n");
    }
    
    
}  // namespace swift
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
