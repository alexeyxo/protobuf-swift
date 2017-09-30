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
#include "swift_helpers_react.h"
#include <limits>
#include <vector>

#include <google/protobuf/stubs/hash.h>
#include <google/protobuf/descriptor.pb.h>
#include <google/protobuf/stubs/strutil.h>
#include "google/protobuf/swift-descriptor.pb.h"
#include "swift_helpers.h"


namespace google { namespace protobuf { namespace compiler { namespace swift {
    using namespace std;
    
    string DefaultValueReact(const FieldDescriptor* field) {
        
        switch (field->cpp_type()) {
            case FieldDescriptor::CPPTYPE_INT32:  return SimpleItoa(field->default_value_int32());
            case FieldDescriptor::CPPTYPE_UINT32: return SimpleItoa(field->default_value_uint32());
            case FieldDescriptor::CPPTYPE_INT64:  return SimpleItoa(field->default_value_int64());
            case FieldDescriptor::CPPTYPE_UINT64: return SimpleItoa(field->default_value_uint64());
            case FieldDescriptor::CPPTYPE_BOOL:   return field->default_value_bool() ? "true" : "false";
            case FieldDescriptor::CPPTYPE_DOUBLE: {
                const double value = field->default_value_double();
                if (value == numeric_limits<double>::infinity()) {
                    return "Double(HUGE)";
                } else if (value == -numeric_limits<double>::infinity()) {
                    return "Double(-HUGE)";
                } else if (value != value) {
                    return "0.0";
                } else {
                    return SimpleDtoa(field->default_value_double());
                }
            }
            case FieldDescriptor::CPPTYPE_FLOAT: {
                const float value = field->default_value_float();
                if (value == numeric_limits<float>::infinity()) {
                    return "HUGE";
                } else if (value == -numeric_limits<float>::infinity()) {
                    return "-HUGE";
                } else if (value != value) {
                    return "0.0";
                } else {
                    return SimpleFtoa(value);
                }
            }
            case FieldDescriptor::CPPTYPE_STRING:
                if (field->type() == FieldDescriptor::TYPE_BYTES) {
                    if (field->has_default_value()) {
                        return
                        "Data(bytes:([UInt8]() + \"" + CEscape(field->default_value_string()) + "\".utf8), count:" + SimpleItoa(field->default_value_string().length()) + ")";
                    } else {
                        return "Data()";
                    }
                } else {
                    if (AllAscii(field->default_value_string())) {
                        return "\"" + EscapeTrigraphs(CEscape(EscapeUnicode(field->default_value_string()))) + "\"";
                    } else {
                        return "\"" + EscapeTrigraphs(CEscape(EscapeUnicode(field->default_value_string()))) + "\"";
                    }
                }
            case FieldDescriptor::CPPTYPE_ENUM:
                return EnumValueName(field->default_value_enum());
                
            case FieldDescriptor::CPPTYPE_MESSAGE:
            {
                if (field->is_map()) {
                    
                    const FieldDescriptor* key_descriptor = field->message_type()->FindFieldByName("key");
                    const FieldDescriptor* value_descriptor = field->message_type()->FindFieldByName("value");
                    return "Dictionary<" + MapKeyName(key_descriptor) + "," + MapValueName(value_descriptor) + ">()";
                }
                
                return ClassNameReturedType(field->message_type()) + "()";
            }
        }
        
        GOOGLE_LOG(FATAL) << "Can't get here.";
        return "";
    }
    
    string ClassNameReact(const Descriptor* descriptor) {
        string name = "";
        if (descriptor->containing_type() != NULL) {
            name += ClassNameReactWorker(descriptor->containing_type());
            name += "_";
        }
        string className = FileClassPrefix(descriptor->file());
        className += UnderscoresToCapitalizedCamelCase(descriptor->name());
        return SafeName(name + SafeName(className));
    }
    string ClassNameReact(const EnumDescriptor* descriptor) {
        string name = "";
        if (descriptor->containing_type() != NULL) {
            name += ClassNameReactWorker(descriptor->containing_type());
            name += "_";
        }
        string className = FileClassPrefix(descriptor->file());
        className += UnderscoresToCapitalizedCamelCase(descriptor->name());
        return SafeName(name + SafeName(className));
    }
    
