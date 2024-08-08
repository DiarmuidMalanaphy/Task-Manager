package main

import (
	"sync"
)

type User struct {
	Username    Username
	UserID      uint64
	Hash        StoredHash
	TaskCounter uint64
	mutex       sync.Mutex
}

func NewUser_FromGo(name [20]byte, hash StoredHash) User {
	return User{
		Username:    name,
		UserID:      0,
		Hash:        hash,
		TaskCounter: 0,
	}
}

func (u *User) IncrementTaskID() uint64 {
	u.mutex.Lock()
	incrementTaskCounter(u.UserID)
	u.TaskCounter = u.TaskCounter + 1
	u.mutex.Unlock()
	return u.TaskCounter
}

func (u *User) ClearTasks() error {
	err := deleteTasksForUser(u.UserID)
	return err
}

func (u *User) RemoveTask(taskID uint64) {
	deleteTask(u.UserID, taskID)
}

func (u *User) GetTasksAfter(latest_task uint64) ([]Task, error) {
	return getTaskAfter(u.UserID, latest_task)
}
func (u *User) AddTask(task Task) error {
	err := writeTaskToDB(u.UserID, task)
	return err
}
