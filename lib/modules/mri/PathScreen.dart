import 'dart:convert';

import 'package:alzheimer/modules/mri/TestMRIModel.dart';
import 'package:alzheimer/shared/functions/shared_function.dart';
import 'package:flutter/material.dart';

import '../../Test.dart';
import '../../constants.dart';
import 'package:http/http.dart' as http;

class PathScreen extends StatelessWidget {
  var Controller = TextEditingController();
  var fkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text(
          "Test Path",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black
          ),
        ),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Expanded(child: PageViewScreen(0)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: fkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      // email address
                      height: 50.0,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "this filed is required";
                          }
                          return null;
                        },
                        controller: Controller,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Test data path",
                          border: OutlineInputBorder(),
                          prefix: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.text_fields),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 26,),
                    Container(
                      width: double.infinity,
                      height: 40,
                      color: kPrimaryColor,
                      child: MaterialButton(
                          onPressed: () async {
                            if(fkey.currentState!.validate()) {
                              String url = 'http://127.0.0.1:5000/choose';
                              var response = await http.post(
                                Uri.parse(url),
                                body: {
                                  "path": Controller.text
                                }
                              );
                              var r = json.decode(response.body) as Map;
                               navigateTo(
                                   context,
                                   TestMRI(
                                       title: r['res'],
                                       data: r['data'],
                                       rec: r['recomendations']
                                   )
                               );
                            }
                          },
                        child: Text("Test"),
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
}
