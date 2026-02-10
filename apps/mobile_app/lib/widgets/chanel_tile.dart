import 'package:flutter/material.dart';
import 'package:chatapp_client/chatapp_client.dart';
import '../const/colors.dart';

class ChannelTile extends StatelessWidget {
  final Channel channel;
  final VoidCallback onTap;

  const ChannelTile({
    super.key,
    required this.channel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: AppColors.red,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.directions_bus,
            color: Colors.white,
            size: 28,
          ),
        ),
        title: Text(
          channel.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Aktivna linija (ID: ${channel.id})',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 13,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white.withOpacity(0.3),
          size: 16,
        ),
      ),
    );
  }
}
