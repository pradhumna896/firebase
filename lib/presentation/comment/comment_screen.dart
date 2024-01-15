import 'package:flutter/material.dart';

class CommentScreen extends StatelessWidget {
  static const route = "/comment_screen";
  CommentScreen({super.key});
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
                child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(),
                  title: Text("User $index"),
                  subtitle: Text("Comment $index"),
                );
              },
            )),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: "Enter your comment",
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (commentController.text.isNotEmpty) {}
                    commentController.clear();
                  },
                  icon: const Icon(Icons.send),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
