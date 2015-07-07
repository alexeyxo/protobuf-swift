MAINTAINERCLEANFILES = \
	Makefile.in
bin_PROGRAMS = protoc-gen-swift
protoc_gen_swift_LDFLAGS = -lprotobuf -lprotoc
protoc_gen_swift_SOURCES = 	\
	main.cc					\
	swift_enum_field.cc		\
	swift_map_field.cc		\
	swift_file.cc			\
	swift_message_field.cc	\
	swift_oneof.cc			\
	swift_enum.cc			\
	swift_generator.cc		\
	swift_primitive_field.cc	\
	swift_extension.cc		\
	swift_helpers.cc			\
	swift_field.cc			\
	swift_message.cc	\
  google/protobuf/swift-descriptor.pb.cc
