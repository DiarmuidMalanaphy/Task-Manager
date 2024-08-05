package main

import (
	"bytes"
	"encoding/gob"
	"fmt"
	"go.etcd.io/bbolt"
)

var userDB *bbolt.DB

func initUserDB() error {
	var err error
	userDB, err = bbolt.Open("users.db", 0600, nil)
	if err != nil {
		return err
	}
	return userDB.Update(func(tx *bbolt.Tx) error {
		_, err := tx.CreateBucketIfNotExists([]byte("Users"))
		return err
	})
}

func writeUserToDB(user *User) error {
	return userDB.Update(func(tx *bbolt.Tx) error {
		b := tx.Bucket([]byte("Users"))
		var buf bytes.Buffer
		if err := gob.NewEncoder(&buf).Encode(user); err != nil {
			return err
		}
		return b.Put(uint64ToBytes(user.UserID), buf.Bytes())
	})
}

func incrementTaskCounter(userID uint64) error {
	return userDB.Update(func(tx *bbolt.Tx) error {
		b := tx.Bucket([]byte("Users"))
		userData := b.Get(uint64ToBytes(userID))
		if userData == nil {
			return fmt.Errorf("user not found")
		}

		var user User
		if err := gob.NewDecoder(bytes.NewReader(userData)).Decode(&user); err != nil {
			return err
		}

		user.TaskCounter++

		var buf bytes.Buffer
		if err := gob.NewEncoder(&buf).Encode(user); err != nil {
			return err
		}

		return b.Put(uint64ToBytes(userID), buf.Bytes())
	})
}

func getUserFromDB(userID uint64) (User, error) {
	var user User
	err := userDB.View(func(tx *bbolt.Tx) error {
		b := tx.Bucket([]byte("Users"))
		v := b.Get(uint64ToBytes(userID))
		if v == nil {
			return fmt.Errorf("user not found")
		}
		buf := bytes.NewBuffer(v)
		return gob.NewDecoder(buf).Decode(&user)
	})
	return user, err
}

func removeUser(userID uint64) error {
	return userDB.Update(func(tx *bbolt.Tx) error {
		b := tx.Bucket([]byte("Users"))
		return b.Delete(uint64ToBytes(userID))
	})
}

func userExists(userID uint64) (bool, error) {
	var exists bool
	err := userDB.View(func(tx *bbolt.Tx) error {
		b := tx.Bucket([]byte("Users"))
		v := b.Get(uint64ToBytes(userID))
		exists = (v != nil)
		return nil
	})
	return exists, err
}

func getAllUsers() ([]User, error) {
	var users []User
	err := userDB.View(func(tx *bbolt.Tx) error {
		b := tx.Bucket([]byte("Users"))
		return b.ForEach(func(k, v []byte) error {
			var user User
			buf := bytes.NewBuffer(v)
			if err := gob.NewDecoder(buf).Decode(&user); err != nil {
				return err
			}
			users = append(users, user)
			return nil
		})
	})
	return users, err
}
