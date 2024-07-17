package main

// The filters will be provided in the format of two uint64 number, this will allow for at max 128 filters, but is relatively scalable and cheap (I will only use 7 initially and will leave the first bit unused) .
type Task struct {
	TaskID          uint64
	TaskName        [20]byte
	TargetUsername  [20]byte
	SetterUsername  [20]byte
	Status          uint8
	TaskDescription [120]byte
	Filterone       uint64
	Filtertwo       uint64
}
