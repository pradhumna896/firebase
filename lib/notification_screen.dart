import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:push_notification/presentation/auth/screen/login_screen.dart';

class NotificationScreen extends StatefulWidget {
  static const route = "/notification_screen";

  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    
    final message = ModalRoute.of(context)!.settings;
    print(message);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Screen'),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, LoginScreen.route, (route) => false);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
