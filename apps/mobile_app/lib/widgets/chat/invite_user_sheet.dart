import 'package:flutter/material.dart';
import 'package:chatapp_client/chatapp_client.dart';
import '../../main.dart'; // Da bi video 'client'
import '../../const/colors.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as auth;

class InviteUserSheet extends StatelessWidget {
  final int channelId;

  const InviteUserSheet({super.key, required this.channelId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.darkBlue,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text(
            "Pozovi putnika na liniju",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(color: Colors.white10, height: 24),
          Flexible(
            child: FutureBuilder<List<auth.UserInfo>>(
              future: client.user.getAllAvailableUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.lightYellow,
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Nema dostupnih putnika.",
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }

                final users = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.red.withOpacity(0.8),
                        child: Text(
                          user.userName?[0].toUpperCase() ?? '',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        user.userName ?? '',
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        user.email ?? '',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.person_add_alt_1,
                        color: AppColors.lightYellow,
                      ),
                      onTap: () async {
                        try {
                          await client.channel.addUserToChannel(
                            channelId,
                            user.id!,
                          );
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("${user.userName} je dodat!"),
                              ),
                            );
                          }
                        } catch (e) {
                          debugPrint("Greška: $e");
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
