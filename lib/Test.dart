import 'dart:async';
import 'package:flutter/material.dart';
class PageViewScreen extends StatefulWidget {
  final index;
  PageViewScreen(this.index);
  @override
  State<PageViewScreen> createState() => _PageViewScreenState(index);
}

class _PageViewScreenState extends State<PageViewScreen> {
  _PageViewScreenState(int index) {
    _currentPage = index;
  }
  int _currentPage = 0;
  late Timer _timer;
  PageController _pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {

    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 8) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });

  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
  List<String> images = [
    'assets/images2/1.jpeg',
    'assets/images2/2.jpeg',
    'assets/images2/4.jpeg',
    'assets/images2/5.jpeg',
    'assets/images2/6.jpeg',
    'assets/images2/7.jpg',
    'assets/images2/8.jpeg',
    'assets/images2/9.jpg',
  ];
  double imageWidth = 400;
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: [
        SizedBox(
          height: double.infinity,
          width: imageWidth,
          child: Image(
            image: AssetImage(images[0]),
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          height: double.infinity,
          width: imageWidth,
          child: Image(
            image: AssetImage(images[1]),
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          height: double.infinity,
          width: imageWidth,
          child: Image(
            image: AssetImage(images[2]),
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          height: double.infinity,
          width: imageWidth,
          child: Image(
            image: AssetImage(images[3]),
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          height: double.infinity,
          width: imageWidth,
          child: Image(
            image: AssetImage(images[4]),
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          height: double.infinity,
          width: imageWidth,
          child: Image(
            image: AssetImage(images[5]),
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          height: double.infinity,
          width: imageWidth,
          child: Image(
            image: AssetImage(images[6]),
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          height: double.infinity,
          width: imageWidth,
          child: Image(
            image: AssetImage(images[7]),
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }
}
