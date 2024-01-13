import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static const route = "/profile_screen";
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String? firstName;
  String? lastName;
  String? age;
  String? email;
  String? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfile')),
      body: StreamBuilder(
        stream: firestore
            .collection('users')
            .doc(auth.currentUser!.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        data['image'],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      initialValue: data['firstName'],
                      decoration: const InputDecoration(
                          labelText: "name", hintText: "Enter your first name"),
                      onChanged: (value) {
                        setState(() {
                          firstName = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      initialValue: data['lastName'],
                      decoration: const InputDecoration(
                          hintText: "Enter your last name"),
                      onChanged: (value) {
                        setState(() {
                          lastName = value;
                          print(data['lastName']);
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      data['age'],
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      data['email'],
                      style: const TextStyle(fontSize: 20),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          print(data);
                          try {
                            firestore
                                .collection('users')
                                .doc(auth.currentUser?.email)
                                .update({
                              'firstName': firstName ?? data['firstName'],
                              'lastName': lastName ?? data['lastName'],
                              'age': data['age'],
                              'email': data['email'],
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: const Text("Edit Profile"))
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
