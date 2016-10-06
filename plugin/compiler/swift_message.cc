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

#include "swift_message.h"

#include <algorithm>
#include <google/protobuf/stubs/hash.h>
#include <google/protobuf/stubs/strutil.h>
#include <google/protobuf/io/printer.h>
#include <google/protobuf/io/coded_stream.h>
#include <google/protobuf/wire_format.h>
#include <google/protobuf/wire_format_lite_inl.h>
#include <google/protobuf/descriptor.pb.h>

#include "swift_enum.h"
#include "swift_extension.h"
#include "swift_helpers.h"
#include "swift_oneof.h"

namespace google { namespace protobuf { namespace compiler { namespace swift {
    
    using internal::WireFormat;
    using internal::WireFormatLite;
    
    namespace {
        
        void SetMapVariables(const Descriptor* descriptor, map<string, string>* variables) {
            (*variables)["acontrol"] = GetAccessControlType(descriptor->file());
            (*variables)["className"] =  ClassName(descriptor);
            (*variables)["errorType"] = HasOptionForGenerateErrors(descriptor) ? ", Error" : "";
            (*variables)["classNameReturnedType"] = ClassNameReturedType(descriptor);
            (*variables)["fileName"] = FileClassName(descriptor->file());
        }
        
        struct FieldOrderingByNumber {
            inline bool operator()(const FieldDescriptor* a,
                                   const FieldDescriptor* b) const {
                return a->number() < b->number();
            }
        };
        
        struct FieldOrderingByType {
            inline bool operator()(const FieldDescriptor* a, const FieldDescriptor* b) const {
                if (a->is_repeated() != b->is_repeated()) {
                    return b->is_repeated();
                }
                
                
                if (a->type() == FieldDescriptor::TYPE_BOOL &&
                    b->type() != FieldDescriptor::TYPE_BOOL) {
                    return true;
                }
                
                if (a->type() != FieldDescriptor::TYPE_BOOL &&
                    b->type() == FieldDescriptor::TYPE_BOOL) {
                    return false;
                }
                
                return a->type() < b->type();
            }
        };
        
        struct ExtensionRangeOrdering {
            bool operator()(const Descriptor::ExtensionRange* a,
                            const Descriptor::ExtensionRange* b) const {
                return a->start < b->start;
            }
        };
        
        const FieldDescriptor** SortFieldsByNumber(const Descriptor* descriptor) {
            const FieldDescriptor** fields = new const FieldDescriptor*[descriptor->field_count()];
            for (int i = 0; i < descriptor->field_count(); i++) {
                fields[i] = descriptor->field(i);
            }
            sort(fields, fields + descriptor->field_count(), FieldOrderingByNumber());
            return fields;
        }
        
        const FieldDescriptor** SortFieldsByType(const Descriptor* descriptor) {
            const FieldDescriptor** fields = new const FieldDescriptor*[descriptor->field_count()];
            for (int i = 0; i < descriptor->field_count(); i++) {
                
                fields[i] = descriptor->field(i);
                
            }
            sort(fields, fields + descriptor->field_count(), FieldOrderingByType());
            return fields;
        }
        
        static bool HasRequiredFields(
                                      const Descriptor* type,
                                      hash_set<const Descriptor*>* already_seen) {
            if (already_seen->count(type) > 0) {
                return false;
            }
            already_seen->insert(type);
            if (type->extension_range_count() > 0) {
                return true;
            }
            
            for (int i = 0; i < type->field_count(); i++) {
                const FieldDescriptor* field = type->field(i);
                if (field->is_required()) {
                    return true;
                }
                if (field->cpp_type() == FieldDescriptor::CPPTYPE_MESSAGE) {
                    if (HasRequiredFields(field->message_type(), already_seen)) {
                        return true;
                    }
                }
            }
            
            return false;
        }
        
        static bool HasRequiredFields(const Descriptor* type) {
            hash_set<const Descriptor*> already_seen;
            return HasRequiredFields(type, &already_seen);
        }
        
    }  // namespace
    
    
    MessageGenerator::MessageGenerator(const Descriptor* descriptor) : descriptor_(descriptor), field_generators_(descriptor) {
        SetMapVariables(descriptor, &variables_);
    }
    
    
    MessageGenerator::~MessageGenerator() {
    }
    
