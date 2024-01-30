import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:push_notification/presentation/auth/bloc/auth.dart';
import 'package:push_notification/presentation/auth/screen/login_screen.dart';
import 'package:push_notification/presentation/chat/chat_screen.dart';

class UserSearchScreen extends StatefulWidget {
  static const route = "/user_search_screen";
  const UserSearchScreen({super.key});

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final TextEditingController _search = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  Map<String,dynamic>? userData;

  searchUser() async {
    setState(() {
      isLoading = true;
    });
    if (_search.text.isNotEmpty) {
      var snapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: _search.text)
          .get();
      setState(() {
        userData = snapshot.docs[0].data();
        isLoading = false;
      });
    }
  }

  bool isLoading = false;

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user1$user2";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Search Screen"),actions: [
        IconButton(onPressed: (){
          auth.signOut();
          Navigator.pushNamedAndRemoveUntil(context, LoginScreen.route, (route) => false);
        }, icon: const Icon(Icons.logout))
      
      ],),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _search,
              decoration: const InputDecoration(
                hintText: "Search User",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  searchUser();
                  _search.clear();
                },
                child: Text("Search")),
            if (userData != null)
              ListTile(
                onTap: () {
                  String roomId = chatRoomId(
                      auth.currentUser!.displayName!, userData!['firstName']);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatScreen(chatRoomId: roomId, user2: userData!),
                      ));
                },
                title: Text(userData!["email"]),
                subtitle: Text(userData!["firstName"]),
              )
          ],
        ),
      ),
    );
  }
}
