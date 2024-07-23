import 'dart:typed_data';

class Username {
  static const int LENGTH = 20;
  final Uint8List _bytes;

  Username.fromBytes(this._bytes) {
    if (bytes.length != LENGTH) {
      throw ArgumentError('Username must be $LENGTH bytes');
    }
  }

  Username.fromString(String username)
      : _bytes = Uint8List.fromList(padRightWithZeros(username, 20)) {
    if (_bytes.length > LENGTH) {
      throw ArgumentError('Username must be at most $LENGTH characters');
    }
  }
  Uint8List get bytes => _bytes;

  static List<int> padRightWithZeros(String str, int length) {
    List<int> byteList = List.filled(
        length, 0); // Create a list of zeros with the specified length
    List<int> strBytes = str.codeUnits; // Convert string to list of code units
    for (int i = 0; i < strBytes.length && i < length; i++) {
      byteList[i] = strBytes[i];
    }
    return byteList;
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

class Verification {
  final Username username;
  final Uint8List hash;

  Verification(this.username, this.hash);
}
