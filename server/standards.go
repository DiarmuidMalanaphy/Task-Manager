package main

import (
	"bytes"
	"encoding/gob"
)

type Hash [32]byte
type Username [20]byte

func (u *Username) toString() string {
	return string(bytes.Trim(u[:], "\x00"))
}

func init() {
	// Register the Username type with gob
	gob.Register(Username{})
}

type Verification struct {
	Username Username
	Hash     Hash
}

type Error struct {
	ErrorMessage [60]byte
}

func NewError(message string) Error {
	var e Error
	copy(e.ErrorMessage[:], message)
	return e
}

type AddUserRequest struct {
	Username Username
	Password [30]byte
}

type RemoveUserRequest struct {
	Verification Verification
}

type VerifyUserExistsRequest struct {
	Username Username
}

type UpdateUserRequest struct {
	Verification Verification
	User         User
}

type PollUserRequest struct {
	Verification   Verification
	LastSeenTaskID uint32
}

type AddTaskRequest struct {
	Verification Verification
	NewTask      Task
}

type RemoveTaskRequest struct {
	Verification Verification
	TaskID       uint64
}

type RemoveAllTasksRequest struct {
	Verification Verification
}
