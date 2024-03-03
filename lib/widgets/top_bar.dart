import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/appStyles/app_fontsize.dart';
import 'package:p2p/models/user_model.dart';
import 'package:p2p/screens/user/profile_screen.dart';
import 'package:p2p/service/authentication_service.dart';
import 'package:p2p/service/profile_service.dart';
import 'package:p2p/utilities/utilities.dart';
import 'package:provider/provider.dart';

class TopBar extends StatefulWidget {
  TopBar({super.key, this.fullname, this.imageUrl, required this.title});
  String? imageUrl;
  String? fullname;
  String? title;

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  bool isGetMeRunning = false;
  late Future<User> user;
  String fName = "";
  String lName = "";
  @override
  void didChangeDependencies() {
    print('get user info  didchangedepcey ...........');

    user = Provider.of<ProfileService>(context, listen: false).getUser();
    super.didChangeDependencies();
    isGetMeRunning = false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: widget.title == 'Nearby Orders' ||
                  widget.title == 'All Orders' ||
                  widget.title == 'AGENT APPROVAL'
              ? InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: P2pAppColors.normal,
                    size: 31,
                  ),
                )
              : Icon(
                  Icons.notifications,
                  color: P2pAppColors.normal,
                  size: 31,
                ),
        ),
        if (widget.title == "home")
          Flexible(
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'H',
                    style: TextStyle(
                      color: P2pAppColors.black,
                      fontSize: P2pFontSize.p2p35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'O',
                    style: TextStyle(
                      color: P2pAppColors.yellow,
                      fontSize: P2pFontSize.p2p35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'ME',
                    style: TextStyle(
                      color: P2pAppColors.black,
                      fontSize: P2pFontSize.p2p35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (widget.title == "order")
          const Flexible(
            child: AutoSizeText.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'O',
                    style: TextStyle(
                      color: P2pAppColors.yellow,
                      fontSize: P2pFontSize.p2p35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'RDER',
                    style: TextStyle(
                      color: P2pAppColors.black,
                      fontSize: P2pFontSize.p2p35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        if (widget.title == "myOrder")
          Flexible(
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'My ',
                    style: TextStyle(
                      color: P2pAppColors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'R',
                    style: TextStyle(
                      color: P2pAppColors.yellow,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'equests',
                    style: TextStyle(
                      color: P2pAppColors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (widget.title == "Nearby Orders")
          Flexible(
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Nearby ',
                    style: TextStyle(
                      color: P2pAppColors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'o',
                    style: TextStyle(
                      color: P2pAppColors.yellow,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'rders',
                    style: TextStyle(
                      color: P2pAppColors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (widget.title == "All Orders")
          Flexible(
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: '',
                    style: TextStyle(
                      color: P2pAppColors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'O',
                    style: TextStyle(
                      color: P2pAppColors.yellow,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'rders',
                    style: TextStyle(
                      color: P2pAppColors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (widget.title == "History")
          Flexible(
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Hist',
                    style: TextStyle(
                      color: P2pAppColors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'O',
                    style: TextStyle(
                      color: P2pAppColors.yellow,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'ry',
                    style: TextStyle(
                      color: P2pAppColors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        Flexible(
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: FutureBuilder(
                    future: user,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        CircularProgressIndicator();
                      }
                      if (snapshot.hasData) {
                        return Container(
                          width: 40,
                          height: 40,
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
                        );
                      }
                      return Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                        child: Center(
                          child: Text('N/A',
                              style: TextStyle(
                                fontSize: P2pFontSize.p2p14,
                                overflow: TextOverflow.ellipsis,
                              )),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 8, // Add spacing between the avatar and text
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hi',
                          style: TextStyle(
                              fontSize: P2pFontSize.p2p14,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        // Wrap the text in a container to limit its width
                        width: double
                            .infinity, // Constrain the width to the maximum available

                        child: FutureBuilder(
                          future: user,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              CircularProgressIndicator();
                            }
                            if (snapshot.hasData) {
                              return Text(snapshot.data!.firstName.toString(),
                                  style: TextStyle(
                                    fontSize: P2pFontSize.p2p14,
                                    overflow: TextOverflow.ellipsis,
                                  ));
                            }
                            return Text('User',
                                style: TextStyle(
                                  fontSize: P2pFontSize.p2p14,
                                  overflow: TextOverflow.ellipsis,
                                ));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
