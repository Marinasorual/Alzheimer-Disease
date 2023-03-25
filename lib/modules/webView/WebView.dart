import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Test.dart';
import '../../shared/constants/Constants.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webviewx/webviewx.dart';
class ViewScreen extends StatefulWidget {
  late int index;
  ViewScreen(this.index);
  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  @override
  void initState() {
    super.initState();
  }
  _launchURL() async {
    const url = 'https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi';
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
        title: const Text('Genes Definitions'),
        centerTitle: true,
      ),
      // body: WebViewWidget(controller: controller,),
      body: Row(
        children: [
          Expanded(child: PageViewScreen(widget.index)),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    const Text(
                      '''
Important notes:
When click on \'Show Genes Definitions\' button a website will be opened.
Write gene name in \'GEO accession\' field at the top-right and click on Go button next to it(e.g. type GSM701542 and click on Go).

GSM701542 -iPSC cell line.
GSM701543 -Sporadic Parkinson's disease patient derived iPSC.
GSM701544 -iPSC from primary fibroblast.
GSM701544 -\tiPSC from primary fibroblast.

International Practical Shooting Confederation (IPSC).
                      ''',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Center(
                    child: MaterialButton(
                      color: kPrimaryColor,
                      onPressed: _launchURL,
                        child:const  Text('Show Genes Definitions'),
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
