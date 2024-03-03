import 'package:flutter/material.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/appStyles/app_fontsize.dart';
import 'package:p2p/appStyles/fontsfamiliy.dart';
import 'package:p2p/components/order_detail_topbar.dart';
import 'package:p2p/models/order.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;
  const OrderDetailScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    bool? _isBrittle = false;
    bool? _isFlammable = false;
    bool? _isSensitive = false;
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderDetailTopBar(
              VehicleType: order.vehicleType,
              orderId: order.id,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pickup Location:",
                    style: TextStyle(
                        color: Colors.black54,
                        fontFamily:
                            P2pAppFontsFamily.descriptionTexts.fontFamily),
                  ),
                  Text(
                    "${order.pickupPoint!.street}",
                    style: TextStyle(
                      color: Colors.black,
                      // fontFamily: P2pAppFontsFamily.descriptionTexts.fontFamily,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Dropoff Location:",
                    style: TextStyle(
                        color: Colors.black54,
                        fontFamily:
                            P2pAppFontsFamily.descriptionTexts.fontFamily),
                  ),
                  Text(
                    "${order.destinationPoint!.street}",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily:
                            P2pAppFontsFamily.descriptionTexts.fontFamily),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Icon(
                          Icons.person_3_sharp,
                          size: 50,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Receiver Name:",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: P2pAppFontsFamily
                                      .descriptionTexts.fontFamily),
                            ),
                            Container(
                              child: Text(
                                "${order.receiverName}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: P2pAppFontsFamily
                                        .descriptionTexts.fontFamily),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Icon(
                          Icons.phone,
                          size: 50,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Receiver Phone:",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: P2pAppFontsFamily
                                      .descriptionTexts.fontFamily),
                            ),
                            Container(
                              child: Text(
                                "${order!.receiverPhoneNumber}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: P2pAppFontsFamily
                                        .descriptionTexts.fontFamily),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(height: 8),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Delivery Charges",
                            style: TextStyle(
                                color: Colors.black54,
                                fontFamily: P2pAppFontsFamily
                                    .descriptionTexts.fontFamily),
                          ),
                          Container(
                            child: Text(
                              // "${order.receiverName}",
                              "0.0",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: P2pAppFontsFamily
                                      .descriptionTexts.fontFamily),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Text and Service Charges",
                            style: TextStyle(
                                color: Colors.black54,
                                fontFamily: P2pAppFontsFamily
                                    .descriptionTexts.fontFamily),
                          ),
                          Container(
                            child: Text(
                              // "${order.receiverName}",
                              '0.0',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: P2pAppFontsFamily
                                      .descriptionTexts.fontFamily),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Package Total",
                            style: TextStyle(
                                color: Colors.black54,
                                fontFamily: P2pAppFontsFamily
                                    .descriptionTexts.fontFamily),
                          ),
                          Container(
                            child: Text(
                              // "${order.receiverName}",
                              '0.0',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: P2pAppFontsFamily
                                      .descriptionTexts.fontFamily),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(height: 1),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Package Details',
                    style: TextStyle(
                        fontSize: P2pFontSize.p2p18,
                        fontFamily:
                            P2pAppFontsFamily.descriptionTexts.fontFamily),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: order.deliveryItem.length,
                    itemBuilder: (context, index) => Card(
                      child: Container(
                        margin: EdgeInsets.only(top: 20.0),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Text(
                                    '${order.deliveryItem[index].name}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: P2pAppColors.black,
                                        fontSize: P2pFontSize.p2p14,
                                        fontFamily: P2pAppFontsFamily
                                            .descriptionTexts.fontFamily),
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            Text(
                              'Size',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text('${order.deliveryItem[index].size}'),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Package Description',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text('${order!.deliveryItem[index].description}'),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'About the Item',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Is Flammable'),
                                order.deliveryItem[index].isFlammable == true
                                    ? Center(
                                        child: Center(child: Text('Yes')),
                                      )
                                    : Center(child: Text('No')),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Is Brittle'),
                                order.deliveryItem[index].isBrittle == true
                                    ? Center(child: Center(child: Text('Yes')))
                                    : Center(child: Text('No')),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Is Sensitive'),
                                order.deliveryItem[index].isSensitive == true
                                    ? Center(child: Text('Yes'))
                                    : Center(child: Text('No')),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Remark',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text('${order!.deliveryItem[index].remark}'),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
