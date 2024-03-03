// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/appStyles/app_fontsize.dart';
import 'package:p2p/appStyles/fontsfamiliy.dart';
import 'package:p2p/models/areaofcoverage.dart';
import 'package:p2p/models/user_model.dart';
import 'package:p2p/screens/authentication/signup_or_login_screen.dart';
import 'package:p2p/screens/user/agent_request_screen.dart';
import 'package:p2p/screens/user/history.dart';
import 'package:p2p/service/agent_service.dart';
import 'package:p2p/service/authentication_service.dart';
import 'package:p2p/service/profile_service.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var init = true;

  late Future<User> userData;
  @override
  void didChangeDependencies() {
    if (init) {
      userData = Provider.of<ProfileService>(context, listen: false).getUser();
      Provider.of<AgentService>(context, listen: false).getAreaOfCoverage();
    }
    init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBarWithBackArrow(),
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.only(top: 35),
              decoration: BoxDecoration(color: P2pAppColors.orange),
              height: 230,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Text(
                        'MY PROFILE',
                        style: TextStyle(
                            fontSize: P2pFontSize.p2p35,
                            fontFamily:
                                P2pAppFontsFamily.descriptionTexts.fontFamily),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          // Add your action logic here
                        },
                      ),
                    ],
                  ),
                  FutureBuilder(
                    future: userData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                              ),
                              child: Center(
                                child: snapshot.data!.firstName!.isNotEmpty &&
                                        snapshot.data!.firstName!.isNotEmpty
                                    ? Text(
                                        '${snapshot.data!.firstName![0].toUpperCase()}${snapshot.data!.lastName![0].toUpperCase()}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        'N/A', // Provide a fallback value if either fName or lName is empty
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // TextButton(
                                //     onPressed: () {
                                //       Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //             builder: (context) =>
                                //                 HistoryScreen(),
                                //           ));
                                //     },
                                //     child: Text('History')),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AgentRequestScreen(
                                                  profileData: snapshot.data),
                                        ));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Text(
                                      'Become an Agent',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: P2pFontSize.p2p14,
                                          fontFamily: P2pAppFontsFamily
                                              .descriptionTexts.fontFamily),
                                    ),
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Provider.of<AuthService>(context,
                                              listen: false)
                                          .logOut();
                                      Navigator.of(context).popAndPushNamed(
                                          SignupOrLogin.routeName);
                                    },
                                    child: Text('Log Out')),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                            child: Center(
                              child: Text(
                                'N/A', // Provide a fallback value if either fName or lName is empty
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Provider.of<AuthService>(context, listen: false)
                                    .logOut();
                                Navigator.of(context)
                                    .popAndPushNamed(SignupOrLogin.routeName);
                              },
                              child: Text('Log Out')),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 200,
            ),
            FutureBuilder(
              future: userData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // return CircularProgressIndicator();
                }
                if (snapshot.hasData) {
                  return Container(
                    margin: EdgeInsets.only(
                      top: 200,
                      // left: MediaQuery.of(context).size.width * 0.1
                    ),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                child:
                                    PersonalDetails(userData: snapshot.data)),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Account Type',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(''),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Member Since',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(''),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'LOGIN CREDENTIALS',
                                            style: TextStyle(
                                                fontSize: P2pFontSize.p2p14,
                                                fontFamily: P2pAppFontsFamily
                                                    .descriptionTexts
                                                    .fontFamily),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Change',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: P2pAppColors.black,
                                                  fontSize: P2pFontSize.p2p14,
                                                  fontFamily: P2pAppFontsFamily
                                                      .descriptionTexts
                                                      .fontFamily),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'User Name',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text('${snapshot.data!.userName}'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Password',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text('********'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return Text('waiting...');
              },
            )
          ],
        ),
      ),
    );
  }
}

class PersonalDetails extends StatelessWidget {
  final User? userData;
  PersonalDetails({required this.userData});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: EdgeInsets.only(top: 20.0),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PERSONAL DETAILS',
                  style: TextStyle(
                      fontSize: P2pFontSize.p2p14,
                      fontFamily:
                          P2pAppFontsFamily.descriptionTexts.fontFamily),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Edit',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: P2pAppColors.black,
                        fontSize: P2pFontSize.p2p14,
                        fontFamily:
                            P2pAppFontsFamily.descriptionTexts.fontFamily),
                  ),
                ),
              ],
            ),
            Divider(),
            Text(
              'First Name',
              style: TextStyle(color: Colors.grey),
            ),
            Text('${userData!.firstName}'),
            SizedBox(
              height: 10,
            ),
            Text(
              'Last  Name',
              style: TextStyle(color: Colors.grey),
            ),
            Text('${userData!.lastName}'),
            SizedBox(
              height: 10,
            ),
            Text(
              'Email',
              style: TextStyle(color: Colors.grey),
            ),
            Text('${userData!.email}'),
            SizedBox(
              height: 10,
            ),
            Text(
              'Phone Number',
              style: TextStyle(color: Colors.grey),
            ),
            Text('${userData!.userName}'),
            SizedBox(
              height: 10,
            ),
            Text(
              'Address',
              style: TextStyle(color: Colors.grey),
            ),
            Text('${userData!.address!.street}'),
          ],
        ),
      ),
    );
  }
}