    void MessageGenerator::GenerateStaticVariablesInitialization(io::Printer* printer) {
        map<string, string> vars;
        vars["index"] = SimpleItoa(descriptor_->index());
        vars["className"] = ClassName(descriptor_);
        
        for (int i = 0; i < descriptor_->extension_count(); i++) {
            ExtensionGenerator(ClassNameExtensions(descriptor_), descriptor_->extension(i)).GenerateInitializationSource(printer);
        }
        for (int i = 0; i < descriptor_->nested_type_count(); i++) {
            MessageGenerator(descriptor_->nested_type(i)).GenerateStaticVariablesInitialization(printer);
        }
    }
    
    
    void MessageGenerator::GenerateStaticVariablesSource(io::Printer* printer) {
        map<string, string> vars;
        vars["index"] = SimpleItoa(descriptor_->index());
        vars["classname"] = ClassName(descriptor_);
        
        for (int i = 0; i < descriptor_->extension_count(); i++) {
            ExtensionGenerator(ClassNameExtensions(descriptor_), descriptor_->extension(i)).GenerateFieldsSource(printer);
        }
        for (int i = 0; i < descriptor_->nested_type_count(); i++) {
            MessageGenerator(descriptor_->nested_type(i)).GenerateStaticVariablesSource(printer);
        }
    }
    
