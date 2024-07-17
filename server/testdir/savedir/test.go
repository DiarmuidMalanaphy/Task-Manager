package main

import (
	"bytes"
	"fmt"
	networktools "github.com/DiarmuidMalanaphy/networktools"
)

func main() {
	testUser := AddUserRequest{
		Username: Username{'D', 'E', 'S', 'T'},
		Password: [30]byte{'p', 'a', 's', 's', 'w', 'o', 'r', 'd', '1', '2', '3'},
	}
	req, _ := networktools.GenerateRequest(testUser, 2)

	data, _ := networktools.Handle_Single_TCP_Exchange("192.168.1.76:5050", req, 1024)
	response, err := networktools.DeserialiseRequest(data)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Println("Received Type ", response.Type)
	}

	example_task := Task{
		TaskID:          40,
		TaskName:        [20]byte{'T', 'E', 'S', 'T'},
		TargetUsername:  [20]byte{'D', 'E', 'S', 'T'},
		SetterUsername:  [20]byte{'D', 'E', 'S', 'T'},
		Status:          1,
		TaskDescription: [120]byte{'S', 'E', 'I', 'N', 'A'},
		Filterone:       64,
		Filtertwo:       64,
	}

	example_verification := Verification{
		Username: Username{'D', 'E', 'S', 'T'},
		Hash: Hash{
			0xef, 0x92, 0xb7, 0x78, 0xba, 0xfe, 0x77, 0x1e,
			0x89, 0x24, 0x5b, 0x89, 0xec, 0xbc, 0x08, 0xa4,
			0x4a, 0x4e, 0x16, 0x6c, 0x06, 0x65, 0x99, 0x11,
			0x88, 0x1f, 0x38, 0x3d, 0x44, 0x73, 0xe9, 0x4f,
		},
	}
	testTask := AddTaskRequest{
		Verification: example_verification,
		NewTask:      example_task,
	}
	req, _ = networktools.GenerateRequest(testTask, 6)

	data, _ = networktools.Handle_Single_TCP_Exchange("192.168.1.76:5050", req, 1024)

	response, _ = networktools.DeserialiseRequest(data)
	var slice []Task

	test_poll := PollUserRequest{
		Verification:   example_verification,
		LastSeenTaskID: 3,
	}
	req, _ = networktools.GenerateRequest(test_poll, 5)
	data, _ = networktools.Handle_Single_TCP_Exchange("192.168.1.76:5050", req, 1024)
	response, _ = networktools.DeserialiseRequest(data)

	err = networktools.DeserialiseData(&slice, response.Payload)
	fmt.Println(err)
	printTasks(slice)

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
