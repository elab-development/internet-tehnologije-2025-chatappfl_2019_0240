import 'package:flutter/material.dart';
import 'package:chatapp_client/chatapp_client.dart';
import '../const/colors.dart';

class ChatScreen extends StatefulWidget {
  final Channel channel;

  const ChatScreen({super.key, required this.channel});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        title: Text(widget.channel.name),
        backgroundColor: AppColors.red,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Ovde ćemo uskoro listati poruke...',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
