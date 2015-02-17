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

#include "swift_generator.h"

#include <google/protobuf/io/printer.h>
#include <google/protobuf/io/zero_copy_stream.h>
#include <google/protobuf/descriptor.pb.h>
#include <google/protobuf/stubs/strutil.h>

#include "swift_file.h"
#include "swift_helpers.h"

namespace google { namespace protobuf { namespace compiler { namespace swift {
    SwiftGenerator::SwiftGenerator() {
    }


    SwiftGenerator::~SwiftGenerator() {
    }


    bool SwiftGenerator::Generate(const FileDescriptor* file,
                                  const string& parameter,
                                  GeneratorContext* generator_context,
                                  string* error) const {
        
        
//        static int ints = 0;
//        printf("\n\n\n\n %d fasdfasdgdasdgasdgasdg \n\n\n\n",ints);
//        ints++;
        
        static map<string, string> packages;
        
        vector< pair<string, string> > options;
        ParseGeneratorParameter(parameter, &options);

        for (int i = 0; i < options.size(); i++) {
            *error = "Unknown generator option: " + options[i].first;
            return false;
        }

        FileGenerator file_generator(file);

        string filepath = FilePath(file);
        {
            bool needToGeneratePackageStructs = false;
            string package_name;
            if (packages.find(file->package()) == packages.end()) {
                (packages[file->package()] = "generate");
                needToGeneratePackageStructs = true;
                
            }
            if (file->package() != "") {
                package_name = UnderscoresToCapitalizedCamelCase(file->package()) + "_";
            }
            
            scoped_ptr<io::ZeroCopyOutputStream> output(generator_context->Open(package_name + filepath + ".pb.swift"));
            io::Printer printer(output.get(), '$');
            file_generator.GenerateSource(&printer, needToGeneratePackageStructs);
        }

        return true;
    }

}  // namespace swift
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
