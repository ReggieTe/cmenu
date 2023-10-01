import 'package:cmenu/Components/empty_page_content.dart';
import 'package:cmenu/Components/rounded_button.dart';
import 'package:cmenu/Splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'background.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
        child: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
       const SizedBox(
          height: 30,
        ),
        GestureDetector(
          child:const EmptyPageContent(
              imageLink: "assets/images/no-wifi.png",
              label: 'No internet connection'),
          onTap: () {},
        ),
        const Text(
          "No active connection available \n Check connections & try again!",
          style: TextStyle(fontSize: 14, color: Colors.red),
        ),
        const SizedBox(
          height: 10,
        ),
        RoundedButton(
            text: "Try again",
            press: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const SplashScreen();
              }));
            })
      ],
    )));
  }
}
