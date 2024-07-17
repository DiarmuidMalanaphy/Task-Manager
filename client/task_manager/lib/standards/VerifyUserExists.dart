import 'base.dart';
import 'dart:typed_data';

class VerifyUserExistsRequest {
  final Username username;

  VerifyUserExistsRequest(this.username);
}

Uint8List serializeVerifyUserExistsRequest(VerifyUserExistsRequest request) {
  return request.username.bytes;
}

VerifyUserExistsRequest? deserializeVerifyUserExistsRequest(Uint8List? payload) {
  if (payload != null && payload.length == 20) {
    return VerifyUserExistsRequest(Username.fromBytes(payload));
  }
  return null;
}
