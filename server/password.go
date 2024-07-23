package main

import (
	"bytes"
	"fmt"
	pb "github.com/DiarmuidMalanaphy/Task-Manager/standards"
)

type Password [30]byte

func passwordFromProtobuf(r *pb.AddUserRequest) Password {

	var password Password

	if len(r.Password) > 30 { // To mitigate buffer overflow
		// Password is too long, truncate and log a warning
		copy(password[:], r.Password[:30])
		fmt.Printf("Warning: password truncated from %d to 30 bytes\n", len(r.Password))
	} else {
		// Username fits, copy it entirely
		copy(password[:], r.Password)
	}
	return password
}

func (p *Password) toString() string {
	return string(bytes.Trim(p[:], "\x00"))
}

func (p *Password) ToProto() []byte {
	return p[:]
}
