import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    super.key,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      height: size.height,
      child: Stack(
        children: <Widget>[
         Padding(
            padding:const EdgeInsets.symmetric(horizontal: 20) ,
            child: child
            )
        ],
      ),
    );
  }
}
