import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Test.dart';
import '../../shared/constants/Constants.dart';

class MRIInfo extends StatelessWidget {
  late int index ;
  MRIInfo(int i) {
    index = i;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text('Model Information'),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Expanded(child: PageViewScreen(index)),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: const [
                    Text(
                      'About Model',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '''
Alzheimer's disease is a progressive neurological disorder that affects millions of people worldwide. It is characterized by the accumulation of abnormal proteins in the brain, which can lead to memory loss, cognitive decline, and behavioral changes.

Medical imaging techniques such as magnetic resonance imaging (MRI) can be used to detect changes in the brain associated with Alzheimer's disease. However, accurately identifying these changes can be challenging, requiring careful analysis and interpretation of large amounts of imaging data.

Deep learning techniques, specifically Convolutional Neural Networks (CNNs), have emerged as a promising approach for analyzing MRI images and detecting signs of Alzheimer's disease. CNNs are a type of artificial neural network that have been specifically designed to analyze visual data such as images and videos.

By training a CNN on a large dataset of MRI images, the network can learn to identify patterns and features that are indicative of Alzheimer's disease, such as changes in brain structure and the presence of abnormal proteins.

In recent years, several studies have demonstrated the potential of CNNs for accurately detecting Alzheimer's disease from MRI images, achieving high levels of accuracy and sensitivity. For example, a CNN model trained on a dataset of 6,400 MRI images achieved an accuracy range of 95% to 98%, suggesting that the model is effective at detecting patterns and features that are associated with Alzheimer's disease.

While these results are promising, it's important to continue validating CNN models and testing their performance on new data to ensure their generalizability and reliability. Ultimately, CNNs could have important clinical applications for diagnosing and monitoring Alzheimer's disease, potentially enabling earlier detection and intervention.
'''
                      ,style: TextStyle(
                        fontSize: 20
                    )   ,
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
