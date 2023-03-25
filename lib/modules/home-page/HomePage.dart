import 'package:alzheimer/modules/testGenes/TestGenesScreen.dart';
import 'package:alzheimer/shared/functions/shared_function.dart';
import 'package:flutter/material.dart';

import '../../Test.dart';
import '../../shared/constants/Constants.dart';
import '../genes/Genes.dart';
import '../mri/MRI.dart';

class HomePageScreen extends StatelessWidget {
  late int index ;
  HomePageScreen(int i) {
    index = i;
  }
  double circleRadius = 100;
  double circleTextSize = 30;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text(
            "Home Page",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black
            ),
        ),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Expanded(child: PageViewScreen(index)),
          Expanded(
            child: Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: InkWell(
                          onTap: () {
                            navigateTo(context, MRIMainScreen(index));
                          },
                          child: CircleAvatar(
                            backgroundColor: kPrimaryColor,
                            radius: circleRadius,
                            child: Text(
                                "MRI Model",
                                style: TextStyle(
                                  fontSize: circleTextSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                ),
                            ),
                          ),
                        )
                    ),
                    Container(width: double.infinity, height: 2, color: Colors.grey,),
                    Expanded(
                        child: InkWell(
                          onTap: () {
                            navigateTo(context, GenesMainScreen(index));
                          },
                          child: CircleAvatar(
                            backgroundColor: kPrimaryColor,
                            radius: circleRadius,
                            child: Text(
                              "Genes Model",
                              style: TextStyle(
                                  fontSize: circleTextSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                              ),
                            ),
                          ),
                        )
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
