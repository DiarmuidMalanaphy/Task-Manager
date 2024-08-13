import 'package:flutter/foundation.dart';
import 'package:task_management_system/networking/dartproto/request.pb.dart';
import 'dart:async';
import 'bufferedsocket.dart';
import 'dart:typed_data';
import 'dart:io';
import 'standards/request.dart';

Future<Request_Type> handleSingleTCPExchange(
    Uint8List data, String host, int port,
    {int timeout = 2}) async {
  final completer = Completer<Request_Type>();
  Socket? socket;
  BufferedSocket? bufferedSocket;

  try {
    // Connect with a timeout
    socket =
        await Socket.connect(host, port).timeout(Duration(seconds: timeout));
    bufferedSocket = BufferedSocket(socket);

    // Send the data
    socket.add(data);
    await socket.flush();
    print('Sent ${data.length} bytes');

    // Start the timeout timer for receiving data
    Timer closeTimer = Timer(Duration(seconds: timeout), () {
      print('Timeout reached, closing connection');
      if (!completer.isCompleted) {
        completer.complete(Request_Type(254, 0, Uint8List(0)));
      }
    });

    var parsedRequest =
        await parseRequest(bufferedSocket).timeout(Duration(seconds: timeout));
    closeTimer.cancel();

    if (!completer.isCompleted) {
      completer.complete(Request_Type(parsedRequest.type,
          parsedRequest.payloadSize, parsedRequest.payload));
    }
  } on SocketException catch (socketError) {
    print("Socket error: $socketError");
    if (!completer.isCompleted) {
      completer.complete(Request_Type(253, 0, Uint8List(0)));
    }
  } on TimeoutException {
    print("Connection or operation timed out");
    if (!completer.isCompleted) {
      completer.complete(Request_Type(254, 0, Uint8List(0)));
    }
  } catch (e) {
    print("Unexpected error: $e");
    if (!completer.isCompleted) {
      completer.completeError(e);
    }
  } finally {
    await bufferedSocket?.close();
    await socket?.close();
    print('Connection closed');
  }

  return completer.future;
}

class PartialRequest {
  int type = 0;
  int payloadSize = 0;
  Uint8List payload = Uint8List(0);
  BufferedSocket bufferedSocket;
  PartialRequest(BufferedSocket socket) : bufferedSocket = socket;
}

Future<PartialRequest> parseRequest(BufferedSocket socket) async {
  PartialRequest partialRequest = PartialRequest(socket);
  Future<int> readVarint(int maxLength) async {
    int value = 0;
    int shift = 0;
    int index = 0;
    while (true) {
      if (index >= maxLength) {
        throw Exception("The input is formatted incorrectly");
      }

      final byte = await partialRequest.bufferedSocket.readExactly(1);
      value |= (byte[0] & 0x7F) << shift;
      if ((byte[0] & 0x80) == 0) break;
      shift += 7;
      index++;
    }

    return value;
  }

  await readVarint(1);

  partialRequest.type = await readVarint(16); //16 is arbitrary
  if (partialRequest.type == 220) {
    return partialRequest;
  }
  await readVarint(1);

  partialRequest.payloadSize = await readVarint(16);

  //GenerateRequest adds two headers to the data frustratingly
  await readVarint(1); //Field + Tag
  await readVarint(16); // Length

  var payload = await partialRequest.bufferedSocket
      .readExactly(partialRequest.payloadSize);

  partialRequest.payload = payload;
  return partialRequest;
}
