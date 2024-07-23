package main

import (
	"bytes"
	"crypto/sha256"
	"fmt"
	networktool "github.com/DiarmuidMalanaphy/networktools"
)

const (
	RequestTypePollAlive        = uint8(1)
	RequestTypeAddUser          = uint8(2)
	RequestTypeRemoveUser       = uint8(3)
	RequestTypeVerifyUserExists = uint8(4)
	RequestTypeUpdateUser       = uint8(5)

	RequestTypePollUser       = uint8(15)
	RequestTypeAddTask        = uint8(16)
	RequestTypeRemoveTask     = uint8(17)
	RequestTypeRemoveAllTasks = uint8(18)
	RequestTypeUpdateTask     = uint8(19)
	RequestTypeFlipTaskState  = uint8(20)
	RequestSuccessful         = uint8(200)
	RequestFailure            = uint8(255)
)

func main() {
	initTaskDB()
	initUserDB()
	user_map := LoadPreexisingUserMap()

	request_channel, listener := networktool.Create_TCP_Listener(5050)

	for {
		select {
		case data := <-request_channel: //Could have support for TCP requests in here too.
			handle_TCP_requests(data, user_map)
		}
	}
	listener.Stop()
}

func createHash(input string) Hash {
	// Compute SHA-256 hash of the input
	hashBytes := sha256.Sum256([]byte(input))

	// Convert the hash to Hash type (which is [20]byte)
	var hash Hash
	copy(hash[:], hashBytes[:32])

	return hash
}

type empty struct {
	Type uint8
}

func get_small_meaningless_data() empty {
	return empty{
		Type: 8,
	}
}

//Specification for each Request
// RequestTypePollAlive ->
// Simple ping, just reply with a success
// RequestTypeAddUser ->
// Take a password as input, hash it on the server and store it
// Validate if the user already exists, if so deny and send failure.
// if not, return successful -> Make the validation work based off of username
// RequestTypeRemoveUser ->
// Take a hash value as input + username
// Delete a user, all references to them and their tasks.
// RequestTypeVerifyUserExists ->
// Takes a username as input
// Returns a boolean if they exist or not
// RequestTypePollUser ->
// Take a hash as input + username + Last seen TaskID
// Send all tasks greater than the LastSeenTaskID
// RequestTypeAddTask ->
// Take a hash as input + personal_username + Task
// Return a success or failure
// RequestTypeRemoveTask ->
// Take a hash as input + personal_username + TaskID
// Return a success or failure
// RequestTypeRemoveAllTasks ->
// Take a hash as input + personal_username
// Delete all tasks in the users account
// Return a success or failure

