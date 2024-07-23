package main

import (
	"encoding/gob"
	pb "github.com/DiarmuidMalanaphy/Task-Manager/standards"
)

func init() {
	// Register the Username type with gob
	gob.Register(Username{})
}

type Verification struct {
	Username Username
	Hash     Hash
}

func NewVerification_FromProtobuf(verification *pb.Verification) Verification {
	return Verification{
		Username: newUsername(verification.Username),
		Hash:     NewHash_FromProtobuf(verification.Hash),
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

func (e Error) ToProto() pb.Error {
	return pb.Error{
		Error: e.ErrorMessage[:],
	}
}

func NewError(message string) Error {
	var e Error
	copy(e.ErrorMessage[:], message)
	return e
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

func AddUserRequest_FromProto(r *pb.AddUserRequest) AddUserRequest {
	username := newUsername(r.Username)
	password := passwordFromProtobuf(r)
	return AddUserRequest{
		Username: username,
		Password: password,
	}
}

type RemoveUserRequest struct {
	Verification Verification
}

func (r RemoveUserRequest) ToProto() *pb.RemoveUserRequest {
	return &pb.RemoveUserRequest{
		Verification: r.Verification.ToProto(),
	}
}

func RemoveUserRequest_FromProto(r *pb.RemoveUserRequest) RemoveUserRequest {
	return RemoveUserRequest{
		Verification: NewVerification_FromProtobuf(r.Verification),
	}
}

type VerifyUserExistsRequest struct {
	Username Username
}

func VerifyUserExistsRequest_FromProto(r *pb.VerifyUserExistsRequest) VerifyUserExistsRequest {
	return VerifyUserExistsRequest{
		Username: newUsername(r.Username),
	}
}

func (r VerifyUserExistsRequest) ToProto() *pb.VerifyUserExistsRequest {
	return &pb.VerifyUserExistsRequest{
		Username: r.Username.ToProto(),
	}

}

type UpdateUserRequest struct {
	Verification Verification
	User         User
} // I am not handling this right now

type PollUserRequest struct {
	Verification   Verification
	LastSeenTaskID uint32
}

func PollUserRequest_FromProto(r *pb.PollUserRequest) PollUserRequest {
	return PollUserRequest{
		Verification:   NewVerification_FromProtobuf(r.Verification),
		LastSeenTaskID: r.LastseentaskID,
	}
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

func AddTaskRequest_FromProto(r *pb.AddTaskRequest) AddTaskRequest {
	return AddTaskRequest{
		Verification: NewVerification_FromProtobuf(r.Verification),
		NewTask:      NewTask_FromProtobuf(r.Newtask),
	}
}

func (r AddTaskRequest) ToProto() *pb.AddTaskRequest {
	return &pb.AddTaskRequest{
		Verification : r.Verification.ToProto(),
		Newtask: r.NewTask.ToProto(),
	}
}

type RemoveTaskRequest struct {
	Verification Verification
	TaskID       uint64
}

func RemoveTaskRequest_FromProto(r *pb.RemoveTaskRequest) RemoveTaskRequest {
	return RemoveTaskRequest{
		Verification: NewVerification_FromProtobuf(r.Verification),
		TaskID:       r.TaskID,
	}
}

func (r RemoveTaskRequest) ToProto(r *pb.RemoveTaskRequest) *pb.RemoveTaskRequest {
	return &pb.RemoveTaskRequest {
		Verification : r.Verification.ToProto()
		TaskID: r.TaskID,
	}
}

type RemoveAllTasksRequest struct {
	Verification Verification
}

func RemoveAllTasksRequest_FromProto(r *pb.RemoveAllTasksRequest) RemoveAllTasksRequest {
	return RemoveAllTasksRequest{
		Verification: NewVerification_FromProtobuf(r.Verification),
	}
}

func 
