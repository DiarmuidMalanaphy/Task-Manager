package main

import (
	"bytes"
	"fmt"
	pb "github.com/DiarmuidMalanaphy/Task-Manager/proto_standards"
)

type Username [20]byte

func Username_FromProto(username *pb.Username) Username {
	var usernameByte Username

	if len(username.Username) > 20 { // To mitigate buffer overflow
		// Username is too long, truncate and log a warning
		copy(usernameByte[:], username.Username[:20])
		fmt.Printf("Warning: Username truncated from %d to 20 bytes\n", len(username.Username))
	} else {
		// Username fits, copy it entirely
		copy(usernameByte[:], username.Username)
	}
	return usernameByte
}

func (u *Username) toString() string {
	return string(bytes.Trim(u[:], "\x00"))
}

func (u Username) ToProto() *pb.Username {
	return &pb.Username{
		Username: u[:],
	}
}
