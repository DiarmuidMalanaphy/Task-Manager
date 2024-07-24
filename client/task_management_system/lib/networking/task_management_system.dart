import 'standards/base.dart';
import 'standards/AddUserRequest.dart';
import 'standards/AddTaskRequest.dart';
import 'standards/RemoveAllTasksRequest.dart';
import 'standards/VerifyUserExists.dart';
import 'standards/RemoveTaskRequest.dart';
import 'standards/PollUserRequest.dart';
import 'standards/Task.dart';
import 'standards/request.dart';
import 'standards/utility.dart';
import 'networktool.dart';

class TaskManagementSystem {
  late Verification verification;
  // Should add an IP address that is verified to work on the initial login stage or, have it such that it pings the IP address a few times to see if it will reply.

  Future<bool> registerUser(String username, String password) async {
    var addUserRequest = AddUserRequest(
      Username.fromString(username),
      Password.fromString(password),
    );

    var req = serialiseRequest(2, serializeAddUserRequest(addUserRequest));
    Request incomingRequest =
        await handleSingleTCPExchange(req, "127.0.0.1", 5050);
    if (incomingRequest.type == 255) {
      return false;
    }
    verification = Verification(
      Username.fromString(username),
      createHash(password),
    );
    return true;
  }

  Future<bool> loginUser(Verification veri) async {
    var req = serialiseRequest(6, veri.bytes);

    Request incomingRequest =
        await handleSingleTCPExchange(req, "127.0.0.1", 5050);
    if (incomingRequest.type == 255) {
      return false;
    }
    verification = veri;
    return true;
  }

  Future<bool> addTask(String taskName, String taskDesc, String targetUsername,
      int filterone, int filtertwo) async {
    var task = Task(
      1,
      Username.fromString(taskName).bytes,
      Username.fromString(targetUsername).bytes,
      verification.username.bytes,
      1,
      stringTo120ByteArray(taskDesc),
      filterone,
      1,
    );

    var addTaskRequest = AddTaskRequest(verification, task);
    var req = serialiseRequest(16, serializeAddTaskRequest(addTaskRequest));
    var data_response = await handleSingleTCPExchange(req, "127.0.0.1", 5050);

    return data_response.type != 255;
  }

  Future<bool> verify_user_exists(String username) async {
    try {
      // Create a VerifyUserExistsRequest
      var request = VerifyUserExistsRequest(Username.fromString(username));

      // Serialize the request
      var serializedRequest = serializeVerifyUserExistsRequest(request);

      // Create the network request
      var networkRequest = serialiseRequest(4, serializedRequest);

      // Send the request and wait for the response
      // Replace "192.168.1.76" and 5050 with your actual server address and port
      Request response =
          await handleSingleTCPExchange(networkRequest, "127.0.0.1", 5050);

      // Check the response
      if (response.type == 255) {
        // Error occurred
        print("Error: ${String.fromCharCodes(response.payload)}");
        return false;
      } else if (response.type == 200) {
        // Assuming 19 is the response type for successful verification
        // User exists
        return true;
      } else {
        // Unexpected response type
        print("Unexpected response type: ${response.type}");
        return false;
      }
    } catch (e) {
      print("An error occurred while verifying user existence: $e");
      return false;
    }
  }

  Future<bool> removeTask(int taskID) async {
    var removeTaskRequest = RemoveTaskRequest(verification, taskID);
    var req =
        serialiseRequest(17, serializeRemoveTaskRequest(removeTaskRequest));
    var data_response = await handleSingleTCPExchange(req, "127.0.0.1", 5050);

    return data_response.type != 255;
  }

  Future<List<Task>> pollTasks(int lastSeenID) async {
    var pollRequest = PollUserRequest(verification, lastSeenID);
    var req = serialiseRequest(15, serializePollUserRequest(pollRequest));
    var data_response = await handleSingleTCPExchange(req, "127.0.0.1", 5050);
    print("Pi");
    if (data_response.type != 255) {
      return deserialiseTaskList(data_response.payload);
    } else {
      return [];
    }
  }
}
