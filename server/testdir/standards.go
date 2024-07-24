package main

import (
	"encoding/gob"
	pb "github.com/DiarmuidMalanaphy/Task-Manager/standards"
	"google.golang.org/protobuf/proto"
)

func init() {
	// Register the Username type with gob
	gob.Register(Username{})
}

type Verification struct {
	Username Username
	Hash     Hash
}

func Verification_FromProto(verification *pb.Verification) Verification {
	return Verification{
		Username: Username_FromProto(verification.Username),
		Hash:     Hash_FromProto(verification.Hash),
	}
}

func (r Verification) ToProto() *pb.Verification {
	return &pb.Verification{
		Username: r.Username.ToProto(),
		Hash:     r.Hash.ToProto(),
	}
}

type Error struct {
	ErrorMessage [60]byte
}

func (e Error) ToProto() *pb.Error {
	return &pb.Error{
		Error: e.ErrorMessage[:],
	}
}
func Error_FromProto(data []byte) (Error, error) {

	var pbError pb.Error
	err := proto.Unmarshal(data, &pbError)
	if err != nil {
		return Error{}, err
	}
	var pbErrorError [60]byte
	copy(pbErrorError[:], pbError.Error[:60])
	return Error{
		ErrorMessage: pbErrorError,
	}, nil
}

func NewError(message string) *Error {
	var e Error
	copy(e.ErrorMessage[:], message)
	return &e
}

type AddUserRequest struct {
	Username Username
	Password Password
}

func (r AddUserRequest) ToProto() *pb.AddUserRequest {
	return &pb.AddUserRequest{
		Username: r.Username.ToProto(),
		Password: r.Password.ToProto(),
	}
}

func AddUserRequest_FromProto(data []byte) (AddUserRequest, error) {
	var protobuf_request pb.AddUserRequest
	err := proto.Unmarshal(data, &protobuf_request)

	if err != nil {
		return AddUserRequest{}, err
	}

	return AddUserRequest{
		Username: Username_FromProto(protobuf_request.Username),
		Password: Password_FromProto(protobuf_request.Password),
	}, nil
}

type RemoveUserRequest struct {
	Verification Verification
}

func (r RemoveUserRequest) ToProto() *pb.RemoveUserRequest {
	return &pb.RemoveUserRequest{
		Verification: r.Verification.ToProto(),
	}
}

func RemoveUserRequest_FromProto(data []byte) (RemoveUserRequest, error) {
	var protobuf_request pb.RemoveUserRequest
	err := proto.Unmarshal(data, &protobuf_request)

	if err != nil {
		return RemoveUserRequest{}, err
	}
	return RemoveUserRequest{
		Verification: Verification_FromProto(protobuf_request.Verification),
	}, nil
}

type VerifyUserExistsRequest struct {
	Username Username
}

func VerifyUserExistsRequest_FromProto(data []byte) (VerifyUserExistsRequest, error) {
	var protobuf_request pb.VerifyUserExistsRequest

	err := proto.Unmarshal(data, &protobuf_request)
	if err != nil {
		return VerifyUserExistsRequest{}, err
	}

	return VerifyUserExistsRequest{
		Username: Username_FromProto(protobuf_request.Username),
	}, nil
}

func (r VerifyUserExistsRequest) ToProto() *pb.VerifyUserExistsRequest {
	return &pb.VerifyUserExistsRequest{
		Username: r.Username.ToProto(),
	}

}

type PollUserRequest struct {
	Verification   Verification
	LastSeenTaskID uint32
}

func PollUserRequest_FromProto(data []byte) (PollUserRequest, error) {
	var protobuf_request pb.PollUserRequest
	err := proto.Unmarshal(data, &protobuf_request)
	if err != nil {
		return PollUserRequest{}, err
	}

	return PollUserRequest{
		Verification:   Verification_FromProto(protobuf_request.Verification),
		LastSeenTaskID: protobuf_request.LastseentaskID,
	}, nil
}

func (r PollUserRequest) ToProto() *pb.PollUserRequest {
	return &pb.PollUserRequest{
		Verification:   r.Verification.ToProto(),
		LastseentaskID: r.LastSeenTaskID,
	}
}

type AddTaskRequest struct {
	Verification Verification
	NewTask      Task
}

func AddTaskRequest_FromProto(data []byte) (AddTaskRequest, error) {
	var protobuf_request pb.AddTaskRequest
	err := proto.Unmarshal(data, &protobuf_request)
	if err != nil {
		return AddTaskRequest{}, err
	}

	return AddTaskRequest{
		Verification: Verification_FromProto(protobuf_request.Verification),
		NewTask:      Task_FromProto(protobuf_request.Newtask),
	}, nil
}

func (r AddTaskRequest) ToProto() *pb.AddTaskRequest {
	return &pb.AddTaskRequest{
		Verification: r.Verification.ToProto(),
		Newtask:      r.NewTask.ToProto(),
	}
}

type RemoveTaskRequest struct {
	Verification Verification
	TaskID       uint64
}

func RemoveTaskRequest_FromProto(data []byte) (RemoveTaskRequest, error) {
	var protobuf_request pb.RemoveTaskRequest
	err := proto.Unmarshal(data, &protobuf_request)
	if err != nil {
		return RemoveTaskRequest{}, err
	}

	return RemoveTaskRequest{
		Verification: Verification_FromProto(protobuf_request.Verification),
		TaskID:       protobuf_request.TaskID,
	}, nil
}

func (r RemoveTaskRequest) ToProto() *pb.RemoveTaskRequest {
	return &pb.RemoveTaskRequest{
		Verification: r.Verification.ToProto(),
		TaskID:       r.TaskID,
	}
}

type RemoveAllTasksRequest struct {
	Verification Verification
}

func RemoveAllTasksRequest_FromProto(data []byte) (RemoveAllTasksRequest, error) {
	var protobuf_request pb.RemoveAllTasksRequest
	err := proto.Unmarshal(data, &protobuf_request)
	if err != nil {
		return RemoveAllTasksRequest{}, err
	}
	return RemoveAllTasksRequest{
		Verification: Verification_FromProto(protobuf_request.Verification),
	}, nil

}
