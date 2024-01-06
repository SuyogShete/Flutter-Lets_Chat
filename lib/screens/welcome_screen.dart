import 'package:flutter/material.dart';
import 'package:lets_chat/screens/login_screen.dart';
import 'package:lets_chat/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lets_chat/components/MyButton.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                SizedBox(
                  child: DefaultTextStyle(
                    style: TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.black),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Lets CHAT',
                          speed: Duration(milliseconds: 500),
                        ),
                      ],
                      totalRepeatCount: 2,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            // RoundedButton(
            //
            //   title: 'Log In',
            //   colour: Color(0xff233743),
            //   onPressed: () {
            //     Navigator.pushNamed(context, LoginScreen.id);
            //   },
            // ),
            // RoundedButton(
            //   title: 'Register',
            //   colour: Color(0xff233743),
            //   onPressed: () {
            //     Navigator.pushNamed(context, LoginScreen.id);
            //   },
            // ),
            MyButton(
              title: 'Log In',
              onTap: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            SizedBox(height: 25.0,),
            MyButton(
              title: 'Register',
              onTap: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}


