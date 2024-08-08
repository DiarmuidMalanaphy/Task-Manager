import 'package:crypto/crypto.dart';
import 'dart:typed_data';
import 'dart:convert';

class Password {
  static const int LENGTH = 30;
  final Uint8List _bytes;
  final String _string;
  Password.fromBytes(this._bytes)
      : _string = String.fromCharCodes(_bytes.where((byte) => byte != 0)) {
    if (_bytes.length != LENGTH) {
      throw ArgumentError('Password must be $LENGTH bytes');
    }
  }

  Password.fromString(String password)
      : _string = password,
        _bytes = Uint8List.fromList(padRightWithZeros(password, LENGTH)) {
    if (_bytes.length > LENGTH) {
      throw ArgumentError('Password must be at most $LENGTH characters');
    }
  }

  Uint8List get bytes => _bytes;

  Uint8List get hash {
    var bytes = utf8.encode(_string); // Convert the password to bytes
    var digest = sha256.convert(bytes); // Perform the SHA-256 hash
    return Uint8List.fromList(digest.bytes); // Return the hash as Uint8List
  }

  static List<int> padRightWithZeros(String str, int length) {
    List<int> byteList = List.filled(length, 0);
    List<int> strBytes = str.codeUnits;
    for (int i = 0; i < strBytes.length && i < length; i++) {
      byteList[i] = strBytes[i];
    }
    return byteList;
  }
}
