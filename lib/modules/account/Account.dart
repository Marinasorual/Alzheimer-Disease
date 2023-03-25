import 'package:alzheimer/Test.dart';
import 'package:alzheimer/modules/SignIn/SignIn.dart';
import 'package:alzheimer/shared/functions/shared_function.dart';
import 'package:alzheimer/shared/network/local/cache_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../shared/constants/Constants.dart';

class UserAccount extends StatefulWidget {
  final index;
  UserAccount(this.index);
  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  void getData() async {
    var uid = await CachHelper.getData(key: 'uid');
    await FirebaseFirestore.instance
          .collection('Users')
          .where('uID', isEqualTo: uid)
          .get()
          .then((value) {
            value.docs.forEach((element) async {
              emailController.text = element.data()['email'];
              passwordController.text = await CachHelper.getData(key: 'password');
              phoneController.text = element.data()['phone'];
              usernameController.text = element.data()['userName'];
              setState(() {

              });
            });
    });
  }
  void updateEmailAndPassword(String em, String pas) async {
    String email = await CachHelper.getData(key: 'email');
    String password = await CachHelper.getData(key: 'password');
    await FirebaseAuth.instance.
    signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      value.user?.updateEmail(em);
      value.user?.updatePassword(pas);
    })
    ;
    await CachHelper.saveData(
        key: 'email',
        value: em
    );
    await CachHelper.saveData(
        key: 'password',
        value: pas
    );
  }
  void updateUser(String email, String phone, String name) async {
    var docID = await CachHelper.getData(key: 'docID');
    await FirebaseFirestore.instance.collection('Users')
        .doc(docID)
        .update(
              {
                'email': email,
                'phone': phone,
                'userName': name
              }
            );
  }
  @override
  void initState() {
    // TODO: implement initState

    getData();
    super.initState();
  }
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text('Account'),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Expanded(child: PageViewScreen(widget.index)),
          Expanded(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    const SizedBox(height: 20,),
                    const SizedBox(height: 20,),
                    textField(controller: usernameController, label: 'User Name'),
                    const SizedBox(height: 10,),
                    textField(controller: emailController, label: 'Email Address'),
                    const SizedBox(height: 10,),
                    textField(controller: phoneController, label: 'Phone Number'),
                    const SizedBox(height: 10,),
                    textField(controller: passwordController, label: 'Password'),
                    const SizedBox(height: 26,),
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: MaterialButton(
                        color: kPrimaryColor,
                          onPressed: () {
                              if(formKey.currentState!.validate()) {
                                updateUser(emailController.text, phoneController.text, usernameController.text);
                                updateEmailAndPassword(emailController.text, passwordController.text);
                                navigateAndFinish(context, SignInScreen());
                              }
                          },
                        child: const Center(child: Text("Save", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget textField(
      {
        required TextEditingController controller,
        required String label,
      }
      ) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is require";
        }
        //
        // else if (
        // !(value.contains(RegExp(
        //     r"^[0-9.]")))
        // )
        // {
        //   return "Please enter a value\nFor more information click on mark";
        // }
        return null;
      },
      decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          // labelText: label,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 3,
              color: kPrimaryColor
            )
          ),
          labelText: label
      ),
    );
  }
}
