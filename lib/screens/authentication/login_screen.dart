import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/appStyles/app_fontsize.dart';
import 'package:p2p/components/have_account_text.dart';
import 'package:p2p/providers/user_provider.dart';
import 'package:p2p/screens/admin/admin_home_screen.dart';
import 'package:p2p/screens/admin/manage_agent_status.dart';
import 'package:p2p/screens/agent/agent_home_screen.dart';
import 'package:p2p/screens/authentication/signup.dart';
import 'package:p2p/screens/user/delivery_request_screen.dart';
import 'package:p2p/screens/user/user_home.dart';
import 'package:p2p/service/authentication_service.dart';
import 'package:p2p/widgets/button.dart';
import 'package:p2p/widgets/error_message.dart';
import 'package:p2p/widgets/progress_indicator.dart';
import 'package:p2p/widgets/text_area.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class Login extends StatefulWidget {
  static const routeName = '/login';
  const Login({super.key});
  @override
  State<Login> createState() => _logInPageState();
}

// ignore: camel_case_types
class _logInPageState extends State<Login> {
  late TextEditingController passwordController;
  late TextEditingController phoneNumberController;
  bool isObscure = true;
  bool isValidPassword = true;
  String passwordMessage = "";
  String phoneMessage = "";
  bool isValidPhone = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    phoneNumberController = TextEditingController();
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
                        'assets/images/p2p_signin_top.png',
                        fit:
                            BoxFit.fill, // Stretch and fill the available width
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: P2pFontSize.screenPadding),
                      child: Column(
                        children: [
                          Textarea(
                            label: "Phone No",
                            isAuthentication: true,
                            isValid: isValidPassword,
                            isPassword: false,
                            setObscure: () => {},
                            isObscure: isObscure,
                            hint: "+251-9",
                            icon: Icons.phone,
                            controller: phoneNumberController,
                            onChanged: (value) {
                              setState(() {
                                phoneNumberController.text = value;
                              });
                            },
                          ),
                          if (phoneMessage.isNotEmpty)
                            ErrorMessage(message: phoneMessage),
                          const SizedBox(height: 5),
                          Textarea(
                            label: "Password",
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
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/forgot'),
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(color: P2pAppColors.blue),
                              ),
                            ),
                          ),
                          Button(
                            hint: "Sign In",
                            onPressed: validateAndSignin,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          HaveAccount(
                              action: () =>
                                  // Navigator.pushNamed(context, '/getotp'),
                                  Navigator.of(context)
                                      .pushNamed(SignUp.routeName),
                              prompt: "Don't have an account?",
                              actionHint: " Create"),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double
                          .infinity, // Make the SizedBox as wide as its parent
                      child: Image.asset(
                        'assets/images/p2p_signin_bottom.png',
                        fit:
                            BoxFit.fill, // Stretch and fill the available width
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

  void validateAndSignin() {
    setState(() {
      passwordMessage = "";
      phoneMessage = "";
      isValidPhone = true;
      isValidPassword = true;
    });

    if (passwordController.text.isEmpty) {
      setState(() {
        isValidPassword = false;
        passwordMessage = "Enter password";
      });
    }
    if (passwordController.text.isEmpty) {
      isValidPhone = false;
      phoneMessage = "Please enter phone number";
    }
    isValidPassword && isValidPhone ? login() : "";
  }

  void setPhoneNumber(String value) {
    setState(() {
      phoneNumberController.text = value;
      print("the phone number inside loginpageis $value");
    });
  }

  void login() {
    isLoading = true;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final authService = AuthService();
    Map<String, dynamic> requestData = {
      "userName": "0" +
          phoneNumberController.text
              .trim()
              .substring(phoneNumberController.text.length - 9),
      "password": passwordController.text,
    };
    authService.login(requestData).then((role) async {
      print('user;.....${role}');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Successfully Login'),
          duration: Duration(seconds: 2)));
      // setState(() {
      //   // isLoading = false;
      //   // phoneNumberController.text = "";
      //   // passwordController.text = "";
      // });
      if (role[0] == 'ADMIN') {
        print('starting.................');
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Admin_Home_Screen()),
          );
        });
      }
      if (role[0] == 'CANDIDATE' || role[0] == 'AGENT') {
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Agent_Home_Screen(),
            ),
          );
        });
      }
      if (role[0] == 'USER') {
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => User_Home()));
        });
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isSignedIn', true);
      String now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      await prefs.setString('lastSignInTime', now);
    }).catchError((error) {
      print("Error object received: $error");

      String errorMessage = "Failed to login. Unexpected error.";

      if (error is Exception) {
        errorMessage = "phone number or/and password is not correct";
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