    void MessageGenerator::GenerateGlobalStaticVariablesSource(io::Printer* printer, string rootclass) {
        map<string, string> vars;
        vars["index"] = SimpleItoa(descriptor_->index());
        vars["className"] = ClassName(descriptor_);
        for (int i = 0; i < descriptor_->extension_count(); i++) {
            ExtensionGenerator(ClassNameExtensions(descriptor_), descriptor_->extension(i)).GenerateFieldsGetterSource(printer, rootclass);
        }
        for (int i = 0; i < descriptor_->nested_type_count(); i++) {
            MessageGenerator(descriptor_->nested_type(i)).GenerateGlobalStaticVariablesSource(printer, rootclass);
        }
    }
    
    
    void MessageGenerator::DetermineDependencies(set<string>* dependencies) {
        
        for (int i = 0; i < descriptor_->nested_type_count(); i++) {
            
            MessageGenerator(descriptor_->nested_type(i)).DetermineDependencies(dependencies);
        }
    }
    
    
    void MessageGenerator::GenerateExtensionRegistrationSource(io::Printer* printer) {
        for (int i = 0; i < descriptor_->extension_count(); i++) {
            ExtensionGenerator(ClassNameExtensions(descriptor_), descriptor_->extension(i))
            .GenerateRegistrationSource(printer);
        }
        
        for (int i = 0; i < descriptor_->nested_type_count(); i++) {
            MessageGenerator(descriptor_->nested_type(i))
            .GenerateExtensionRegistrationSource(printer);
        }
    }
    
    
    void MessageGenerator::GenerateSource(io::Printer* printer) {
        
        scoped_array<const FieldDescriptor*> sorted_fields(SortFieldsByType(descriptor_));

        SourceLocation location;
        if (descriptor_->GetSourceLocation(&location)) {
            string comments;
            comments = BuildCommentsString(location);
            printer->Print(comments.c_str());
        }

        if (descriptor_->extension_range_count() > 0) {
            printer->Print(variables_,
                           "final $acontrol$ class $className$ : ExtendableMessage$errorType$ {\n"
                          );
        } else {
            printer->Print(variables_,
                           "final $acontrol$ class $className$ : GeneratedMessage$errorType$ {\n"
                           );
        }
        printer->Indent();
        
        printer->Print("\n");
        GenerateMessageIsEqualSource(printer);
        
        //Nested Types
        for (int i = 0; i < descriptor_->nested_type_count(); i++) {
            printer->Print("\n\n//Nested type declaration start\n\n");
            printer->Indent();
            MessageGenerator(descriptor_->nested_type(i)).GenerateSource(printer);
            printer->Outdent();
            printer->Print("//Nested type declaration end\n\n");
            
        }
        
        ///
        
        //Oneof
        
        
        
        for (int i = 0; i < descriptor_->oneof_decl_count(); i++) {
            string classNames = ClassNameOneof(descriptor_->oneof_decl(i));
            OneofGenerator(descriptor_->oneof_decl(i)).GenerateSource(printer);
            printer->Print("fileprivate var storage$storageName$:$classname$ =  $classname$.OneOf$storageName$NotSet\n",
                           "storageName", UnderscoresToCapitalizedCamelCase(descriptor_->oneof_decl(i)->name()),
                           "classname", classNames);
            printer->Print("$acontrol$ func getOneOf$storageName$() ->  $classname$ {\n"
                           "    let copyObject$storageName$ = storage$storageName$\n"
                           "    return copyObject$storageName$\n"
                           "}\n",
                           "acontrol", GetAccessControlType(descriptor_->file()),
                           "storageName", UnderscoresToCapitalizedCamelCase(descriptor_->oneof_decl(i)->name()),
                           "classname", classNames);
        }
        
        ////
        
        
        ///Enums
        
        for (int i = 0; i < descriptor_->enum_type_count(); i++) {
            
            printer->Indent();
            EnumGenerator(descriptor_->enum_type(i)).GenerateSource(printer);
            printer->Outdent();
            
        }
        
        ///
        
        
        
        for (int i = 0; i < descriptor_->field_count(); i++) {
            if (descriptor_->field(i)->options().deprecated()) {
                printer->Print("@available(*, deprecated:0.1, message:\"The field is marked as \\\"Deprecated\\\"\")\n");
            }
            field_generators_.get(descriptor_->field(i)).GenerateVariablesSource(printer);
        }
        
        
        for (int i = 0; i < descriptor_->extension_count(); i++) {
            ExtensionGenerator(ClassNameExtensions(descriptor_), descriptor_->extension(i)).GenerateMembersSource(printer);
        }
        
        for (int i = 0; i < descriptor_->field_count(); i++) {
            field_generators_.get(descriptor_->field(i)).GenerateMembersSource(printer);
        }
        
        printer->Print(variables_,"required $acontrol$ init() {\n");
        
        
        for (int i = 0; i < descriptor_->field_count(); i++) {
         
            field_generators_.get(descriptor_->field(i)).GenerateInitializationSource(printer);
        }
        
        
        printer->Print("     super.init()\n"
                       "}\n");
        
        
        GenerateIsInitializedSource(printer);
        GenerateMessageSerializationMethodsSource(printer);
        
//        GenerateParseFromMethodsSource(printer);
    
        printer->Print(variables_,
                       "$acontrol$ class func getBuilder() -> $classNameReturnedType$.Builder {\n"
                       "  return $classNameReturnedType$.classBuilder() as! $classNameReturnedType$.Builder\n"
                       "}\n"
                       "$acontrol$ func getBuilder() -> $classNameReturnedType$.Builder {\n"
                       "  return classBuilder() as! $classNameReturnedType$.Builder\n"
                       "}\n"
                       "override $acontrol$ class func classBuilder() -> ProtocolBuffersMessageBuilder {\n"
                       "  return $classNameReturnedType$.Builder()\n"
                       "}\n"
                       "override $acontrol$ func classBuilder() -> ProtocolBuffersMessageBuilder {\n"
                       "  return $classNameReturnedType$.Builder()\n"
                       "}\n"
                       "$acontrol$ func toBuilder() throws -> $classNameReturnedType$.Builder {\n"
                       "  return try $classNameReturnedType$.builderWithPrototype(prototype:self)\n"
                       "}\n"
                       "$acontrol$ class func builderWithPrototype(prototype:$classNameReturnedType$) throws -> $classNameReturnedType$.Builder {\n"
                       "  return try $classNameReturnedType$.Builder().mergeFrom(other:prototype)\n"
                       "}\n");

        //JSON
        GenerateMessageJSONSource(printer);
        GenerateMessageDescriptionSource(printer);
        
        
        GenerateMessageHashSource(printer);
        
        printer->Print("\n\n//Meta information declaration start\n\n");
        
        printer->Print(variables_,"override $acontrol$ class func className() -> String {\n"
                       "    return \"$classNameReturnedType$\"\n"
                       "}\n"
                       "override $acontrol$ func className() -> String {\n"
                       "    return \"$classNameReturnedType$\"\n"
                       "}\n");
        
        printer->Print("//Meta information declaration end\n\n");
        GenerateBuilderSource(printer);
        printer->Outdent();
        printer->Print("}\n\n");
        
        
    }
    
    
    void MessageGenerator::GenerateMessageSerializationMethodsSource(io::Printer* printer) {
        scoped_array<const FieldDescriptor*> sorted_fields(SortFieldsByNumber(descriptor_));
        
        vector<const Descriptor::ExtensionRange*> sorted_extensions;
        for (int i = 0; i < descriptor_->extension_range_count(); ++i) {
            sorted_extensions.push_back(descriptor_->extension_range(i));
        }
        sort(sorted_extensions.begin(), sorted_extensions.end(),
             ExtensionRangeOrdering());
        
        printer->Print(variables_,"override $acontrol$ func writeTo(codedOutputStream: CodedOutputStream) throws {\n");
        printer->Indent();
        
        for (int i = 0, j = 0;
             i < descriptor_->field_count() || j < sorted_extensions.size(); ) {
            if (i == descriptor_->field_count()) {
                GenerateSerializeOneExtensionRangeSource(printer, sorted_extensions[j++]);
            } else if (j == sorted_extensions.size()) {
                GenerateSerializeOneFieldSource(printer, sorted_fields[i++]);
            } else if (sorted_fields[i]->number() < sorted_extensions[j]->start) {
                GenerateSerializeOneFieldSource(printer, sorted_fields[i++]);
            } else {
                GenerateSerializeOneExtensionRangeSource(printer, sorted_extensions[j++]);
            }
        }
        
        if (descriptor_->options().message_set_wire_format()) {
            printer->Print("try unknownFields.writeAsMessageSetTo(codedOutputStream: codedOutputStream)\n");
        } else {
            printer->Print("try unknownFields.writeTo(codedOutputStream: codedOutputStream)\n");
        }
        printer->Outdent();
        
        printer->Print("}\n");
        
        printer->Print("override $acontrol$ func serializedSize() -> Int32 {\n",
                       "acontrol", GetAccessControlType(descriptor_->file()));
        printer->Indent();
        printer->Print("var serialize_size:Int32 = memoizedSerializedSize\n"
                       "if serialize_size != -1 {\n"
                       " return serialize_size\n"
                       "}\n"
                       "\n"
                       "serialize_size = 0\n");
        for (int i = 0; i < descriptor_->field_count(); i++) {
            field_generators_.get(sorted_fields[i]).GenerateSerializedSizeCodeSource(printer);
        }
        
        if (descriptor_->extension_range_count() > 0) {
            printer->Print(
                           "serialize_size += extensionsSerializedSize()\n");
        }
        
        if (descriptor_->options().message_set_wire_format()) {
            printer->Print(
                           "serialize_size += unknownFields.serializedSizeAsMessageSet()\n");
        } else {
            printer->Print(
                           "serialize_size += unknownFields.serializedSize()\n");
        }
        
        
        printer->Print(
                       "memoizedSerializedSize = serialize_size\n"
                       "return serialize_size\n");
        printer->Outdent();
        printer->Print("}\n");
    }
    
