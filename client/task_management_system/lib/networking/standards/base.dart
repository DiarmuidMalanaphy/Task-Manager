import 'dart:typed_data';
import 'package:task_management_system/networking/dartproto/Hash.pb.dart';
import 'package:task_management_system/networking/dartproto/Username.pb.dart';
import 'package:task_management_system/networking/dartproto/Username.pbserver.dart';
import 'package:task_management_system/networking/dartproto/Verification.pb.dart';

class Username_Type {
  static const int LENGTH = 20;
  final Uint8List _bytes;

  Username_Type.fromBytes(this._bytes) {
    if (bytes.length != LENGTH) {
      throw ArgumentError('Username must be $LENGTH bytes');
    }
  }

  Username_Type.fromString(String username)
      : _bytes = Uint8List.fromList(padRightWithZeros(username, 20)) {
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

class Password {
  static const int LENGTH = 30;
  final Uint8List _bytes;

  Password.fromBytes(this._bytes) {
    if (_bytes.length != LENGTH) {
      throw ArgumentError('Password must be $LENGTH bytes');
    }
  }

  Password.fromString(String password)
      : _bytes = Uint8List.fromList(padRightWithZeros(password, LENGTH)) {
    if (_bytes.length > LENGTH) {
      throw ArgumentError('Password must be at most $LENGTH characters');
    }
  }

  Uint8List get bytes => _bytes;

  static List<int> padRightWithZeros(String str, int length) {
    List<int> byteList = List.filled(length, 0);
    List<int> strBytes = str.codeUnits;
    for (int i = 0; i < strBytes.length && i < length; i++) {
      byteList[i] = strBytes[i];
    }
    return byteList;
  }
}

class Verification_Type {
  final Username_Type username;
  final Uint8List hash;

  late final Uint8List bytes;

  Verification_Type(this.username, this.hash) {
    bytes = Uint8List(username.bytes.length + hash.length);
    bytes.setRange(0, username.bytes.length, username.bytes);
    bytes.setRange(username.bytes.length, bytes.length, hash);
  }
  Verification get toProto {
    Verification verification = Verification();
    verification.username = username.toProto;

    Hash hashProto = Hash();
    hashProto.hash = hash;

    verification.hash = hashProto;

    return verification;
  }
}
