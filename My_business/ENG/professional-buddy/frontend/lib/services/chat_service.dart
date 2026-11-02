import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/message.dart';
import 'api_client.dart';

class ChatService extends ChangeNotifier {
  final ApiClient _api = ApiClient();
  WebSocketChannel? _channel;

  final Map<String, List<ChatMessage>> _conversations = {}; // buddyId -> messages
  final _incomingController = StreamController<ChatMessage>.broadcast();

  Stream<ChatMessage> get incomingMessages => _incomingController.stream;

  List<ChatMessage> messagesFor(String buddyId) => _conversations[buddyId] ?? [];

  Future<void> loadHistory(String buddyId) async {
    final data = await _api.get('/chat/$buddyId/messages') as List;
    _conversations[buddyId] = data.map((e) => ChatMessage.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> connect() async {
    if (_channel != null) return;
    final token = await _api.getToken();
    if (token == null) return;

    final uri = Uri.parse('${ApiConfig.wsUrl}/chat/ws?token=$token');
    _channel = WebSocketChannel.connect(uri);

    _channel!.stream.listen(
      (raw) {
        final data = jsonDecode(raw);
        if (data['type'] == 'message') {
          final msg = ChatMessage.fromJson(data);
          // conversation key is "the other person" in this 1:1 chat
          final otherId = msg.senderId == _lastSelfId ? msg.receiverId : msg.senderId;
          _conversations.putIfAbsent(otherId, () => []);
          _conversations[otherId]!.add(msg);
          _incomingController.add(msg);
          notifyListeners();
        }
      },
      onDone: () => _channel = null,
      onError: (_) => _channel = null,
    );
  }

  String? _lastSelfId;
  void setSelfId(String id) => _lastSelfId = id;

  void sendMessage(String receiverId, String content) {
    _channel?.sink.add(jsonEncode({
      'receiver_id': receiverId,
      'content': content,
    }));
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  @override
  void dispose() {
    disconnect();
    _incomingController.close();
    super.dispose();
  }
}
