import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_notification/firebase_api.dart';
import 'package:push_notification/notification_screen.dart';
import 'package:push_notification/presentation/auth/bloc/auth_bloc.dart';
import 'package:push_notification/presentation/auth/screen/login_screen.dart';
import 'package:push_notification/presentation/auth/screen/signup_screen.dart';
import 'package:push_notification/presentation/chat/chat_screen.dart';
import 'package:push_notification/presentation/chat/user_search_screen.dart';
import 'package:push_notification/presentation/comment/comment_screen.dart';
import 'package:push_notification/presentation/home/bloc/home_bloc.dart';
import 'package:push_notification/presentation/home/screen/home_screen.dart';
import 'package:push_notification/presentation/profile/screen/profile_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        appId: '1:439706195334:android:833a44931198261fb00807',
        messagingSenderId: '439706195334',
        projectId: 'pushnotificatio-7cbaf',
        apiKey: 'AIzaSyDfbvK4g9ZVOUJiAxWgOcJjabbSSZOffzM',
        storageBucket: "pushnotificatio-7cbaf.appspot.com"),
  );
  await FirebaseApi().initNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBLoc>(
          create: (context) => AuthBLoc(),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        navigatorKey: navigatorKey,
        home: auth.currentUser != null
            ? const UserSearchScreen()
            : const LoginScreen(),
        routes: {
          NotificationScreen.route: (context) => const NotificationScreen(),
          LoginScreen.route: (context) => const LoginScreen(),
          SignupScreen.route: (context) => const SignupScreen(),
          HomeScreen.route: (context) => const HomeScreen(),
          ProfileScreen.route: (context) => const ProfileScreen(),
          
          CommentScreen.route: (context) => CommentScreen(),
          UserSearchScreen.route: (context) => const UserSearchScreen()
        },
      ),
    );
  }
}
