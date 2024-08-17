import 'dart:typed_data';
import 'package:task_management_system/networking/dartproto/Username.pb.dart';
import 'package:task_management_system/networking/dartproto/Username.pbserver.dart';

class Username_Type {
  static const int LENGTH = 50;
  final Uint8List _bytes;

  Username_Type.fromBytes(this._bytes) {
    if (bytes.length != LENGTH) {
      throw ArgumentError('Username must be $LENGTH bytes');
    }
  }

  Username_Type.fromString(String username)
      : _bytes = Uint8List.fromList(padRightWithZeros(username, LENGTH)) {
    if (_bytes.length > LENGTH) {
      throw ArgumentError('Username must be at most $LENGTH characters');
    }
  }

  Username_Type.fromProto(Username proto)
      : _bytes = Uint8List.fromList(proto.username) {
    if (_bytes.length != LENGTH) {
      throw ArgumentError('Username must be $LENGTH bytes');
    }
  }
  Uint8List get bytes => _bytes;

  int get length => (_bytes).length;
  Username get toProto {
    Username username = Username();
    username.username = _bytes;
    return username;
  }

  static List<int> padRightWithZeros(String str, int length) {
    List<int> byteList = List.filled(
        length, 0); // Create a list of zeros with the specified length
    List<int> strBytes = str.codeUnits; // Convert string to list of code units
    for (int i = 0; i < strBytes.length && i < length; i++) {
      byteList[i] = strBytes[i];
    }
    return byteList;
  }

  @override
  String toString() {
    // Find the index of the first zero byte or the end of the list
    int endIndex = _bytes.indexOf(0);
    if (endIndex == -1) endIndex = LENGTH;

    // Convert the trimmed bytes to a string
    return String.fromCharCodes(_bytes.sublist(0, endIndex));
  }
}
