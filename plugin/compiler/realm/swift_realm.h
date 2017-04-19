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

#ifndef swift_REALM_H
#define swift_REALM_H

#include <string>
#include <map>
#include <set>
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
                
                class RealmGenerator {
                public:
                    explicit RealmGenerator(const Descriptor* descriptor);
                    ~RealmGenerator();
    
                    void GenerateSource(io::Printer* printer);
                    
                    const Descriptor* descriptor_;

                    map<string, string> variables_;
                    
                    GOOGLE_DISALLOW_EVIL_CONSTRUCTORS(RealmGenerator);
        
                private:
                    
                    void GeneratePrimaryKey(io::Printer* printer);
                    void GenerateIndexedProperties(io::Printer* printer);
                    void GeneratePrimitiveTypes(io::Printer* printer);
                    void GeneratePBToRealmExtension(io::Printer* printer);
                    void GenerateRealmRepresenterExtension(io::Printer* printer);
                    void GenerateStaticInnerTypes(io::Printer* printer, const Descriptor* field);
                  
                };
            }  // namespace swift
        }  // namespace compiler
    }  // namespace protobuf
}  // namespace google

#endif // swift_REALM_H
