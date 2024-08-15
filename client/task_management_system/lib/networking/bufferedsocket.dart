import 'dart:io';
import 'dart:typed_data';

class BufferedSocket {
  final Socket _socket;
  List<int> _buffer = [];

  BufferedSocket(this._socket) {
    _socket.listen((data) => _buffer.addAll(data),
        onError: (error) => print('Error: $error'),
        onDone: () => {} //print('Socket closed'),
        );
  }

  Future<Uint8List> readExactly(int n) async {
    while (_buffer.length < n) {
      await Future.delayed(Duration(milliseconds: 10));
    }
    var result = Uint8List.fromList(_buffer.take(n).toList());
    _buffer = _buffer.sublist(n);
    return result;
  }

  Future<void> close() => _socket.close();
}
