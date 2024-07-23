package main

import (
	"crypto/sha256"
	"fmt"
	pb "github.com/DiarmuidMalanaphy/Task-Manager/standards"
)

type Hash [32]byte

func NewHash_FromProtobuf(hash *pb.Hash) Hash {
	var hashByte Hash
	if len(hash.Hash) != 32 {
		fmt.Printf("Warning: Hash not 32 bytes -> Could be problematic as SHA256 should be 32 bytes, assuming error and truncating")
		copy(hashByte[:], hash.Hash[:32])
	} else {
		copy(hashByte[:], hash.Hash)
	}
	return hashByte

}

func createHash(input string) Hash {
	// Compute SHA-256 hash of the input
	hashBytes := sha256.Sum256([]byte(input))

	// Convert the hash to Hash type (which is [20]byte)
	var hash Hash
	copy(hash[:], hashBytes[:32])

	return hash
}

func (h Hash) ToProto() *pb.Hash {
	return &pb.Hash{
		Hash: h[:],
	}
}
