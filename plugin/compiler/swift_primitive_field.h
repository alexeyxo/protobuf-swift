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

#ifndef SWIFT_PRIMITIVE_FIELD_H
#define SWIFT_PRIMITIVE_FIELD_H

#include <map>
#include <string>
#include <google/protobuf/descriptor.h>
#include "swift_field.h"
namespace google {
    namespace protobuf {
        namespace compiler {
            namespace swift {
                
                class PrimitiveFieldGenerator : public FieldGenerator {
                public:
                    explicit PrimitiveFieldGenerator(const FieldDescriptor* descriptor);
                    ~PrimitiveFieldGenerator();
                    
                    void GenerateExtensionSource(io::Printer* printer) const;
                    void GenerateVariablesSource(io::Printer* printer) const;
                    void GenerateSubscript(io::Printer* printer) const;
                    void GenerateSetSubscript(io::Printer* printer) const;
                    void GenerateInitializationSource(io::Printer* printer) const;
                    void GenerateMembersSource(io::Printer* printer) const;
                    void GenerateBuilderMembersSource(io::Printer* printer) const;
                    void GenerateMergingCodeSource(io::Printer* printer) const;
                    void GenerateBuildingCodeSource(io::Printer* printer) const;
                    void GenerateParsingCodeSource(io::Printer* printer) const;
                    void GenerateSerializationCodeSource(io::Printer* printer) const;
                    void GenerateSerializedSizeCodeSource(io::Printer* printer) const;
                    void GenerateDescriptionCodeSource(io::Printer* printer) const;
                    void GenerateJSONEncodeCodeSource(io::Printer* printer) const;
                    void GenerateJSONDecodeCodeSource(io::Printer* printer) const;
                    void GenerateIsEqualCodeSource(io::Printer* printer) const;
                    void GenerateHashCodeSource(io::Printer* printer) const;
                    
                private:
                    const FieldDescriptor* descriptor_;
                    std::map<string, string> variables_;
                    
                    GOOGLE_DISALLOW_EVIL_CONSTRUCTORS(PrimitiveFieldGenerator);
                };
                
                class RepeatedPrimitiveFieldGenerator : public FieldGenerator {
                public:
                    explicit RepeatedPrimitiveFieldGenerator(const FieldDescriptor* descriptor);
                    ~RepeatedPrimitiveFieldGenerator();
                    
                    void GenerateExtensionSource(io::Printer* printer) const;
                    void GenerateVariablesSource(io::Printer* printer) const;
                    void GenerateSubscript(io::Printer* printer) const;
                    void GenerateSetSubscript(io::Printer* printer) const;
                    void GenerateInitializationSource(io::Printer* printer) const;
                    void GenerateMembersSource(io::Printer* printer) const;
                    void GenerateBuilderMembersSource(io::Printer* printer) const;
                    void GenerateMergingCodeSource(io::Printer* printer) const;
                    void GenerateBuildingCodeSource(io::Printer* printer) const;
                    void GenerateParsingCodeSource(io::Printer* printer) const;
                    void GenerateSerializationCodeSource(io::Printer* printer) const;
                    void GenerateSerializedSizeCodeSource(io::Printer* printer) const;
                    void GenerateDescriptionCodeSource(io::Printer* printer) const;
                    void GenerateJSONEncodeCodeSource(io::Printer* printer) const;
                    void GenerateJSONDecodeCodeSource(io::Printer* printer) const;
                    void GenerateIsEqualCodeSource(io::Printer* printer) const;
                    void GenerateHashCodeSource(io::Printer* printer) const;
                    
                private:
                    const FieldDescriptor* descriptor_;
                    std::map<string, string> variables_;
                    
                    GOOGLE_DISALLOW_EVIL_CONSTRUCTORS(RepeatedPrimitiveFieldGenerator);
                };
            }  // namespace swift
        }  // namespace compiler
    }  // namespace protobuf
}  // namespace google

#endif // SWIFT_PRIMITIVE_FIELD_H
