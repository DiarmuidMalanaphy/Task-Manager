package main

import (
	"fmt"
	"sync"
)

type UserMap struct {
	mu        sync.Mutex
	Map       map[string]*User
	usercount uint64
}

func NewUserMap() *UserMap {
	return &UserMap{
		Map: make(map[string]*User),
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
	user_map := make(map[string]*User)
	largest_ID := uint64(0)
	for i := range users {
		user := &users[i] // Create a new pointer for each user -< otherwise memory trickery occurs
		user_map[user.Username.toString()] = user
		if user.UserID > largest_ID {
			largest_ID = user.UserID
		}
	}
	return &UserMap{
		Map:       user_map,
		usercount: largest_ID,
	}
}

func (um *UserMap) Add(user *User) error {
	fmt.Println(um.usercount)
	user_id := um.IncUserCount()
	um.mu.Lock()
	user.UserID = user_id

	um.Map[(user.Username).toString()] = user
	err := writeUserToDB(user)
	um.mu.Unlock()

	return err
}

func (um *UserMap) IncUserCount() uint64 {
	um.mu.Lock()
	um.usercount = um.usercount + 1
	um.mu.Unlock()
	return um.usercount
}

func (um *UserMap) Remove(key string) {
	um.mu.Lock()
	delete(um.Map, key)
	um.mu.Unlock()
}

func (um *UserMap) In(key string) (exists bool) {
	_, exists = um.Map[key]
	return exists
}

func (um *UserMap) Verify(verification Verification) (exists bool) {
	user, exists := um.Map[verification.Username.toString()]

	if exists != true {
		return false
	}

	if user.Hash != verification.Hash {
		return false
	}

	return true
}

func (um *UserMap) Value(key string) *User {
	return um.Map[key]
}
