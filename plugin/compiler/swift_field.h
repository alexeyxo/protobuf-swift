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

#ifndef swift_FIELD_H
#define swift_FIELD_H

#include <string>
#include <google/protobuf/stubs/common.h>
#include <google/protobuf/descriptor.h>

namespace google {
    namespace protobuf {
        namespace io {
            class Printer;             // printer.h
        }
    }
    
    namespace protobuf {
        namespace compiler {
            namespace swift {
                
                class FieldGenerator {
                public:
                    FieldGenerator() {}
                    virtual ~FieldGenerator();
                    
                    virtual void GenerateExtensionSource(io::Printer* printer) const = 0;
                    virtual void GenerateVariablesSource(io::Printer* printer) const = 0;
                    virtual void GenerateSubscript(io::Printer* printer) const = 0;
                    virtual void GenerateSetSubscript(io::Printer* printer) const = 0;
                    virtual void GenerateInitializationSource(io::Printer* printer) const = 0;
                    virtual void GenerateMembersSource(io::Printer* printer) const = 0;
                    virtual void GenerateBuilderMembersSource(io::Printer* printer) const = 0;
                    virtual void GenerateMergingCodeSource(io::Printer* printer) const = 0;
                    virtual void GenerateBuildingCodeSource(io::Printer* printer) const = 0;
                    virtual void GenerateParsingCodeSource(io::Printer* printer) const = 0;
                    virtual void GenerateSerializationCodeSource(io::Printer* printer) const = 0;
                    virtual void GenerateSerializedSizeCodeSource(io::Printer* printer) const = 0;
                    virtual void GenerateDescriptionCodeSource(io::Printer* printer) const = 0;
                    virtual void GenerateJSONEncodeCodeSource(io::Printer* printer) const = 0;
                    virtual void GenerateJSONDecodeCodeSource(io::Printer* printer) const = 0;
                    virtual void GenerateIsEqualCodeSource(io::Printer* printer) const = 0;
                    virtual void GenerateHashCodeSource(io::Printer* printer) const = 0;
                    
                private:
                    GOOGLE_DISALLOW_EVIL_CONSTRUCTORS(FieldGenerator);
                };
                
                // Convenience class which constructs FieldGenerators for a Descriptor.
                class FieldGeneratorMap {
                public:
                    explicit FieldGeneratorMap(const Descriptor* descriptor);
                    ~FieldGeneratorMap();
                    
                    const FieldGenerator& get(const FieldDescriptor* field) const;
                    const FieldGenerator& get_extension(int index) const;
                    
                private:
                    const Descriptor* descriptor_;
                    std::unique_ptr<std::unique_ptr<FieldGenerator>[]> field_generators_;
                    std::unique_ptr<std::unique_ptr<FieldGenerator>[]> extension_generators_;
                    std::unique_ptr<std::unique_ptr<FieldGenerator>[]> oneof_generators_;
                    
                    static FieldGenerator* MakeGenerator(const FieldDescriptor* field);
                    
                    GOOGLE_DISALLOW_EVIL_CONSTRUCTORS(FieldGeneratorMap);
                };
            }  // namespace swift
        }  // namespace compiler
    }  // namespace protobuf
}  // namespace google

#endif // swift_FIELD_H
