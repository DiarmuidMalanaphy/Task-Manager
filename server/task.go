package main

import (
	"encoding/binary"
	"fmt"
	pb "github.com/DiarmuidMalanaphy/Task-Manager/proto_standards"
)

type Uint128 struct {
	High uint64
	Low  uint64
}

func (u *Uint128) Print() {
	fmt.Printf("%d-%d", u.High, u.Low)
}

func (u *Uint128) Uint128ToBytes() []byte {
	b := make([]byte, 16)
	binary.BigEndian.PutUint64(b[:8], u.High)
	binary.BigEndian.PutUint64(b[8:], u.Low)
	return b
}

// The filters will be provided in the format of two uint64 number, this will allow for at max 128 filters, but is relatively scalable and cheap (I will only use 7 initially and will leave the first bit unused) .
type Task struct {
	TaskID          uint64
	TaskName        Username //Just so happened to fit the same dimensions
	TargetUsername  Username
	SetterUsername  Username
	Status          uint8
	TaskDescription [120]byte
	Filterone       uint64
	Filtertwo       uint64
}

func (t *Task) Generate_globally_unique_task_ID(userID uint64) *Uint128 {
	return &Uint128{
		High: userID,
		Low:  t.TaskID,
	}

}

func (t *Task) Flip_Task_State() *Task {
	// Essentially it just flips the state (I'm lazy)
	// 0 IS PENDING
	if t.Status == 0 {
		t.Status = 1
		return t
	}
	t.Status = 0
	return t
}
func Task_FromProto(pbTask *pb.Task) Task {
	var taskDescription [120]byte
	if len(pbTask.TaskDescription) > 120 { // To mitigate buffer overflow
		// Username is too long, truncate and log a warning
		copy(taskDescription[:], pbTask.TaskDescription[:120])
		fmt.Printf("Warning: Description truncated from %d to 120 bytes\n", len(pbTask.TaskDescription))
	} else {
		// Username fits, copy it entirely
		copy(taskDescription[:], pbTask.TaskDescription)
	}

	return Task{
		TaskID:          pbTask.TaskID,
		TaskName:        Username_FromProto(pbTask.TaskName),
		TargetUsername:  Username_FromProto(pbTask.TargetUsername),
		SetterUsername:  Username_FromProto(pbTask.SetterUsername),
		Status:          uint8(pbTask.Status),
		TaskDescription: taskDescription,
		Filterone:       pbTask.Filterone,
		Filtertwo:       pbTask.Filtertwo,
	}
}

func (t *Task) ToProto() *pb.Task {
	// Convert TaskDescription to a slice of bytes
	taskDescriptionBytes := t.TaskDescription[:]

	// Return the Protobuf Task message
	return &pb.Task{
		TaskID:          t.TaskID,
		TaskName:        t.TaskName.ToProto(),
		TargetUsername:  t.TargetUsername.ToProto(),
		SetterUsername:  t.SetterUsername.ToProto(),
		Status:          uint32(t.Status), // Protobuf uses uint32 for field types
		TaskDescription: taskDescriptionBytes,
		Filterone:       t.Filterone,
		Filtertwo:       t.Filtertwo,
	}
}
