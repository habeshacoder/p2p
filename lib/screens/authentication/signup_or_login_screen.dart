import 'package:flutter/material.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/appStyles/sized_boxes.dart';
import 'package:p2p/components/have_account_text.dart';
import 'package:p2p/screens/authentication/signup.dart';
import 'package:p2p/widgets/button.dart';

class SignupOrLogin extends StatelessWidget {
  static String routeName = "/signUpLoginScreen";
  const SignupOrLogin({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: P2pAppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: SizedBox(
                  width: double
                      .infinity, // Make the SizedBox as wide as its parent
                  child: Image.asset(
                    'assets/images/p2p_loginorSignup.png',
                    fit: BoxFit.fill, // Stretch and fill the available width
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Button(
                  hint: "Sign In",
                  onPressed: () => Navigator.pushNamed(context, '/login')),
              const SizedBox(
                height: P2pSizedBox.betweenbuttonAndText,
              ),
              HaveAccount(
                  action: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUp(),
                        ),
                      ),
                  prompt: "Don't have an account?",
                  actionHint: " Create"),
            ],
          ),
        ),
      ),
    );
  }
}
