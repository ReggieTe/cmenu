import 'package:cmenu/Splash/components/body.dart';
import 'package:cmenu/constants.dart';
import 'package:flutter/material.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kPrimaryColor,
      body: Body(),
    );
  }
}