    void MessageGenerator::GenerateMessageDescriptionSource(io::Printer* printer) {
        scoped_array<const FieldDescriptor*> sorted_fields(SortFieldsByNumber(descriptor_));
        
        vector<const Descriptor::ExtensionRange*> sorted_extensions;
        for (int i = 0; i < descriptor_->extension_range_count(); ++i) {
            sorted_extensions.push_back(descriptor_->extension_range(i));
        }
        sort(sorted_extensions.begin(), sorted_extensions.end(), ExtensionRangeOrdering());
        
        printer->Print("override $acontrol$ func getDescription(indent:String) throws -> String {\n","acontrol", GetAccessControlType(descriptor_->file()));
        printer->Indent();
        printer->Print("var output = \"\"\n");
        
        for (int i = 0, j = 0;
             i < descriptor_->field_count() || j < sorted_extensions.size(); ) {
            if (i == descriptor_->field_count()) {
                GenerateDescriptionOneExtensionRangeSource(printer, sorted_extensions[j++]);
            } else if (j == sorted_extensions.size()) {
                GenerateDescriptionOneFieldSource(printer, sorted_fields[i++]);
            } else if (sorted_fields[i]->number() < sorted_extensions[j]->start) {
                GenerateDescriptionOneFieldSource(printer, sorted_fields[i++]);
            } else {
                GenerateDescriptionOneExtensionRangeSource(printer, sorted_extensions[j++]);
            }
        }
        
        printer->Print("output += unknownFields.getDescription(indent: indent)\n");
        printer->Print("return output\n");
        printer->Outdent();
        printer->Print(
                       "}\n");
    }
    
    void MessageGenerator::GenerateMessageJSONSource(io::Printer* printer) {
        
        //
        
        printer->Print(variables_,"override $acontrol$ func encode() throws -> Dictionary<String,Any> {\n");
        
        printer->Indent();
        
        printer->Print("guard isInitialized() else {\n"
                       "  throw ProtocolBuffersError.invalidProtocolBuffer(\"Uninitialized Message\")\n"
                       "}\n\n");
        
        if (descriptor_->field_count() == 0) {
            printer->Print("let jsonMap:Dictionary<String,Any> = Dictionary<String,Any>()\n");
        }
        else {
            printer->Print("var jsonMap:Dictionary<String,Any> = Dictionary<String,Any>()\n");
        }
        
        
        for (int i = 0; i < descriptor_->field_count(); i++) {
            field_generators_.get(descriptor_->field(i)).GenerateJSONEncodeCodeSource(printer);
        }
    
        printer->Outdent();
        printer->Print("  return jsonMap\n"
                       "}\n");
        
        printer->Print(variables_,"override class $acontrol$ func decode(jsonMap:Dictionary<String,Any>) throws -> $classNameReturnedType$ {\n"
                       "  return try $classNameReturnedType$.Builder.decodeToBuilder(jsonMap:jsonMap).build()\n"
                       "}\n");
        
        printer->Print(variables_,"override class $acontrol$ func fromJSON(data:Data) throws -> $classNameReturnedType$ {\n"
                       "  return try $classNameReturnedType$.Builder.fromJSONToBuilder(data:data).build()\n"
                       "}\n");
    }
    
