import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Test.dart';
import '../../shared/constants/Constants.dart';

class CNNScreen extends StatelessWidget {
  late int index ;
  CNNScreen(int i) {
    index = i;
  }
  _launchURL() async {
    const url = 'https://playground.tensorflow.org/#activation=tanh&batchSize=10&dataset=circle&regDataset=reg-plane&learningRate=0.03&regularizationRate=0&noise=0&networkShape=4,2&seed=0.15044&showTestData=false&discretize=false&percTrainData=50&x=true&y=true&xTimesY=false&xSquared=false&ySquared=false&cosX=false&sinX=false&cosY=false&sinY=false&collectStats=false&problem=classification&initZero=false&hideText=false';
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
        backgroundColor: kPrimaryColor,
        title: const Text('CNN Information'),
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
                  children: [
                    Text(
                      'What is Deep learning ',
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
Deep learning is a subfield of machine learning that uses algorithms inspired by the structure and function of the human brain, called artificial neural networks, to learn from large amounts of data. It involves training deep neural networks, which are composed of multiple layers of interconnected nodes, to recognize patterns and make predictions.

Deep learning has been applied to various tasks such as image and speech recognition, natural language processing, and autonomous driving. Its success is largely due to its ability to learn complex representations of data that would be difficult or impossible for humans to program manually.

In summary, deep learning is a type of machine learning that uses neural networks with multiple layers to learn and recognize complex patterns in data.
'''
                      ,style: TextStyle(
                        fontSize: 20
                    )   ,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'What is CNN',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      '''
CNN stands for Convolutional Neural Network, which is a specific type of neural network commonly used in image and video recognition tasks.

In a CNN, the input image is passed through multiple layers of filters, each of which detects specific features of the image, such as edges or corners. The filters are learned during the training process using backpropagation, where the network adjusts its parameters to minimize the difference between the predicted output and the actual output.

The output of the convolutional layers is then fed into one or more fully connected layers, which are similar to those found in traditional neural networks. These layers use the features learned in the convolutional layers to make a prediction about the image, such as the objects it contains or the emotions it expresses.

CNNs have become a popular approach to image and video recognition tasks due to their ability to automatically learn and extract features from raw data, as well as their ability to scale to large datasets.
'''
                      ,style: TextStyle(
                        fontSize: 20
                    )   ,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      '''
As we mention above. KMeans algorithm depends on number of clusters. But actually we don\'t know the
optimal number of clusters for our dataset. So we user Elbow method which is a graphical method to know the optimal number
of clusters. As in the above image: the optimal number is 3. Why 3?\nScientists do experiments about that and conclude that ...//TODO   
'''
                      ,style: TextStyle(
                        fontSize: 20
                    ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextButton(

                        onPressed: _launchURL,
                        child: const Text(
                          'Simulation for CNN',
                          style: TextStyle(color: kPrimaryColor, fontSize: 30),

                        )
                    )
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
