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

#ifndef swift_HELPERS_H
#define swift_HELPERS_H

#include <string>
#include <google/protobuf/descriptor.h>
#include <google/protobuf/descriptor.pb.h>

namespace google {
    namespace protobuf {
        namespace compiler {
            namespace swift {
                
             
                // Converts the field's name to camel-case, e.g. "foo_bar_baz" becomes
                // "fooBarBaz" or "FooBarBaz", respectively.
                string UnderscoresToCamelCase(const FieldDescriptor* field);
                string UnderscoresToCapitalizedCamelCase(const FieldDescriptor* field);
                string UnderscoresToCapitalizedCamelCase(const string& name);
                
                // Similar, but for method names.  (Typically, this merely has the effect
                // of lower-casing the first letter of the name.)
                string UnderscoresToCamelCase(const MethodDescriptor* method);
                
                // Apply CamelCase-formatting to the given filename string.  Existing
                // capitalization is not modified, but non-alphanumeric characters are
                // removed and the following legal character is capitalized.
                string FilenameToCamelCase(const string& filename);
                
                // Strips ".proto" or ".protodevel" from the end of a filename.
                string StripProto(const string& filename);
                
                // Returns true if the name requires a ns_returns_not_retained attribute applied
                // to it.
                
                bool isPackedTypeProto3(const FieldDescriptor* field);
                
                //Packages
                vector<string> FullNameSplit(const FileDescriptor* file);
                string FullName(const FileDescriptor* file);
                string FullName(const vector<string> splitVector);
                string PackageName(const Descriptor* descriptor);
                string PackageName(const EnumDescriptor* descriptor);
                string PackageExtensionName(const vector<string> splitVector);
                ///
                
                bool IsBootstrapFile(const FileDescriptor* file);
                bool IsBootstrapPackage(const string& package);
                
                bool isCompileForFramework(const FileDescriptor* file);
                
                string GetAccessControlType(const FileDescriptor* file);
                
                string GetAccessControlTypeForFields(const FileDescriptor* file);
                
                // Gets the name of the file we're going to generate (sans the .proto.swift
                // extension).  This does not include the path to that file.
                string FileName(const FileDescriptor* file);
                string FileNameDescription(const FileDescriptor* file);
                // Gets the path of the file we're going to generate (sans the .proto.swift
                // extension).  The path will be dependent on the swift package
                // declared in the proto package.
                string FilePath(const FileDescriptor* file);
                
                // Gets the name of the root class we'll generate in the file.  This class
                // is not meant for external consumption, but instead contains helpers that
                // the rest of the the classes need
                string FileClassName(const FileDescriptor* file);
                string PackageFileName(const FileDescriptor* file);
                string ExtensionFileClassName(const FileDescriptor* file);
                // These return the fully-qualified class name corresponding to the given
                // descriptor.
                //
                
                // Enums class name and returned type
                string ClassName(const EnumDescriptor* descriptor);
                string ClassNameReturedType(const EnumDescriptor* descriptor);
                bool HasOptionForGenerateErrors(const EnumDescriptor* descriptor);
                bool HasOptionForGenerateErrors(const Descriptor* descriptor);
                //
                
                //Message
                string ClassName(const Descriptor* descriptor);
                string ClassNameReturedType(const Descriptor* descriptor);
                //
                
                //Maps
                string GetCapitalizedType(const FieldDescriptor* field);
                string MapKeyName(const FieldDescriptor* field);
                string MapValueName(const FieldDescriptor* field);
                //
                
//                string ClassNameEnum(const EnumDescriptor* descriptor);
                
//                string ClassName(const EnumDescriptor* descriptor);
                string ClassName(const ServiceDescriptor* descriptor);
                string ClassNameExtensions(const Descriptor* descriptor);
                string ClassNameOneof(const OneofDescriptor* descriptor);
                string EnumValueName(const EnumValueDescriptor* descriptor);
                
                string SafeName(const string& name);
                
                enum SwiftType {
                    SWIFTTYPE_INT,
                    SWIFTTYPE_LONG,
                    SWIFTTYPE_FLOAT,
                    SWIFTTYPE_DOUBLE,
                    SWIFTTYPE_BOOLEAN,
                    SWIFTTYPE_STRING,
                    SWIFTTYPE_DATA,
                    SWIFTTYPE_ENUM,
                    SWIFTTYPE_MESSAGE,
                    SWIFTTYPE_MAP
                };
                
                SwiftType GetSwiftType(const FieldDescriptor *field);
                
                
                const char* BoxedPrimitiveTypeName(SwiftType type);
                
                bool IsPrimitiveType(SwiftType type);
                bool IsReferenceType(SwiftType type);
                bool isOneOfField(const FieldDescriptor* descriptor);
                
                bool ReturnsPrimitiveType(const FieldDescriptor* field);
                bool ReturnsReferenceType(const FieldDescriptor* field);
                
                string DefaultValue(const FieldDescriptor* field);

                string BuildCommentsString(const SourceLocation& location);
                
                //const char* GetArrayValueType(const FieldDescriptor* field);
                
                // Escape C++ trigraphs by escaping question marks to \?
                string EscapeTrigraphs(const string& to_escape);
                string EscapeUnicode(const string& to_escape);
                
                // Do message classes in this file keep track of unknown fields?
                inline bool HasUnknownFields(const FileDescriptor *file) {
                    return file->options().optimize_for() != FileOptions::LITE_RUNTIME;
                }
                
                // Does this file have generated parsing, serialization, and other
                // standard methods for which reflection-based fallback implementations exist?
                inline bool HasGeneratedMethods(const FileDescriptor *file) {
                    return file->options().optimize_for() != FileOptions::CODE_SIZE;
                }
                
                // Do message classes in this file have descriptor and refelction methods?
                inline bool HasDescriptorMethods(const FileDescriptor *file) {
                    return file->options().optimize_for() != FileOptions::LITE_RUNTIME;
                }
                
                //JSON
                string JSONCastingValue(const FieldDescriptor* field);
                string FromJSONValue(const FieldDescriptor* field, string value);
                string FromJSONMapKeyValue(const FieldDescriptor* field, string value);
                string ToJSONValue(const FieldDescriptor* field, string value);
                string ToJSONValueRepeatedStorageType(const FieldDescriptor* field);
                
            }  // namespace swift
        }  // namespace compiler
    }  // namespace protobuf
}  // namespace google

#endif // swift_HELPERS_H
