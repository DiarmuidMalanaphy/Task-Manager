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
    : _bytes = _stringToAsciiBytes(username.padRight(LENGTH))  {
    if (bytes.length > LENGTH) { 
    //Essentially if it's longer than it should be break the program -> this should not be doing error correction
        throw ArgumentError('Username must be at most $LENGTH characters');
      }
  }
  Uint8List get bytes => _bytes;

  static Uint8List _stringToAsciiBytes(String str) {
      final codeUnits = str.codeUnits;
      if (codeUnits.any((unit) => unit > 127)) {
        throw ArgumentError('Username must contain only ASCII characters');
      }
      return Uint8List.fromList(codeUnits);
  }
  String toString() {
    return String.fromCharCodes(bytes).trim();
  }
}

class Verification {
  final Username username;
  final Uint8List hash;

  Verification(this.username, this.hash);
}