    string ClassNameReact(const FieldDescriptor* descriptor) {
        string name = "";
        if (descriptor->containing_type() != NULL) {
            name += ClassNameReactWorker(descriptor->containing_type());
            name += "_";
        }
        string className = FileClassPrefix(descriptor->file());
        className += UnderscoresToCapitalizedCamelCase(descriptor->name());
        return SafeName(name + SafeName(className));
    }
    
    string ClassNameReactReturnType(const Descriptor* descriptor) {
        string name = "";
        if (descriptor->containing_type() != NULL) {
            name += ClassNameWorkers(descriptor->containing_type());
            name += ".";
        }
        string className = FileClassPrefix(descriptor->file());
        className += UnderscoresToCapitalizedCamelCase(descriptor->name());
        return SafeName(name + SafeName(className));
    }
    string ClassNameReactReturnType(const EnumDescriptor* descriptor) {
        string name = "";
        if (descriptor->containing_type() != NULL) {
            name += ClassNameWorkers(descriptor->containing_type());
            name += ".";
        }
        string className = FileClassPrefix(descriptor->file());
        className += UnderscoresToCapitalizedCamelCase(descriptor->name());
        return SafeName(name + SafeName(className));
    }
    
    string ClassNameReactReturnType(const FieldDescriptor* descriptor) {
        string name = "";
        if (descriptor->containing_type() != NULL) {
            name += ClassNameWorkers(descriptor->containing_type());
            name += ".";
        }
        string className = FileClassPrefix(descriptor->file());
        className += UnderscoresToCapitalizedCamelCase(descriptor->name());
        return SafeName(name + SafeName(className));
    }
    
    ////Workers
    
    string ClassNameReactWorker(const Descriptor* descriptor) {
        string name = "";
        if (descriptor->containing_type() != NULL) {
            name += ClassNameWorkers(descriptor->containing_type());
            name += "_";
        }
        name += FileClassPrefix(descriptor->file());
        name += UnderscoresToCapitalizedCamelCase(descriptor->name());
        return SafeName(name);
    }
    
    string ClassNameWorkers(const Descriptor* descriptor) {
        string name = "";
        if (descriptor->containing_type() != NULL) {
            name += ClassNameWorkers(descriptor->containing_type());
            name += "_";
        }
        name += FileClassPrefix(descriptor->file());
        name += UnderscoresToCapitalizedCamelCase(descriptor->name());
        return SafeName(name);
    }
    ////
    
    bool NeedGenerateReactFileClass(const FileDescriptor* file) {
        if (file->options().HasExtension(swift_file_options)) {
            SwiftFileOptions options = file->options().GetExtension(swift_file_options);
            return options.generate_react();
        }
        for (int i = 0; i < file->message_type_count(); i++) {
            if (NeedGenerateReactType(file->message_type(i))) {
                return true;
            }
        }
        for (int i = 0; i < file->enum_type_count(); i++) {
            if (NeedGenerateReactType(file->enum_type(i))) {
                return true;
            }
        }
        return false;
    }
    

//
    bool NeedGenerateReactType(const Descriptor* message) {
        if  (message->containing_type() != NULL) {
            return NeedGenerateReactType(message->containing_type());
        }
        if (message->options().HasExtension(swift_message_options)) {
            SwiftMessageOptions options = message->options().GetExtension(swift_message_options);
            return options.generate_react();
        }
        return false;
    }
    bool NeedGenerateReactType(const EnumDescriptor* message) {
        if  (message->containing_type() != NULL) {
            return NeedGenerateReactType(message->containing_type());
        }
        if (message->options().HasExtension(swift_enum_options)) {
            SwiftEnumOptions options = message->options().GetExtension(swift_enum_options);
            return options.generate_react();
        }
        return false;
    }

