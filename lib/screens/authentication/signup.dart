import 'package:flutter/material.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/appStyles/app_fontsize.dart';
import 'package:p2p/appStyles/sized_boxes.dart';
import 'package:p2p/providers/user_provider.dart';
import 'package:p2p/screens/authentication/login_screen.dart';
import 'package:p2p/service/authentication_service.dart';
import 'package:p2p/utilities/utilities.dart';
import 'package:p2p/widgets/button.dart';
import 'package:p2p/widgets/error_message.dart';
import 'package:p2p/widgets/progress_indicator.dart';
import 'package:p2p/widgets/text_area.dart';
import 'package:provider/provider.dart';
import 'dart:core';

// ignore: camel_case_types
class SignUp extends StatefulWidget {
  static String routeName = "/signUp";
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUp> {
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController emailController;
  late TextEditingController streetController;
  late TextEditingController cityController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneNumberNameController;
  bool isObscure = true;
  bool isValidPassword = true;
  String passwordMessage = "";
  bool isValidConfirmPassword = true;
  String confirmPasswordMessage = "";
  String phoneMessage = "";
  String streetMessage = "";
  String cityMessage = "";
  String firstNameMessage = "";
  String lastNameMessage = "";
  late String userName = "";
  bool isValidPhone = true;
  bool isValidPhoneNumber = true;
  bool isValidEmail = true;
  bool isValidStreet = true;
  bool isValidCity = true;
  bool isValidFirstName = true;
  bool isValidLastName = true;
  String emailMessage = "";
  bool isLoading = false;
  bool _isPasswordVisible = false;
  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () {
    //   // Retrieve the arguments using ModalRoute
    //   final Map<String, dynamic> args =
    //       ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    //   setState(() {
    //     userName = args['phone_number'];
    //   });
    // });

    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    passwordController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    cityController = TextEditingController();
    streetController = TextEditingController();
    cityController = TextEditingController();
    phoneNumberNameController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var size = MediaQuery.of(context).size.height;
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
                    Container(
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/images/p2p_signup_top.png',
                            fit: BoxFit
                                .cover, // Set the fit property to BoxFit.cover
                            width: double.infinity,
                            height: orientation == Orientation.portrait
                                ? size * 0.2
                                : size * 0.7,
                          ),
                          SizedBox(
                            width: double
                                .infinity, // Make the SizedBox as wide as its parent
                            child: Image.asset(
                              'assets/images/p2p_sign_up.png',
                              height: orientation == Orientation.portrait
                                  ? size * 0.2
                                  : size *
                                      0.7, // Stretch and fill the available width
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: P2pFontSize.screenPadding),
                      child: Column(
                        children: [
                          Textarea(
                            label: "FirstName",
                            isAuthentication: true,
                            isValid: isValidPassword,
                            isPassword: false,
                            setObscure: () => {},
                            isObscure: isObscure,
                            hint: "John",
                            isEnabled: true,
                            icon: Icons.person,
                            controller: firstNameController,
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                          if (firstNameMessage.isNotEmpty)
                            ErrorMessage(message: firstNameMessage),
                          const SizedBox(height: P2pSizedBox.betweenButtons),
                          Textarea(
                            label: "LastName",
                            isAuthentication: true,
                            isValid: isValidPassword,
                            isPassword: false,
                            setObscure: () => {},
                            isObscure: isObscure,
                            hint: "Doe",
                            isEnabled: true,
                            icon: Icons.person_2,
                            controller: lastNameController,
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                          if (lastNameMessage.isNotEmpty)
                            ErrorMessage(message: lastNameMessage),
                          Textarea(
                            label: "Phone",
                            isAuthentication: true,
                            isValid: isValidPhoneNumber,
                            isPassword: false,
                            setObscure: () => {},
                            isObscure: isObscure,
                            hint: "251989858377",
                            isEnabled: true,
                            icon: Icons.phone,
                            controller: phoneNumberNameController,
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                          if (phoneMessage.isNotEmpty)
                            ErrorMessage(message: phoneMessage),
                          const SizedBox(height: P2pSizedBox.betweenButtons),
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
                          const SizedBox(height: P2pSizedBox.betweenButtons),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            maxLines: 1,
                            minLines: 1,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              hintText: '**********',
                              labelText: 'Confirm Password',
                              hintStyle: TextStyle(
                                  color: P2pAppColors.normal,
                                  fontSize: P2pFontSize.p2p14,
                                  fontWeight: FontWeight.bold),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 50.0, vertical: 15),
                            ),
                            controller: confirmPasswordController,
                            // enabled: true,
                          ),
                          if (confirmPasswordMessage.isNotEmpty)
                            ErrorMessage(message: confirmPasswordMessage),
                          const SizedBox(height: P2pSizedBox.betweenButtons),
                          const SizedBox(
                            height: P2pSizedBox.betweenButtons,
                          ),
                          Textarea(
                            label: "Email",
                            isAuthentication: true,
                            isValid: isValidPassword,
                            isPassword: false,
                            isObscure: isObscure,
                            hint: "example@gmail.com",
                            icon: Icons.email,
                            controller: emailController,
                            onChanged: (value) {
                              setState(() {
                                emailController.text = value;
                              });
                            },
                          ),
                          if (emailMessage.isNotEmpty)
                            ErrorMessage(message: emailMessage),
                          const SizedBox(
                            height: P2pSizedBox.betweenButtons,
                          ),
                          Textarea(
                            label: "Street",
                            isAuthentication: true,
                            isValid: isValidPassword,
                            isPassword: false,
                            isObscure: isObscure,
                            hint: "Churchill Godana",
                            icon: Icons.directions,
                            controller: streetController,
                            onChanged: (value) {
                              setState(() {
                                streetController.text = value;
                              });
                            },
                          ),
                          if (streetMessage.isNotEmpty)
                            ErrorMessage(message: streetMessage),
                          const SizedBox(
                            height: P2pSizedBox.betweenButtons,
                          ),
                          Textarea(
                            label: "City",
                            isAuthentication: true,
                            isValid: isValidPassword,
                            isPassword: false,
                            setObscure: setObscure,
                            isObscure: isObscure,
                            hint: "Addiss Ababa",
                            icon: Icons.location_city,
                            controller: cityController,
                            onChanged: (value) {
                              setState(() {
                                cityController.text = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    if (cityMessage.isNotEmpty)
                      ErrorMessage(message: cityMessage),
                    const SizedBox(
                      height: P2pSizedBox.betweenbuttonAndText,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: P2pFontSize.screenPadding,
                          vertical: P2pFontSize.screenPadding),
                      child: Button(
                        hint: "Register",
                        onPressed: () {
                          // Navigator.of(context).pushNamed(Login.routeName);
                          validateAndSignin();
                        },
                      ),
                    )
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
    print("message of password ${passwordController.text}");
    setState(() {
      //reset the state without refresh
      passwordMessage = "";
      firstNameMessage = "";
      phoneMessage = "";
      confirmPasswordMessage = '';
      lastNameMessage = "";
      streetMessage = "";
      cityMessage = "";
      emailMessage = "";
      phoneMessage = "";
      isValidPhone = true;
      isValidFirstName = true;
      isValidLastName = true;
      isValidPhoneNumber = true;
      isValidPassword = true;
      isValidConfirmPassword = true;
      isValidStreet = true;
      isValidCity = true;
      isValidEmail = true;
    });
    if (firstNameController.text.isEmpty) {
      isValidPhone = false;
      firstNameMessage = "Firstname is required";
    }

    //VALIDATE PHONE
    // bool validateNumbers(String inputString) {
    //   final pattern = r'^[0-9]+$';
    //   final regExp = RegExp(pattern);
    //   print(regExp.hasMatch(inputString));
    //   return regExp.hasMatch(inputString);
    // }

    if (phoneNumberNameController.text.isEmpty ||
        phoneNumberNameController.text.length > 13 ||
        phoneNumberNameController.text.trim().length < 9) {
      isValidPhoneNumber = false;
      phoneMessage = "please enter a valid phone number";
    }
    if (lastNameController.text.isEmpty) {
      isValidPhone = false;
      lastNameMessage = "Lastname is required";
    }
    var message = Utilities.validatePassword(passwordController.text);
    if (message != null) {
      setState(() {
        isValidPassword = false;
        passwordMessage = message;
      });
    }
    if (confirmPasswordController.text.isEmpty) {
      isValidConfirmPassword = false;
      confirmPasswordMessage = "please enter password again";
    }
    if (confirmPasswordController.text != passwordController.text) {
      isValidConfirmPassword = false;
      confirmPasswordMessage = "password didn't match";
    }
    if (streetController.text.isEmpty) {
      isValidStreet = false;
      streetMessage = "Address street is required";
    }
    if (cityController.text.isEmpty) {
      isValidCity = false;
      cityMessage = "Address city is required";
    }
    if (emailController.text.isEmpty) {
      setState(() {
        emailMessage = "Enter email";
        isValidEmail = false;
      });
    } else if (!Utilities.validateEmail(emailController.text)) {
      setState(() {
        emailMessage = "Invalid email";
        isValidEmail = false;
      });
    }
    isValidPassword &&
            isValidConfirmPassword &&
            isValidPhone &&
            isValidEmail &&
            isValidCity &&
            isValidStreet &&
            isValidFirstName &&
            isValidLastName &&
            isValidPhoneNumber
        ? register()
        : "";
  }

  void register() {
    setState(() {
      isLoading = true;
    });
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final authService = AuthService();
    Map<String, dynamic> requestData = {
      "firstName": firstNameController.text,
      "lastName": lastNameController.text,
      "userName": "0" + phoneNumberNameController.text
          .trim()
          .substring(phoneNumberNameController.text.length - 9),
      "userPassword": passwordController.text,
      "email": emailController.text,
      "address": {
        "street": streetController.text,
        "city": cityController.text,
      },
    };
    authService.registerUser(requestData).then((user) {
      userProvider.setUser(user);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.green,
            content: const Text('User created successfully'),
            action: SnackBarAction(
              label: 'Login',
              textColor: P2pAppColors.white,
              onPressed: () {},
            )),
      );
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushNamed(Login.routeName);
    }).catchError((error) {
      print("Error object received: $error");

      String errorMessage =
          "Failed to create user. Unexpected error."; // Default error message

      if (error is Exception) {
        String errorString = error.toString();

        // Extract the content inside [] or {} (symbols might vary)
        RegExp regExp = RegExp(r"[\[{](.*?)[\]}]");
        Iterable<Match> matches = regExp.allMatches(errorString);

        if (matches.isNotEmpty) {
          String? errorContent = matches.first.group(1);

          // Split the content using : and get the key-value pairs
          List<String> keyValuePairs = errorContent!.split(',');

          // Map specific error keys to custom messages
          Map<String, String> customErrorMessages = {
            'Password': 'Password should be at least 6 and max 20 characters',
            // Add more keys and messages as needed
          };

          for (String pair in keyValuePairs) {
            List<String> keyValue = pair.split(':');
            if (keyValue.length == 2) {
              String key =
                  keyValue[0].trim().replaceAll('"', ''); // Remove quotes
              String value =
                  keyValue[1].trim().replaceAll('"', ''); // Remove quotes

              // Check if the key has a custom error message
              if (customErrorMessages.containsKey(key)) {
                errorMessage = customErrorMessages[key]!;
                break; // Stop after finding a custom message
              } else {
                // Use the original key and value if no custom message is available
                errorMessage = "$key: $value";
              }
            }
          }
        }
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
