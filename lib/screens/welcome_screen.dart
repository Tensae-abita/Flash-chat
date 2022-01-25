import 'package:chat/screens/login_screen.dart';
import 'package:chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'padding_widget.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
   AnimationController controller;
   Animation animation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
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
                    height: 60,
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flash Chat',
                      textStyle: TextStyle(
                        color: Colors.blue,
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                      ),
                      speed: const Duration(milliseconds: 200),
                    ),
                  ],
                  totalRepeatCount: 2,
                )
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            PaddingWidget(
                color: Colors.lightBlueAccent,
                title: 'Log In',
                onpressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                }),
            PaddingWidget(
                color: Colors.blueAccent,
                title: 'Register',
                onpressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                }),
          ],
        ),
      ),
    );
  }
}
