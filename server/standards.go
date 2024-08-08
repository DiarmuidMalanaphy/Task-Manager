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
	Hash     NetworkHash
}

func AddUserRequest_FromProto(data []byte) (AddUserRequest, error) {
	var protobuf_request pb.AddUserRequest
	err := proto.Unmarshal(data, &protobuf_request)

	if err != nil {
		return AddUserRequest{}, err
	}

	return AddUserRequest{
		Username: Username_FromProto(protobuf_request.Verification.Username),
		Hash:     NetworkHash_FromProto(protobuf_request.Verification.Hash),
	}, nil
}

type RemoveUserRequest struct {
	VerificationToken VerificationToken
}

//func (r RemoveUserRequest) ToProto() *pb.RemoveUserRequest {
//	return &pb.RemoveUserRequest{
//		Token: r.VerificationToken.toPro,

//	}
//}

func RemoveUserRequest_FromProto(data []byte) (RemoveUserRequest, error) {
	var protobuf_request pb.RemoveUserRequest
	err := proto.Unmarshal(data, &protobuf_request)

	if err != nil {
		return RemoveUserRequest{}, err
	}
	token, err := VerificationToken_FromProto(protobuf_request.Token)

	if err != nil {
		return RemoveUserRequest{}, err
	}
	return RemoveUserRequest{
		VerificationToken: token,
	}, nil
}

type LoginRequest struct {
	Verification InitialVerification
}

//func (r LoginRequest) ToProto() *pb.LoginRequest {
//	return &pb.LoginRequest{
//		Verification: r.Verification.ToProto(),
//	}
//}

func LoginRequest_FromProto(data []byte) (LoginRequest, error) {
	var protobuf_request pb.LoginRequest
	err := proto.Unmarshal(data, &protobuf_request)

	if err != nil {
		return LoginRequest{}, err
	}
	return LoginRequest{
		Verification: InitialVerification_FromProto(protobuf_request.Initialverification),
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
	Verification   VerificationToken
	LastSeenTaskID uint64
}

func PollUserRequest_FromProto(data []byte) (PollUserRequest, error) {
	var protobuf_request pb.PollUserRequest
	err := proto.Unmarshal(data, &protobuf_request)
	if err != nil {
		return PollUserRequest{}, err
	}
	token, err := VerificationToken_FromProto(protobuf_request.Token)
	if err != nil {
		return PollUserRequest{}, err
	}

	return PollUserRequest{
		Verification:   token,
		LastSeenTaskID: uint64(protobuf_request.LastseentaskID),
	}, nil
}

//func (r PollUserRequest) ToProto() *pb.PollUserRequest {
//	return &pb.PollUserRequest{
//		Verification:   r.Verification.ToProto(),
//		LastseentaskID: r.LastSeenTaskID,
//	}
//}

type AddTaskRequest struct {
	Verification VerificationToken
	NewTask      Task
}

func AddTaskRequest_FromProto(data []byte) (AddTaskRequest, error) {
	var protobuf_request pb.AddTaskRequest
	err := proto.Unmarshal(data, &protobuf_request)
	if err != nil {
		return AddTaskRequest{}, err
	}
	token, err := VerificationToken_FromProto(protobuf_request.Token)
	if err != nil {
		return AddTaskRequest{}, err
	}

	return AddTaskRequest{
		Verification: token,
		NewTask:      Task_FromProto(protobuf_request.Newtask),
	}, nil
}

//func (r AddTaskRequest) ToProto() *pb.AddTaskRequest {
//	return &pb.AddTaskRequest{
//		Verification: r.Verification.ToProto(),
//		Newtask:      r.NewTask.ToProto(),
//	}
//}

type RemoveTaskRequest struct {
	Verification VerificationToken
	TaskID       uint64
}

func RemoveTaskRequest_FromProto(data []byte) (RemoveTaskRequest, error) {
	var protobuf_request pb.RemoveTaskRequest
	err := proto.Unmarshal(data, &protobuf_request)
	if err != nil {
		return RemoveTaskRequest{}, err
	}

	token, err := VerificationToken_FromProto(protobuf_request.Token)
	if err != nil {
		return RemoveTaskRequest{}, err
	}

	return RemoveTaskRequest{
		Verification: token,
		TaskID:       protobuf_request.TaskID,
	}, nil
}

//func (r RemoveTaskRequest) ToProto() *pb.RemoveTaskRequest {
//	return &pb.RemoveTaskRequest{
//		Verification: r.Verification.ToProto(),
//		TaskID:       r.TaskID,
//	}
//}

type RemoveAllTasksRequest struct {
	Verification VerificationToken
}

func RemoveAllTasksRequest_FromProto(data []byte) (RemoveAllTasksRequest, error) {
	var protobuf_request pb.RemoveAllTasksRequest
	err := proto.Unmarshal(data, &protobuf_request)
	if err != nil {
		return RemoveAllTasksRequest{}, err
	}

	token, err := VerificationToken_FromProto(protobuf_request.Token)
	if err != nil {
		return RemoveAllTasksRequest{}, err
	}

	return RemoveAllTasksRequest{
		Verification: token,
	}, nil

}
