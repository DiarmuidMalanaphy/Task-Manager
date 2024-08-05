import 'base.dart';
import 'dart:typed_data';
import '../dartproto/AddUserRequest.pb.dart';

class AddUserRequest_Type {
  final Username_Type username;
  final Password password;

  AddUserRequest_Type(this.username, this.password);

  AddUserRequest_Type.fromStrings(String username, String password)
      : username = Username_Type.fromString(username),
        password = Password.fromString(password);

  Uint8List get serialise {
    final addUserRequest = AddUserRequest()
      ..username = username.toProto
      ..password = password.bytes;
    return addUserRequest.writeToBuffer();
  }
}
