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

#include "swift_file.h"

#include <google/protobuf/compiler/code_generator.h>
#include <google/protobuf/io/printer.h>
#include <google/protobuf/io/zero_copy_stream.h>
#include <google/protobuf/descriptor.pb.h>
#include <google/protobuf/stubs/strutil.h>

#include <sstream>
#include "swift_helpers.h"
#include "swift_helpers_realm.h"
#include "swift_realm.h"

namespace google { namespace protobuf { namespace compiler {namespace swift {
    
    FileGenerator::FileGenerator(const FileDescriptor* file)
    : file_(file), classname_(PackageFileName(file)) {
        
    }
    
    
    FileGenerator::~FileGenerator() {
        
    }
    
    void FileGenerator::GenerateSource(io::Printer* printer) {
        FileGenerator file_generator(file_);

        for (int i = 0; i < file_->message_type_count(); i++) {
            if (NeedGenerateRealmClass(file_->message_type(i))) {
                RealmGenerator(file_->message_type(i)).GenerateSource(printer);
            }
        }
        printer->Print("\n""// @@protoc_insertion_point(global_scope)\n");
    }
    
    
}  // namespace swift
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
