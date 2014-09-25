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
    string UniqueFileScopeIdentifier(const Descriptor* descriptor) {
      return "static_" + StringReplace(descriptor->full_name(), ".", "_", true);
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


  MessageGenerator::MessageGenerator(const Descriptor* descriptor)
    : descriptor_(descriptor),
    field_generators_(descriptor) {
  }


  MessageGenerator::~MessageGenerator() {
  }


//  void MessageGenerator::GenerateStaticVariablesHeader(io::Printer* printer) {
//    map<string, string> vars;
//    vars["identifier"] = UniqueFileScopeIdentifier(descriptor_);
//    vars["index"] = SimpleItoa(descriptor_->index());
//    vars["classname"] = ClassName(descriptor_);
//    if (descriptor_->containing_type() != NULL) {
//      vars["parent"] = UniqueFileScopeIdentifier(descriptor_->containing_type());
//    }
//
//    for (int i = 0; i < descriptor_->nested_type_count(); i++) {
//      MessageGenerator(descriptor_->nested_type(i)).GenerateStaticVariablesHeader(printer);
//    }
//  }


  void MessageGenerator::GenerateStaticVariablesInitialization(io::Printer* printer) {
//    map<string, string> vars;
//    vars["identifier"] = UniqueFileScopeIdentifier(descriptor_);
//    vars["index"] = SimpleItoa(descriptor_->index());
//    vars["classname"] = ClassName(descriptor_);
//    if (descriptor_->containing_type() != NULL) {
//      vars["parent"] = UniqueFileScopeIdentifier(descriptor_->containing_type());
//    }
//
//    for (int i = 0; i < descriptor_->extension_count(); i++) {
//      ExtensionGenerator(ClassName(descriptor_), descriptor_->extension(i)).GenerateInitializationSource(printer);
//    }
//    for (int i = 0; i < descriptor_->nested_type_count(); i++) {
//      MessageGenerator(descriptor_->nested_type(i)).GenerateStaticVariablesInitialization(printer);
//    }
  }


  void MessageGenerator::GenerateStaticVariablesSource(io::Printer* printer) {
//    map<string, string> vars;
//    vars["identifier"] = UniqueFileScopeIdentifier(descriptor_);
//    vars["index"] = SimpleItoa(descriptor_->index());
//    vars["classname"] = ClassName(descriptor_);
//    if (descriptor_->containing_type() != NULL) {
//      vars["parent"] = UniqueFileScopeIdentifier(descriptor_->containing_type());
//    }
//
//    for (int i = 0; i < descriptor_->extension_count(); i++) {
//      ExtensionGenerator(ClassName(descriptor_), descriptor_->extension(i))
//        .GenerateFieldsSource(printer);
//    }

  }


  void MessageGenerator::DetermineDependencies(set<string>* dependencies) {

    for (int i = 0; i < descriptor_->nested_type_count(); i++) {

      MessageGenerator(descriptor_->nested_type(i)).DetermineDependencies(dependencies);
    }
  }


  void MessageGenerator::GenerateExtensionRegistrationSource(io::Printer* printer) {
    for (int i = 0; i < descriptor_->extension_count(); i++) {
      ExtensionGenerator(ClassName(descriptor_), descriptor_->extension(i))
        .GenerateRegistrationSource(printer);
    }

    for (int i = 0; i < descriptor_->nested_type_count(); i++) {
      MessageGenerator(descriptor_->nested_type(i))
        .GenerateExtensionRegistrationSource(printer);
    }
  }


  void MessageGenerator::GenerateSource(io::Printer* printer) {

      scoped_array<const FieldDescriptor*> sorted_fields(SortFieldsByType(descriptor_));

      
      if (descriptor_->extension_range_count() > 0) {
          printer->Print(
                         "final class $classname$ : ExtendableMessage {\n",
                         "classname", UnderscoresToCapitalizedCamelCase(descriptor_->name()));
      } else {
          printer->Print(
                         "final class $classname$ : GeneratedMessage {\n",
                         "classname", UnderscoresToCapitalizedCamelCase(descriptor_->name()));
      }
      printer->Indent();
      
      
      //Nested Types
      for (int i = 0; i < descriptor_->nested_type_count(); i++) {
          printer->Print("\n\n//Nested type declaration start \n\n");
          printer->Indent();
          MessageGenerator(descriptor_->nested_type(i)).GenerateSource(printer);
          printer->Outdent();
          printer->Print("\n\n//Nested type declaration end \n\n");
          
      }
      
      ///
      
      //Oneof
      
      for (int i = 0; i < descriptor_->oneof_decl_count(); i++) {
          OneofGenerator(descriptor_->oneof_decl(i)).GenerateSource(printer);
          printer->Print("private var storage$storageName$:$classname$ =  $classname$.$storageName$NotSet(0)\n",
                         "storageName", UnderscoresToCapitalizedCamelCase(descriptor_->oneof_decl(i)->name()),
                         "classname", ClassNameOneof(descriptor_->oneof_decl(i)));
          
      }
      
      ////
      
      
      ///Enums
      
      for (int i = 0; i < descriptor_->enum_type_count(); i++) {
          printer->Print("\n\n//Enum type declaration start \n\n");
          printer->Indent();
          EnumGenerator(descriptor_->enum_type(i)).GenerateSource(printer);
          printer->Outdent();
          printer->Print("\n\n//Enum type declaration end \n\n");
      }
      
      
      
      
      
    for (int i = 0; i < descriptor_->field_count(); i++) {
      field_generators_.get(descriptor_->field(i)).GenerateSynthesizeSource(printer);
    }


    for (int i = 0; i < descriptor_->extension_count(); i++) {
      ExtensionGenerator(ClassName(descriptor_), descriptor_->extension(i)).GenerateMembersSource(printer);
    }

    for (int i = 0; i < descriptor_->field_count(); i++) {
      field_generators_.get(descriptor_->field(i)).GenerateMembersSource(printer);
    }

    printer->Print("required init() {\n");
    
    
    for (int i = 0; i < descriptor_->field_count(); i++) {
        field_generators_.get(descriptor_->field(i)).GenerateInitializationSource(printer);
    }
    
    
    printer->Print("     super.init()\n"
                 "}\n");


    GenerateIsInitializedSource(printer);
    GenerateMessageSerializationMethodsSource(printer);

    GenerateParseFromMethodsSource(printer);

    printer->Print(
      "class func builder() -> $classname$Builder {\n"
      "  return $classname$Builder()\n"
      "}\n"
      "class func builderWithPrototype(prototype:$classname$) -> $classname$Builder {\n"
      "  return $classname$.builder().mergeFrom(prototype)\n"
      "}\n"
      "func builder() -> $classname$Builder {\n"
      "  return $classname$.builder()\n"
      "}\n"
      "func toBuilder() -> $classname$Builder {\n"
      "  return $classname$.builderWithPrototype(self)\n"
      "}\n",
      "classname", UnderscoresToCapitalizedCamelCase(descriptor_->name()));

    GenerateMessageDescriptionSource(printer);


    GenerateMessageHashSource(printer);
    printer->Outdent();
    printer->Print("}\n\n");
    
    GenerateBuilderSource(printer);
  }


  void MessageGenerator::GenerateMessageSerializationMethodsSource(io::Printer* printer) {
    scoped_array<const FieldDescriptor*> sorted_fields(SortFieldsByNumber(descriptor_));

    vector<const Descriptor::ExtensionRange*> sorted_extensions;
    for (int i = 0; i < descriptor_->extension_range_count(); ++i) {
      sorted_extensions.push_back(descriptor_->extension_range(i));
    }
    sort(sorted_extensions.begin(), sorted_extensions.end(),
      ExtensionRangeOrdering());

    printer->Print(
      "override func writeToCodedOutputStream(output:CodedOutputStream) {\n");
      printer->Indent();
    // Merge the fields and the extension ranges, both sorted by field number.
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
      printer->Print(
        "unknownFields.writeAsMessageSetTo(output)\n");
    } else {
      printer->Print(
        "unknownFields.writeToCodedOutputStream(output)\n");
    }
      printer->Outdent();
    
    printer->Print("}\n");
      
    printer->Print("override func serializedSize() -> Int32 {\n");
    printer->Indent();
    printer->Print("var size:Int32 = memoizedSerializedSize\n"
      "if size != -1 {\n"
      " return size\n"
      "}\n"
      "\n"
      "size = 0\n");
    for (int i = 0; i < descriptor_->field_count(); i++) {
      field_generators_.get(sorted_fields[i]).GenerateSerializedSizeCodeSource(printer);
    }
    
    if (descriptor_->extension_range_count() > 0) {
      printer->Print(
        "size += extensionsSerializedSize()\n");
    }

    if (descriptor_->options().message_set_wire_format()) {
      printer->Print(
        "size += unknownFields.serializedSizeAsMessageSet()\n");
    } else {
      printer->Print(
        "size += unknownFields.serializedSize()\n");
    }

    
    printer->Print(
      "memoizedSerializedSize = size\n"
                   "return size\n");
    printer->Outdent();
    printer->Print("}\n");
  }

  void MessageGenerator::GenerateMessageDescriptionSource(io::Printer* printer) {
    scoped_array<const FieldDescriptor*> sorted_fields(SortFieldsByNumber(descriptor_));

    vector<const Descriptor::ExtensionRange*> sorted_extensions;
    for (int i = 0; i < descriptor_->extension_range_count(); ++i) {
      sorted_extensions.push_back(descriptor_->extension_range(i));
    }
    sort(sorted_extensions.begin(), sorted_extensions.end(),
      ExtensionRangeOrdering());

    printer->Print(
      "override func writeDescriptionTo(inout output:String, indent:String) {\n");
    
    printer->Indent();
     
    // Merge the fields and the extension ranges, both sorted by field number.
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

    printer->Print(
      "unknownFields.writeDescriptionTo(&output, indent:indent)\n");

    printer->Outdent();
    printer->Print(
      "}\n");
  }




    //TODO override equals
  void MessageGenerator::GenerateMessageIsEqualSource(io::Printer* printer) {
    scoped_array<const FieldDescriptor*> sorted_fields(SortFieldsByNumber(descriptor_));

    vector<const Descriptor::ExtensionRange*> sorted_extensions;
    for (int i = 0; i < descriptor_->extension_range_count(); ++i) {
      sorted_extensions.push_back(descriptor_->extension_range(i));
    }
    sort(sorted_extensions.begin(), sorted_extensions.end(),
      ExtensionRangeOrdering());

    printer->Print(
      "func == (lhs: $classname$, rhs: $classname$) -> Bool {\n","classname", ClassName(descriptor_));
    printer->Indent();
    
    
    printer->Print(
      "if (lhs === rhs) {\n"
      "  return true\n"
      "}\n"
      );




    // Merge the fields and the extension ranges, both sorted by field number.
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

    printer->Print("return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))\n");
    
    
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

    printer->Print(
      "override var hashValue:Int {\n");
      printer->Indent();
      printer->Indent();
    printer->Print("get {\n");
    
    
      printer->Indent();
      printer->Indent();
    printer->Print("var hashCode:Int = 7\n");

//    // Merge the fields and the extension ranges, both sorted by field number.
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
    printer->Print(
      "class func parseFromData(data:[Byte]) -> $classname$ {\n"
      "  return $classname$.builder().mergeFromData(data).build()\n"
      "}\n"
      "class func parseFromData(data:[Byte], extensionRegistry:ExtensionRegistry) -> $classname$ {\n"
      "  return $classname$.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()\n"
      "}\n"
      "class func parseFromInputStream(input:NSInputStream) -> $classname$ {\n"
      "  return $classname$.builder().mergeFromInputStream(input).build()\n"
      "}\n"
      "class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->$classname$ {\n"
      "  return $classname$.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()\n"
      "}\n"
      "class func parseFromCodedInputStream(input:CodedInputStream) -> $classname$ {\n"
      "  return $classname$.builder().mergeFromCodedInputStream(input).build()\n"
      "}\n"
      "class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> $classname$ {\n"
      "  return $classname$.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()\n"
      "}\n",
      "classname", ClassName(descriptor_));
  }
  
   void MessageGenerator::GenerateParseFromExtensionMethodsSource(io::Printer* printer) {
        printer->Print(
                       "extension $classname$ {\n"
                       "    class func parseFromNSData(data:NSData) -> $classname$ {\n"
                       "        var bytes = [Byte](count: data.length, repeatedValue: 0)\n"
                       "        data.getBytes(&bytes)\n"
                       "        return $classname$.builder().mergeFromData(bytes).build()\n"
                       "    }\n"
                       "    class func parseFromNSData(data:NSData, extensionRegistry:ExtensionRegistry) -> $classname$ {\n"
                       "        var bytes = [Byte](count: data.length, repeatedValue: 0)\n"
                       "        data.getBytes(&bytes)\n"
                       "        return $classname$.builder().mergeFromData(bytes, extensionRegistry:extensionRegistry).build()\n"
                       "    }\n"
                       "}\n",
                      "classname", ClassName(descriptor_));
    }
    


  void MessageGenerator::GenerateSerializeOneFieldSource(
    io::Printer* printer, const FieldDescriptor* field) {
      field_generators_.get(field).GenerateSerializationCodeSource(printer);
  }


  void MessageGenerator::GenerateSerializeOneExtensionRangeSource(
    io::Printer* printer, const Descriptor::ExtensionRange* range) {
      printer->Print(
        "writeExtensionsToCodedOutputStream(output, startInclusive:Int32($from$), endExclusive:Int32($to$))\n",
        "from", SimpleItoa(range->start),
        "to", SimpleItoa(range->end));
  }

  void MessageGenerator::GenerateDescriptionOneFieldSource(
    io::Printer* printer, const FieldDescriptor* field) {
      field_generators_.get(field).GenerateDescriptionCodeSource(printer);
  }


  void MessageGenerator::GenerateDescriptionOneExtensionRangeSource(
    io::Printer* printer, const Descriptor::ExtensionRange* range) {
      printer->Print(
        "writeExtensionDescription(&output, startInclusive:Int32($from$), endExclusive:Int32($to$), indent:indent)\n",
        "from", SimpleItoa(range->start),
        "to", SimpleItoa(range->end));
  }


  void MessageGenerator::GenerateIsEqualOneFieldSource(
    io::Printer* printer, const FieldDescriptor* field) {
      field_generators_.get(field).GenerateIsEqualCodeSource(printer);
  }


  void MessageGenerator::GenerateIsEqualOneExtensionRangeSource(
    io::Printer* printer, const Descriptor::ExtensionRange* range) {
      printer->Print(
        "lhs.isEqualExtensionsInOther(rhs, startInclusive:Int32($from$), endExclusive:Int32($to$))",
        "from", SimpleItoa(range->start), "to", SimpleItoa(range->end));
  }


  void MessageGenerator::GenerateHashOneFieldSource(
    io::Printer* printer, const FieldDescriptor* field) {
      field_generators_.get(field).GenerateHashCodeSource(printer);
  }


  void MessageGenerator::GenerateHashOneExtensionRangeSource(
    io::Printer* printer, const Descriptor::ExtensionRange* range) {
      printer->Print(
        "hashCode = (hashCode &* 31) &+ Int(hashExtensionsFrom(Int32($from$), endExclusive:Int32($to$)))\n",
        "from", SimpleItoa(range->start), "to", SimpleItoa(range->end));
  }


  void MessageGenerator::GenerateBuilderSource(io::Printer* printer) {

      if (descriptor_->extension_range_count() > 0) {
          printer->Print(
                         "final class $classname$Builder : ExtendableMessageBuilder {\n",
                         "classname", UnderscoresToCapitalizedCamelCase(descriptor_->name()));
      } else {
          printer->Print(
                         "final class $classname$Builder : GeneratedMessageBuilder {\n",
                         "classname", UnderscoresToCapitalizedCamelCase(descriptor_->name()));
      }

    printer->Indent();
     
    printer->Print(
      "private var builderResult:$classname$\n\n"
      "required override init () {\n"
      "   builderResult = $classname$()\n"
      "   super.init()\n"
      "}\n",
      "classname", ClassName(descriptor_));
      for (int i = 0; i < descriptor_->field_count(); i++) {
          field_generators_.get(descriptor_->field(i)).GenerateBuilderMembersSource(printer);
      }

    GenerateCommonBuilderMethodsSource(printer);
    GenerateBuilderParsingMethodsSource(printer);
    printer->Outdent();



    printer->Print("}\n\n");
  }


  void MessageGenerator::GenerateCommonBuilderMethodsSource(io::Printer* printer) {
    if (descriptor_->extension_range_count() > 0) {
      printer->Print(
      "override var internalGetResult:ExtendableMessage {\n"
      "     get {\n"
      "         return builderResult\n"
      "     }\n"
      "}\n");
    } else {
        printer->Print(
       "override var internalGetResult:GeneratedMessage {\n"
       "     get {\n"
       "        return builderResult\n"
       "     }\n"
       "}\n");
    }

    printer->Print(
      "override func clear() -> $classname$Builder {\n"
      "  builderResult = $classname$()\n"
      "  return self\n"
      "}\n"
      "override func clone() -> $classname$Builder {\n"
      "  return $classname$.builderWithPrototype(builderResult)\n"
      "}\n",
      "classname", ClassName(descriptor_));

    printer->Print(
      "func build() -> $classname$ {\n"
      "     checkInitialized()\n"
      "     return buildPartial()\n"
      "}\n"
      "func buildPartial() -> $classname$ {\n",
      "classname", ClassName(descriptor_));
    

    for (int i = 0; i < descriptor_->field_count(); i++) {
      field_generators_.get(descriptor_->field(i)).GenerateBuildingCodeSource(printer);
    }

    
    printer->Print(
      "  var returnMe:$classname$ = builderResult\n"
      "  return returnMe\n"
      "}\n",
      "classname", ClassName(descriptor_));

    printer->Print(
      "func mergeFrom(other:$classname$) -> $classname$Builder {\n"
      // Optimization:  If other is the default instance, we know none of its
      //   fields are set so we can skip the merge.
      "  if (other == $classname$()) {\n"
      "    return self\n"
      "  }\n",
      "classname", ClassName(descriptor_));
    

    for (int i = 0; i < descriptor_->field_count(); i++) {
      field_generators_.get(descriptor_->field(i)).GenerateMergingCodeSource(printer);
    }

    

    if (descriptor_->extension_range_count() > 0) {
      printer->Print(
        "  mergeExtensionFields(other)\n");
    }

    printer->Print(
      "    mergeUnknownFields(other.unknownFields)\n"
      "  return self\n"
      "}\n");
  }

    //////////////////////////////////////////////////////////

  void MessageGenerator::GenerateBuilderParsingMethodsSource(io::Printer* printer) {
    scoped_array<const FieldDescriptor*> sorted_fields(
      SortFieldsByNumber(descriptor_));


    printer->Print(
      "override func mergeFromCodedInputStream(input:CodedInputStream) ->$classname$Builder {\n"
      "     return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())\n"
      "}\n"
      "override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> $classname$Builder {\n",
      "classname", ClassName(descriptor_));
    
    printer->Indent();
    printer->Print(
      "var unknownFieldsBuilder:UnknownFieldSetBuilder = UnknownFieldSet.builderWithUnknownFields(self.unknownFields)\n"
      "while (true) {\n");
    printer->Indent();
    printer->Print(
      "var tag = input.readTag()\n"
      "switch tag {\n");
    
     printer->Print(
     "case 0: \n");
     printer->Indent();
     printer->Print(
      "self.unknownFields = unknownFieldsBuilder.build()\n"
      "return self\n"
      "\n"
     );
    printer->Outdent();
    for (int i = 0; i < descriptor_->field_count(); i++) {
      const FieldDescriptor* field = sorted_fields[i];
      uint32 tag = WireFormatLite::MakeTag(field->number(),
        WireFormat::WireTypeForField(field));

      printer->Print(
        "case $tag$ :\n",
        "tag", SimpleItoa(tag));
      
      printer->Indent();
      field_generators_.get(field).GenerateParsingCodeSource(printer);
      printer->Outdent();
      printer->Print("\n");
    }
     printer->Print(
                 "default:\n"
                 "  if (!parseUnknownField(input,unknownFields:unknownFieldsBuilder, extensionRegistry:extensionRegistry, tag:tag)) {\n"
                 "     unknownFields = unknownFieldsBuilder.build()\n"
                 "     return self\n"
                 "  }\n"
                 "}\n");

    
    
    printer->Outdent();
    printer->Print("}\n");
    printer->Outdent();
    printer->Print("}\n");
  }


  void MessageGenerator::GenerateIsInitializedSource(io::Printer* printer) {
    printer->Print(
      "override func isInitialized() -> Bool {\n");
      printer->Indent();
    // Check that all required fields in this message are set.
    // TODO(kenton):  We can optimize this when we switch to putting all the
    //   "has" fields into a single bitfield.
    for (int i = 0; i < descriptor_->field_count(); i++) {
      const FieldDescriptor* field = descriptor_->field(i);

      if (field->is_required()) {
        printer->Print(
          "if !has$capitalized_name$ {\n"
          "  return false\n"
          "}\n",
          "capitalized_name", UnderscoresToCapitalizedCamelCase(field));
      }
    }

    // Now check that all embedded messages are initialized.
    for (int i = 0; i < descriptor_->field_count(); i++) {
      const FieldDescriptor* field = descriptor_->field(i);
      if (field->cpp_type() == FieldDescriptor::CPPTYPE_MESSAGE &&
        HasRequiredFields(field->message_type())) {

          map<string,string> vars;
          vars["type"] = ClassName(field->message_type());
          vars["name"] = UnderscoresToCamelCase(field);
          vars["capitalized_name"] = UnderscoresToCapitalizedCamelCase(field);

          switch (field->label()) {
            case FieldDescriptor::LABEL_REQUIRED:
              printer->Print(vars,
                "if !$name$.isInitialized() {\n"
                "  return false\n"
                "}\n");
              break;
            case FieldDescriptor::LABEL_OPTIONAL:
              printer->Print(vars,
                "if has$capitalized_name$ {\n"
                " if !$name$.isInitialized() {\n"
                "   return false\n"
                " }\n"
                "}\n");
              break;
            case FieldDescriptor::LABEL_REPEATED:
              printer->Print(vars,
               "var isInit$name$:Bool = true\n"
               "for element in $name$ {\n"
               "    if (!element.isInitialized()) {\n"
               "        isInit$name$ = false\n"
               "        break \n"
               "    }\n"
               "}\n"
               "if !isInit$name$ {\n return isInit$name$\n }\n"
                );
              break;
          }
      }
    }

    if (descriptor_->extension_range_count() > 0) {
      printer->Print(
        "if !extensionsAreInitialized() {\n"
        " return false\n"
        "}\n");
    }

    printer->Outdent();
    printer->Print(
      " return true\n"
      "}\n");
  }
}  // namespace objectivec
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
