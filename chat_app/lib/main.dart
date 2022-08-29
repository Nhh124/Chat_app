import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //FirebaseMessaging.instance.getToken().then((token) => print("token: $token"));
  FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
  runApp(const MyApp());
}

Future<void> _onBackgroundMessage(RemoteMessage msg) async {
  await Firebase.initializeApp();

  print("onBackgroundMessage: $msg");
  print("onBackgroundMessage.data: ${msg.data}");
  print("onBackgroundMessage.notification.title: ${msg.notification?.title}");
  print("onBackgroundMessage.notification.body: ${msg.notification?.body}");
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return MaterialApp(
          title: 'Flutter Chat',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            backgroundColor: Colors.blueAccent,
            colorScheme:
                ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
              secondary: Colors.deepPurpleAccent,
            ),
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const ChatScreen();
              }
              return const AuthScreen();
            },
          ),
        );
      },
    );
  }
}
