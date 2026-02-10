import 'package:chatapp_flutter/screens/greetings_screen.dart';
import 'package:chatapp_flutter/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:chatapp_client/chatapp_client.dart';
import 'screens/home_screen.dart'; // Tvoj novi ekran

late final Client client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Tvoja lokalna IP adresa
  const String myIp = '192.168.0.37';
  final serverUrl = 'http://$myIp:8080/';

  // 1. SETUP KLIJENTA (Standardni način)
  client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();

  // 2. INICIJALIZACIJA SESIJE
  // Ovo proverava da li si već ulogovan kad upališ app
  await client.auth.initialize();
  // DODAJ OVO: Otvara tunel za poruke u realnom vremenu
  if (client.auth.isAuthenticated) {
    try {
      await client.openStreamingConnection();
      debugPrint("📡 Lasta: Strim uspešno otvoren!");
    } catch (e) {
      debugPrint("❌ Lasta: Greška pri otvaranju strima: $e");
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lasta 493 Chat',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: const Color(0xFF001F3F), // Tvoja tamno plava
      ),
      // LOGIKA: Ako je user ulogovan -> HomeScreen, ako nije -> SignInScreen
      home: client.auth.isAuthenticated
          ? const HomeScreen()
          : SignInScreen(
              child: const HomeScreen(),
            ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),

      // body: const GreetingsScreen(),
      // To test authentication in this example app, uncomment the line below
      // and comment out the line above. This wraps the GreetingsScreen with a
      // SignInScreen, which automatically shows a sign-in UI when the user is
      // not authenticated and displays the GreetingsScreen once they sign in.
      body: SignInScreen(
        child: GreetingsScreen(
          onSignOut: () async {
            await client.auth.signOutDevice();
          },
        ),
      ),
    );
  }
}
