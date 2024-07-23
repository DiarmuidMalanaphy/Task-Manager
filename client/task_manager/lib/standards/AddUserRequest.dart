import 'base.dart';
import 'dart:typed_data';

class AddUserRequest {
  final Username username;
  final Password password;

  AddUserRequest(this.username, this.password);

  AddUserRequest.fromStrings(String username, String password)
      : username = Username.fromString(username),
        password = Password.fromString(password);
}

Uint8List serializeAddUserRequest(AddUserRequest request) {
  var buffer = ByteData(Username.LENGTH + Password.LENGTH);
  buffer.buffer
      .asUint8List(0, Username.LENGTH)
      .setAll(0, request.username.bytes);
  buffer.buffer
      .asUint8List(Username.LENGTH, Password.LENGTH)
      .setAll(0, request.password.bytes);
  return buffer.buffer.asUint8List();
}

AddUserRequest? deserializeAddUserRequest(Uint8List? payload) {
  if (payload != null && payload.length == Username.LENGTH + Password.LENGTH) {
    var username = Username.fromBytes(payload.sublist(0, Username.LENGTH));
    var password = Password.fromBytes(
        payload.sublist(Username.LENGTH, Username.LENGTH + Password.LENGTH));
    return AddUserRequest(username, password);
  }
  return null;
}
