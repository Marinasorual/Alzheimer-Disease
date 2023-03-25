import 'package:alzheimer/shared/functions/component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../../models/userModel.dart';
import '../../../modules/SignIn/SignIn.dart';
import '../../../shared/functions/passwordcheck.dart';
import '../../../shared/functions/shared_function.dart';
import '../../../shared/network/local/cache_helper.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatefulWidget {
  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
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
      navigateAndFinish(
          context, LoginScreen());
    }).catchError((onError) {
      print("object");
      showToast(text: 'Invalid Data', color: Colors.red, time: 3);
      setState(() {

      });
    });

    setState(() {
      Loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
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
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              print("YES");
              // navigateTo(context, LoginScreen());
              if (formKey.currentState!.validate()) {
                createUser(
                    email: emailController.text,
                    password: passwordController.text,
                    userName: usernameController.text,
                    phone: phoneController.text
                );

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
    );
  }
}