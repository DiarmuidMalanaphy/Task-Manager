package main

import (
	"bytes"
	"encoding/binary"
	"encoding/gob"
	"fmt"
	"go.etcd.io/bbolt"
)

var taskDB *bbolt.DB

func initTaskDB() error {
	var err error
	taskDB, err = bbolt.Open("tasks.db", 0600, nil)
	if err != nil {
		return err
	}
	return taskDB.Update(func(tx *bbolt.Tx) error {
		_, err := tx.CreateBucketIfNotExists([]byte("Tasks"))
		return err
	})
}

func writeTaskToDB(userID uint64, task Task) error {
	return taskDB.Update(func(tx *bbolt.Tx) error {
		b := tx.Bucket([]byte("Tasks"))
		var buf bytes.Buffer
		if err := gob.NewEncoder(&buf).Encode(task); err != nil {
			return err
		}
		key := task.Generate_globally_unique_task_ID(userID).Uint128ToBytes()
		return b.Put(key, buf.Bytes())
	})
}

func getTasksForUser(userID uint64) ([]Task, error) {
	var tasks []Task
	err := taskDB.View(func(tx *bbolt.Tx) error {
		b := tx.Bucket([]byte("Tasks"))
		c := b.Cursor()
		prefix := uint64ToBytes(userID)
		for k, v := c.Seek(prefix); k != nil && bytes.HasPrefix(k, prefix); k, v = c.Next() {
			var task Task
			buf := bytes.NewBuffer(v)
			if err := gob.NewDecoder(buf).Decode(&task); err != nil {
				return err
			}
			tasks = append(tasks, task)
		}
		return nil
	})
	return tasks, err
}

func getTaskAfter(userID uint64, afterTaskID uint64) ([]Task, error) {
	var tasks []Task
	err := taskDB.View(func(tx *bbolt.Tx) error {
		b := tx.Bucket([]byte("Tasks"))
		c := b.Cursor()
		prefix := uint64ToBytes(userID)
		startKey := (&Uint128{High: userID, Low: afterTaskID}).Uint128ToBytes()
		for k, v := c.Seek(startKey); k != nil && bytes.HasPrefix(k, prefix); k, v = c.Next() {
			var task Task
			buf := bytes.NewBuffer(v)
			if err := gob.NewDecoder(buf).Decode(&task); err != nil {
				return err
			}
			if task.TaskID > afterTaskID {
				tasks = append(tasks, task)
			}
		}
		return nil
	})
	return tasks, err
}
func deleteTask(userID uint64, taskID uint64) error {
	return taskDB.Update(func(tx *bbolt.Tx) error {
		b := tx.Bucket([]byte("Tasks"))
		if b == nil {
			return fmt.Errorf("Tasks bucket not found")
		}
		key := (&Uint128{High: userID, Low: taskID}).Uint128ToBytes()
		(&Uint128{High: userID, Low: taskID}).Print()
		v := b.Get(key)
		if v == nil {
			return fmt.Errorf("Task not found")
		}
		return b.Delete(key)
	})
}

func deleteTasksForUser(userID uint64) error {
	err := taskDB.Update(func(tx *bbolt.Tx) error {
		b := tx.Bucket([]byte("Tasks"))
		c := b.Cursor()
		prefix := uint64ToBytes(userID)
		for k, _ := c.Seek(prefix); k != nil && bytes.HasPrefix(k, prefix); k, _ = c.Next() {
			b.Delete(k)
		}
		return nil
	})
	return err

}

func flipTaskState(userID uint64, taskID uint64) error {

	return taskDB.Update(func(tx *bbolt.Tx) error {
		b := tx.Bucket([]byte("Tasks"))
		key := (&Uint128{High: userID, Low: taskID}).Uint128ToBytes()

		// Get the task from the database
		v := b.Get(key)
		if v == nil {
			return fmt.Errorf("Task not found")
		}

		// Decode the task
		var task Task
		buf := bytes.NewBuffer(v)
		if err := gob.NewDecoder(buf).Decode(&task); err != nil {
			return err
		}

		// Complete the task
		task.Flip_Task_State()

		// Write the updated task back to the database
		var writeBuf bytes.Buffer
		if err := gob.NewEncoder(&writeBuf).Encode(task); err != nil {
			return err
		}

		return b.Put(key, writeBuf.Bytes())
	})
}

func uint64ToBytes(u uint64) []byte {
	b := make([]byte, 8)
	binary.BigEndian.PutUint64(b, u)
	return b
}
