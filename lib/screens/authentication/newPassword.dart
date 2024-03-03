// ignore: file_names
import 'package:flutter/material.dart';
import 'package:p2p/appStyles/app_fontsize.dart';
import 'package:p2p/appStyles/sized_boxes.dart';
import 'package:p2p/screens/authentication/login_screen.dart';
import 'package:p2p/service/authentication_service.dart';
import 'package:p2p/widgets/button.dart';
import 'package:p2p/widgets/error_message.dart';
import 'package:p2p/widgets/progress_indicator.dart';
import 'package:p2p/widgets/text_area.dart';

// ignore: camel_case_types
class NewPassword extends StatefulWidget {
  static String routeName = "/newPassword";
  const NewPassword({super.key});
  @override
  State<NewPassword> createState() => _NewPasswordPageState();
}

// ignore: camel_case_types
class _NewPasswordPageState extends State<NewPassword> {
  late TextEditingController passwordController;
  bool isObscure = true;
  bool isValidPassword = true;
  String passwordMessage = "";
  String phoneNumber = "";
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      // Retrieve the arguments using ModalRoute
      final Map<String, dynamic> args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      setState(() {
        phoneNumber = args['phone_number'];
      });
    });
    passwordController = TextEditingController();
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
                        'assets/images/p2p_new_password.png',
                        fit:
                            BoxFit.fill, // Stretch and fill the available width
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: P2pFontSize.screenPadding),
                      child: Column(
                        children: [
                          Textarea(
                            label: "New Password",
                            isAuthentication: true,
                            isValid: isValidPassword,
                            isPassword: true,
                            setObscure: setObscure,
                            isObscure: isObscure,
                            hint: "**********",
                            icon: Icons.password,
                            controller: passwordController,
                            onChanged: (value) {
                              setState(() {
                                passwordController.text = value;
                              });
                            },
                          ),
                          if (passwordMessage.isNotEmpty)
                            ErrorMessage(message: passwordMessage),
                          const SizedBox(
                            height: P2pSizedBox.betweenButtonAndInputField,
                          ),
                          Button(
                            hint: "Reset Password",
                            onPressed: validateAndReset,
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

  void setObscure() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  void validateAndReset() {
    Navigator.of(context).pushNamed(Login.routeName);
    setState(() {
      //reset the state without refresh
      passwordMessage = "";
      isValidPassword = true;
    });

    if (passwordController.text.isEmpty) {
      setState(() {
        isValidPassword = false;
        passwordMessage = "Enter password";
      });
    }
    isValidPassword ? resetController() : "";
  }

  void resetController() {
    setState(() {
      isLoading = true;
    });
    final authService = AuthService();
    print("reset phone $phoneNumber");
    print("password to reset ${passwordController.text}");
    Map<String, dynamic> requestData = {
      "userPassword": passwordController.text,
      "phoneNumber": phoneNumber,
    };
    authService.resetPassword(requestData).then((user) {
      print("response body is $user");
      // Assuming user authentication was successful and you have the 'user' object
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Password Reset Successfully'),
          duration: Duration(seconds: 2)));
      setState(() {
        isLoading = false;
      });
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushNamed(context, '/login');
      });
    }).catchError((error) {
      print("Error object received: $error");

      String errorMessage = "Failed to reset. Unexpected error.";

      if (error is Exception) {
        errorMessage = "Failed to authenticate user";
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(errorMessage),
      ));
      setState(() {
        isLoading = false;
      });
    });
  }
}
