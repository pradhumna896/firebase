import 'package:flutter/material.dart';
import 'package:push_notification/presentation/auth/bloc/auth.dart';

class CommentScreen extends StatelessWidget {
  static const route = "/comment_screen";
  CommentScreen({super.key});
  final TextEditingController commentController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
      ),
      body: StreamBuilder(
        stream: firestore.collection("posts").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var posts = snapshot.data!.docs;

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                
                var data = snapshot.data!.docs[index];
                return Column(
                  children: [
                   
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: data["comments"].length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(data["comments"][index]["comment"]),
                          subtitle: Text(data["comments"][index]["email"]),
                        );
                      },
                    ),
                    const Divider(),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            decoration: const InputDecoration(
                              hintText: "Enter comment",
                            ),
                          ),
                        ),
                      
                      ],
                    )
                  ],
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
