import 'dart:typed_data';
import 'bufferedsocket.dart';
import 'standards/request.dart';
import 'standards/base.dart';
import 'standards/RemoveTaskRequest.dart';


void main() {
  // Create a sample RemoveTaskRequest
  var sample_username = "Test user";
  var username = Username.fromString(sample_username);
  print(username);
  var hash = Uint8List(32); // 32 bytes of zeros for this example
  var verification = Verification(username, hash);
  var taskID = 12345;
  var data = RemoveTaskRequest(verification, taskID);

  // Serialize the request
  var serialisedData = serializeRemoveTaskRequest(data);
  
  var serialisedRequest = serialiseRequest(7, serialisedData); 

  print('Serialized Request:');
  print(serialisedRequest);

  // Deserialize the request
  var deserialised_request = deserialiseRequest(serialisedRequest);
  if (deserialised_request != null){

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



