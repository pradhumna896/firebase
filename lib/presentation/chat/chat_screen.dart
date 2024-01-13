import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static const route = "/chat_screen";
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController messageController = TextEditingController();
  final form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat Screen")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                var messages = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      alignment: message['senderId'] == auth.currentUser!.email
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            color:
                                message['senderId'] == auth.currentUser!.email
                                    ? Colors.blue
                                    : Colors.green,
                            borderRadius:
                                message['senderId'] == auth.currentUser!.email
                                    ? const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                      )
                                    : const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      )),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment:
                              message['senderId'] == auth.currentUser!.email
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                          children: [
                            IconButton(
                                onPressed: () {
                                  if (message["likes"]
                                      .contains(auth.currentUser!.email)) {
                                    firestore
                                        .collection('messages')
                                        .doc(message.id)
                                        .update({
                                      "likes": FieldValue.arrayRemove(
                                          [auth.currentUser!.email])
                                    });
                                  } else {
                                    firestore
                                        .collection('messages')
                                        .doc(message.id)
                                        .update({
                                      "likes": FieldValue.arrayUnion(
                                          [auth.currentUser!.email])
                                    });
                                  }
                                },
                                icon: Icon(
                                  Icons.favorite,
                                  color: message["likes"]
                                          .contains(auth.currentUser!.email)
                                      ? Colors.red
                                      : Colors.grey,
                                )),
                            Text(message['text']),
                            Text(message['senderId']),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: form,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter your message...',
                      ),
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (form.currentState!.validate()) {
                          firestore.collection('messages').add({
                            'text': messageController.text,
                            'senderId': auth.currentUser!.email,
                            'timestamp': DateTime.now(),
                            "likes": []
                          });
                          messageController.clear();
                        }
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
