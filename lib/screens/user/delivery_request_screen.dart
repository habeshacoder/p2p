import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/appStyles/app_fontsize.dart';
import 'package:p2p/appStyles/sized_boxes.dart';
import 'package:p2p/models/user_model.dart';
import 'package:p2p/providers/user_provider.dart';
import 'package:p2p/screens/admin/manage_agent_status.dart';
import 'package:p2p/screens/user/order_screen.dart';
import 'package:p2p/screens/user/user_home.dart';
import 'package:p2p/screens/user/myorder.dart';
import 'package:p2p/widgets/button.dart';
import 'package:p2p/widgets/top_bar.dart';
import 'package:provider/provider.dart';

class DeliveryRequest extends StatefulWidget {
  static const routeName = '/deliveryRequest';

  const DeliveryRequest({super.key});

  @override
  State<DeliveryRequest> createState() => _DeliveryRequestState();
}

class _DeliveryRequestState extends State<DeliveryRequest> {
  @override
  Widget build(BuildContext context) {
    final User? currentUser =
        Provider.of<UserProvider>(context, listen: false).user;
    // String fullName = "${currentUser!.firstName} ${currentUser.lastName}";
    return SafeArea(
      child: Scaffold(
        backgroundColor: P2pAppColors.grey,
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: TopBar(title: "home")),
            SizedBox(
              width: double.infinity, // Make the SizedBox as wide as its parent
              child: Image.asset(
                'assets/images/p2p_home.png',
                fit: BoxFit.fill, // Stretch and fill the available width
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Button(
                    hint: "Request A Delivery",
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => User_Home(
                            toIndex: 1,
                          ),
                        )))),
            const SizedBox(
              height: P2pSizedBox.betweenbuttonAndText,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: AutoSizeText(
                  textAlign: TextAlign.justify,
                  "Click here to request a delivery. You will be able to provide pickup and delivery details on the next page.",
                  style: TextStyle(
                      fontSize: P2pFontSize.p2p18, color: P2pAppColors.normal)),
            ),
            const SizedBox(
              height: P2pSizedBox.betweenbuttonAndText,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyOrderScreen(),
                    ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 30),
                    child: AutoSizeText(
                        textAlign: TextAlign.justify,
                        "Visit Your Order",
                        style: TextStyle(
                            fontSize: P2pFontSize.p2p18,
                            decoration: TextDecoration.underline,
                            decorationColor: P2pAppColors.orange,
                            color: P2pAppColors.orange)),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
