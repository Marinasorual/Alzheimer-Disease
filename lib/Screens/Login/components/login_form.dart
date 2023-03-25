import 'package:alzheimer/modules/home-page/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../../modules/testGenes/TestGenesScreen.dart';
import '../../../shared/functions/component.dart';
import '../../../shared/functions/shared_function.dart';
import '../../../shared/network/local/cache_helper.dart';
import '../../Signup/signup_screen.dart';

class LoginForm extends StatelessWidget {

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [

          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            validator: (value) {
              if (value!.length == 0) {
                return 'This field is requreid';
              } else if (!(value!.contains(RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")))) {
                return "Please enter a valid e-mail";
              }
            },
            decoration: const InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              validator: (value) {
                if (value!.length == 0) return "This field is required";
              },
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () async {
                if(formKey.currentState!.validate())  {
                  await CachHelper.saveData(key: 'password', value: passwordController.text);
                  await CachHelper.saveData(key: 'email', value: emailController.text);
                  await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text)
                      .then((value) {
                    print(value.user!.uid);
                    CachHelper.saveData(key: "uid", value: value.user!.uid);

                    navigateAndFinish(context, HomePageScreen(0));
                  }).catchError((onError) {
                    showToast(
                        text: 'Invalid Email or Password',
                        color: Colors.red,
                        time: 2);
                  });
                }
              },
              child: Text(
                "Login".toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
