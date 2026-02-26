import 'package:chatapp_flutter/widgets/forme/emailsignin.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import '../main.dart';
import '../widgets/bus_widg.dart';
import '../const/colors.dart';

class SignInScreen extends StatefulWidget {
  final Widget child; // GreetingsScreen
  const SignInScreen({super.key, required this.child});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  void initState() {
    super.initState();
    // 1. KLJUČ: Slušamo promene u auth stanju
    // Čim server javi uspeh, ovo okida _updateState
    client.auth.authInfoListenable.addListener(_updateState);
  }

  @override
  void dispose() {
    // 2. VAŽNO: Skidamo listener kad se ekran uništi da ne trošimo resurse
    client.auth.authInfoListenable.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // 3. PROVERA: Sad će build ponovo da se pokrene nakon logina
    // i isAuthenticated će biti TRUE, pa će vratiti GreetingsScreen (child)
    if (client.auth.isAuthenticated) {
      return widget.child;
    }

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: SingleChildScrollView(
          child: BusWidget(
            topText: '493 MLADENOVAC',
            child: Theme(
              data: Theme.of(context).copyWith(
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    foregroundColor: AppColors.lightYellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: AppColors.lightGrey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelStyle: const TextStyle(color: AppColors.darkBlue),
                ),
              ),
              child: BusEmailSignInWidget(
                client: client,
                onAuthenticated: () {
                  // Opciono: Možeš ovde dodati neki SnackBar "Dobrodošli!"
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../main.dart';

class SignInScreen extends StatefulWidget {
  final Widget child;
  const SignInScreen({super.key, required this.child});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    client.auth.authInfoListenable.addListener(_updateSignedInState);
    _isSignedIn = client.auth.isAuthenticated;
  }

  @override
  void dispose() {
    client.auth.authInfoListenable.removeListener(_updateSignedInState);
    super.dispose();
  }

  void _updateSignedInState() {
    setState(() {
      _isSignedIn = client.auth.isAuthenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isSignedIn
        ? widget.child
        : Center(
            child: SignInWidget(
              client: client,
              onAuthenticated: () {},
            ),
          );
  }
}
*/
