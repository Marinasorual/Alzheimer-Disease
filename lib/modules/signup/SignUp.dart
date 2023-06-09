// ignore: file_names
import 'package:alzheimer/shared/network/local/cache_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:alzheimer/modules/SignIn/SignIn.dart';
import 'package:alzheimer/shared/functions/shared_function.dart';

import '../../models/userModel.dart';
import '../../shared/constants/Constants.dart';
import '../../shared/functions/passwordcheck.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  void createUser({
    required email,
    required password,
    required userName,
    required phone,
  }) async {
    setState(() {
      Loading = true;
    });
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      UserModel user =
          UserModel(email, password, value.user!.uid, userName, phone);
      FirebaseFirestore.instance
          .collection("Users")
          .add(user.toMap()).then((value) async {
            await CachHelper.saveData(key: 'docID', value: value.id);
      });
      FirebaseFirestore.instance
          .collection("Users")
          .get()
          .then((value) {

      })
      ;
    });

    setState(() {
      Loading = false;
    });
  }

  int _radioSelected = 2;
  String role = "worker";
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var prefixIcon = Icons.lock;
  var suffexIcon = Icons.visibility_off;
  var secure = true;
  var formKey = GlobalKey<FormState>();

  bool Loading = false;
  bool is8digits = false;
  bool hasUpper = false;
  bool hasLower = false;
  bool hasDigit = false;
  bool hsaSpecial = false;

  PasswordInteraction(String password) {
    is8digits = false;
    hasUpper = false;
    hasLower = false;
    hasDigit = false;
    hsaSpecial = false;
    setState(() {
      if (password.contains(RegExp(r'.{8,}'))) {
        is8digits = true;
      }
      if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        hsaSpecial = true;
      }
      if (password.contains(RegExp(r'[a-z]'))) {
        hasLower = true;
      }
      if (password.contains(RegExp(r'[0-9]'))) {
        hasDigit = true;
      }
      if (password.contains(RegExp(r'[A-Z]'))) {
        hasUpper = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: PAGEWIDTH,
          height: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              color: Colors.grey[100]
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    TextFormField(
                        controller: usernameController,
                        validator: (value) {
                          if (value!.isEmpty) return 'This field is requried';
                        },
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'User name',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.person))),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        controller: phoneController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field is requreid';
                          } else if (value.length != 13) {
                            return 'Please enter a valid number';
                          }
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Phone number',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.phone))),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field is requreid';
                        }
                        else if (
                        !(value.contains(RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")))
                        )
                        {
                          return "Please enter a valid e-mail";
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: 'Email address',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.email)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: passwordController,
                      onChanged: (value) {
                        PasswordInteraction(value);
                      },
                      validator: (value) {
                        if (value!.isEmpty) return 'This field is requreid';
                        if (value.length < 8) return 'Please enter valid password';
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: secure ? true : false,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  secure = !secure;
                                });
                              },
                              icon: secure
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CheckCard("Has Uppercase", hasUpper),
                    const SizedBox(
                      height: 10,
                    ),
                    CheckCard("Has Lowercase", hasLower),
                    const SizedBox(
                      height: 10,
                    ),
                    CheckCard("Has Special Character", hsaSpecial),
                    const SizedBox(
                      height: 10,
                    ),
                    CheckCard("At least one number", hasDigit),
                    const SizedBox(
                      height: 10,
                    ),
                    CheckCard("At least 8 digits", is8digits),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text('Have an account? '),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SignInScreen()));
                            },
                            child: const Text(
                              'Sign in',
                              style: TextStyle(color: Colors.blue),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          createUser(
                              email: emailController.text,
                              password: passwordController.text,
                              userName: usernameController.text,
                              phone: phoneController.text
                          );
                          navigateAndFinish(context, SignInScreen());
                        }
                      },
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue),
                        child: Center(
                            child: Loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Create an acount',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
