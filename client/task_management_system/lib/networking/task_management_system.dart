import 'package:task_management_system/networking/auth.dart';
import 'package:task_management_system/networking/dartproto/Verification.pb.dart';
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
import 'error.dart';
import 'standards/Task.dart';
import 'standards/request.dart';
import 'standards/utility.dart';
import 'networktool.dart';
import 'dart:io';

class TaskManagementSystem {
  final Auth _auth;
  late String targetIP;
  TaskManagementSystem(this._auth) {
    initializeIP();
  }
  Future<void> initializeIP() async {
    String? grabbedIP = _auth.getIPAddress();
    if (grabbedIP == null) {
      try {
        targetIP = await _resolveIPAddress("diarmuidmalanaphy.co.uk");
      } catch (e) {
        // If DNS resolution fails, default to 0.0.0.0
        print('Failed to resolve IP address: $e');
        targetIP = "0.0.0.0";
      }
    } else {
      targetIP = grabbedIP;
    }
    print('Resolved IP: $targetIP');
  }

  Future<String> _resolveIPAddress(String hostname) async {
    try {
      final List<InternetAddress> addresses =
          await InternetAddress.lookup(hostname);
      if (addresses.isNotEmpty) {
        return addresses.first.address;
      }
    } catch (e) {
      print('Failed to resolve IP address: $e');
    }
    // Fallback to a default IP address if resolution fails
    return "192.168.0.66";
  }

  //final targetIP = _auth "192.168.0.66"; // Should add an IP address that is verified to work on the initial login stage or, have it such that it pings the IP address a few times to see if it will reply.

//          UTILITY FUNCTIONS
  ReturnError logError(Request_Type request) {
    //True if there is no error from the server
    if (request.type == 200 || request.type == 220) {
      return ReturnError(true, "");
    }
    if (request.type == 254 || request.type == 253) {
      return ReturnError(false, "Cannot Connect to server at ${targetIP} ");
    }

    if (request.type != 255) {
      throw ArgumentError(
          "The return type is neither a success or a failure -> Unusual");
    }
    Error_Type error = Error_Type.fromBuffer(request.payload);
    print("Error Logged by TMS: ${error.errorMessage} ");

    return ReturnError(false, error.errorMessage);
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

  Future<ReturnError> pingAlive() async {
    Uint8List empty = Uint8List(0);
    var req = serialiseRequest(1, empty);
    Request_Type reply = await handleSingleTCPExchange(req, targetIP, 5050);
    return logError(reply);
  }

  Future<ReturnError> registerUser(String username, String password) async {
    var request = AddUserRequest_Type(
      username,
      password,
    );

    var req = serialiseRequest(2, request.serialise);
    Request_Type reply = await handleSingleTCPExchange(req, targetIP, 5050);

    ReturnError err = logError(reply);
    if (err.success) {
      _auth.storeInitialVerification(Initialisation_Verification_Type(
          request.verification.username, request.verification.hash));
      _auth.storeVerificationToken(
          Verification_Token_Type.fromProto(reply.payload));
    }
    return err;
  }

  Future<ReturnError> verifyUserExists(String username) async {
    // Create a VerifyUserExistsRequest
    var request =
        VerifyUserExistsRequest_Type(Username_Type.fromString(username));

    var networkRequest = serialiseRequest(4, request.serialise);

    Request_Type reply =
        await handleSingleTCPExchange(networkRequest, targetIP, 5050);

    return logError(reply);
  }

  Future<ReturnError> verifyToken() async {
    var request = _auth.getVerificationToken();
    if (request == null) {
      return ReturnError(false, "No token");
    }
    var networkRequest = serialiseRequest(7, request.serialise);
    Request_Type reply =
        await handleSingleTCPExchange(networkRequest, targetIP, 5050);
    return logError(reply);
  }

  Future<ReturnError> getAuthToken(
      Initialisation_Verification_Type veri) async {
    LoginRequest_Type request = LoginRequest_Type(veri);
    var req = serialiseRequest(6, request.serialise);
    Request_Type reply = await handleSingleTCPExchange(req, targetIP, 5050);
    ReturnError err = logError(reply);
    if (err.success) {
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

    bool err = logError(reply).success;

    if (err) {
      return deserialiseTasks(reply.payload);
    } else {
      return [];
    }
  }

  Future<ReturnError> addTask(
      String taskName,
      String taskDesc,
      String setterUsername,
      String targetUsername,
      int filterone,
      int filtertwo) async {
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

    var token = await _auth.getVerificationToken();
    var addTaskRequest = AddTaskRequest_Type(token!, task);
    var req = serialiseRequest(16, addTaskRequest.serialise);
    var reply = await handleSingleTCPExchange(req, targetIP, 5050);
    return logError(reply);
  }

  Future<ReturnError> removeTask(int taskID) async {
    var token = await _auth.getVerificationToken();
    var removeTaskRequest = RemoveTaskRequest_Type(token!, taskID);

    var req = serialiseRequest(17, removeTaskRequest.serialise);
    var reply = await handleSingleTCPExchange(req, targetIP, 5050);

    return logError(reply);
  }

  Future<ReturnError> flipTaskStatus(int taskID) async {
    var token = await _auth.getVerificationToken();
    var removeTaskRequest = RemoveTaskRequest_Type(token!, taskID);
    var req = serialiseRequest(20, removeTaskRequest.serialise);
    var reply = await handleSingleTCPExchange(req, targetIP, 5050);

    return logError(reply);
  }
}