    string PrimitiveTypeReact(const FieldDescriptor* field) {
        switch (field->type()) {
            case FieldDescriptor::TYPE_INT32   : return "number" ;
            case FieldDescriptor::TYPE_UINT32  : return "number";
            case FieldDescriptor::TYPE_SINT32  : return "number" ;
            case FieldDescriptor::TYPE_FIXED32 : return "number";
            case FieldDescriptor::TYPE_SFIXED32: return "number" ;
                
            case FieldDescriptor::TYPE_INT64   : return "number" ;
            case FieldDescriptor::TYPE_UINT64  : return "number";
            case FieldDescriptor::TYPE_SINT64  : return "number";
            case FieldDescriptor::TYPE_FIXED64 : return "number";
            case FieldDescriptor::TYPE_SFIXED64: return "number";
                
            case FieldDescriptor::TYPE_FLOAT   : return "number" ;
            case FieldDescriptor::TYPE_DOUBLE  : return "number";
            case FieldDescriptor::TYPE_BOOL    : return "boolean"  ;
            case FieldDescriptor::TYPE_STRING  : return "string";
            case FieldDescriptor::TYPE_BYTES   : return "string"  ;
            default                            : return NULL;
        }
        
        GOOGLE_LOG(FATAL) << "Can't get here.";
        return NULL;
    }
//
//    string PrimitiveTypeRealmOptional(const FieldDescriptor* field) {
//        switch (field->type()) {
//            case FieldDescriptor::TYPE_INT32   :
//            case FieldDescriptor::TYPE_UINT32  :
//            case FieldDescriptor::TYPE_SINT32  :
//            case FieldDescriptor::TYPE_FIXED32 :
//            case FieldDescriptor::TYPE_SFIXED32:
//                
//            case FieldDescriptor::TYPE_INT64   :
//            case FieldDescriptor::TYPE_UINT64  :
//            case FieldDescriptor::TYPE_SINT64  :
//            case FieldDescriptor::TYPE_FIXED64 :
//            case FieldDescriptor::TYPE_SFIXED64: return "RealmOptional<Int>";
//            case FieldDescriptor::TYPE_FLOAT   : return "RealmOptional<Float>";
//            case FieldDescriptor::TYPE_DOUBLE  : return "RealmOptional<Double>";
//            case FieldDescriptor::TYPE_BOOL    : return "RealmOptional<Bool>";
//            case FieldDescriptor::TYPE_STRING  : return "String";
//            case FieldDescriptor::TYPE_BYTES   : return "Data"  ;
//            default                            : return NULL;
//        }
//        
//        GOOGLE_LOG(FATAL) << "Can't get here.";
//        return NULL;
//    }
//    
//    string PrimitiveTypeCastingRealm(const FieldDescriptor* field) {
//        string results = "";
//        switch (field->type()) {
//            case FieldDescriptor::TYPE_INT32   :
//            case FieldDescriptor::TYPE_UINT32  :
//            case FieldDescriptor::TYPE_SINT32  :
//            case FieldDescriptor::TYPE_FIXED32 :
//            case FieldDescriptor::TYPE_SFIXED32:
//                
//            case FieldDescriptor::TYPE_INT64   :
//            case FieldDescriptor::TYPE_UINT64  :
//            case FieldDescriptor::TYPE_SINT64  :
//            case FieldDescriptor::TYPE_FIXED64 :
//            case FieldDescriptor::TYPE_SFIXED64:
//                if (field->is_optional()) {
//                    return ".value = Int(proto." + UnderscoresToCamelCase(field) + ")";
//                }
//                return " = Int(proto." + UnderscoresToCamelCase(field) + ")";
//            case FieldDescriptor::TYPE_FLOAT   :
//            case FieldDescriptor::TYPE_DOUBLE  :
//            case FieldDescriptor::TYPE_BOOL    :
//                if (field->is_optional()) {
//                    return ".value = proto." + UnderscoresToCamelCase(field);
//                }
//                return " = proto." + UnderscoresToCamelCase(field);
//            case FieldDescriptor::TYPE_STRING  :
//                return " = proto." + UnderscoresToCamelCase(field);
//            case FieldDescriptor::TYPE_BYTES   :
//                return " = proto." + UnderscoresToCamelCase(field);
//            default                            : return NULL;
//        }
//        
//        GOOGLE_LOG(FATAL) << "Can't get here.";
//        return NULL;
//    }
//    
//    string PrimitiveTypeCastingRealmRepresent(const FieldDescriptor* field) {
//        string results = "";
//        switch (field->type()) {
//            case FieldDescriptor::TYPE_INT32   :
//            case FieldDescriptor::TYPE_UINT32  :
//            case FieldDescriptor::TYPE_SINT32  :
//            case FieldDescriptor::TYPE_FIXED32 :
//            case FieldDescriptor::TYPE_SFIXED32:
//                
//            case FieldDescriptor::TYPE_INT64   :
//            case FieldDescriptor::TYPE_UINT64  :
//            case FieldDescriptor::TYPE_SINT64  :
//            case FieldDescriptor::TYPE_FIXED64 :
//            case FieldDescriptor::TYPE_SFIXED64:
//                if (field->is_optional()) {
//                    return ".value";
//                }
//                return "";
//            case FieldDescriptor::TYPE_FLOAT   :
//            case FieldDescriptor::TYPE_DOUBLE  :
//            case FieldDescriptor::TYPE_BOOL    :
//                if (field->is_optional()) {
//                    return ".value";
//                }
//                return "";
//            case FieldDescriptor::TYPE_STRING  :
//                return "";
//            case FieldDescriptor::TYPE_BYTES   :
//                return "";
//            default                            : return NULL;
//        }
//        
//        GOOGLE_LOG(FATAL) << "Can't get here.";
//        return NULL;
//    }
//    
//    
//    string PrimitiveTypeRealmOptionalVariable(const FieldDescriptor* field) {
//        string defaultValue = "()";
//        if (field->has_default_value()) {
//            defaultValue = DefaultValueRealm(field);
//            defaultValue = "(" + defaultValue + ")";
//        }
//        switch (field->type()) {
//            case FieldDescriptor::TYPE_INT32   :
//            case FieldDescriptor::TYPE_UINT32  :
//            case FieldDescriptor::TYPE_SINT32  :
//            case FieldDescriptor::TYPE_FIXED32 :
//            case FieldDescriptor::TYPE_SFIXED32:
//                
//            case FieldDescriptor::TYPE_INT64   :
//            case FieldDescriptor::TYPE_UINT64  :
//            case FieldDescriptor::TYPE_SINT64  :
//            case FieldDescriptor::TYPE_FIXED64 :
//                
//                
//            case FieldDescriptor::TYPE_SFIXED64:
//                return "let " + UnderscoresToCamelCase(field) +  ":" + PrimitiveTypeRealmOptional(field) + " = " + PrimitiveTypeRealmOptional(field) + defaultValue;
//            case FieldDescriptor::TYPE_FLOAT   :
//                return "let " + UnderscoresToCamelCase(field) +  ":" + PrimitiveTypeRealmOptional(field) + " = " + PrimitiveTypeRealmOptional(field) + defaultValue;
//            case FieldDescriptor::TYPE_DOUBLE  :
//                return "let " + UnderscoresToCamelCase(field) +  ":" + PrimitiveTypeRealmOptional(field) + " = " + PrimitiveTypeRealmOptional(field) + defaultValue;
//            case FieldDescriptor::TYPE_BOOL    :
//                return "let " + UnderscoresToCamelCase(field) +  ":" + PrimitiveTypeRealmOptional(field) + " = " + PrimitiveTypeRealmOptional(field) + defaultValue;
//            case FieldDescriptor::TYPE_STRING  :
//                if (defaultValue == "()") {
//                    defaultValue = "nil";
//                }
//                return "dynamic var " + UnderscoresToCamelCase(field) + ":" +PrimitiveTypeRealmOptional(field) + "? = " + defaultValue;
//            case FieldDescriptor::TYPE_BYTES   :
//                if (defaultValue == "()") {
//                    defaultValue = "nil";
//                }
//                return "dynamic var " + UnderscoresToCamelCase(field) + ":" + PrimitiveTypeRealmOptional(field) + "? = " + defaultValue;
//            default                            :
//                return NULL;
//        }
//        
//        GOOGLE_LOG(FATAL) << "Can't get here.";
//        return NULL;
//    }

}  // namespace swift
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
