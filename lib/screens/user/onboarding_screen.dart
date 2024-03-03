import 'package:flutter/material.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/appStyles/app_fontsize.dart';
import 'package:p2p/components/onboarding_component.dart';
import 'package:p2p/screens/authentication/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding extends StatefulWidget {
  static String routeName = "/onboarding";

  const Onboarding({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      height: isActive ? 25 : 16,
      width: isActive ? 25 : 18.0,
      decoration: BoxDecoration(
          color: isActive ? P2pAppColors.yellow : Colors.black12,
          shape: BoxShape.circle),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
          child: ListView(
            children: [
              // ignore: sized_box_for_whitespace
              Container(
                height: MediaQuery.of(context).size.height * 0.82,
                child: PageView(
                  physics: const ClampingScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (int page) => setpage(page),
                  children: const <Widget>[
                    OnboardingComponent(
                        title: "Select your vehicle Type",
                        description:
                            "Simply select your desired delivery vehicle between bicycle, motor and a car.",
                        image: "p2p_destination.png"),
                    OnboardingComponent(
                        title: "Pickup and Dropoff Points",
                        description:
                            "Use the map or search to find the Pickup and Dropoff address for your delivery.",
                        image: "p2p_delivery_truck.png"),
                    OnboardingComponent(
                        title: "Track the delivery",
                        description:
                            "Track your personal delivery on the live map and have the exact time of arrival at your convenience.",
                        image: "p2p_Location_tracking.png")
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator(),
                  ),
                  if (_currentPage != 2)
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_currentPage != 2)
                            GestureDetector(
                              onTap: () async {
                                Navigator.pushNamed(
                                    context, "/signup_or_login");
                                // Set the onboarding completion flag
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool(
                                    'isOnboardingCompleted', true);
                              },
                              child: Row(
                                children: [
                                  const Text(
                                    "Skip",
                                    style: TextStyle(
                                        fontSize: P2pFontSize.p2p17,
                                        color: P2pAppColors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 24, // Adjust the icon size as needed
                                    color: P2pAppColors.normal,
                                  ) //)
                                ],
                              ),
                            ),
                          if (_currentPage != 2)
                            GestureDetector(
                              onTap: () => {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                )
                              },
                              child: Row(children: [
                                const Text(
                                  "Next",
                                  style: TextStyle(
                                      fontSize: P2pFontSize.p2p17,
                                      color: P2pAppColors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(Icons.chevron_right,
                                    size: 24, color: P2pAppColors.normal)
                              ]),
                            )
                        ])
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(" "),
                        GestureDetector(
                          onTap: () async {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ));
                            // Set the onboarding completion flag
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setBool('isOnboardingCompleted', true);
                          },
                          child: const Text(
                            "Finish",
                            style: TextStyle(
                                fontSize: P2pFontSize.p2p17,
                                color: P2pAppColors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  setpage(page) {
    setState(() {
      _currentPage = page;
    });
  }
}
