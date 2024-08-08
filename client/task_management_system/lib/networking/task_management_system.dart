import 'package:task_management_system/networking/auth.dart';
import 'package:task_management_system/networking/standards/Error.dart';
import 'package:fixnum/fixnum.dart';
import 'package:task_management_system/networking/standards/LoginRequest.dart';
import 'standards/username.dart';
import 'standards/AddUserRequest.dart';
import 'standards/AddTaskRequest.dart';
import 'standards/verification.dart';
import 'standards/VerifyUserExists.dart';
import 'standards/RemoveTaskRequest.dart';
import 'standards/PollUserRequest.dart';
import 'dart:typed_data';
import 'standards/Task.dart';
import 'standards/request.dart';
import 'standards/utility.dart';
import 'networktool.dart';

class TaskManagementSystem {
  final Auth _auth;
  TaskManagementSystem(this._auth);

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

  Initialisation_Verification_Type? get userdata {
    return _auth.getInitialVerification();
  }

  Username_Type? get username {
    return _auth.getUsername();
  }

  void clearVerification() {
    _auth.clear();
  }

  void setVerification(Initialisation_Verification_Type verification) {
    _auth.storeInitialVerification(verification);
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
      username,
      password,
    );

    var req = serialiseRequest(2, request.serialise);
    Request_Type reply = await handleSingleTCPExchange(req, targetIP, 5050);

    bool err = logError(reply);
    if (err) {
      _auth.storeInitialVerification(Initialisation_Verification_Type(
          request.verification.username, request.verification.hash));
      _auth.storeVerificationToken(
          Verification_Token_Type.fromProto(reply.payload));
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

  Future<bool> getAuthToken(Initialisation_Verification_Type veri) async {
    LoginRequest_Type request = LoginRequest_Type(veri);
    var req = serialiseRequest(6, request.serialise);
    Request_Type reply = await handleSingleTCPExchange(req, targetIP, 5050);
    bool err = logError(reply);
    if (err) {
      _auth.storeVerificationToken(
          Verification_Token_Type.fromProto(reply.payload));
    }
    return err;
  }

  Future<List<Task_Type>> pollTasks(int lastSeenID) async {
    var token = await _auth.getVerificationToken();
    var pollRequest = PollUserRequest_Type(token!, Int64(lastSeenID));

    var req = serialiseRequest(15, pollRequest.serialise);

    var reply = await handleSingleTCPExchange(req, targetIP, 5050);

    bool err = logError(reply);

    if (err) {
      return deserialiseTasks(reply.payload);
    } else {
      return [];
    }
  }

  Future<bool> addTask(String taskName, String taskDesc, String setterUsername,
      String targetUsername, int filterone, int filtertwo) async {
    var task = Task_Type(
      Int64(0),
      Username_Type.fromString(taskName),
      Username_Type.fromString(targetUsername),
      Username_Type.fromString(setterUsername),
      0,
      stringTo120ByteArray(taskDesc),
      Int64(filterone),
      Int64(0),
    );

    print("Personal Username ${setterUsername.toString()}");
    var token = await _auth.getVerificationToken();
    var addTaskRequest = AddTaskRequest_Type(token!, task);
    var req = serialiseRequest(16, addTaskRequest.serialise);
    var reply = await handleSingleTCPExchange(req, targetIP, 5050);
    return logError(reply);
  }

  Future<bool> removeTask(int taskID) async {
    var token = await _auth.getVerificationToken();
    var removeTaskRequest = RemoveTaskRequest_Type(token!, taskID);

    var req = serialiseRequest(17, removeTaskRequest.serialise);
    var reply = await handleSingleTCPExchange(req, targetIP, 5050);

    return logError(reply);
  }

  Future<bool> flipTaskStatus(int taskID) async {
    var token = await _auth.getVerificationToken();
    var removeTaskRequest = RemoveTaskRequest_Type(token!, taskID);
    var req = serialiseRequest(20, removeTaskRequest.serialise);
    var reply = await handleSingleTCPExchange(req, targetIP, 5050);

    return logError(reply);
  }
}
