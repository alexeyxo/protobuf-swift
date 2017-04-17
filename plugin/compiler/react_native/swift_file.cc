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
#include "swift_helpers_react.h"
#include "swift_react.h"
#include "swift_react_enums.h"

namespace google { namespace protobuf { namespace compiler { namespace swift {
    
    FileGenerator::FileGenerator(const FileDescriptor* file)
    : file_(file), classname_(PackageFileName(file)) {
        
    }
    
    
    FileGenerator::~FileGenerator() {
        
    }
    
    void FileGenerator::GenerateSource(io::Printer* printer) {
        FileGenerator file_generator(file_);

        GenerateImports(printer);
        for (int i = 0; i < file_->enum_type_count(); i++) {
            if (NeedGenerateReactType(file_->enum_type(i))) {
                ReactEnumGenerator(file_->enum_type(i)).GenerateSource(printer);
            }
        }
        
        for (int i = 0; i < file_->message_type_count(); i++) {
            if (NeedGenerateReactType(file_->message_type(i))) {
                ReactGenerator(file_->message_type(i)).GenerateSource(printer);
            }
        }
        
        printer->Print("\n""// @@protoc_insertion_point(global_scope)\n");
    }
    
    void FileGenerator::GenerateImports(io::Printer* printer) {
        for (int i = 0; i<file_->dependency_count(); i++) {
            const FileDescriptor *depFile = file_->dependency(i);
            string filepath = FilePath(depFile);
            string package_name;
            if (depFile->package() != "") {
                package_name = FullName(depFile);
            }
            package_name = package_name + UnderscoresToCapitalizedCamelCase(UnderscoresToCapitalizedCamelCase(filepath)) + ".proto";
            
            if (!IsDescriptorFile(depFile) && NeedGenerateReactFileClass(depFile)) {
                if (depFile->message_type_count() > 0) {
                    printer->Print("import {\n");
                    XCodeStandartIndent(printer);
                    for (int j = 0; j < depFile->message_type_count(); j++) {
                        ReactGenerator(depFile->message_type(j)).GenerateSourceImport(printer);
                        if (depFile->message_type_count() > j) {
                            if (NeedGenerateReactType(depFile->message_type(j))) {
                                printer->Print(",\n");
                            }
                        } else {
                            if (NeedGenerateReactType(depFile->message_type(j))) {
                                printer->Print("\n");
                            }
                        }
                    }
                    XCodeStandartOutdent(printer);
                    printer->Print("} from \'./$file$\'\n",
                                   "file",package_name);
                }
                
                if (depFile->enum_type_count()>0) {
                    printer->Print("import {\n");
                    XCodeStandartIndent(printer);
                    for (int j = 0; j < depFile->enum_type_count(); j++) {
                        ReactEnumGenerator(depFile->enum_type(j)).GenerateSourceImport(printer);
                        if (depFile->enum_type_count() > j) {
                            if (NeedGenerateReactType(depFile->enum_type(j))) {
                                printer->Print(",\n");
                            }
                        } else {
                            if (NeedGenerateReactType(depFile->enum_type(j))) {
                                printer->Print("\n");
                            }
                        }
                    }
                    printer->Print("} from \'./$file$\'\n",
                                   "file",package_name);
                    XCodeStandartOutdent(printer);
                }
            }
            
        }
    }
    
//    map<string,string> FileGenerator::CheckGenerateImport(const FileDescriptor *dep) {
//        map<string,string> packages;
//        for (int i = 0; i<dep->message_type_count(); i++) {
//            const Descriptor *depmessage = dep->message_type(i);
//            for (int i = 0; i<file_->message_type_count(); i++) {
//                const Descriptor *message = file_->message_type(i);
//                if (message->full_name() == depmessage->full_name()) {
//                    printer->Print(message->full_name()));
//                    packages[message->full_name()] = "generate";
//                }
//            }
//        }
//    }
    
    
}  // namespace swift
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
