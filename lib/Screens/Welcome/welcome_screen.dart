import 'package:flutter/material.dart';

import '../../components/background.dart';
import '../../responsive.dart';
import '../../shared/constants/Constants.dart';
import 'components/login_signup_btn.dart';
import 'components/welcome_image.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // width: PAGEWIDTH/1.2,
        // height: double.infinity,
        // decoration: BoxDecoration(
        //     border: Border.all(color: Colors.grey),
        //     color: Colors.grey[100]
        // ),

        child: Background(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Responsive(
                desktop: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Expanded(
                      child: WelcomeImage(),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            width: 300,
                            child: LoginAndSignupBtn(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                mobile: const MobileWelcomeScreen(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MobileWelcomeScreen extends StatelessWidget {
  const MobileWelcomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const WelcomeImage(),
        Row(
          children: const [
            Spacer(),
            Expanded(
              flex: 8,
              child: LoginAndSignupBtn(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
