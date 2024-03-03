import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/appStyles/app_fontsize.dart';

// ignore: must_be_immutable
class HaveAccount extends StatelessWidget {
  HaveAccount(
      {required this.action,
      required this.prompt,
      required this.actionHint,
      super.key});
  String actionHint;
  String prompt;
  VoidCallback action;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: prompt, // "Don't have an account?",
              style: TextStyle(
                  color: P2pAppColors.normal,
                  fontSize: P2pFontSize.p2p20,
                  fontWeight: FontWeight.bold),
            ),
            const TextSpan(
              text: ' ',
            ),
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = action, //Navigator.pushNamed(context, '/signup'),
              text: actionHint,
              style: const TextStyle(
                color: P2pAppColors.blue,
                fontSize: P2pFontSize.p2p20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
