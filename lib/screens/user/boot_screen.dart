import 'dart:async';
import 'package:flutter/material.dart';
import 'package:p2p/screens/user/onboarding_screen.dart';
import 'package:p2p/widgets/progress_indicator.dart';

class BootScreen extends StatefulWidget {
  const BootScreen({super.key});

  @override
  State<BootScreen> createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Onboarding())));
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      top: false,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image(
                image: AssetImage('assets/images/p2p_logo.png'),
                fit: BoxFit.fill,
              ),
            ),
            CustomProgressIndicator()
          ],
        ),
      ),
    );
  }
}
