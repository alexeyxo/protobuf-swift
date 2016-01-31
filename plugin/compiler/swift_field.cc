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

#include "swift_field.h"

#include <google/protobuf/stubs/common.h>
#include <map>
#include "swift_field.h"
#include "swift_helpers.h"
#include "swift_primitive_field.h"
#include "swift_map_field.h"
#include "swift_enum_field.h"
#include "swift_message_field.h"
#include "swift_map_field.h"

namespace google { namespace protobuf { namespace compiler { namespace swift {
    
    FieldGenerator::~FieldGenerator() {
    }
    
    
    FieldGeneratorMap::FieldGeneratorMap(const Descriptor* descriptor)
    : descriptor_(descriptor),
    field_generators_(new scoped_ptr<FieldGenerator>[descriptor->field_count()]),
    extension_generators_(new scoped_ptr<FieldGenerator>[descriptor->extension_count()]){
    
        
        for (int i = 0; i < descriptor->field_count(); i++) {
            field_generators_[i].reset(MakeGenerator(descriptor->field(i)));
        }
        for (int i = 0; i < descriptor->extension_count(); i++) {
            extension_generators_[i].reset(MakeGenerator(descriptor->extension(i)));
        }
        
    }
    
    
    FieldGenerator* FieldGeneratorMap::MakeGenerator(const FieldDescriptor* field) {
        if (field->is_repeated()) {
            switch (GetSwiftType(field)) {
                case SWIFTTYPE_MESSAGE:
                    return new RepeatedMessageFieldGenerator(field);
                case SWIFTTYPE_MAP:
                    return new MapFieldGenerator(field);
                case SWIFTTYPE_ENUM:
                    return new RepeatedEnumFieldGenerator(field);
                default:
                    return new RepeatedPrimitiveFieldGenerator(field);
            }
        } else {
            switch (GetSwiftType(field)) {
                case SWIFTTYPE_MESSAGE:
                    return new MessageFieldGenerator(field);
                case SWIFTTYPE_ENUM:
                    return new EnumFieldGenerator(field);
                default:
                    return new PrimitiveFieldGenerator(field);
            }
        }
    }
    
    
    FieldGeneratorMap::~FieldGeneratorMap() {
    }
    
    
    const FieldGenerator& FieldGeneratorMap::get(const FieldDescriptor* field) const {
        GOOGLE_CHECK_EQ(field->containing_type(), descriptor_);
        return *field_generators_[field->index()];
    }
    
    
    const FieldGenerator& FieldGeneratorMap::get_extension(int index) const {
        return *extension_generators_[index];
    }
}  // namespace swift
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
