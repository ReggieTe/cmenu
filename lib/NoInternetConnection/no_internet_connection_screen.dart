import 'package:cmenu/constants.dart';

import 'components/body.dart';
import 'package:flutter/material.dart';

class NoInternetConnectionScreen extends StatelessWidget {
  const NoInternetConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            " cMenu",
            style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor,fontFamily: 'Quicksand'),
          ),
        ),
       body: const Body(),
    );
  }
}
