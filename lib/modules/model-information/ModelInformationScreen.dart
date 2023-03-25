import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Test.dart';
import '../../shared/constants/Constants.dart';

class ModelInformationScreen extends StatelessWidget {
  late int index ;
  ModelInformationScreen(int i) {
    index = i;
  }
  _launchURL() async {
    const url = 'https://en.wikipedia.org/wiki/K-means_clustering';
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
                  children: [
                    const Text(
                        'About algorithm used',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Column(
                      children: [
                        const Text(
                            '''
Information about Kmeans clustring:
  k-means clustering is a method of vector quantization, originally from signal processing, that aims to partition n observations into k clusters in which each observation belongs to the cluster with the nearest mean (cluster centers or cluster centroid), serving as a prototype of the cluster. This results in a partitioning of the data space into Voronoi cells.
'''
                            ,style: TextStyle(
                                    fontSize: 20
                                    )   ,
                        ),
                        Row(
                          children: [
                            Spacer(),
                            TextButton(

                                onPressed: _launchURL,
                                child: const Text('For more Information ?', style: TextStyle(color: kPrimaryColor),)
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'About Number of Clusters',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const SizedBox(
                      width: 300,
                      height: 400,
                      child:  Image(
                        fit: BoxFit.fill,
                          image: AssetImage('assets/images/clusters.jpg'),
                      ),
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
                    const Text(
                      'About Clusters',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26
                      ),
                    ),
                    const SizedBox(
                      width: 300,
                      height: 400,
                      child:  Image(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/samples.jpg'),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                        '''
After training the model:
  1- Te accuracy about 89%
  2- The model classify the genes into three clusters as it the optimal number for these data set.
     
'''
                        ,style: TextStyle(
                      fontSize: 20
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
