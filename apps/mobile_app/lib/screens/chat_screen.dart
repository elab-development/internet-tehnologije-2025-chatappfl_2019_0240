import 'package:chatapp_flutter/widgets/chat/chatappbar.dart';
import 'package:chatapp_flutter/widgets/chat/message_buble.dart';
import 'package:flutter/material.dart';
import 'package:chatapp_client/chatapp_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import '../main.dart';
import '../const/colors.dart';
import '../widgets/chat/chat_input_bar.dart';

class ChatScreen extends StatefulWidget {
  final Channel channel;
  const ChatScreen({super.key, required this.channel});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];
  int? _currentUserId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      // 1. POKUŠAJ OTVARANJA STRIMA (Bez isStreamingConnectionOpen provere)
      try {
        await client.openStreamingConnection();
        debugPrint("📡 Lasta: Strim otvoren!");
      } catch (e) {
        // Ako je već otvoren ili postoji greška, samo nastavi dalje
        debugPrint("ℹ️ Napomena o strimu: $e");
      }

      final myUserInfo = await client.user.getMe();
      if (myUserInfo != null) {
        _currentUserId = myUserInfo.id;
      }

      // 2. ISTORIJA
      final history = await client.chat.getPastMessages(widget.channel.id!);

      if (mounted) {
        setState(() {
          _messages.clear();
          _messages.addAll(history);
          _isLoading = false;
        });
      }

      // 3. SLUŠALICE
      _setupStreamListener();
    } catch (e) {
      debugPrint("⚠️ Greška: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _setupStreamListener() {
    client.chat.stream.listen((message) {
      if (message is Message && message.channelId == widget.channel.id) {
        if (mounted) {
          setState(() {
            if (!_messages.any((m) => m.id == message.id)) {
              _messages.insert(0, message);
            }
          });
        }
      }
    }, onError: (err) => debugPrint("❌ Stream Error: $err"));
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final message = Message(
      channelId: widget.channel.id!,
      content: text,
      senderId: _currentUserId ?? 0,
      timestamp: DateTime.now(),
    );

    // Šaljemo serveru
    client.chat.sendMessage(message);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: ChatAppBar(channel: widget.channel),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.lightYellow,
                    ),
                  )
                : _messages.isEmpty
                ? const Center(
                    child: Text(
                      "Nema poruka. Kreni prvi!",
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                : ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(12),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) => MessageBubble(
                      message: _messages[index],
                      currentUserId: _currentUserId,
                    ),
                  ),
          ),
          ChatInputBar(
            controller: _messageController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
