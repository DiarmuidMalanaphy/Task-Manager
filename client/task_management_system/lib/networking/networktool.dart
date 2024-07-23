import 'bufferedsocket.dart';
import 'dart:typed_data';
import 'dart:io';
import 'standards/request.dart';

Future<Request> handleSingleTCPExchange(Uint8List data, String host, int port) async {
  Socket socket = await Socket.connect(host, port);
  BufferedSocket bufferedSocket = BufferedSocket(socket);

  try {
    // Send the data
    socket.add(data);
    await socket.flush();
    print('Sent ${data.length} bytes');

    // Read the header (5 bytes: 1 byte type + 4 bytes length)
    Uint8List header = await bufferedSocket.readExactly(5);
    int type = header[0];
    int payloadLength = ByteData.view(header.buffer).getUint32(1, Endian.little);

    print('Received header: Type $type, Length $payloadLength');

    // Read the payload
    Uint8List payload = await bufferedSocket.readExactly(payloadLength);
    Request new_request = Request(type, payloadLength, payload); 

    // Combine header and payload
    return new_request;

  } finally {
    await bufferedSocket.close();
    print('Connection closed');
  }
}

