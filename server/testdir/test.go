package main

import (
	"bufio"
	"bytes"
	"crypto/sha256"
	"fmt"
	networktools "github.com/DiarmuidMalanaphy/networktools"
	"os"
	"reflect"
	"strconv"
	"strings"
)

func main() {
	reader := bufio.NewReader(os.Stdin)

	fmt.Println("Welcome to the Task Management System")

	// User Registration
	fmt.Print("Enter username: ")
	username, _ := reader.ReadString('\n')
	username = strings.TrimSpace(username)

	fmt.Print("Enter password: ")
	password, _ := reader.ReadString('\n')
	password = strings.TrimSpace(password)

	testUser := AddUserRequest{
		Username: stringToUsername(username),
		Password: stringToByteArray(password, 30),
	}

	req, _ := networktools.GenerateRequest(testUser, 2)
	data, _ := networktools.Handle_Single_TCP_Exchange("192.168.1.76:5050", req, 1024)
	incoming_request, err := networktools.DeserialiseRequest(data)
	fmt.Println(incoming_request.Type)
	if err != nil {
		fmt.Println(err)
		return
	}
	printError(incoming_request, "User Registered Successfully")
	// Create verification objec

	verification := Verification{
		Username: stringToUsername(username),
		Hash:     createHash(password),
	}
	fmt.Println(verification.Hash)
	for {
		fmt.Println("\n1. Add Task")
		fmt.Println("2. Poll Tasks")
		fmt.Println("3. Remove Task")
		fmt.Println("4. Exit")
		fmt.Print("Choose an option: ")

		choice, _ := reader.ReadString('\n')
		choice = strings.TrimSpace(choice)

		switch choice {
		case "1":
			addTask(reader, verification)
		case "2":
			pollTasks(reader, verification)
		case "3":
			removeTask(reader, verification)
		case "4":
			fmt.Println("Exiting...")
			return
		default:
			fmt.Println("Invalid option, please try again.")
		}
	}

}
func printError(req networktools.Request, good_string string) {
	if req.Type == 255 {
		var e Error
		networktools.DeserialiseData(&e, req.Payload)
		printByteArrayAsString(e.ErrorMessage)
	} else {
		fmt.Println(good_string)

	}
}

func addTask(reader *bufio.Reader, verification Verification) {
	fmt.Print("Enter task name: ")
	taskName, _ := reader.ReadString('\n')
	taskName = strings.TrimSpace(taskName)

	fmt.Print("Enter task description: ")
	taskDesc, _ := reader.ReadString('\n')
	taskDesc = strings.TrimSpace(taskDesc)

	fmt.Print("Enter target username: ")
	targetUsername, _ := reader.ReadString('\n')
	targetUsername = strings.TrimSpace(targetUsername)

	task := Task{
		TaskName:        stringTo20ByteArray(taskName),
		TargetUsername:  stringToUsername(targetUsername),
		SetterUsername:  verification.Username,
		Status:          1,
		TaskDescription: stringTo120ByteArray(taskDesc),
		Filterone:       0,
		Filtertwo:       0,
	}
	addTaskRequest := AddTaskRequest{
		Verification: verification,
		NewTask:      task,
	}

	req, _ := networktools.GenerateRequest(addTaskRequest, 16)
	data, _ := networktools.Handle_Single_TCP_Exchange("192.168.1.76:5050", req, 1024)
	response, _ := networktools.DeserialiseRequest(data)
	printError(response, "Successfully added task")

}

func removeTask(reader *bufio.Reader, verification Verification) {
	fmt.Print("Enter the ID of the task you want to remove: ")
	taskIDStr, _ := reader.ReadString('\n')
	taskIDStr = strings.TrimSpace(taskIDStr)

	taskID, err := strconv.ParseUint(taskIDStr, 10, 64)
	if err != nil {
		fmt.Println("Invalid task ID. Please enter a valid number.")
		return
	}

	removeTaskRequest := RemoveTaskRequest{
		Verification: verification,
		TaskID:       taskID,
	}

	req, _ := networktools.GenerateRequest(removeTaskRequest, 17)
	data, _ := networktools.Handle_Single_TCP_Exchange("192.168.1.76:5050", req, 1024)
	response, _ := networktools.DeserialiseRequest(data)
	printError(response, "Successfully removed task")
}

func pollTasks(reader *bufio.Reader, verification Verification) {
	fmt.Print("Enter the ID of the last task you've seen (0 for all tasks): ")
	lastSeenIDStr, _ := reader.ReadString('\n')
	lastSeenIDStr = strings.TrimSpace(lastSeenIDStr)

	lastSeenID, err := strconv.ParseUint(lastSeenIDStr, 10, 64)
	if err != nil {
		fmt.Println("Invalid input. Using 0 as the last seen task ID.")
		lastSeenID = 0
	}
	pollRequest := PollUserRequest{
		Verification:   verification,
		LastSeenTaskID: lastSeenID, // Poll all tasks
	}

	req, _ := networktools.GenerateRequest(pollRequest, 15)
	data, _ := networktools.Handle_Single_TCP_Exchange("192.168.1.76:5050", req, 1024)
	response, _ := networktools.DeserialiseRequest(data)

	var tasks []Task
	err = networktools.DeserialiseData(&tasks, response.Payload)
	if err != nil {
		fmt.Println("Error retrieving tasks:", err)
		return
	}
	printError(response, "Successfully registered tasks")

	printTasks(tasks)
}

func printTasks(tasks []Task) {
	for i, task := range tasks {
		fmt.Printf("Task #%d:\n", i+1)
		fmt.Printf("  Task ID: %d\n", task.TaskID)
		fmt.Printf("  Task Name: %s\n", string(bytes.Trim(task.TaskName[:], "\x00")))
		fmt.Printf("  Target Username: %s\n", string(bytes.Trim(task.TargetUsername[:], "\x00")))
		fmt.Printf("  Setter Username: %s\n", string(bytes.Trim(task.SetterUsername[:], "\x00")))
		fmt.Printf("  Task Description: %s\n", string(bytes.Trim(task.TaskDescription[:], "\x00")))
		fmt.Printf("  Filter One: %064b\n", task.Filterone)
		fmt.Printf("  Filter Two: %064b\n", task.Filtertwo)
		fmt.Println("--------------------")
	}
}

// Implement createHash function based on your Hash type
func createHash(password string) Hash {

	hashBytes := sha256.Sum256([]byte(password))

	// This is a placeholder. Implement actual hash function.
	var hash Hash
	copy(hash[:], hashBytes[:32])
	return hash
}
func printByteArrayAsString(arr interface{}) {
	value := reflect.ValueOf(arr)
	if value.Kind() != reflect.Array {
		fmt.Println("Not an array")
		return
	}

	bytes := make([]byte, value.Len())
	for i := 0; i < value.Len(); i++ {
		bytes[i] = byte(value.Index(i).Uint())
	}

	fmt.Printf("%s\n", string(bytes))
}

func stringToByteArray(s string, size int) [30]byte {
	var result [30]byte
	copy(result[:], s)
	return result
}

func stringTo30ByteArray(s string) [30]byte {
	var result [30]byte
	copy(result[:], s)
	return result
}

func stringTo20ByteArray(s string) [20]byte {
	var result [20]byte
	copy(result[:], s)
	return result
}

func stringTo120ByteArray(s string) [120]byte {
	var result [120]byte
	copy(result[:], s)
	return result
}

func stringToUsername(s string) Username {
	var username [20]byte
	copy(username[:], s)
	return username
}

// The printTasks function remains the same as in your original code
