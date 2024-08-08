package main

import (
	"crypto/rand"
	"crypto/sha256"
	"encoding/hex"
	pb "github.com/DiarmuidMalanaphy/Task-Manager/standards"
	"time"
)

type InitialVerification struct {
	Username Username
	Hash     NetworkHash
}

func InitialVerification_FromProto(verification *pb.InitialVerification) InitialVerification {
	return InitialVerification{
		Username: Username_FromProto(verification.Username),
		Hash:     NetworkHash_FromProto(verification.Hash),
	}
}

type Token [32]byte

type VerificationToken struct {
	Token   [32]byte
	UserID  uint64
	Expires uint64
}

func NewVerificationToken(userID uint64) (VerificationToken, error) {
	var token [32]byte
	_, err := rand.Read(token[:])
	if err != nil {
		return VerificationToken{}, err
	}

	// Hash the random bytes
	hashedToken := sha256.Sum256(token[:])

	return VerificationToken{
		Token:   hashedToken,
		UserID:  userID,
		Expires: uint64(time.Now().Add(2 * time.Hour).Unix()),
	}, nil
}

func (v VerificationToken) ToProto() *pb.VerificationToken {
	return &pb.VerificationToken{
		Token:   hex.EncodeToString(v.Token[:]),
		UserID:  v.UserID,
		Expires: v.Expires,
	}
}

func VerificationToken_FromProto(token *pb.VerificationToken) (VerificationToken, error) {
	var vt VerificationToken
	tokenBytes, err := hex.DecodeString(token.Token)
	if err != nil {
		return VerificationToken{}, err
	}
	copy(vt.Token[:], tokenBytes)
	vt.UserID = token.UserID
	vt.Expires = token.Expires
	return vt, nil
}
