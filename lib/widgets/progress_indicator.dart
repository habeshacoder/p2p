import 'package:flutter/material.dart';
import 'package:p2p/appStyles/app_colors.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 70),
        child: CircularProgressIndicator(
          color: P2pAppColors.yellow,
        ),
      ), // Show circular progress indicator overlaid
    );
  }
}
