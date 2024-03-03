import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/appStyles/app_fontsize.dart';
import 'package:p2p/appStyles/fontsfamiliy.dart';
import 'package:p2p/appStyles/sized_boxes.dart';
import 'package:p2p/models/order.dart';
import 'package:p2p/models/user_model.dart';
import 'package:p2p/service/order_service.dart';
import 'package:p2p/widgets/button.dart';
import 'package:p2p/widgets/top_bar.dart';
import 'package:provider/provider.dart';
import 'package:string_capitalize/string_capitalize.dart';

class HistoryScreen extends StatefulWidget {
  static const routeName = '/HistoryScreen';

  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Order>> orders;
  String _nearByDistanceValue = '10km';
  Future<void> _refreshOrders() async {
    setState(() {
      orders = Provider.of<OrderService>(context, listen: false).fetchMyOrder();
    });
  }

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

  @override
  void didChangeDependencies() {
    print('get mu order ...........');

    orders = Provider.of<OrderService>(context, listen: false).fetchMyOrder();
    super.didChangeDependencies();
    print("after orders fetched............");
  }

  //dropdown for measurments
  List<DropdownMenuItem<String>> _nearByDistanceDropDowns() {
    List<String> nearByDistnances = ['10km', '20km', '13km'];
    return nearByDistnances!.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // String fullName = "${currentUser!.firstName} ${currentUser.lastName}";
    return SafeArea(
      child: Scaffold(
        backgroundColor: P2pAppColors.grey,
        body: RefreshIndicator(
          onRefresh: _refreshOrders,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 2),
                    child: TopBar(title: "History")),

                // padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'List of Orders',
                        style: TextStyle(
                            fontFamily:
                                P2pAppFontsFamily.descriptionTexts.fontFamily,
                            fontSize: P2pFontSize.p2p18),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: TextField(
                          // controller: dropoffLocationController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 4),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            labelText: 'search order here...',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: FutureBuilder(
                    future: orders,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        print('has data');
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            print(
                                "pickl:${snapshot.data![index].pickupPoint!.street}");
                            print(
                                "pickup date:${snapshot.data![index].pickupDate}");
                            print(
                                "dropl:${snapshot.data![index].destinationPoint!.street}");
                            //pick up country
                            String? pickupAddress =
                                snapshot.data![index].pickupPoint!.country;
                            List<String> addressParts = pickupAddress!
                                .split(','); // Split the address by commas
                            String PickupCountry = addressParts.last.trim();
                            //dropoff  country
                            String? dropoffAddress =
                                snapshot.data![index].destinationPoint!.country;
                            List<String> addressPartss = dropoffAddress!
                                .split(','); // Split the address by commas
                            String dropoffCountry = addressPartss.last.trim();
                            print(snapshot.data![index].createdOn);
                            // final DateTime dateTime =
                            //     DateTime.parse(orderDateTime);

                            // Define the desired date and time format
                            final DateFormat dateFormat =
                                DateFormat('dd/MM/yy');
                            final DateFormat timeFormat = DateFormat('HH:mm a');

                            // Format the date and time
                            final String formattedDate = dateFormat
                                .format(snapshot.data![index].createdOn!);
                            final String formattedTime = timeFormat
                                .format(snapshot.data![index].createdOn!);
                            return Card(
                              child: ListTile(
                                title: Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (snapshot
                                          .data![index].deliveryItem.isEmpty)
                                        Text(
                                          'No Items Added',
                                          style: TextStyle(
                                            fontFamily: P2pAppFontsFamily
                                                .descriptionTexts.fontFamily,
                                            fontSize: 14,
                                          ),
                                        ),
                                      if (snapshot
                                          .data![index].deliveryItem.isNotEmpty)
                                        Row(
                                          children: [
                                            Container(
                                              height: 20,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .57,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: snapshot.data![index]
                                                    .deliveryItem.length,
                                                itemBuilder: (context,
                                                    deliveryItemsIndex) {
                                                  final itemName = snapshot
                                                      .data![index]
                                                      .deliveryItem[
                                                          deliveryItemsIndex]
                                                      .name;

                                                  final isLastItem =
                                                      deliveryItemsIndex ==
                                                          snapshot
                                                                  .data![index]
                                                                  .deliveryItem
                                                                  .length -
                                                              1;

                                                  final formattedName =
                                                      '${itemName}${isLastItem ? "" : ", "}';

                                                  return Text(
                                                    formattedName.capitalize(),
                                                    style: TextStyle(
                                                      fontFamily:
                                                          P2pAppFontsFamily
                                                              .descriptionTexts
                                                              .fontFamily,
                                                      fontSize: 18,
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      Container(
                                          padding: EdgeInsets.only(
                                              left: 4,
                                              top: 4,
                                              bottom: 4,
                                              right: 2),
                                          decoration: BoxDecoration(
                                              color: P2pAppColors.yellow,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Text(
                                            "picked",
                                            style: TextStyle(
                                                fontFamily: P2pAppFontsFamily
                                                    .descriptionTexts
                                                    .fontFamily),
                                          )),
                                    ],
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            // color: P2pAppColors.,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Text(
                                          '${formattedDate}',
                                          style: TextStyle(
                                              fontFamily: P2pAppFontsFamily
                                                  .descriptionTexts.fontFamily),
                                        )),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on_outlined),
                                        Text(
                                          'Pickup Location: ',
                                          style: TextStyle(
                                              fontFamily: P2pAppFontsFamily
                                                  .descriptionTexts.fontFamily),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${snapshot.data![index].pickupPoint!.street.toString()}, " +
                                                "$PickupCountry",
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontFamily: P2pAppFontsFamily
                                                    .descriptionTexts
                                                    .fontFamily),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on_outlined),
                                        Text(
                                          'Dropoff Location: ',
                                          style: TextStyle(
                                              fontFamily: P2pAppFontsFamily
                                                  .descriptionTexts.fontFamily),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${snapshot.data![index].destinationPoint!.street.toString()}, " +
                                                "$dropoffCountry",
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontFamily: P2pAppFontsFamily
                                                    .descriptionTexts
                                                    .fontFamily),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: P2pSizedBox.betweenbuttonAndText,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Text(
                          'No Order available',
                          style: TextStyle(
                              fontFamily: P2pAppFontsFamily
                                  .descriptionTexts.fontFamily),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void deleteOrder(int? orderId) async {
    print('delete...............................');
    try {
      final statusCode = await Provider.of<OrderService>(context, listen: false)
          .deleteOrder(orderId);
      if (statusCode == 204 || statusCode == 202) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Order item deleted successfully',
              style: TextStyle(color: P2pAppColors.yellow),
            ),
          ),
        );
        await _refreshOrders();

        //
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'failed to delete order',
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
        return;
      }
    } catch (error) {
      // showalert(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'failed to delete order',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
      return;
    }
  }
}
