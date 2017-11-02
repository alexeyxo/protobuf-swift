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

#ifndef swift_HELPERS_REACT_H
#define swift_HELPERS_REACT_H

#include <string>
#include <google/protobuf/descriptor.h>
#include <google/protobuf/descriptor.pb.h>
#include <google/protobuf/io/printer.h>

#define SWIFT_PROTOBUF_VERSION "4.0.0"

namespace google {
    namespace protobuf {
        namespace compiler {
            namespace swift {
               
                //React
                string ClassNameReact(const Descriptor* descriptor);
                string ClassNameReact(const FieldDescriptor* descriptor);
                string ClassNameReact(const EnumDescriptor* descriptor);
                string ClassNameReactWorker(const Descriptor* descriptor);
                string ClassNameWorkers(const Descriptor* descriptor);
                
                string ClassNameReactReturnType(const Descriptor* descriptor);
                string ClassNameReactReturnType(const FieldDescriptor* descriptor);
                string ClassNameReactReturnType(const EnumDescriptor* descriptor);
                
                bool NeedGenerateReactFileClass(const FileDescriptor* message);
                bool NeedGenerateReactType(const Descriptor* message);
                bool NeedGenerateReactType(const EnumDescriptor* message);
//                bool NeedGenerateRealmFileClass(const FileDescriptor* file);
//                bool NeedGenerateRealmClass(const Descriptor* message);
//                
//                string RealmPrimaryKey(const Descriptor* message);
//                string RealmIndexedProperties(const Descriptor* message);
                string PrimitiveTypeReact(const FieldDescriptor* field);
//                string PrimitiveTypeRealmOptional(const FieldDescriptor* field);
//                string PrimitiveTypeCastingRealm(const FieldDescriptor* field);
//                string PrimitiveTypeCastingRealmRepresent(const FieldDescriptor* field);
//                string PrimitiveTypeRealmOptionalVariable(const FieldDescriptor* field);
                string DefaultValueReact(const FieldDescriptor* field);
                //
                
            }  // namespace swift
        }  // namespace compiler
    }  // namespace protobuf
}  // namespace google

#endif // swift_HELPERS_REACT_H
