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

#ifndef swift_ONEOF_H
#define swift_ONEOF_H

#include <string>
#include <set>
#include <vector>
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
                
                class OneofGenerator {
                public:
                    explicit OneofGenerator(const OneofDescriptor* descriptor);
                    ~OneofGenerator();
                    
                    void GenerateSource(io::Printer* printer);
                    
                private:
                    const OneofDescriptor* descriptor_;
                    
                    GOOGLE_DISALLOW_EVIL_CONSTRUCTORS(OneofGenerator);
                };
                
            }  // namespace swift
        }  // namespace compiler
    }  // namespace protobuf
}  // namespace google

#endif // swift_ENUM_H
