import 'package:flutter/material.dart';

import '../../Test.dart';
import '../../constants.dart';
class TestMRI extends StatelessWidget {
  final title;
  final data;
  final rec;

  const TestMRI({super.key, required this.title, required this.data, required this.rec});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text(
          "MRI Test results",
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
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  SizedBox(height: 20,),
                  Center(child: Text(title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)),
                  const SizedBox(height: 10,),
                  Container(
                    width: 200,
                    height: 200,
                    child: const Image(
                        image: AssetImage('backend/test.png')
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Text('Information:',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10,),
                  ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${index+1}- ${rec[index]}", style: TextStyle(fontSize: 20),),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 6,);
                      },
                      itemCount: data.length
                  ),
                  const Text('Recommendations:',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10,),
                  /*
                  (context, index) {
                        return Text(rec[index]);
                      },
                   */
                  ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${index+1}- ${rec[index]}" ,style: TextStyle(fontSize: 20),),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 6,);
                      },
                      itemCount: rec.length
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
