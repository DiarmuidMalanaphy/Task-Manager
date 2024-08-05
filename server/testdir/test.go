package main

import (
	"bufio"
	"bytes"
	"fmt"
	pb "github.com/DiarmuidMalanaphy/Task-Manager/standards"
	networktools "github.com/DiarmuidMalanaphy/networktools"
	"google.golang.org/protobuf/proto"
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

	protoUser := AddUserRequest{
		Username: stringToUsername(username),
		Password: stringToPassword(password),
	}.ToProto()

	req, err := networktools.GenerateRequest(protoUser, 2)
	if err != nil {
		fmt.Println("Error generating request:", err)
		return
	}

	data, err := networktools.Handle_Single_TCP_Exchange("127.0.0.1:5050", req, 10240)
	if err != nil {
		fmt.Println("Error in TCP exchange:", err)
		return
	}

	incoming_request, err := networktools.DeserialiseRequest(data)
	if err != nil {
		fmt.Println("Error deserializing request:", err)
		return
	}

	fmt.Println(incoming_request.Type)
	if incoming_request.Type == 255 {
		err, _ := Error_FromProto(incoming_request.Payload)
		printByteArrayAsString(err.ErrorMessage)
	} else {
		fmt.Println("User Registered Successfully")
	}

	// Create verification object
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

	protoAddTaskRequest := addTaskRequest.ToProto()

	req, _ := networktools.GenerateRequest(protoAddTaskRequest, 16)

	data, _ := networktools.Handle_Single_TCP_Exchange("127.0.0.1:5050", req, 10240)
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

	protoRemoveTaskRequest := removeTaskRequest.ToProto()

	req, _ := networktools.GenerateRequest(protoRemoveTaskRequest, 17)
	data, _ := networktools.Handle_Single_TCP_Exchange("127.0.0.1:5050", req, 10240)
	response, _ := networktools.DeserialiseRequest(data)
	printError(response, "Successfully removed task")
}

func pollTasks(reader *bufio.Reader, verification Verification) {
	fmt.Print("Enter the ID of the last task you've seen (0 for all tasks): ")
	lastSeenIDStr, _ := reader.ReadString('\n')
	lastSeenIDStr = strings.TrimSpace(lastSeenIDStr)

	lastSeenID, err := strconv.ParseUint(lastSeenIDStr, 10, 32)
	if err != nil {
		fmt.Println("Invalid input. Using 0 as the last seen task ID.")
		lastSeenID = 0
	}
	pollRequest := PollUserRequest{
		Verification:   verification,
		LastSeenTaskID: uint32(lastSeenID),
	}

	protoPollRequest := pollRequest.ToProto()

	req, _ := networktools.GenerateRequest(protoPollRequest, 15)
	data, _ := networktools.Handle_Single_TCP_Exchange("127.0.0.1:5050", req, 10240)
	response, _ := networktools.DeserialiseRequest(data)

	if response.Type == 255 {
		err, _ := Error_FromProto(response.Payload)
		printByteArrayAsString(err.ErrorMessage)
		return
	}

	var taskList pb.TaskList
	err = proto.Unmarshal(response.Payload, &taskList)
	if err != nil {
		fmt.Println("Error unmarshaling task list:", err)
		return
	}

	tasks := make([]Task, len(taskList.Tasks))
	for i, protoTask := range taskList.Tasks {
		tasks[i] = Task_FromProto(protoTask)
	}

	printTasks(tasks)
}

func printError(req networktools.Request_Type, good_string string) {
	if req.Type == 255 {
		err, _ := Error_FromProto(req.Payload)

		printByteArrayAsString(err.ErrorMessage)
	} else {
		fmt.Println(good_string)

	}
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

func stringToPassword(s string) Password {
	var password [30]byte
	copy(password[:], s)
	return password
}

// The printTasks function remains the same as in your original code
