// import 'dart:ffi';

import 'package:cmenu/constants.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class InformationCenterScreen extends StatelessWidget {

  const InformationCenterScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context, true);
            },
            child: const Icon(Icons.arrow_back,
                color:kPrimaryColor)),
        title:  const Text(
                    "Account",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                        fontFamily: 'Quicksand',
                        overflow: TextOverflow.ellipsis),
                  ),      
      ),
      body:  const Body());
  }
}
