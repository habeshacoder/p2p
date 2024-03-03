import 'package:flutter/material.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/appStyles/app_fontsize.dart';

// ignore: must_be_immutable
class Button extends StatelessWidget {
  Button({
    super.key,
    required this.hint,
    required this.onPressed,
  });
  String hint;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              P2pAppColors.black), // Background color
          side: MaterialStateProperty.all<BorderSide>(
            const BorderSide(
              width: 2.0, // Border width
            ),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0), // Border radius
            ),
          ),
        ),
        child: Text(
          hint,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: P2pAppColors.white, // Text color
            fontSize: P2pFontSize.p2p23,
          ),
        ),
      ),
    );
  }
}
