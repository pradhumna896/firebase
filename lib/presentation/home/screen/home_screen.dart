import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:push_notification/presentation/auth/screen/login_screen.dart';
import 'package:push_notification/presentation/chat/chat_screen.dart';
import 'package:push_notification/presentation/home/bloc/home_bloc.dart';
import 'package:push_notification/presentation/home/bloc/home_event.dart';
import 'package:push_notification/presentation/home/bloc/home_state.dart';
import 'package:push_notification/presentation/profile/screen/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  static const route = "/home_screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc homeBloc = HomeBloc();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    homeBloc.add(HomeInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(auth.currentUser);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.route, (route) => false);
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, ProfileScreen.route);
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, ChatScreen.route);
            },
            icon: const Icon(Icons.chat),
          )
        ],
      ),
      body: StreamBuilder(
        stream: firestore.collection("posts").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          var posts = snapshot.data!.docs;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              var post = posts[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                              "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg"),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          post['createdBy'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(post['title']),
                    const SizedBox(height: 10),
                    Image.network(post['post']),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            doLike(post);
                          },
                          icon: Icon(
                            Icons.favorite,
                            color:
                                post["likes"].contains(auth.currentUser!.email)
                                    ? Colors.red
                                    : Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.comment),
                        ),
                      ],
                    ),
                    Text(
                      "${post["likes"].length} Likes",
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return CustomPostSheet(
                homeBloc: homeBloc,
              );
            },
          );
        },
      ),
    );
  }

  doLike(post) {
    if (post["likes"].contains(auth.currentUser!.email)) {
      firestore.collection('posts').doc(post.id).update({
        "likes": FieldValue.arrayRemove([auth.currentUser!.email])
      });
    } else {
      firestore.collection('posts').doc(post.id).update({
        "likes": FieldValue.arrayUnion([auth.currentUser!.email])
      });
    }
  }
}

class CustomPostSheet extends StatefulWidget {
  final HomeBloc homeBloc;

  const CustomPostSheet({super.key, required this.homeBloc});

  @override
  State<CustomPostSheet> createState() => _CustomPostSheetState();
}

class _CustomPostSheetState extends State<CustomPostSheet> {
  Uint8List? image;
  imagePick() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = await pickedFile.readAsBytes();
      setState(() {});
    }
  }

  final TextEditingController title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              imagePick();
            },
            child: Container(
              height: 200,
              width: 200,
              child: image == null
                  ? const Icon(
                      Icons.person,
                      color: Colors.grey,
                      size: 50,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.memory(
                        image!,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: title,
            decoration: const InputDecoration(
              hintText: "Title",
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () {
                widget.homeBloc
                    .add(HomePostCreateEvent(title: title.text, image: image!));
                Navigator.pop(context);
              },
              child: Text("Post"))
        ],
      ),
    );
  }
}
