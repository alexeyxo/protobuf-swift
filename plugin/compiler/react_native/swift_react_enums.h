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

#ifndef swift_REACT_ENUM_H
#define swift_REACT_ENUM_H

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
                
                class ReactEnumGenerator {
                public:
                    explicit ReactEnumGenerator(const EnumDescriptor* descriptor);
                    ~ReactEnumGenerator();
    
                    void GenerateSource(io::Printer* printer);
                    void GenerateSourceImport(io::Printer* printer);
                    
                    const EnumDescriptor* descriptor_;

                    std::map<string, string> variables_;
                    
                    GOOGLE_DISALLOW_EVIL_CONSTRUCTORS(ReactEnumGenerator);
        
                private:
                  
                };
            }  // namespace swift
        }  // namespace compiler
    }  // namespace protobuf
}  // namespace google

#endif // swift_REACT_ENUM_H
