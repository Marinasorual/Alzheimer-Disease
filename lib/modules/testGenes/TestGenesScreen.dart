import 'dart:io';

import 'dart:convert';
import 'package:alzheimer/modules/SignIn/SignIn.dart';
import 'package:alzheimer/modules/account/Account.dart';
import 'package:alzheimer/modules/model-information/ModelInformationScreen.dart';
import 'package:alzheimer/modules/show-results/ShowResults.dart';
import 'package:alzheimer/modules/webView/WebView.dart';
import 'package:alzheimer/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Test.dart';
import '../../shared/constants/Constants.dart';
import '../../shared/functions/shared_function.dart';
class TestGenesModel extends StatefulWidget {
  late int index;
  TestGenesModel(this.index);
  @override
  State<TestGenesModel> createState() => _TestGenesModelState();
}

class _TestGenesModelState extends State<TestGenesModel> {
  bool isDoctor = true;
  var firstGeneController = TextEditingController();
  var secondGeneController = TextEditingController();
  var thirdGeneController = TextEditingController();
  var forthGeneController = TextEditingController();
  var mutationController = TextEditingController();
  String res = "";
  var formKey = GlobalKey<FormState>();
  String tst = 'Hello';
  _launchURL() async {
    // var url = 'whatsapp://send?phone=0201021890205&text=${Uri.encodeComponent('Hello')}';
    var url = 'https://api.whatsapp.com/send/?phone=+201021370424&text=Hello';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Genes"),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
              onPressed: () {
                _launchURL();
              },
              icon: const Icon(Icons.call))
        ],
      ),
      backgroundColor: kPrimaryLightColor,
      body: Row(
        children: [
          Expanded(child: PageViewScreen(widget.index)),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Center(
                    child: ListView(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40,),
                        textField(controller: firstGeneController, label: 'GSM701542 Gene'),
                        const SizedBox(height: 10,),
                        textField(controller: secondGeneController, label: 'GSM701543 Gene'),
                        const SizedBox(height: 10,),
                        textField(controller: thirdGeneController, label: 'GSM701544 Gene'),
                        const SizedBox(height: 10,),
                        textField(controller: forthGeneController, label: 'GSM701545 Gene'),
                        const SizedBox(height: 10,),
                        textField(controller: mutationController, label: 'Mutation'),
                        const SizedBox(height: 10,),
                        const SizedBox(height: 20,),
                        Text(
                          res,
                          style: const TextStyle(
                              color: Colors.blue
                          ),
                        ),
                        const SizedBox(height: 20,),
                        MaterialButton(
                          color: kPrimaryColor,
                          height: 60,
                          onPressed: () async {
                            if(formKey.currentState!.validate()) {
                              String g1 ="${firstGeneController.text}";
                              String g2 = "${secondGeneController.text}";
                              String g3 = "${thirdGeneController.text}";
                              String g4 = "${forthGeneController.text}";
                              String mu = "${mutationController.text}";
                              String url = 'http://127.0.0.1:5000/genes/test/$g1/$g2/$g3/$g4/$mu';
                              var response = await http.post(
                                  Uri.parse(url),
                              );
                              print(response.body);
                              var r = json.decode(response.body) as Map;
                              navigateTo(context, ShowResultsScreen(respone: r['response'], index: widget.index,));
                              setState(() {

                              });
                            }

                          },
                          child: const Text("Show Results"),
                        ),
                      ],
                    ),
                  ),
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

        else if (
        !(value.contains(RegExp(
            r"^[0-9.]")))
        )
        {
          return "Please enter a value\nFor more information click on Genes definition tap at the top left";
        }
        return null;
      },
      cursorColor: kPrimaryColor,
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
          hintText: label
      ),
    );
  }
}
