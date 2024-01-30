import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:push_notification/presentation/auth/bloc/auth.dart';

class ChatScreen extends StatefulWidget {
  static const route = "/chat_screen";
  final String chatRoomId;
  final Map<String, dynamic> user2;
  const ChatScreen({super.key, required this.chatRoomId, required this.user2});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  TextEditingController messageController = TextEditingController();
  final form = GlobalKey<FormState>();
  File? image;
  Future<String> getImageUrl() async {
    var ref = storage.ref().child("images");
    var uploadTask = await ref.putFile(image!);
    var downloadUrl = await uploadTask.ref.getDownloadURL();
    return downloadUrl;
  }

  pickImage() async {
    String imageUrl;
    var imageStore = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageStore != null) {
      setState(() {
        image = File(imageStore.path);
      });
      imageUrl = await getImageUrl();
      firestore
          .collection("chatRoom")
          .doc(widget.chatRoomId)
          .collection("chats")
          .add({
        "senderId": auth.currentUser!.displayName,
        "text": imageUrl,
        "timestamp": FieldValue.serverTimestamp(),
        "likes": [],
        "type": "image"
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.chatRoomId);
    return Scaffold(
      appBar: AppBar(title: Text(widget.user2["firstName"])),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
                  stream: firestore
                      .collection("chatRoom")
                      .doc(widget.chatRoomId)
                      .collection("chats")
                      .orderBy("timestamp", descending: false)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var map = snapshot.data?.docs[index].data()
                              as Map<String, dynamic>;
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: map["senderId"] ==
                                      auth.currentUser!.displayName
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(map[
                                              "senderId"] ==
                                          auth.currentUser!.displayName
                                      ? auth.currentUser!.photoURL ??
                                          "https://www.cleanpng.com/png-computer-icons-user-profile-person-730537/preview.html"
                                      : map["senderId"][0] ??
                                          "https://www.cleanpng.com/png-computer-icons-user-profile-person-730537/preview.html"),
                                ),
                                map["type"] == "image"
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          map["text"],
                                          height: 200,
                                        ),
                                      )
                                    : Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(map["text"]),
                                        ],
                                      ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  })),
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
                      onPressed: () {
                        pickImage();
                      },
                      icon: const Icon(Icons.camera)),
                  IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (form.currentState!.validate()) {
                          firestore
                              .collection("chatRoom")
                              .doc(widget.chatRoomId)
                              .collection("chats")
                              .add({
                            "senderId": auth.currentUser!.displayName,
                            "text": messageController.text,
                            "timestamp": FieldValue.serverTimestamp(),
                            "likes": [],
                            "type": "text"
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
