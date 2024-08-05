import 'base.dart';
import 'dart:typed_data';

class RemoveAllTasksRequest {
  final Verification_Type verification;

  RemoveAllTasksRequest(this.verification);
}

Uint8List serializeRemoveAllTasksRequest(RemoveAllTasksRequest request) {
  var buffer = ByteData(52); // 52 bytes verification
  buffer.buffer
      .asUint8List(0, 20)
      .setAll(0, request.verification.username.bytes);
  buffer.buffer.asUint8List(20, 32).setAll(0, request.verification.hash);
  return buffer.buffer.asUint8List();
}

RemoveAllTasksRequest? deserializeRemoveAllTasksRequest(Uint8List? payload) {
  if (payload != null && payload.length == 52) {
    var username = Username_Type.fromBytes(payload.sublist(0, 20));
    var hash = payload.sublist(20, 52);
    var verification = Verification_Type(username, hash);
    return RemoveAllTasksRequest(verification);
  }
  return null;
}