    void MessageGenerator::GenerateMessageBuilderJSONSource(io::Printer* printer) {
        //
        printer->Print(variables_, "class override $acontrol$ func decodeToBuilder(jsonMap:Dictionary<String,Any>) throws -> $classNameReturnedType$.Builder {\n");
        
        printer->Indent();
        printer->Print(variables_,"let resultDecodedBuilder = $classNameReturnedType$.Builder()\n");
        
        for (int i = 0; i < descriptor_->field_count(); i++) {
            field_generators_.get(descriptor_->field(i)).GenerateJSONDecodeCodeSource(printer);
        }
        
        printer->Print("return resultDecodedBuilder\n");
        //
        printer->Outdent();
        printer->Print(
                       "}\n");
        
        printer->Print(variables_,"override class $acontrol$ func fromJSONToBuilder(data:Data) throws -> $classNameReturnedType$.Builder {\n"
                       "  let jsonData = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions(rawValue: 0))\n"
                       "  guard let jsDataCast = jsonData as? Dictionary<String,Any> else {\n"
                       "    throw ProtocolBuffersError.invalidProtocolBuffer(\"Invalid JSON data\")\n"
                       "  }\n"
                       "  return try $classNameReturnedType$.Builder.decodeToBuilder(jsonMap:jsDataCast)\n"
                       "}\n");
    }
    
    

    void MessageGenerator::GenerateMessageIsEqualSource(io::Printer* printer) {
        scoped_array<const FieldDescriptor*> sorted_fields(SortFieldsByNumber(descriptor_));
        
        vector<const Descriptor::ExtensionRange*> sorted_extensions;
        for (int i = 0; i < descriptor_->extension_range_count(); ++i) {
            sorted_extensions.push_back(descriptor_->extension_range(i));
        }
        sort(sorted_extensions.begin(), sorted_extensions.end(),
             ExtensionRangeOrdering());
        
        printer->Print(variables_,"$acontrol$ static func == (lhs: $classNameReturnedType$, rhs: $classNameReturnedType$) -> Bool {\n");
                       
        printer->Indent();
        
        
        printer->Print("if (lhs === rhs) {\n"
                       "  return true\n"
                       "}\n"
                       );
        
        printer->Print("var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)\n");
        for (int i = 0, j = 0; i < descriptor_->field_count() || j < sorted_extensions.size(); ) {
            
            if (i == descriptor_->field_count())
            {
                printer->Print("fieldCheck = fieldCheck && ");
                GenerateIsEqualOneExtensionRangeSource(printer, sorted_extensions[j++]);
                printer->Print("\n");
            } else if (j == sorted_extensions.size())
            {
                printer->Print("fieldCheck = fieldCheck && ");
                GenerateIsEqualOneFieldSource(printer, sorted_fields[i++]);
                printer->Print("\n");
                
            } else if (sorted_fields[i]->number() < sorted_extensions[j]->start) {
                printer->Print("fieldCheck = fieldCheck && ");
                GenerateIsEqualOneFieldSource(printer, sorted_fields[i++]);
                printer->Print("\n");
                
            } else {
                printer->Print("fieldCheck = fieldCheck && ");
                GenerateIsEqualOneExtensionRangeSource(printer, sorted_extensions[j++]);
                printer->Print("\n");
            }
            
        }
        printer->Print("fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))\n");
        printer->Print("return fieldCheck\n");
        
        
        printer->Outdent();
        printer->Print("}\n\n");
    }
    
    
    void MessageGenerator::GenerateMessageHashSource(io::Printer* printer) {
        scoped_array<const FieldDescriptor*> sorted_fields(SortFieldsByNumber(descriptor_));
        
        vector<const Descriptor::ExtensionRange*> sorted_extensions;
        for (int i = 0; i < descriptor_->extension_range_count(); ++i) {
            sorted_extensions.push_back(descriptor_->extension_range(i));
        }
        sort(sorted_extensions.begin(), sorted_extensions.end(),
             ExtensionRangeOrdering());
        
        printer->Print(variables_,"override $acontrol$ var hashValue:Int {\n");
        printer->Indent();
        printer->Indent();
        printer->Print("get {\n");
        
        
        printer->Indent();
        printer->Indent();
        printer->Print("var hashCode:Int = 7\n");
        
        for (int i = 0, j = 0;
             i < descriptor_->field_count() || j < sorted_extensions.size(); ) {
            if (i == descriptor_->field_count()) {
                GenerateHashOneExtensionRangeSource(printer, sorted_extensions[j++]);
            } else if (j == sorted_extensions.size()) {
                GenerateHashOneFieldSource(printer, sorted_fields[i++]);
            } else if (sorted_fields[i]->number() < sorted_extensions[j]->start) {
                GenerateHashOneFieldSource(printer, sorted_fields[i++]);
            } else {
                GenerateHashOneExtensionRangeSource(printer, sorted_extensions[j++]);
            }
        }
        
        printer->Print("hashCode = (hashCode &* 31) &+  unknownFields.hashValue\n"
                       "return hashCode\n");
        
        printer->Outdent();
        printer->Outdent();
        printer->Print("}\n");
        printer->Outdent();
        printer->Outdent();
        printer->Print(
                       "}\n");
        
    }
    
    
    void MessageGenerator::GenerateParseFromMethodsSource(io::Printer* printer) {
        
        printer->Print(variables_,"extension $classNameReturnedType$: GeneratedMessageProtocol {\n");
        printer->Indent();
        printer->Print(variables_,
                       "$acontrol$ class func parseArrayDelimitedFrom(inputStream: InputStream) throws -> Array<$classNameReturnedType$> {\n"
                       "  var mergedArray = Array<$classNameReturnedType$>()\n"
                       "  while let value = try parseDelimitedFrom(inputStream: inputStream) {\n"
                       "    mergedArray.append(value)\n"
                       "  }\n"
                       "  return mergedArray\n"
                       "}\n"
                       "$acontrol$ class func parseDelimitedFrom(inputStream: InputStream) throws -> $classNameReturnedType$? {\n"
                       "  return try $classNameReturnedType$.Builder().mergeDelimitedFrom(inputStream: inputStream)?.build()\n"
                       "}\n"
                       "$acontrol$ class func parseFrom(data: Data) throws -> $classNameReturnedType$ {\n"
                       "  return try $classNameReturnedType$.Builder().mergeFrom(data: data, extensionRegistry:$fileName$.default.extensionRegistry).build()\n"
                       "}\n"
                       "$acontrol$ class func parseFrom(data: Data, extensionRegistry:ExtensionRegistry) throws -> $classNameReturnedType$ {\n"
                       "  return try $classNameReturnedType$.Builder().mergeFrom(data: data, extensionRegistry:extensionRegistry).build()\n"
                       "}\n"
                       "$acontrol$ class func parseFrom(inputStream: InputStream) throws -> $classNameReturnedType$ {\n"
                       "  return try $classNameReturnedType$.Builder().mergeFrom(inputStream: inputStream).build()\n"
                       "}\n"
                       "$acontrol$ class func parseFrom(inputStream: InputStream, extensionRegistry:ExtensionRegistry) throws -> $classNameReturnedType$ {\n"
                       "  return try $classNameReturnedType$.Builder().mergeFrom(inputStream: inputStream, extensionRegistry:extensionRegistry).build()\n"
                       "}\n"
                       "$acontrol$ class func parseFrom(codedInputStream: CodedInputStream) throws -> $classNameReturnedType$ {\n"
                       "  return try $classNameReturnedType$.Builder().mergeFrom(codedInputStream: codedInputStream).build()\n"
                       "}\n"
                       "$acontrol$ class func parseFrom(codedInputStream: CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> $classNameReturnedType$ {\n"
                       "  return try $classNameReturnedType$.Builder().mergeFrom(codedInputStream: codedInputStream, extensionRegistry:extensionRegistry).build()\n"
                       "}\n");
      
        printer->Outdent();
       
        printer->Print(
                      "}\n");
        for (int i = 0; i < descriptor_->nested_type_count(); i++) {
            MessageGenerator(descriptor_->nested_type(i)).GenerateParseFromMethodsSource(printer);
        }
    }
    
    
    void MessageGenerator::GenerateSerializeOneFieldSource(io::Printer* printer, const FieldDescriptor* field) {
        field_generators_.get(field).GenerateSerializationCodeSource(printer);
    }
    
    
    void MessageGenerator::GenerateSerializeOneExtensionRangeSource(io::Printer* printer, const Descriptor::ExtensionRange* range) {
        printer->Print(
                       "try writeExtensionsTo(codedOutputStream: codedOutputStream, startInclusive:$from$, endExclusive:$to$)\n",
                       "from", SimpleItoa(range->start),
                       "to", SimpleItoa(range->end));
    }
    
