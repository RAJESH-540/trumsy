import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trumsy/auth_repository.dart';
import 'package:trumsy/custom_widget/button.dart';
import 'package:trumsy/custom_widget/textfield.dart';
import 'package:trumsy/screens/create_screen.dart';
import 'package:trumsy/screens/task_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repo = AuthRepository();


  void _handleSignIn() {
    repo.signInWithGoogle().then((UserCredential userCredential) {
      User? user = userCredential.user;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const  TaskScreen(),
          ),
        );
      }
    }).catchError((error) {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffD9D9D9),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 70,
                ),
                Image.asset(
                  "assets/images/logo.png",
                  height: 80,
                  width: 300,
                ),
                const SizedBox(
                  height: 70,
                ),
                const Text(
                  "Enter Username and password to login",
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff515151)),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFields(
                    prefixIcons: const Icon(Icons.account_circle),
                    hintText: "Username, email and phone number",
                    visible: false,
                    controller: emailController),
                const SizedBox(
                  height: 30,
                ),
                TextFields(
                  prefixIcons: const Icon(Icons.lock_outline),
                  hintText: "Enter your password",
                  visible: true,
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Forgot password",
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff5E17EB)),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomRoundBtn(
                    onPressed: () async {
                      showDialog(context: context, builder: (context) {
                        return const Center(
                            child: CircularProgressIndicator());
                      });
                      repo.signInWithEmail(
                          email: emailController.text,
                          password: passwordController.text);

                      await Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const TaskScreen()));
                    },
                    btnText: "Sign in "),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have account?",
                      style: TextStyle(fontSize: 15.0),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const CreateAccountScreen()));
                        },
                        child: const Text(
                          "Sign Up",
                          style:
                          TextStyle(
                              fontSize: 15.0, color: Color(0xff9661FF)),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/line.png",
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text("Sign Up with"),
                    const SizedBox(
                      width: 15,
                    ),
                    Image.asset(
                      "assets/images/line.png",
                      color: Colors.black,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector (
                    onTap: () {
                       _handleSignIn();
                    },
                    child: Image.asset("assets/images/google.png"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
