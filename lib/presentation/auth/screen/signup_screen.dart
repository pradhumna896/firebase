import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:push_notification/notification_screen.dart';
import 'package:push_notification/presentation/auth/bloc/auth_bloc.dart';
import 'package:push_notification/presentation/auth/bloc/auth_event.dart';
import 'package:push_notification/presentation/auth/bloc/auth_state.dart';
import 'package:push_notification/presentation/auth/screen/login_screen.dart';
import 'package:push_notification/presentation/home/screen/home_screen.dart';

class SignupScreen extends StatefulWidget {
  static const route = "/signup_screen";
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  AuthBLoc _authBLoc = AuthBLoc();
  final GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Uint8List? image;
  imagePick() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = await pickedFile.readAsBytes();

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBLoc, AuthState>(
      bloc: _authBLoc,
      listener: (context, state) {
        if (state is AuthSignupSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Signup successfull,")));
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.route, (route) => false);
        }
        if (state is AuthSignupFailed) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100),
                    Stack(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: image == null
                              ? const Icon(
                                  Icons.person,
                                  color: Colors.white,
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
                        Positioned(
                            bottom: -10,
                            right: -10,
                            child: IconButton(
                              onPressed: () {
                                imagePick();
                              },
                              icon: Icon(Icons.camera),
                            ))
                      ],
                    ),
                    TextFormField(
                      controller: firstNameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "First name is required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: "Enter your first name"),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: lastNameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Last name is required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: "Enter your last name"),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: ageController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Age is required";
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(hintText: "Enter your age"),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email is required";
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(hintText: "Enter your email"),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password is required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: "Enter your password"),
                    ),
                    const SizedBox(height: 20),
                    state is AuthLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                minimumSize: Size(double.infinity, 45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                )),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                _authBLoc.add(AuthSignupEvent(
                                    imageFile: image!,
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                    age: ageController.text,
                                    email: emailController.text,
                                    password: passwordController.text));
                              }
                            },
                            child: const Text(
                              "Sign up",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
