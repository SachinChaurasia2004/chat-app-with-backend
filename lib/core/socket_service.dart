import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  final _storage = FlutterSecureStorage();
  late IO.Socket _socket;

  SocketService._internal() {
    initSocket();
  }

  Future<void> initSocket() async {
    try {
      String token = await _storage.read(key: 'token') ?? '';
      print('Token: $token');
      _socket = IO.io(
        'http://10.0.2.2:2000',
        IO.OptionBuilder()
            .setTransports(['websocket', 'polling'])
            .enableAutoConnect()
            .setExtraHeaders({'Authorization': 'Bearer $token'})
            .build(),
      );

      _socket.onConnect((_) {
        print('Connected to Socket.IO server: ${_socket.id}');
      });

      _socket.onConnectError((data) {
        print('Connect error: $data');
      });

      _socket.onDisconnect((_) {
        print('Disconnected from Socket.IO server: ${_socket.id}');
      });

      _socket.connect();
    } catch (e) {
      print('Error initializing socket connection: $e');
    }
  }

  IO.Socket get socket => _socket;
}
