import 'dart:typed_data';
import 'dart:async';
import 'dart:io';
import 'standards/Task.dart';
import 'standards/request.dart';
import 'standards/base.dart';
import 'standards/Error.dart';
import 'standards/RemoveTaskRequest.dart';
import 'networktool.dart';

Future<void> main() async {
  // Create a sample RemoveTaskRequest
  var sample_username = "malanaph";
  var username = Username.fromString(sample_username);
  print(username);
  var hash = Uint8List(32); // 32 bytes of zeros for this example
  var verification = Verification(username, hash);
  var taskID = 12345;
  var data = RemoveTaskRequest(verification, taskID);

  // Serialize the request
  var serialisedData = serializeRemoveTaskRequest(data);

  var serialisedRequest = serialiseRequest(17, serialisedData);

  var data_from_exchange =
      await handleSingleTCPExchange(serialisedRequest, "192.168.1.76", 5050);
  print("Message ${data_from_exchange.type}");
  if (data_from_exchange.type == 255) {
    var error = Error.deserialize(data_from_exchange.payload);
    print(error.errorMessage);
  }
  print('Serialized Request:');
  print(serialisedRequest);

  // Deserialize the request
  var deserialised_request = deserialiseRequest(serialisedRequest);
  if (deserialised_request != null) {
    var data = deserialiseRemoveTaskRequest(deserialised_request.payload);
    print('\nDeserialized Request:');
    if (data != null) {
      print('Username: ${data.verification.username}');
      print('Hash: ${data.verification.hash}');
      print('TaskID: ${data.taskID}');
    } else {
      print('Failed to deserialize the request.');
    }
  }
}
