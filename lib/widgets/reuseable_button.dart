import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReusableButton extends StatelessWidget {
  final Color? color;
  final VoidCallback? press;
  final Color? textColor;
  final String? label;
  ReusableButton({this.press, this.textColor, this.color, this.label});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(5),
      child: MaterialButton(
        onPressed: press,
        minWidth: double.infinity,
        textColor: textColor,
        child: Text(
          label!,
          style: GoogleFonts.montserrat(
              color: textColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5),
        ),
      ),
    );
  }
}
