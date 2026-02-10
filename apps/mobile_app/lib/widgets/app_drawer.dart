import 'package:flutter/material.dart';
import 'package:chatapp_client/chatapp_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import '../const/colors.dart';
import '../main.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.darkBlue,
      child: Column(
        children: [
          // 1. SAMO HEADER JE U FUTURE BUILDER-u
          // Ako pukne, prikazaće default "Putnik" podatke, ali neće srušiti app
          FutureBuilder(
            future: client.user.getMe(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Ubaci ovo unutar FutureBuilder-a u AppDrawer-u
                print(
                  "DEBUG: UserName iz baze je: '${snapshot.data?.userName}'",
                );
                print("DEBUG: Email iz baze je: '${snapshot.data?.email}'");
                print("DEBUG: ID iz baze je: ${snapshot.data?.id}");
              }
              // Ako ima podataka, super. Ako nema ili je greška, koristimo null (default)
              final user = snapshot.data;

              return UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: AppColors.red,
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://www.bgprevoz.rs/storage/vesti/vest-199-hO2tbLu31q7GRNCZKjRWq7Duy5eys1tsftBpjeTm.jpg',
                    ),
                    opacity: 0.2,
                    fit: BoxFit.cover,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: AppColors.lightYellow,
                  child: Text(
                    user?.userName?[0].toUpperCase() ?? '?',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.red,
                    ),
                  ),
                ),
                accountName: Text(
                  user?.userName ?? 'Putnik (Offline)',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                accountEmail: Text(
                  user?.email ?? 'Greška u učitavanju ili nema neta',
                  style: const TextStyle(color: AppColors.lightGrey),
                ),
              );
            },
          ),

          // 2. OVO JE SADA VAN BUILDERA I UVEK SE VIDI
          // Čak i ako server gori, ovo dugme radi!

          // ID sekcija (Statična ili vezana za snapshot ako želiš, ali ovako je sigurnije)
          const ListTile(
            leading: Icon(Icons.badge, color: AppColors.lightYellow),
            title: Text(
              'Status',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              'Korisnik sistema',
              style: TextStyle(color: Colors.grey),
            ),
          ),

          const Divider(color: Colors.white24),

          ListTile(
            leading: const Icon(Icons.directions_bus, color: Colors.white),
            title: const Text(
              'Moje linije',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => Navigator.pop(context),
          ),

          const Spacer(),

          // 3. DUGME ZA SPAS (IZLAZ)
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ListTile(
              leading: const Icon(Icons.exit_to_app, color: AppColors.red),
              title: const Text(
                'IZLAZ IZ BUSA',
                style: TextStyle(
                  color: AppColors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async {
                // Forsiramo logout bez obzira na server
                try {
                  // 1. Ovo briše ključeve sa servera
                  await client.auth.signOutDevice();
                  // 2. OVO JE KLJUČNO: Briše lokalni session manager (tokene) sa telefona
                  var sessionManager = await SessionManager.instance;
                  await sessionManager.signOutDevice();
                } catch (e) {
                  debugPrint("Greška pri odjavi: $e");
                }

                if (context.mounted) {
                  // Vraćamo se na početni ekran (Login) i brišemo istoriju stack-a
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/', (route) => false);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
