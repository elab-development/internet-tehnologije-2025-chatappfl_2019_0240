import 'dart:async';

import 'package:chatapp_flutter/screens/greetings_screen.dart';
import 'package:chatapp_flutter/screens/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:chatapp_client/chatapp_client.dart';
import 'screens/home_screen.dart'; // Tvoj novi ekran

late final Client client;
late final FlutterAuthSessionManager authSessionManager;

// Globalni broadcast stream za chat poruke
// Dozvoljava više listenera (npr. više chat soba otvorenih)
final chatMessageController = StreamController<dynamic>.broadcast();

/// FCM Token retry logika - pokušava do 5 puta sa rastućim pauzama

void _initFcmToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // 1. Zatraži dozvolu (ovo je bitno i za inicijalizaciju!)
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    debugPrint('✅ Korisnik prihvatio dozvole');

    // 2. Uzmi token
    String? token = await messaging.getToken();
    debugPrint('🔑 FCM TOKEN: $token');

    // 3. OBAVEZNO: Slušaj poruke dok je app otvorena da vidiš da li stižu u konzolu
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📩 STIGLA PORUKA: ${message.notification?.title}');
    });
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // FCM Token - retry logika za slučaj da mreža nije odmah dostupna
  _initFcmToken();

  // Slušamo i buduće promene tokena (refresh)
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    debugPrint('🔄 FCM TOKEN REFRESH: $newToken');
    // TODO: Pošalji novi token backendu
  });

  // Tvoja lokalna IP adresa (LAN IP iMac-a)
  const String serverUrl = 'http://192.168.0.37:8080/';

  // 1. SETUP KLIJENTA (Standardni način)
  authSessionManager = FlutterAuthSessionManager();
  client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = authSessionManager;

  // 2. INICIJALIZACIJA SESIJE
  await client.auth.initialize();

  // Otvori stream ako je korisnik već ulogovan
  if (client.auth.isAuthenticated) {
    try {
      await client.openStreamingConnection();
      // Prosledi sve poruke u globalni broadcast stream
      client.chat.stream.listen((msg) => chatMessageController.add(msg));
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
