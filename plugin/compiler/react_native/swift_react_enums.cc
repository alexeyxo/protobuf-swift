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

#include "swift_react_enums.h"

#include <algorithm>
#include <google/protobuf/stubs/hash.h>
#include <google/protobuf/stubs/strutil.h>
#include <google/protobuf/io/printer.h>
#include <google/protobuf/io/coded_stream.h>
#include <google/protobuf/wire_format.h>
#include <google/protobuf/wire_format_lite_inl.h>
#include <google/protobuf/descriptor.pb.h>
#include "swift_helpers_react.h"
#include "swift_helpers.h"

namespace google { namespace protobuf { namespace compiler { namespace swift {
    
    using internal::WireFormat;
    using internal::WireFormatLite;
    
    namespace {
        
        void SetMapVariables(const EnumDescriptor* descriptor, std::map<string, string>* variables) {
            (*variables)["classNameReaсt"] = ClassNameReact(descriptor);
        }
        
    }  // namespace
    
    
    ReactEnumGenerator::ReactEnumGenerator(const EnumDescriptor* descriptor) : descriptor_(descriptor) {
        SetMapVariables(descriptor, &variables_);
    }
    
    
    ReactEnumGenerator::~ReactEnumGenerator() {
        
    }
    
    void ReactEnumGenerator::GenerateSourceImport(io::Printer* printer) {
        if (NeedGenerateReactType(descriptor_)) {
            printer->Print(variables_,"$classNameReaсt$");
        }
    }

    void ReactEnumGenerator::GenerateSource(io::Printer* printer) {

        printer->Print(variables_,"export const $classNameReaсt$ : Object = {\n");
        XCodeStandartIndent(printer);
        for (int i = 0; i < descriptor_->value_count(); i++) {
            const EnumValueDescriptor* value = descriptor_->value(i);
            const EnumValueDescriptor* canonical_value = descriptor_->FindValueByNumber(value->number());
            printer->Print("$canonicalName$: \'$canonicalName$\'",
                           "canonicalName", canonical_value->name());
            if (descriptor_->value_count() - 1 > i) {
                printer->Print(",\n");
            } else {
                printer->Print("\n");
            }
        }

        XCodeStandartOutdent(printer);
        printer->Print("}\n\n");
        
    }
    
}  // namespace swift
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
