import 'base.dart';
import 'dart:typed_data';
import 'utility.dart';

class PollUserRequest {
  final Verification verification;
  final int lastSeenTaskID;

  PollUserRequest(this.verification, this.lastSeenTaskID);
}

Uint8List serializePollUserRequest(PollUserRequest request) {
  var buffer = ByteData(56); // 52 bytes verification + 4 bytes lastSeenTaskID
  buffer.buffer.asUint8List(0, 20).setAll(0, request.verification.username.bytes);
  buffer.buffer.asUint8List(20, 32).setAll(0, request.verification.hash);
  buffer.setUint32(52, request.lastSeenTaskID, Endian.little);
  return buffer.buffer.asUint8List();
}

PollUserRequest? deserializePollUserRequest(Uint8List? payload) {
  if (payload != null && payload.length == 56) {
    var username = Username.fromBytes(payload.sublist(0, 20));
    var hash = payload.sublist(20, 52);
    var verification = Verification(username, hash);
    var lastSeenTaskID = getUint32(payload, 52);
    return PollUserRequest(verification, lastSeenTaskID);
  }
  return null;
}