    void MessageGenerator::GenerateDescriptionOneFieldSource(io::Printer* printer, const FieldDescriptor* field) {
        field_generators_.get(field).GenerateDescriptionCodeSource(printer);
    }
    
    
    void MessageGenerator::GenerateDescriptionOneExtensionRangeSource(io::Printer* printer, const Descriptor::ExtensionRange* range) {
        printer->Print(
                       "output += try getExtensionDescription(startInclusive:$from$, endExclusive:$to$, indent:indent)\n",
                       "from", SimpleItoa(range->start),
                       "to", SimpleItoa(range->end));
    }
    
    
    void MessageGenerator::GenerateIsEqualOneFieldSource(io::Printer* printer, const FieldDescriptor* field) {
        field_generators_.get(field).GenerateIsEqualCodeSource(printer);
    }
    
    
    void MessageGenerator::GenerateIsEqualOneExtensionRangeSource(io::Printer* printer, const Descriptor::ExtensionRange* range) {
        printer->Print(
                       "lhs.isEqualExtensionsInOther(otherMessage: rhs, startInclusive:$from$, endExclusive:$to$)",
                       "from", SimpleItoa(range->start), "to", SimpleItoa(range->end));
    }
    
    
    void MessageGenerator::GenerateHashOneFieldSource(io::Printer* printer, const FieldDescriptor* field) {
        field_generators_.get(field).GenerateHashCodeSource(printer);
    }
    
    
    void MessageGenerator::GenerateHashOneExtensionRangeSource(io::Printer* printer, const Descriptor::ExtensionRange* range) {
        printer->Print(
                       "hashCode = (hashCode &* 31) &+ Int(hashExtensionsFrom(startInclusive: $from$, endExclusive:$to$))\n",
                       "from", SimpleItoa(range->start), "to", SimpleItoa(range->end));
    }
    
    
    void MessageGenerator::GenerateBuilderSource(io::Printer* printer) {
        
        if (descriptor_->extension_range_count() > 0) {
            printer->Print(variables_,
                           "final $acontrol$ class Builder : ExtendableMessageBuilder {\n");
        } else {
            printer->Print(variables_,
                           "final $acontrol$ class Builder : GeneratedMessageBuilder {\n");
        }
        
        printer->Indent();
        
        printer->Print(variables_,
                       "fileprivate var builderResult:$classNameReturnedType$ = $classNameReturnedType$()\n"
                       "$acontrol$ func getMessage() -> $classNameReturnedType$ {\n"
                       "    return builderResult\n"
                       "}\n\n"
                       "required override $acontrol$ init () {\n"
                       "   super.init()\n"
                       "}\n");
        for (int i = 0; i < descriptor_->field_count(); i++) {
            field_generators_.get(descriptor_->field(i)).GenerateBuilderMembersSource(printer);
        }
        
        GenerateCommonBuilderMethodsSource(printer);
        GenerateBuilderParsingMethodsSource(printer);
//        if (file->syntax() == FileDescriptor::SYNTAX_PROTO3) {
            GenerateMessageBuilderJSONSource(printer);
//        }
        printer->Outdent();
        
        
        
        printer->Print("}\n\n");
    }
    
    
    void MessageGenerator::GenerateCommonBuilderMethodsSource(io::Printer* printer) {
        
        if (descriptor_->extension_range_count() > 0) {
            printer->Print(variables_,
                           "override $acontrol$ var internalGetResult:ExtendableMessage {\n"
                           "     get {\n"
                           "         return builderResult\n"
                           "     }\n"
                           "}\n");
        } else {
            printer->Print(variables_,
                           "override $acontrol$ var internalGetResult:GeneratedMessage {\n"
                           "     get {\n"
                           "        return builderResult\n"
                           "     }\n"
                           "}\n");
        }
        
        printer->Print(variables_,
                       "@discardableResult\n"
                       "override $acontrol$ func clear() -> $classNameReturnedType$.Builder {\n"
                       "  builderResult = $classNameReturnedType$()\n"
                       "  return self\n"
                       "}\n"
                       "override $acontrol$ func clone() throws -> $classNameReturnedType$.Builder {\n"
                       "  return try $classNameReturnedType$.builderWithPrototype(prototype:builderResult)\n"
                       "}\n");
        
        printer->Print(variables_,
                       "override $acontrol$ func build() throws -> $classNameReturnedType$ {\n"
                       "     try checkInitialized()\n"
                       "     return buildPartial()\n"
                       "}\n"
                       "$acontrol$ func buildPartial() -> $classNameReturnedType$ {\n");
        
        
        for (int i = 0; i < descriptor_->field_count(); i++) {
            field_generators_.get(descriptor_->field(i)).GenerateBuildingCodeSource(printer);
        }
        
        
        printer->Print(variables_,
                       "  let returnMe:$classNameReturnedType$ = builderResult\n"
                       "  return returnMe\n"
                       "}\n");
        
        printer->Print(variables_,
                       "@discardableResult\n"
                       "$acontrol$ func mergeFrom(other:$classNameReturnedType$) throws -> $classNameReturnedType$.Builder {\n");

        printer->Indent();
        printer->Print(variables_,
                       "if other == $classNameReturnedType$() {\n"
                       " return self\n"
                       "}\n");
        
        
        for (int i = 0; i < descriptor_->field_count(); i++) {
            field_generators_.get(descriptor_->field(i)).GenerateMergingCodeSource(printer);
        }
        
        
        
        if (descriptor_->extension_range_count() > 0) {
            printer->Print("try mergeExtensionFields(other: other)\n");
        }
        
        printer->Print("try merge(unknownField: other.unknownFields)\n"
                       "return self\n");
        printer->Outdent();
        printer->Print("}\n");
    }
    