func handle_TCP_requests(data networktool.TCPNetworkData, user_map *UserMap) {
	fmt.Println(data.Request.Type)
	switch data.Request.Type {
	case RequestTypePollAlive:
		generate_and_send_success(data)
		return

	case RequestTypeAddUser:
		var r AddUserRequest
		err := networktool.DeserialiseData(&r, data.Request.Payload)
		if err != nil {
			fmt.Println(err)
			return
		}
		if does_user_exist(r.Username, user_map) {
			generate_and_send_error("Username already exists", data)
			return
		}

		stringified_password := string(bytes.Trim(r.Password[:], "\x00"))

		new_user := newUser(r.Username, createHash(stringified_password))

		user_map.Add(&new_user)
		generate_and_send_success(data)
		return

	case RequestTypeRemoveUser:
		var r RemoveUserRequest
		err := networktool.DeserialiseData(&r, data.Request.Payload)
		fmt.Println(r.Verification.Username)
		if err != nil {
			fmt.Println(err)
			return

		}
		if !does_user_exist(r.Verification.Username, user_map) {
			generate_and_send_error("Username doesn't exist", data)
			return
		}

		if !user_map.Verify(r.Verification) {
			generate_and_send_error("Incorrect Username or Password", data)
			return
		}

		user_map.Remove(r.Verification.Username.toString())
		generate_and_send_success(data)
		return

	case RequestTypeVerifyUserExists:
		var r VerifyUserExistsRequest
		err := networktool.DeserialiseData(&r, data.Request.Payload)
		if err != nil {
			fmt.Println(err)
			return
		}

		if !does_user_exist(r.Username, user_map) {
			generate_and_send_error("Username doesn't exist", data)
			return
		}

		generate_and_send_success(data)
		return

	case RequestTypePollUser:
		fmt.Println("polling")
		var t PollUserRequest
		err := networktool.DeserialiseData(&t, data.Request.Payload)
		if err != nil {
			fmt.Println(err)
		}

		if !does_user_exist(t.Verification.Username, user_map) {
			generate_and_send_error("Sender username isn't registered", data)
			return
		}
		fmt.Println("BB")
		if !user_map.Verify(t.Verification) {
			generate_and_send_error("Incorrect Username or Password", data)
			return
		}
		user := user_map.Value(t.Verification.Username.toString())
		tasks, err := user.GetTasksAfter(uint64(t.LastSeenTaskID))
		outgoing_req, err := networktool.GenerateRequest(tasks, RequestSuccessful)
		fmt.Println("Worked")
		if err != nil {
			fmt.Println(err)
			return
		}
		networktool.SendTCPReply(data.Conn, outgoing_req)
		return

	case RequestTypeAddTask:
		fmt.Println("Add Task")
		var r AddTaskRequest
		err := networktool.DeserialiseData(&r, data.Request.Payload)
		if err != nil {
			fmt.Println(err)
			return
		}

		if !does_user_exist(r.Verification.Username, user_map) {
			generate_and_send_error("Sender username isn't registered", data)
			return
		}
		fmt.Println(user_map.Verify(r.Verification))
		if !user_map.Verify(r.Verification) {
			generate_and_send_error("Incorrect Username or Password", data)
			return
		}

		if !does_user_exist(r.NewTask.TargetUsername, user_map) {
			generate_and_send_error("Recipient username isn't registered", data)
			return
		}
		target_user := user_map.Value(r.NewTask.TargetUsername.toString())

		r.NewTask.TaskID = target_user.IncrementTaskID()
		err = target_user.AddTask(r.NewTask)
		if err != nil {
			fmt.Println(err)
			generate_and_send_error("Error storing the task", data)
			return
		}

		err = writeTaskToDB(target_user.UserID, r.NewTask)
		if err != nil {
			fmt.Println(err)
			return
		}

		generate_and_send_success(data)
		return

	case RequestTypeRemoveTask:
		var r RemoveTaskRequest
		err := networktool.DeserialiseData(&r, data.Request.Payload)
		fmt.Println(r.Verification.Username)
		if err != nil {
			fmt.Println(err)
			return
		}
		if !does_user_exist(r.Verification.Username, user_map) {
			generate_and_send_error("Sender username isn't registered", data)
			return
		}
		if !user_map.Verify(r.Verification) {
			generate_and_send_error("Incorrect Username or password", data)
			return
		}
		user := user_map.Value(r.Verification.Username.toString())
		user.RemoveTask(r.TaskID)
		generate_and_send_success(data)
		return

	case RequestTypeRemoveAllTasks:
		var r RemoveAllTasksRequest
		err := networktool.DeserialiseData(&r, data.Request.Payload)
		if err != nil {
			fmt.Println(err)
			return
		}
		if !does_user_exist(r.Verification.Username, user_map) {
			generate_and_send_error("Sender username isn't registered", data)
			return
		}
		if !user_map.Verify(r.Verification) {
			generate_and_send_error("Incorrect Username or Password", data)
			return
		}
		user := user_map.Value(r.Verification.Username.toString())
		user.ClearTasks()
		generate_and_send_success(data)
		return

	case RequestTypeFlipTaskState:
		var r RemoveTaskRequest
		err := networktool.DeserialiseData(&r, data.Request.Payload)
		if err != nil {
			fmt.Println(err)
			return
		}
		if !does_user_exist(r.Verification.Username, user_map) {
			generate_and_send_error("Sender username isn't registered", data)
			return
		}
		if !user_map.Verify(r.Verification) {
			generate_and_send_error("Incorrect Username or Password", data)
			return
		}
		user := user_map.Value(r.Verification.Username.toString())
		flipTaskState(user.UserID, r.TaskID)

	}

}

func generate_globally_unique_task_ID(task Task, user_map *UserMap) *Uint128 {
	task_user := user_map.Value(task.TargetUsername.toString())
	return task.Generate_globally_unique_task_ID(task_user.UserID)
}

func does_user_exist(user Username, user_map *UserMap) bool { //-> could remove this function and just use a user_map function but is more legible like this
	if user_map.In(user.toString()) {
		return true
	}
	return false
}

func generate_and_send_error(error_message string, data networktool.TCPNetworkData) {
	error_request, err := generate_error(error_message)
	if err != nil {
		fmt.Println(err)
	} else {
		networktool.SendTCPReply(data.Conn, error_request)
	}
}

func generate_and_send_success(data networktool.TCPNetworkData) {
	outgoing_req, err := networktool.GenerateRequest(get_small_meaningless_data(), RequestSuccessful)
	if err != nil {
		fmt.Println(err)
	}
	networktool.SendTCPReply(data.Conn, outgoing_req)
}

func stringToUserName(u string) Username {
	originalBytes := []byte(u)
	// Pad the byte slice to 15 bytes
	var username Username
	copy(username[:], originalBytes)

	return username //Implement it later, essentially just puff it up to 20 bytes
}

func generate_error(error_string string) ([]byte, error) {
	if len(error_string) < 60 {

		generated_error := NewError(error_string)
		return networktool.GenerateRequest(generated_error, RequestFailure)
	} else {
		err := fmt.Errorf("Error String too large")
		return nil, err
	}

}
