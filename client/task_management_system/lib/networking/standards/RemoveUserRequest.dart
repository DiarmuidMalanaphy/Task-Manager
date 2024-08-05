import 'dart:typed_data';

import 'package:task_management_system/networking/standards/base.dart';

class RemoveUserRequest {
  final Verification_Type verification;

  RemoveUserRequest(this.verification);
}

Uint8List serializeRemoveUserRequest(RemoveUserRequest request) {
  var buffer = ByteData(52); // 20 bytes username + 32 bytes hash
  buffer.buffer
      .asUint8List(0, 20)
      .setAll(0, request.verification.username.bytes);
  buffer.buffer.asUint8List(20, 32).setAll(0, request.verification.hash);
  return buffer.buffer.asUint8List();
}

RemoveUserRequest? deserializeRemoveUserRequest(Uint8List? payload) {
  if (payload != null && payload.length == 52) {
    var username = Username_Type.fromBytes(payload.sublist(0, 20));
    var hash = payload.sublist(20, 52);
    return RemoveUserRequest(Verification_Type(username, hash));
  }
  return null;
}
