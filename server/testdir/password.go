package main

import (
	"bytes"
	"fmt"
)

type Password [30]byte

func Password_FromProto(passwordBytes []byte) Password {
	var password Password
	if len(passwordBytes) > 30 { // To mitigate buffer overflow
		// Password is too long, truncate and log a warning
		copy(password[:], passwordBytes[:30])
		fmt.Printf("Warning: password truncated from %d to 30 bytes\n", len(passwordBytes))
	} else {
		// Password fits, copy it entirely
		copy(password[:], passwordBytes)
	}
	return password
}

func (p *Password) toString() string {
	return string(bytes.Trim(p[:], "\x00"))
}

func (p *Password) ToProto() []byte {
	return p[:]
}
