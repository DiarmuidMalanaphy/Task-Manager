// Code generated by protoc-gen-go. DO NOT EDIT.
// versions:
// 	protoc-gen-go v1.34.2
// 	protoc        v3.21.12
// source: RemoveUserRequest.proto

package standards

import (
	protoreflect "google.golang.org/protobuf/reflect/protoreflect"
	protoimpl "google.golang.org/protobuf/runtime/protoimpl"
	reflect "reflect"
	sync "sync"
)

const (
	// Verify that this generated code is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(20 - protoimpl.MinVersion)
	// Verify that runtime/protoimpl is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(protoimpl.MaxVersion - 20)
)

type RemoveUserRequest struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	Verification *Verification `protobuf:"bytes,1,opt,name=verification,proto3" json:"verification,omitempty"`
}

func (x *RemoveUserRequest) Reset() {
	*x = RemoveUserRequest{}
	if protoimpl.UnsafeEnabled {
		mi := &file_RemoveUserRequest_proto_msgTypes[0]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *RemoveUserRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*RemoveUserRequest) ProtoMessage() {}

func (x *RemoveUserRequest) ProtoReflect() protoreflect.Message {
	mi := &file_RemoveUserRequest_proto_msgTypes[0]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use RemoveUserRequest.ProtoReflect.Descriptor instead.
func (*RemoveUserRequest) Descriptor() ([]byte, []int) {
	return file_RemoveUserRequest_proto_rawDescGZIP(), []int{0}
}

func (x *RemoveUserRequest) GetVerification() *Verification {
	if x != nil {
		return x.Verification
	}
	return nil
}

var File_RemoveUserRequest_proto protoreflect.FileDescriptor

var file_RemoveUserRequest_proto_rawDesc = []byte{
	0x0a, 0x17, 0x52, 0x65, 0x6d, 0x6f, 0x76, 0x65, 0x55, 0x73, 0x65, 0x72, 0x52, 0x65, 0x71, 0x75,
	0x65, 0x73, 0x74, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x12, 0x0e, 0x74, 0x61, 0x73, 0x6b, 0x6d,
	0x61, 0x6e, 0x61, 0x67, 0x65, 0x72, 0x2e, 0x70, 0x62, 0x1a, 0x12, 0x56, 0x65, 0x72, 0x69, 0x66,
	0x69, 0x63, 0x61, 0x74, 0x69, 0x6f, 0x6e, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x22, 0x55, 0x0a,
	0x11, 0x52, 0x65, 0x6d, 0x6f, 0x76, 0x65, 0x55, 0x73, 0x65, 0x72, 0x52, 0x65, 0x71, 0x75, 0x65,
	0x73, 0x74, 0x12, 0x40, 0x0a, 0x0c, 0x76, 0x65, 0x72, 0x69, 0x66, 0x69, 0x63, 0x61, 0x74, 0x69,
	0x6f, 0x6e, 0x18, 0x01, 0x20, 0x01, 0x28, 0x0b, 0x32, 0x1c, 0x2e, 0x74, 0x61, 0x73, 0x6b, 0x6d,
	0x61, 0x6e, 0x61, 0x67, 0x65, 0x72, 0x2e, 0x70, 0x62, 0x2e, 0x56, 0x65, 0x72, 0x69, 0x66, 0x69,
	0x63, 0x61, 0x74, 0x69, 0x6f, 0x6e, 0x52, 0x0c, 0x76, 0x65, 0x72, 0x69, 0x66, 0x69, 0x63, 0x61,
	0x74, 0x69, 0x6f, 0x6e, 0x42, 0x35, 0x5a, 0x33, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 0x2e, 0x63,
	0x6f, 0x6d, 0x2f, 0x64, 0x69, 0x61, 0x72, 0x6d, 0x75, 0x69, 0x64, 0x6d, 0x61, 0x6c, 0x61, 0x6e,
	0x61, 0x70, 0x68, 0x79, 0x2f, 0x54, 0x61, 0x73, 0x6b, 0x2d, 0x4d, 0x61, 0x6e, 0x61, 0x67, 0x65,
	0x72, 0x2f, 0x73, 0x74, 0x61, 0x6e, 0x64, 0x61, 0x72, 0x64, 0x73, 0x62, 0x06, 0x70, 0x72, 0x6f,
	0x74, 0x6f, 0x33,
}

var (
	file_RemoveUserRequest_proto_rawDescOnce sync.Once
	file_RemoveUserRequest_proto_rawDescData = file_RemoveUserRequest_proto_rawDesc
)

func file_RemoveUserRequest_proto_rawDescGZIP() []byte {
	file_RemoveUserRequest_proto_rawDescOnce.Do(func() {
		file_RemoveUserRequest_proto_rawDescData = protoimpl.X.CompressGZIP(file_RemoveUserRequest_proto_rawDescData)
	})
	return file_RemoveUserRequest_proto_rawDescData
}

var file_RemoveUserRequest_proto_msgTypes = make([]protoimpl.MessageInfo, 1)
var file_RemoveUserRequest_proto_goTypes = []any{
	(*RemoveUserRequest)(nil), // 0: taskmanager.pb.RemoveUserRequest
	(*Verification)(nil),      // 1: taskmanager.pb.Verification
}
var file_RemoveUserRequest_proto_depIdxs = []int32{
	1, // 0: taskmanager.pb.RemoveUserRequest.verification:type_name -> taskmanager.pb.Verification
	1, // [1:1] is the sub-list for method output_type
	1, // [1:1] is the sub-list for method input_type
	1, // [1:1] is the sub-list for extension type_name
	1, // [1:1] is the sub-list for extension extendee
	0, // [0:1] is the sub-list for field type_name
}

func init() { file_RemoveUserRequest_proto_init() }
func file_RemoveUserRequest_proto_init() {
	if File_RemoveUserRequest_proto != nil {
		return
	}
	file_Verification_proto_init()
	if !protoimpl.UnsafeEnabled {
		file_RemoveUserRequest_proto_msgTypes[0].Exporter = func(v any, i int) any {
			switch v := v.(*RemoveUserRequest); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
	}
	type x struct{}
	out := protoimpl.TypeBuilder{
		File: protoimpl.DescBuilder{
			GoPackagePath: reflect.TypeOf(x{}).PkgPath(),
			RawDescriptor: file_RemoveUserRequest_proto_rawDesc,
			NumEnums:      0,
			NumMessages:   1,
			NumExtensions: 0,
			NumServices:   0,
		},
		GoTypes:           file_RemoveUserRequest_proto_goTypes,
		DependencyIndexes: file_RemoveUserRequest_proto_depIdxs,
		MessageInfos:      file_RemoveUserRequest_proto_msgTypes,
	}.Build()
	File_RemoveUserRequest_proto = out.File
	file_RemoveUserRequest_proto_rawDesc = nil
	file_RemoveUserRequest_proto_goTypes = nil
	file_RemoveUserRequest_proto_depIdxs = nil
}
