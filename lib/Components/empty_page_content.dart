import 'package:cmenu/constants.dart';
import 'package:flutter/material.dart';

class EmptyPageContent extends StatelessWidget {
  const EmptyPageContent({
    Key? key,
    required this.imageLink,
    required this.label,
  }) : super(key: key);

  final String imageLink;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
      Image.asset(imageLink,height: 100,),
      const SizedBox(height: 10,),
      Text(label,
        style: const TextStyle(color: kPrimaryColor, fontSize: 18),
      )
    ]);
  }
}