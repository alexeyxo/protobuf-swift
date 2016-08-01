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

#ifndef swift_MESSAGE_H
#define swift_MESSAGE_H

#include <string>
#include <map>
#include <set>
#include <google/protobuf/stubs/common.h>

#include "swift_field.h"

namespace google {
    namespace protobuf {
        namespace io {
            class Printer;             // printer.h
        }
    }
    
    namespace protobuf {
        namespace compiler {
            namespace swift {
                
                class MessageGenerator {
                public:
                    explicit MessageGenerator(const Descriptor* descriptor);
                    ~MessageGenerator();
                    
                    void GenerateStaticVariablesInitialization(io::Printer* printer);
                    void GenerateStaticVariablesSource(io::Printer* printer);
                    void GenerateSource(io::Printer* printer);
                    void GenerateMessageIsEqualSource(io::Printer* printer);
                    void GenerateExtensionRegistrationSource(io::Printer* printer);
                    void DetermineDependencies(set<string>* dependencies);
                    void GenerateGlobalStaticVariablesSource(io::Printer* printer, string rootclass);
                    void GenerateParseFromMethodsSource(io::Printer* printer);
                private:
                    
                    void GenerateMessageSerializationMethodsSource(io::Printer* printer);
                    
                    void GenerateSerializeOneFieldSource(io::Printer* printer,
                                                         const FieldDescriptor* field);
                    void GenerateSerializeOneExtensionRangeSource(
                                                                  io::Printer* printer, const Descriptor::ExtensionRange* range);
                    
                    void GenerateMessageDescriptionSource(io::Printer* printer);
                    
                    void GenerateMessageJSONSource(io::Printer* printer);
                    
                    void GenerateMessageBuilderJSONSource(io::Printer* printer);
                    
                    void GenerateDescriptionOneFieldSource(io::Printer* printer,
                                                           const FieldDescriptor* field);
                    void GenerateDescriptionOneExtensionRangeSource(
                                                                    io::Printer* printer, const Descriptor::ExtensionRange* range);
                    
                    
                    void GenerateIsEqualOneFieldSource(io::Printer* printer,
                                                       const FieldDescriptor* field);
                    void GenerateIsEqualOneExtensionRangeSource(
                                                                io::Printer* printer, const Descriptor::ExtensionRange* range);
                    
                    void GenerateMessageHashSource(io::Printer* printer);
                    void GenerateHashOneFieldSource(io::Printer* printer,
                                                    const FieldDescriptor* field);
                    void GenerateHashOneExtensionRangeSource(
                                                             io::Printer* printer, const Descriptor::ExtensionRange* range);
                    
                    void GenerateBuilderSource(io::Printer* printer);
                    void GenerateCommonBuilderMethodsSource(io::Printer* printer);
                    void GenerateBuilderParsingMethodsSource(io::Printer* printer);
                    void GenerateIsInitializedSource(io::Printer* printer);
                    
                    const Descriptor* descriptor_;
                    FieldGeneratorMap field_generators_;

                    map<string, string> variables_;
                    
                    GOOGLE_DISALLOW_EVIL_CONSTRUCTORS(MessageGenerator);
        

                    

                };
            }  // namespace swift
        }  // namespace compiler
    }  // namespace protobuf
}  // namespace google

#endif // swift_MESSAGE_H
