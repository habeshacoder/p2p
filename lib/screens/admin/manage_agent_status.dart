import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/appStyles/app_fontsize.dart';
import 'package:p2p/appStyles/fontsfamiliy.dart';
import 'package:p2p/screens/admin/allwidget.dart';
import 'package:p2p/screens/admin/approvedwidget.dart';
import 'package:p2p/screens/admin/pendingwidget.dart';
import 'package:p2p/screens/admin/rejectedwidget.dart';

class ManageAgentStatus extends StatefulWidget {
  static const routeName = '/manageagentstatus';

  const ManageAgentStatus({super.key});

  @override
  State<ManageAgentStatus> createState() => _ManageAgentStatusScreenState();
}

class _ManageAgentStatusScreenState extends State<ManageAgentStatus> {
  int selectedTopicIndex = 0;

  void showalert(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('an error occured'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('okay'),
            )
          ],
        );
      },
    );
  }

  List<Widget> topBarList = [
    Approved(),
    Rejected(),
    Pending(),
    All(),
  ];
  List<Widget> bodyList = [
    AllWidget(),
    ApprovedWidget(),
    PendingWidget(),
    RejectedWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor:
            Colors.transparent, // Set the status bar color to transparent
      ),
    );
    // String fullName = "${currentUser!.firstName} ${currentUser.lastName}";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: P2pAppColors.yellow,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: P2pAppColors.normal,
            size: 31,
          ),
        ),
        title: Text(
          'AGENT APPROVAL',
          style: TextStyle(
              fontFamily: P2pAppFontsFamily.descriptionTexts.fontFamily,
              fontSize: P2pFontSize.p2p18),
        ),
      ),
      backgroundColor: P2pAppColors.grey,
      body: SingleChildScrollView(
        child: Container(
          // padding: EdgeInsets.only(top: 30),
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    height: 50,
                    color: P2pAppColors.yellow,
                    child: ListView.builder(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: topBarList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          setState(() {
                            selectedTopicIndex = index;
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 85,
                          color: selectedTopicIndex == index
                              ? P2pAppColors.white
                              : null,
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: topBarList[index],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              bodyList[selectedTopicIndex],
            ],
          ),
        ),
      ),
    );
  }
}

class All extends StatelessWidget {
  const All({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Icon(Icons.list), Text('All')],
    );
  }
}

class Approved extends StatelessWidget {
  const Approved({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Icon(Icons.verified_user), Text('Approved')],
    );
  }
}

class Pending extends StatelessWidget {
  const Pending({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Icon(Icons.pending_actions), Text('Pending')],
    );
  }
}

class Rejected extends StatelessWidget {
  const Rejected({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(Icons.person), // The first icon
            Positioned(
              top: 0,
              left: 5,
              child: Icon(
                Icons.close,
                size: 30,
              ), // The close icon positioned at the top right corner
            ),
          ],
        ),
        Text('Rejected')
      ],
    );
  }
}
