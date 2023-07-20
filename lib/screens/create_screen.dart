import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trumsy/auth_repository.dart';
import 'package:trumsy/custom_widget/button.dart';
import 'package:trumsy/custom_widget/textfield.dart';
import 'package:trumsy/screens/task_screen.dart';

import 'login_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final repo = AuthRepository();

  void _handleSignIn() {
    repo.signInWithGoogle().then((UserCredential userCredential) {
      User? user = userCredential.user;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>  const TaskScreen(),
          ),
        );
      }

    }).catchError((error) {

    });
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (repo.isUserLoggedIn()) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const TaskScreen()));
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Image.asset(
                  "assets/images/logo.png",
                  height: 80,
                  width: 300,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Create an Account",
                  style: TextStyle(
                      fontSize: 25,
                      color: Color(0xff515151),
                      fontWeight: FontWeight.w500),
                ),
                const Text(
                  "To create your Trumsy account,please fill\n   the details below",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff515151)),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFields(
                  prefixIcons: const Icon(Icons.account_circle),
                  hintText: 'User name',
                  visible: false,
                  controller: emailController,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFields(
                  prefixIcons: const Icon(Icons.lock_outline),
                  hintText: 'Set password',
                  visible: true,
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFields(
                  prefixIcons: const Icon(Icons.lock_outline),
                  hintText: 'Confirm password',
                  visible: true,
                  controller: confirmPasswordController,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomRoundBtn(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const Center(
                                child: CircularProgressIndicator());
                          });
                      // validateForm();
                      if (passwordController.text == confirmPasswordController.text) {
                        await repo.signUp(
                            email: emailController.text,
                            password: passwordController.text);
                        Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const TaskScreen()));
                      }
                    },
                    btnText: "Continue"),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have account?",
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
                                  builder: (context) => const LoginScreen()));
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                              fontSize: 15.0, color: Color(0xff9661FF)),
                        )),
                  ],
                ),
                const SizedBox(height: 10,),
                InkWell(
                   onTap: () async{ showDialog(
                         context: context,
                         builder: (context) {
                           return const Center(
                               child: CircularProgressIndicator());
                         });
                    repo.signInAnonymously();
                   await  Navigator.push(
                         context,
                         MaterialPageRoute(
                             builder: (context) => const TaskScreen()));

                   },
                  child: const Text("SignIn as Guest",style: TextStyle(
                      fontSize: 15.0, color: Color(0xff9661FF)), ),
                ),

                const SizedBox(
                  height: 30,
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
                  height: 30,
                ),
                GestureDetector(
                    onTap: () {
                       print("sign in with google");
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
