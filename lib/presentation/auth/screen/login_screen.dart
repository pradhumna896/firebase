import 'package:flutter/material.dart';

import '../bloc/auth.dart';


class LoginScreen extends StatefulWidget {
  static const route = "/login_screen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthBLoc _authBLoc = AuthBLoc();
  final GlobalKey<FormState> form = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: form,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 300),
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password is required";
                    }
                    return null;
                  },
                  decoration:
                      const InputDecoration(hintText: "Enter your password"),
                ),
                SizedBox(height: 20),
                BlocConsumer<AuthBLoc, AuthState>(
                  bloc: _authBLoc,
                  listener: (context, state) {
                    if (state is AuthLoginSuccess) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        HomeScreen.route,
                        (route) => false,
                      );
                    }
                    if (state is AuthLoginFailed) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (context, state) {
                    return state is AuthLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                minimumSize: Size(double.maxFinite, 44),
                                backgroundColor: Colors.blue),
                            onPressed: () {
                              if (form.currentState!.validate()) {
                                _authBLoc.add(AuthLoginEvent(
                                    email: emailController.text,
                                    password: passwordController.text));
                              }
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                  },
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/signup_screen");
                  },
                  child: Text("Don't have an account? Sign up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
