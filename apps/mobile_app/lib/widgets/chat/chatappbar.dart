import 'package:flutter/material.dart';
import 'package:chatapp_client/chatapp_client.dart';
import '../../const/colors.dart';
import 'invite_user_sheet.dart'; // PAZI: Proveri da li je putanja do fajla tačna

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Channel channel;
  const ChatAppBar({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.darkBlue,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      // DODATO: Dugme za dodavanje korisnika (ikonica žutog čovečuljka sa plusom)
      actions: [
        IconButton(
          icon: const Icon(
            Icons.person_add_alt_1,
            color: AppColors.lightYellow,
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => InviteUserSheet(channelId: channel.id!),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.red,
            child: const Icon(
              Icons.directions_bus,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                channel.name,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Lasta Real-time',
                style: TextStyle(fontSize: 11, color: Colors.white54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
