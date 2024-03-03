import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/appStyles/app_fontsize.dart';
import 'package:p2p/appStyles/sized_boxes.dart';
import 'package:p2p/components/have_account_text.dart';
import 'package:p2p/utilities/utilities.dart';
import 'package:p2p/widgets/button.dart';
import 'package:p2p/widgets/error_message.dart';
import 'package:p2p/widgets/phone_input.dart';
import 'package:p2p/widgets/progress_indicator.dart';

// ignore: camel_case_types
class GetOtp extends StatefulWidget {
  const GetOtp({super.key});
  @override
  State<GetOtp> createState() => _GetOtpPageState();
}

// ignore: camel_case_types
class _GetOtpPageState extends State<GetOtp> {
  late TextEditingController phoneNumberController;
  String phoneMessage = "";
  bool isValidPhone = false;
  bool isLoading = false;
  bool agree = false;
  String? verificationId;
  var isChecked = false;
  var isCheckedErrorMessage = false;
  @override
  void initState() {
    super.initState();
    phoneNumberController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
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
                      child: Image.asset(
                        'assets/images/p2p_otp.png',
                        fit:
                            BoxFit.fill, // Stretch and fill the available width
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
                            "ENTER YOUR PHONE NUMBER",
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
                            "We'll be sending you a OTP (One Time Password) to the number you'll be entering",
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
                          Container(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Checkbox(
                                  splashRadius: 2,
                                  checkColor: Colors.black,
                                  fillColor: MaterialStateProperty.resolveWith(
                                      (states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return Colors.green;
                                    }
                                    return null;
                                  }),
                                  value: isChecked,
                                  // shape: ,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                  },
                                ),
                                Text("I agree to the terms &conditions",
                                    style: TextStyle(
                                        fontSize: P2pFontSize.p2p18,
                                        color: P2pAppColors.normal))
                              ],
                            ),
                          ),
                          if (isCheckedErrorMessage)
                            Text(
                              'please mark the check box',
                              style: TextStyle(color: Colors.red),
                            ),
                          const SizedBox(height: 30),
                          Button(
                            hint: "Get OTP",
                            onPressed: () => validateAndSignin(),
                          ),
                          const SizedBox(
                            height: P2pSizedBox.betweenbuttonAndText,
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  bottom: P2pSizedBox.fromBottomOfDevice),
                              child: HaveAccount(
                                action: () => Navigator.pushNamed(
                                  context,
                                  '/login',
                                ),
                                prompt: "Have already an account?",
                                actionHint: " Sign In",
                              )),
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
    if (isChecked == false) {
      setState(() {
        isCheckedErrorMessage = true;
      });
      return;
    }
    if (isChecked == true) {
      setState(() {
        isCheckedErrorMessage = false;
      });
    }
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

  bool isNumeric(String s) {
    if (s.isEmpty) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    setState(() {
      isLoading = true;
    });

    verificationCompleted(AuthCredential authCredential) async {
      print("Phone number automatically verified and signed in.");
    }

    verificationFailed(FirebaseAuthException authException) {
      print('verification failed');
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Phone Verification Failed'),
      ));
      // Navigator.pop(context);
      setState(() {
        isLoading = false;
      });
      return;
    }

    codeSent(String verificationId, [int? forceResendingToken]) {
      print('code sent');
      setState(() {
        this.verificationId = verificationId;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Code Sent To Your Phone'),
      ));
      setState(() {
        isLoading = false;
      });
      print("phone number controller is ${phoneNumberController.text}");
      Navigator.pushNamed(context, '/otp', arguments: {
        "phone_number": phoneNumberController.text,
        "verification_id": verificationId,
        "isSignUp": true
      });
    }

    codeAutoRetrievalTimeout(String verificationId) {
      setState(() {});
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }
}
