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

#include "swift_enum.h"

#include <map>
#include <string>

#include <google/protobuf/io/printer.h>
#include <google/protobuf/descriptor.pb.h>
#include <google/protobuf/stubs/strutil.h>

#include "swift_helpers.h"

namespace google { namespace protobuf { namespace compiler { namespace swift {
    
    EnumGenerator::EnumGenerator(const EnumDescriptor* descriptor)
    : descriptor_(descriptor) {
        for (int i = 0; i < descriptor_->value_count(); i++) {
            const EnumValueDescriptor* value = descriptor_->value(i);
            const EnumValueDescriptor* canonical_value =
            descriptor_->FindValueByNumber(value->number());
            
            if (value == canonical_value) {
                canonical_values_.push_back(value);
            } else {
                Alias alias;
                alias.value = value;
                alias.canonical_value = canonical_value;
                aliases_.push_back(alias);
            }
        }
    }
    
    
    EnumGenerator::~EnumGenerator() {
    }
    
    
    
    
    void EnumGenerator::GenerateSource(io::Printer* printer) {
        printer->Print("\n\n//Enum type declaration start \n\n");

        SourceLocation location;
        if (descriptor_->GetSourceLocation(&location)) {
            string comments = BuildCommentsString(location);
            printer->Print(comments.c_str());
        }

        printer->Print("$acontrol$ enum $classname$:Int32 {\n",
                       "classname",ClassName(descriptor_),
                       "acontrol", GetAccessControlType(descriptor_->file()));
        
        printer->Indent();
        for (int i = 0; i < canonical_values_.size(); i++) {
            SourceLocation location;
            if (canonical_values_[i]->GetSourceLocation(&location)) {
                string comments = BuildCommentsString(location);
                if (comments.length() > 0) {
                    if (i > 0)
                        printer->Print("\n");
                    printer->Print(comments.c_str());
                }
            }

            printer->Print("case $name$ = $value$\n",
                           "name", EnumValueName(canonical_values_[i]),
                           "value", SimpleItoa(canonical_values_[i]->number()));
        }
        printer->Print("\n");
        
        printer->Outdent();
        printer->Print(
                       "}\n"
                       "\n");
        printer->Print("//Enum type declaration end \n\n");
    }
}  // namespace swift
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
