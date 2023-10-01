import 'package:cmenu/constants.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback? press;
  final Color color, textColor;
  const RoundedButton({
    Key? key,
    required this.text,
    required this.press,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        width: size.width,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(kBorderRaduis),
            child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  onPressed: press,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(text,
                        style: const TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ))),
      ),
    );
  }
}
