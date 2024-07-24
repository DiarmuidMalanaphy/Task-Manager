import 'base.dart';
import 'dart:typed_data';
import 'utility.dart';

class RemoveTaskRequest {
  final Verification verification;
  final int taskID;

  RemoveTaskRequest(this.verification, this.taskID);
}

Uint8List serializeRemoveTaskRequest(RemoveTaskRequest request) {
  var buffer = ByteData(60); // 60 bytes payload
  // Write payload
  buffer.buffer.asUint8List(0, 20).setAll(0, request.verification.username.bytes);
  buffer.buffer.asUint8List(20, 32).setAll(0, request.verification.hash);
  buffer.setUint64(52, request.taskID, Endian.little);

  return buffer.buffer.asUint8List();
}

RemoveTaskRequest? deserialiseRemoveTaskRequest(Uint8List? payload) {
  if (payload != null){

    if (payload.length < 60) { // 20 (Username) + 32 (Hash) + 8 (TaskID)
      return null;
    }

    var username = Username.fromBytes(payload.sublist(0, 20));
    var hash = payload.sublist(20, 52);
    var verification = Verification(username, hash);
    var taskID = getUint64(payload, 52);

    return RemoveTaskRequest(verification, taskID);
    }
    return null;
}

