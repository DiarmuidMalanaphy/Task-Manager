import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'standards/request.dart';
import 'standards/base.dart';
import 'standards/Error.dart';
import 'standards/RemoveTaskRequest.dart';
import 'standards/AddTaskRequest.dart';
import 'standards/AddUserRequest.dart';
import 'standards/PollUserRequest.dart';
import 'standards/Task.dart';
import 'networktool.dart';

void main() async {
  print("Welcome to the Task Management System");

  // User Registration
  stdout.write("Enter username: ");
  String username = stdin.readLineSync()!.trim();

  stdout.write("Enter password: ");
  String password = stdin.readLineSync()!.trim();

  var addUserRequest = AddUserRequest(
    Username.fromString(username),
    stringToByteArray(password, 30),
  );

  var req = serialiseRequest(2, serializeAddUserRequest(addUserRequest));
  var data = await handleSingleTCPExchange(req, "192.168.1.76", 5050);
  var incomingRequest = deserialiseRequest(data);

  if (incomingRequest != null) {
    printError(incomingRequest, "User Registered Successfully");
  } else {
    print("Failed to deserialize the response.");
    return;
  }

  var verification = Verification(
    Username.fromString(username),
    createHash(password),
  );

  while (true) {
    print("\n1. Add Task");
    print("2. Poll Tasks");
    print("3. Remove Task");
    print("4. Exit");
    stdout.write("Choose an option: ");

    String choice = stdin.readLineSync()!.trim();

    switch (choice) {
      case "1":
        await addTask(verification);
        break;
      case "2":
        await pollTasks(verification);
        break;
      case "3":
        await removeTask(verification);
        break;
      case "4":
        print("Exiting...");
        return;
      default:
        print("Invalid option, please try again.");
    }
  }
}

void printError(Request req, String goodString) {
  if (req.type == 255) {
    var error = Error.deserialize(req.payload);
    print(error.errorMessage);
  } else {
    print(goodString);
  }
}

Future<void> addTask(Verification verification) async {
  stdout.write("Enter task name: ");
  String taskName = stdin.readLineSync()!.trim();

  stdout.write("Enter task description: ");
  String taskDesc = stdin.readLineSync()!.trim();

  stdout.write("Enter target username: ");
  String targetUsername = stdin.readLineSync()!.trim();

  var task = Task(
    stringTo20ByteArray(taskName),
    Username.fromString(targetUsername),
    verification.username,
    1,
    stringTo120ByteArray(taskDesc),
    BigInt.zero,
    BigInt.zero,
    0,
  );

  var addTaskRequest = AddTaskRequest(verification, task);
  var req = serialiseRequest(16, serializeAddTaskRequest(addTaskRequest));
  var data = await handleSingleTCPExchange(req, "192.168.1.76", 5050);
  var response = deserialiseRequest(data);

  if (response != null) {
    printError(response, "Successfully added task");
  } else {
    print("Failed to deserialize the response.");
  }
}

Future<void> removeTask(Verification verification) async {
  stdout.write("Enter the ID of the task you want to remove: ");
  String taskIDStr = stdin.readLineSync()!.trim();

  int taskID = int.tryParse(taskIDStr) ?? 0;
  if (taskID == 0) {
    print("Invalid task ID. Please enter a valid number.");
    return;
  }

  var removeTaskRequest = RemoveTaskRequest(verification, taskID);
  var req = serialiseRequest(17, serializeRemoveTaskRequest(removeTaskRequest));
  var data = await handleSingleTCPExchange(req, "192.168.1.76", 5050);
  var response = deserialiseRequest(data);

  if (response != null) {
    printError(response, "Successfully removed task");
  } else {
    print("Failed to deserialize the response.");
  }
}

Future<void> pollTasks(Verification verification) async {
  stdout.write("Enter the ID of the last task you've seen (0 for all tasks): ");
  String lastSeenIDStr = stdin.readLineSync()!.trim();

  int lastSeenID = int.tryParse(lastSeenIDStr) ?? 0;

  var pollRequest = PollUserRequest(verification, lastSeenID);
  var req = serialiseRequest(15, serializePollUserRequest(pollRequest));
  var data = await handleSingleTCPExchange(req, "192.168.1.76", 5050);
  var response = deserialiseRequest(data);

  if (response != null) {
    if (response.type != 255) {
      var tasks = deserializeTasks(response.payload);
      printTasks(tasks);
    } else {
      printError(response, "");
    }
  } else {
    print("Failed to deserialize the response.");
  }
}

void printTasks(List<Task> tasks) {
  for (var i = 0; i < tasks.length; i++) {
    var task = tasks[i];
    print("Task #${i + 1}:");
    print("  Task ID: ${task.taskID}");
    print("  Task Name: ${String.fromCharCodes(task.taskName).trim()}");
    print(
        "  Target Username: ${String.fromCharCodes(task.targetUsername).trim()}");
    print(
        "  Setter Username: ${String.fromCharCodes(task.setterUsername).trim()}");
    print(
        "  Task Description: ${String.fromCharCodes(task.taskDescription).trim()}");
    print("  Filter One: ${task.filterone.toRadixString(2).padLeft(64, '0')}");
    print("  Filter Two: ${task.filtertwo.toRadixString(2).padLeft(64, '0')}");
    print("--------------------");
  }
}

Uint8List createHash(String password) {
  var bytes = utf8.encode(password);
  var digest = sha256.convert(bytes);
  return Uint8List.fromList(digest.bytes);
}

Uint8List stringToByteArray(String s, int size) {
  var result = Uint8List(size);
  var bytes = utf8.encode(s);
  result.setAll(0, bytes.take(size));
  return result;
}

Uint8List stringTo30ByteArray(String s) => stringToByteArray(s, 30);
Uint8List stringTo20ByteArray(String s) => stringToByteArray(s, 20);
Uint8List stringTo120ByteArray(String s) => stringToByteArray(s, 120);
