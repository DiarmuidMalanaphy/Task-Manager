package main

import (
	"fmt"
	pb "github.com/DiarmuidMalanaphy/Task-Manager/server/proto_standards"
	"golang.org/x/crypto/bcrypt"
)

type NetworkHash [32]byte
type StoredHash [60]byte

// Logically we will only ever be decoding a network hash
func NetworkHash_FromProto(hash *pb.Hash) NetworkHash {
	var hashByte NetworkHash
	if len(hash.Hash) != 32 {
		fmt.Printf("Warning: Hash not 32 bytes -> Could be problematic as SHA256 should be 32 bytes, assuming error and truncating")
		copy(hashByte[:], hash.Hash[:32])
	} else {
		copy(hashByte[:], hash.Hash)
	}
	return hashByte

}

func createStoredHash(input NetworkHash) (StoredHash, error) {
	// Generate the bcrypt hash
	hashBytes, err := bcrypt.GenerateFromPassword(input.ToBytes(), 10)
	var hash StoredHash
	if err != nil {
		return hash, err
	}
	copy(hash[:], hashBytes[:60])

	return hash, nil
}

func (h NetworkHash) ToBytes() []byte {
	return h[:]
}

// We should never transmit a StoredHash.
func (h NetworkHash) ToProto() *pb.Hash {
	return &pb.Hash{
		Hash: h[:],
	}
}
