package main

import (
	"fmt"
	"golang.org/x/crypto/bcrypt"
	"sync"
	"time"
)

type UserMap struct {
	mu          sync.RWMutex
	UserMap     map[uint64]*User
	UsernameMap map[string]uint64
	TokenMap    map[Token]uint64
	usercount   uint64
}

func NewUserMap() *UserMap {
	return &UserMap{
		UserMap:     make(map[uint64]*User),
		UsernameMap: make(map[string]uint64),
		TokenMap:    make(map[Token]uint64),
	}
}

func LoadPreexisingUserMap() *UserMap {
	users, err := getAllUsers()
	if err != nil {
		fmt.Println(err)
		panic("Error initialising usermap -> panic to restrict user data loss")
	}
	if len(users) == 0 {
		return NewUserMap()
	}
	user_map := make(map[uint64]*User)
	username_map := make(map[string]uint64)
	largest_ID := uint64(0)
	for i := range users {
		user := &users[i] // Create a new pointer for each user -> otherwise memory trickery occurs
		user_map[user.UserID] = user
		username_map[user.Username.toString()] = user.UserID
		if user.UserID > largest_ID {
			largest_ID = user.UserID
		}
	}
	return &UserMap{
		UserMap:     user_map,
		UsernameMap: username_map,
		TokenMap:    make(map[Token]uint64),
		usercount:   largest_ID,
	}
}

func (um *UserMap) Add(user *User) error {
	user_id := um.IncUserCount()
	um.mu.Lock()
	defer um.mu.Unlock()
	user.UserID = user_id
	um.UserMap[user_id] = user
	um.UsernameMap[user.Username.toString()] = user_id
	err := writeUserToDB(user)
	return err
}

func (um *UserMap) IncUserCount() uint64 {
	um.mu.Lock()
	um.usercount = um.usercount + 1
	um.mu.Unlock()
	return um.usercount
}

func (um *UserMap) Remove(key interface{}) {
	um.mu.Lock()
	defer um.mu.Unlock()
	switch v := key.(type) {
	case uint64:
		if user, exists := um.UserMap[v]; exists {
			delete(um.UsernameMap, user.Username.toString())
			delete(um.UserMap, v)
			deleteTasksForUser(v)
		}
	case string:
		if userID, exists := um.UsernameMap[v]; exists {
			delete(um.UserMap, userID)
			delete(um.UsernameMap, v)
			deleteTasksForUser(userID) //Patching Exploit
		}
	}
}

func (um *UserMap) In(key interface{}) bool {
	um.mu.RLock()
	defer um.mu.RUnlock()
	switch v := key.(type) {
	case uint64:
		_, exists := um.UserMap[v]
		return exists
	case string:
		_, exists := um.UsernameMap[v]
		return exists
	default:
		return false
	}
}

func (um *UserMap) Value(key interface{}) (*User, bool) {
	um.mu.RLock()
	defer um.mu.RUnlock()
	switch v := key.(type) {
	case uint64:
		user, ok := um.UserMap[v]
		return user, ok
	case string:
		if userID, exists := um.UsernameMap[v]; exists {
			user, ok := um.UserMap[userID]
			return user, ok
		}
	}
	return nil, false
}

func (um *UserMap) AddToken(token VerificationToken) error {
	um.TokenMap[token.Token] = token.UserID
	return nil
}

func (um *UserMap) VerifyToken(token VerificationToken) (exists bool) {
	ID, exists := um.TokenMap[token.Token]
	currentTime := time.Now().Unix()

	// Check if the token is expired
	if currentTime > int64(token.Expires) {
		return false
	}
	if exists != true {
		return false
	}
	if ID != token.UserID {
		return false
	}

	return true
}

func (um *UserMap) VerifyUser(initial InitialVerification) (exists bool) {
	user, ok := um.Value(initial.Username.toString())
	if !ok {
		return false // User doesn't exist
	}

	inputtedPasswordToTest := initial.Hash
	storedHash := user.Hash

	// Compare the inputted password with the stored hash
	err := bcrypt.CompareHashAndPassword((storedHash[:]), (inputtedPasswordToTest[:]))

	// Return true if they match, false otherwise
	if err != nil {
		return false
	}

	return true
}
