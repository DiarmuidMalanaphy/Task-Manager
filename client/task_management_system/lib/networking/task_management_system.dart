import 'package:task_management_system/networking/standards/Error.dart';
import 'package:fixnum/fixnum.dart';
import 'package:task_management_system/networking/standards/LoginRequest.dart';
import 'standards/base.dart';
import 'standards/AddUserRequest.dart';
import 'standards/AddTaskRequest.dart';
import 'standards/VerifyUserExists.dart';
import 'standards/RemoveTaskRequest.dart';
import 'standards/PollUserRequest.dart';
import 'dart:typed_data';
import 'standards/Task.dart';
import 'standards/request.dart';
import 'standards/utility.dart';
import 'networktool.dart';

class TaskManagementSystem {
  Verification_Type? _verification;
  final targetIP =
      "192.168.0.66"; // Should add an IP address that is verified to work on the initial login stage or, have it such that it pings the IP address a few times to see if it will reply.

//          UTILITY FUNCTIONS
  bool logError(Request_Type request) {
    //True if there is no error from the server
    if (request.type == 200 || request.type == 220) {
      return true;
    }
    if (request.type == 254 || request.type == 253) {
      throw ArgumentError(
          "Socket Not available -> Indicates Server turned off");
    }

    if (request.type != 255) {
      throw ArgumentError(
          "The return type is neither a success or a failure -> Unusual");
    }
    Error_Type error = Error_Type.fromBuffer(request.payload);
    print("Error Logged by TMS: ${error.errorMessage} ");

    return false;
  }

  Verification_Type get verification {
    return _verification!;
  }

  void resetVerification() {
    _verification = null;
  }

//NETWORKING FUNCTIONS

  Future<bool> pingAlive() async {
    Uint8List empty = Uint8List(0);
    var req = serialiseRequest(1, empty);
    Request_Type reply = await handleSingleTCPExchange(req, targetIP, 5050);
    return logError(reply);
  }

  Future<bool> registerUser(String username, String password) async {
    var request = AddUserRequest_Type(
      Username_Type.fromString(username),
      Password.fromString(password),
    );

    var req = serialiseRequest(2, request.serialise);
    Request_Type reply = await handleSingleTCPExchange(req, targetIP, 5050);

    bool err = logError(reply);
    if (err) {
      _verification = Verification_Type(
        Username_Type.fromString(username),
        createHash(password),
      );
    }
    return err;
  }

  Future<bool> verifyUserExists(String username) async {
    // Create a VerifyUserExistsRequest
    var request =
        VerifyUserExistsRequest_Type(Username_Type.fromString(username));

    var networkRequest = serialiseRequest(4, request.serialise);

    Request_Type reply =
        await handleSingleTCPExchange(networkRequest, targetIP, 5050);

    return logError(reply);
  }

  Future<bool> loginUser(Verification_Type veri) async {
    LoginRequest_Type request = LoginRequest_Type(veri);

    var req = serialiseRequest(6, request.serialise);
    Request_Type reply = await handleSingleTCPExchange(req, targetIP, 5050);
    bool err = logError(reply);
    if (err) {
      _verification = veri;
    }
    return err;
  }

  Future<List<Task_Type>> pollTasks(int lastSeenID) async {
    var pollRequest = PollUserRequest_Type(verification, lastSeenID);

    var req = serialiseRequest(15, pollRequest.serialise);

    var reply = await handleSingleTCPExchange(req, targetIP, 5050);

    bool err = logError(reply);

    if (err) {
      return deserialiseTasks(reply.payload);
    } else {
      return [];
    }
  }

  Future<bool> addTask(String taskName, String taskDesc, String targetUsername,
      int filterone, int filtertwo) async {
    var task = Task_Type(
      Int64(0),
      Username_Type.fromString(taskName),
      Username_Type.fromString(targetUsername),
      verification.username,
      0,
      stringTo120ByteArray(taskDesc),
      Int64(filterone),
      Int64(0),
    );

    var addTaskRequest = AddTaskRequest_Type(verification, task);
    var req = serialiseRequest(16, addTaskRequest.serialise);
    var reply = await handleSingleTCPExchange(req, targetIP, 5050);
    return logError(reply);
  }

  Future<bool> removeTask(int taskID) async {
    var removeTaskRequest = RemoveTaskRequest_Type(verification, taskID);

    var req = serialiseRequest(17, removeTaskRequest.serialise);
    var reply = await handleSingleTCPExchange(req, targetIP, 5050);

    return logError(reply);
  }

  Future<bool> flipTaskStatus(int taskID) async {
    var removeTaskRequest = RemoveTaskRequest_Type(verification, taskID);
    var req = serialiseRequest(20, removeTaskRequest.serialise);
    var reply = await handleSingleTCPExchange(req, targetIP, 5050);

    return logError(reply);
  }
}