    //////////////////////////////////////////////////////////
    
    void MessageGenerator::GenerateBuilderParsingMethodsSource(io::Printer* printer) {
        scoped_array<const FieldDescriptor*> sorted_fields(SortFieldsByNumber(descriptor_));
        
        printer->Print(variables_,
                       "@discardableResult\n"
                       "override $acontrol$ func mergeFrom(codedInputStream: CodedInputStream) throws -> $classNameReturnedType$.Builder {\n"
                       "     return try mergeFrom(codedInputStream: codedInputStream, extensionRegistry:ExtensionRegistry())\n"
                       "}\n"
                       "@discardableResult\n"
                       "override $acontrol$ func mergeFrom(codedInputStream: CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> $classNameReturnedType$.Builder {\n");
        
        printer->Indent();
        printer->Print(
                       "let unknownFieldsBuilder:UnknownFieldSet.Builder = try UnknownFieldSet.builderWithUnknownFields(copyFrom:self.unknownFields)\n"
                       "while (true) {\n");
        printer->Indent();

        printer->Print("let protobufTag = try codedInputStream.readTag()\n"
                       "switch protobufTag {\n");
        
        printer->Print("case 0: \n");
        
        printer->Indent();
        
        printer->Print("self.unknownFields = try unknownFieldsBuilder.build()\n"
                       "return self\n"
                       "\n");
        
        printer->Outdent();
        for (int i = 0; i < descriptor_->field_count(); i++) {
            const FieldDescriptor* field = sorted_fields[i];
            uint32 tag = WireFormatLite::MakeTag(field->number(),
                                                 WireFormat::WireTypeForFieldType(field->type()));
            
            if (isPackedTypeProto3(field) && field->is_repeated()) {
                tag = WireFormatLite::MakeTag(field->number(),
                                              WireFormatLite::WIRETYPE_LENGTH_DELIMITED);
            }
            
            printer->Print("case $tag$:\n",
                           "tag", SimpleItoa(tag));
            
            printer->Indent();
            field_generators_.get(field).GenerateParsingCodeSource(printer);
            printer->Outdent();
            printer->Print("\n");
        }
        printer->Print("default:\n"
                       "  if (!(try parse(codedInputStream:codedInputStream, unknownFields:unknownFieldsBuilder, extensionRegistry:extensionRegistry, tag:protobufTag))) {\n"
                       "     unknownFields = try unknownFieldsBuilder.build()\n"
                       "     return self\n"
                       "  }\n"
                       "}\n");
        
        
        
        printer->Outdent();
        printer->Print("}\n");
        printer->Outdent();
        printer->Print("}\n");
    }
    
    
    void MessageGenerator::GenerateIsInitializedSource(io::Printer* printer) {
        printer->Print(variables_,
                       "override $acontrol$ func isInitialized() -> Bool {\n");
        printer->Indent();
      
        for (int i = 0; i < descriptor_->field_count(); i++) {
            const FieldDescriptor* field = descriptor_->field(i);
            
            if (field->is_required()) {
                printer->Print("if !has$capitalized_name$ {\n"
                               "  return false\n"
                               "}\n",
                               "capitalized_name", UnderscoresToCapitalizedCamelCase(field));
            }
        }
        
        for (int i = 0; i < descriptor_->field_count(); i++) {
            const FieldDescriptor* field = descriptor_->field(i);
            if (field->cpp_type() == FieldDescriptor::CPPTYPE_MESSAGE &&
                HasRequiredFields(field->message_type())) {
                
                map<string,string> vars;
                vars["type"] = ClassName(field->message_type());
                vars["name"] = UnderscoresToCamelCase(field);
                vars["name_reserved"] = SafeName(UnderscoresToCamelCase(field));
                vars["capitalized_name"] = UnderscoresToCapitalizedCamelCase(field);
                
                switch (field->label()) {
                    case FieldDescriptor::LABEL_REQUIRED:
                        printer->Print(vars,
                                       "if !$name_reserved$.isInitialized() {\n"
                                       "  return false\n"
                                       "}\n");
                        break;
                    case FieldDescriptor::LABEL_OPTIONAL:
                        printer->Print(vars,
                                       "if has$capitalized_name$ {\n"
                                       " if !$name_reserved$.isInitialized() {\n"
                                       "   return false\n"
                                       " }\n"
                                       "}\n");
                        break;
                    case FieldDescriptor::LABEL_REPEATED:
                        printer->Print(vars,
                                       "var isInit$capitalized_name$:Bool = true\n"
                                       "for oneElement$capitalized_name$ in $name_reserved$ {\n"
                                       "  if !oneElement$capitalized_name$.isInitialized() {\n"
                                       "    isInit$capitalized_name$ = false\n"
                                       "    break \n"
                                       "  }\n"
                                       "}\n"
                                       "if !isInit$capitalized_name$ {\n"
                                       "  return isInit$capitalized_name$\n"
                                       "}\n"
                                       );
                        break;
                }
            }
        }
        
        if (descriptor_->extension_range_count() > 0) {
            printer->Print(
                           "if !extensionsAreInitialized() {\n"
                           "  return false\n"
                           "}\n");
        }
        
        printer->Outdent();
        printer->Print(
                       " return true\n"
                       "}\n");
    }
}  // namespace swift
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
