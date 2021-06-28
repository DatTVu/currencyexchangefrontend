import 'dart:ui';

import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Widget icon;
  final TextStyle textStyle;
  final String textContent;
  final double height;
  final double width;
  final Color color;
  final double radius;
  final double leftOfText;
  final double rightOfText;
  final GestureTapCallback onPressed;
  final Color borderColor;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry textAlign;
  PrimaryButton({
    this.icon,
    this.textStyle = const TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
    this.height = 58,
    this.width = 260,
    this.color = Colors.green,
    this.radius = 15.0,
    this.leftOfText = 10,
    this.rightOfText = 10,
    this.borderColor = Colors.blue,
    this.padding = const EdgeInsets.only(left: 16, right: 16),
    this.textAlign = Alignment.center,
    this.textContent,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: this.color,
      splashColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(this.radius),
        side: BorderSide(color: this.borderColor),
      ),
      padding: this.padding,
      child: Container(
        height: this.height,
        width: this.width,
        child: Stack(
          children: [
            Align(
              child: this.icon ?? Container(),
              alignment: Alignment.centerLeft,
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: this.leftOfText,
              right: this.rightOfText,
              child: Align(
                alignment: this.textAlign,
                child: Text(
                  this.textContent,
                  style: this.textStyle,
                ),
              ),
            ),
          ],
        ),
      ),
      onPressed: this.onPressed,
    );
  }
}
