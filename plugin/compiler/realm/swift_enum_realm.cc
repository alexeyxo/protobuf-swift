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

#include "swift_enum_realm.h"

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

namespace google { namespace protobuf { namespace compiler { namespace swift {
    
    using internal::WireFormat;
    using internal::WireFormatLite;
    
    namespace {
        
        void SetMapVariables(const EnumDescriptor* descriptor, map<string, string>* variables) {
            (*variables)["acontrol"] = GetAccessControlType(descriptor->file());
            (*variables)["errorType"] = HasOptionForGenerateErrors(descriptor) ? ", Error" : "";
            (*variables)["classNameReturnedType"] = ClassNameReturedType(descriptor);
            (*variables)["classNameRealmReturned"] = ClassNameRealmReturned(descriptor);
            (*variables)["classNameRealm"] = ClassNameRealm(descriptor);
            (*variables)["fileName"] = FileClassName(descriptor->file());
            (*variables)["className"] = ClassNameReturedType(descriptor);
        }
        
    }  // namespace
    
    
    RealmEnumGenerator::RealmEnumGenerator(const EnumDescriptor* descriptor) : descriptor_(descriptor) {
        SetMapVariables(descriptor, &variables_);
    }
    
    
    RealmEnumGenerator::~RealmEnumGenerator() {
        
    }

    
    
    void RealmEnumGenerator::GenerateSource(io::Printer* printer) {
        
        printer->Print(variables_,"$acontrol$ class $classNameRealm$:Object {\n");
        XCodeStandartIndent(printer);
        printer->Print("dynamic var rawValue:String = \"\"\n");
        printer->Print(variables_, "$acontrol$ override class func primaryKey() -> String? {\n");
        XCodeStandartIndent(printer);
        printer->Print("return \"rawValue\"\n");
        XCodeStandartOutdent(printer);
        printer->Print("}\n");
        printer->Print(variables_, "$acontrol$ override class func indexedProperties() -> [String] {\n");
        XCodeStandartIndent(printer);
        printer->Print("return [\"rawValue\"]\n");
        XCodeStandartOutdent(printer);
        printer->Print("}\n");
        XCodeStandartOutdent(printer);
        printer->Print("}\n\n");
        GeneratePBToRealmExtension(printer);
    }
    void RealmEnumGenerator::GeneratePBToRealmExtension(io::Printer* printer) {
        printer->Print(variables_,"extension $classNameRealm$:ProtoEnumRealm {\n");
        XCodeStandartIndent(printer);
        printer->Print(variables_,"$acontrol$ typealias PBType = $classNameReturnedType$\n");
        printer->Print(variables_,"$acontrol$ typealias RMObject = $classNameRealm$\n");
        printer->Print(variables_,"$acontrol$ static func map(_ proto: $classNameReturnedType$) -> $classNameRealmReturned$ {\n");
        XCodeStandartIndent(printer);
        printer->Print(variables_, "let rmModel = $classNameRealm$()\n");
        printer->Print("rmModel.rawValue = proto.toString()\n");
        printer->Print("return rmModel\n");
        XCodeStandartOutdent(printer);
        printer->Print("}\n");
        GenerateRealmRepresenterExtension(printer);
        XCodeStandartOutdent(printer);
        printer->Print("}\n\n");
    }

    void RealmEnumGenerator::GenerateRealmRepresenterExtension(io::Printer* printer) {
        printer->Print(variables_,"$acontrol$ func represent() -> String {\n");
        XCodeStandartIndent(printer);
//        printer->Print("var res = [String:Any]()\n");
//        for (int i = 0; i < descriptor_->field_count(); i++) {
//            
//            const FieldDescriptor* field = descriptor_->field(i);
//            if (field->is_repeated()) {
//                switch (GetSwiftType(field)) {
//                    case SWIFT_TYPE_MESSAGE:
//                        printer->Print("if self.$name$.count > 0 {\n",
//                                       "name", UnderscoresToCamelCase(field));
//                        XCodeStandartIndent(printer);
//                        printer->Print("var sequince = [Dictionary<String,Any>]()\n");
//                        printer->Print("$name$.forEach { element in \n",
//                                       "name", UnderscoresToCamelCase(field));
//                        XCodeStandartIndent(printer);
//                        printer->Print("sequince.append(element.represent())\n");
//                        XCodeStandartOutdent(printer);
//                        printer->Print("}\n");
//                        printer->Print("res[\"$name$\"] = sequince\n",
//                                       "name", UnderscoresToCamelCase(field)
//                                       );
//                        XCodeStandartOutdent(printer);
//                        printer->Print("}\n");
//                        break;
//                    default:
//                        if (field->is_repeated()) {
//                            continue;
//                        }
//                }
//            } else {
//                switch (GetSwiftType(field)) {
//                    case SWIFT_TYPE_MESSAGE:
//                        printer->Print("if let $name$Scope = self.$name$ {\n",
//                                       "name", UnderscoresToCamelCase(field));
//                        XCodeStandartIndent(printer);
//                        printer->Print("res[\"$name$\"] = $name$Scope.represent()\n",
//                                       "name", UnderscoresToCamelCase(field)
//                                       );
//                        XCodeStandartOutdent(printer);
//                        printer->Print("}\n");
//                        break;
//                    case SWIFT_TYPE_ENUM:
//                        printer->Print("res[\"$name$\"] = self.$name$\n",
//                                       "name", UnderscoresToCamelCase(field)
//                                       );
//                        break;
//                    default:
//                        if (field->is_optional()) {
//                            printer->Print("if let $name$Scope = self.$name$$castType$ {\n",
//                                           "name", UnderscoresToCamelCase(field),
//                                           "castType", PrimitiveTypeCastingRealmRepresent(field));
//                            XCodeStandartIndent(printer);
//                            printer->Print("res[\"$name$\"] = $name$Scope\n",
//                                           "name", UnderscoresToCamelCase(field)
//                                           );
//                            XCodeStandartOutdent(printer);
//                            printer->Print("}\n");
//                        } else {
//                            printer->Print("res[\"$name$\"] = self.$name$\n",
//                                           "name", UnderscoresToCamelCase(field)
//                                           );
//                            break;
//                        }
//                }
//            }
//        }
        printer->Print("return self.rawValue\n");
        XCodeStandartOutdent(printer);
        printer->Print("}\n");
    }
    
    
}  // namespace swift
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
