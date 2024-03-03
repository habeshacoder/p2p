import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/appStyles/app_fontsize.dart';
import 'package:p2p/appStyles/sized_boxes.dart';
import 'package:p2p/utilities/utilities.dart';
import 'package:p2p/widgets/button.dart';
import 'package:p2p/widgets/error_message.dart';
import 'package:p2p/widgets/phone_input.dart';
import 'package:p2p/widgets/progress_indicator.dart';

// ignore: camel_case_types
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});
  @override
  State<ForgotPassword> createState() => _ForgotPasswordPageState();
}

// ignore: camel_case_types
class _ForgotPasswordPageState extends State<ForgotPassword> {
  late TextEditingController phoneNumberController;
  String phoneMessage = "";
  bool isValidPhone = false;
  bool isLoading = false;
  String verificationId = "";
  @override
  void initState() {
    super.initState();
    phoneNumberController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height;
    var orientation = MediaQuery.of(context).orientation;

    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            if (isLoading) const CustomProgressIndicator(),
            SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double
                          .infinity, // Make the SizedBox as wide as its parent
                      child: SvgPicture.asset(
                        'assets/images/p2p_reset_password.svg',
                        fit: BoxFit.fill,
                        height: orientation == Orientation.portrait
                            ? size * 0.5
                            : size *
                                0.7, // Stretch and fill the available width
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: P2pFontSize.screenPadding,
                          right: P2pFontSize.screenPadding,
                          bottom: P2pFontSize.screenPadding),
                      child: Column(
                        children: [
                          const AutoSizeText(
                            "Reset Your Password",
                            style: TextStyle(
                              fontSize: P2pFontSize.p2p25,
                              fontWeight: FontWeight.bold,
                              color: P2pAppColors.black,
                            ),
                            maxLines:
                                1, // Ensure that the text is displayed in one line
                          ),
                          const SizedBox(
                            height: P2pSizedBox.betweenText,
                          ),
                          AutoSizeText(
                            "We'll be sending you OTP(one time password) to the number you'll be entering",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: P2pAppColors.normal,
                              fontSize: P2pFontSize.p2p21,
                              height: 1.2,
                            ),
                            maxLines: 2,
                          ),
                          const SizedBox(
                            height: P2pSizedBox.betweenbuttonAndText,
                          ),
                          PhoneInput(
                            setPhoneNumber: setPhoneNumber,
                          ),
                          if (phoneMessage.isNotEmpty)
                            ErrorMessage(message: phoneMessage),
                          const SizedBox(height: 30),
                          Button(
                              hint: "Get OTP",
                              onPressed: () => validateAndSignin()
                              // verifyPhoneNumber(phoneNumberController.text),
                              ),
                          const SizedBox(
                            height: P2pSizedBox.betweenbuttonAndText,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void validateAndSignin() {
    Navigator.pushNamed(context, '/otp', arguments: {
      "verification_id": verificationId,
      "phone_number": phoneNumberController.text,
      "isSignUp": false
    });

    setState(() {
      //reset the state without refresh
      phoneMessage = "";
      isValidPhone = true;
    });
    var message = Utilities.validatePhoneNumber(phoneNumberController.text);
    if (message != null) {
      isValidPhone = false;
      phoneMessage = message;
    }
    isValidPhone ? verifyPhoneNumber(phoneNumberController.text) : "";
  }

  void setPhoneNumber(String value) {
    setState(() {
      phoneNumberController.text = value;
    });
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    setState(() {
      isLoading = true;
    });

    verificationCompleted(AuthCredential authCredential) async {
      print("Phone number automatically verified and signed in.");
    }

    verificationFailed(FirebaseAuthException authException) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Phone Verification Failed'),
      ));
      Navigator.pop(context);
    }

    codeSent(String verificationId, [int? forceResendingToken]) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Code Sent To Your Phone'),
      ));
      setState(() {
        isLoading = false;
        this.verificationId = verificationId;
      });
      Navigator.pushNamed(context, '/otp', arguments: {
        "verification_id": verificationId,
        "phone_number": phoneNumberController.text,
        "isSignUp": false
      });
    }

    codeAutoRetrievalTimeout(String verificationId) {
      setState(() {});
    }

    // await FirebaseAuth.instance.verifyPhoneNumber(
    //   phoneNumber: phoneNumber,
    //   verificationCompleted: verificationCompleted,
    //   verificationFailed: verificationFailed,
    //   codeSent: codeSent,
    //   codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    // );
  }
}
