import 'dart:typed_data';

class Uint64 {
  final BigInt value;

  Uint64(this.value) {
    if (value < BigInt.zero || value > BigInt.parse('18446744073709551615')) {
      throw ArgumentError('Value out of range for Uint64');
    }
  }

  Uint8List serialize() {
    final buffer = Uint8List(8);
    final data = ByteData.view(buffer.buffer);
    data.setUint64(0, value.toInt(), Endian.little);
    return buffer;
  }

  static Uint64 deserialize(Uint8List data) {
    if (data.length != 8) {
      throw ArgumentError('Invalid data length for Uint64 deserialization');
    }
    final value = ByteData.view(data.buffer).getUint64(0, Endian.little);
    return Uint64(BigInt.from(value));
  }
}

class Uint8 {
  final int value;

  Uint8(this.value) {
    if (value < 0 || value > 255) {
      throw ArgumentError('Value out of range for Uint8');
    }
  }

  Uint8List serialize() {
    return Uint8List.fromList([value]);
  }

  static Uint8 deserialize(Uint8List data) {
    if (data.length != 1) {
      throw ArgumentError('Invalid data length for Uint8 deserialization');
    }
    return Uint8(data[0]);
  }
}
