import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/appStyles/app_fontsize.dart';
import 'package:p2p/appStyles/sized_boxes.dart';
import 'package:p2p/components/have_account_text.dart';
import 'package:p2p/screens/authentication/newPassword.dart';
import 'package:p2p/widgets/button.dart';
import 'package:p2p/widgets/progress_indicator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({
    super.key,
  });
  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String? verificationId;
  String smsCode = "";
  String? email;
  bool isSignUp = true;
  bool isLoading = false;
  bool isError = false;
  String otpMessage = "";
  String phoneNo = "";
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      // Retrieve the arguments using ModalRoute
      final Map<String, dynamic> args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      setState(() {
        phoneNo = args['phone_number'];
        verificationId = args['verification_id'];
        isSignUp = args['isSignUp'];
      });
      print("passed arguments $phoneNo  $isSignUp  $verificationId  ");
    });
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    return SafeArea(
      child: Scaffold(
          body: // isLogin
              //?
              Stack(children: [
        if (isLoading) const CustomProgressIndicator(),
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width:
                    double.infinity, // Make the SizedBox as wide as its parent
                child: Image.asset(
                  'assets/images/p2p_otp.png',
                  fit: BoxFit.fill, // Stretch and fill the available width
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: P2pFontSize.screenPadding),
                child: Column(
                  children: [
                    const AutoSizeText(
                      "OTP VERIFICATION",
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
                      "Enter the OTP sent to the phone you entered",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: P2pAppColors.normal,
                        fontSize: P2pFontSize.p2p21,
                        height: 1.2,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: P2pSizedBox.betweenbuttonAndText,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: P2pFontSize.screenPadding,
                ),
                child: PinCodeTextField(
                  mainAxisAlignment: orientation == Orientation.portrait
                      ? MainAxisAlignment.spaceAround
                      : MainAxisAlignment.spaceEvenly,
                  appContext: context,
                  // controller: controller,
                  length: 6,
                  cursorHeight: 19,
                  cursorColor: P2pAppColors.yellow,
                  enableActiveFill: true,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                  boxShadows: [
                    BoxShadow(
                      color: P2pAppColors.yellow.withOpacity(0.5),
                      blurRadius: 1,
                      blurStyle: BlurStyle.normal,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    )
                  ],
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    fieldWidth: 50,
                    activeFillColor: Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    inactiveColor: Colors.black,
                    borderWidth: 1,
                    activeColor: Colors.blue,
                    selectedColor: Colors.black,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      smsCode = value;
                    });
                    // ignore: avoid_print
                    print(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Button(
                        hint: "Verify Otp",
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(NewPassword.routeName);
                          //  verifyOTP(smsCode)
                        },
                      ),
                    ),
                    const SizedBox(
                      height: P2pSizedBox.betweenText,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: P2pFontSize.screenPadding),
                      child: HaveAccount(
                        action: () => verifyPhoneNumber(phoneNo),
                        prompt: "Don't get the code?",
                        actionHint: "Resend",
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        // if (isLoading)
        //   Container(
        //     color: Colors.black.withOpacity(0.5),
        //     child: const Center(
        //       child: CircularProgressIndicator(
        //         color: Color(0xFFFAB631),
        //       ), // Show circular progress indicator overlaid
        //     ),
        //   ),
      ])
          // : Container(
          //     color: Colors.black.withOpacity(0.5),
          //     child: const Center(
          //       child: CircularProgressIndicator(
          //         color: Color(0xFFFAB631),
          //       ), // Show circular progress indicator overlaid
          //     ),
          // z  ),
          ),
    );
  }

  Future<void> verifyOTP(String otp) async {
    print("passed otp $otp");
    print("passed phone is $phoneNo");
    print("passed verification Id is $verificationId");
    setState(() {
      isLoading = true;
    });
    // Create the AuthCredential with the verificationId and the entered OTP
    AuthCredential authCredential = PhoneAuthProvider.credential(
      verificationId: verificationId ?? "",
      smsCode: otp,
    );

    // Sign in with the AuthCredential
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(authCredential);
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Verification successful'),
      ));
      isSignUp
          // ignore: use_build_context_synchronously
          ? Navigator.pushNamed(context, '/signup', arguments: {
              "phone_number": phoneNo,
            })
          // ignore: use_build_context_synchronously
          : Navigator.pushNamed(context, '/newPassword', arguments: {
              "phone_number": phoneNo,
            });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text('OTP Verification failed'),
      ));
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    print("resend again is called");
    print("resend phone is $phoneNumber");
    setState(() {
      isLoading = true;
    });

    verificationCompleted(AuthCredential authCredential) async {
      print("Phone number automatically verified and signed in.");
    }

    verificationFailed(FirebaseAuthException authException) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Phone verification failed'),
      ));
    }

    codeSent(String verificationId, [int? forceResendingToken]) {
      setState(() {
        this.verificationId = verificationId;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Code sent to your phone'),
      ));
      setState(() {
        isLoading = false;
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
