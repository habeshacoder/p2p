import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/appStyles/app_fontsize.dart';
import 'package:p2p/appStyles/sized_boxes.dart';
import 'package:p2p/components/item_component.dart';
import 'package:p2p/components/vehicle_component.dart';
import 'package:p2p/models/item.dart';
import 'package:p2p/models/order.dart';
import 'package:p2p/providers/items_provider.dart';
import 'package:p2p/screens/user/add_item_screen.dart';
import 'package:p2p/screens/user/map_screen.dart';
import 'package:p2p/screens/user/user_home.dart';
import 'package:p2p/service/order_service.dart';
import 'package:p2p/utilities/utilities.dart';
import 'package:p2p/widgets/button.dart';
import 'package:p2p/widgets/text_area.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:p2p/widgets/top_bar.dart";

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});
  static const routeName = '/orderScreen';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool isGetMeRunning = false;

  bool isFirstTime = true;
  String? pickUpLocationLatLang;
  String? dropoffLocationLatLang;

  bool isSendingRequest = false;
  late TextEditingController fullNameController;
  late TextEditingController phoneNumberController = TextEditingController();
  late TextEditingController pickupLocationController = TextEditingController();
  late TextEditingController dropoffLocationController =
      TextEditingController();
  late TextEditingController descriptionController = TextEditingController();
  late TextEditingController pickUpDateController = TextEditingController();
  late TextEditingController dropoffDateController = TextEditingController();
  String? vehicleType;
  List<Map<String, dynamic>>? loadedVehicleTypes;
  String selectedvehicleType = "BIKE";
  int selectedIndex = 0;
  List<Map<String, dynamic>> vehicles = [];
  DateTime dt = DateTime.now();
  String? pickUpDate;
  String? pickupTime;
  int items = 0;
  // List<Item> items = [];
  @override
  void initState() {
    super.initState();
    Provider.of<ItemsProvider>(context, listen: false).removeList();
    fullNameController = TextEditingController();
    phoneNumberController = TextEditingController();
    pickupLocationController = TextEditingController();
    dropoffLocationController = TextEditingController();
    descriptionController = TextEditingController();
    pickUpDateController = TextEditingController();
    String formattedDate =
        DateFormat('dd MMMM yyyy HH:mm').format(DateTime.now());

    pickUpDateController.text = formattedDate;
    dropoffDateController.text = formattedDate;
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    pickupLocationController.dispose();
    dropoffLocationController.dispose();
    descriptionController.dispose();
    pickUpDateController.dispose();

    super.dispose();
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: P2pAppColors.grey,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: TopBar(title: "order")),
                    const SizedBox(
                      height: 30,
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Request A Delivery",
                        style: TextStyle(
                            color: P2pAppColors.black,
                            fontSize: P2pFontSize.p2p23,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: P2pSizedBox.betweenbuttonAndText,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: AutoSizeText(
                          textAlign: TextAlign.center,
                          "Fill the form to request your order.",
                          style: TextStyle(
                              fontSize: P2pFontSize.p2p18,
                              color: P2pAppColors.normal)),
                    ),
                    const SizedBox(
                      height: P2pFontSize.p2p17,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(right: 15, left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Textarea(
                                title: "Receiver Full Name :",
                                hint: "Enter Full Name",
                                isValid: true,
                                isObscure: false,
                                isPassword: false,
                                icon: Icons.person,
                                onChanged: (value) => {},
                                controller: fullNameController,
                                isAuthentication: false),
                            const SizedBox(
                              height: P2pSizedBox.betweenOrderInputs,
                            ),
                            Textarea(
                              isPhone: true,
                              title: "Receiver Phone Number :",
                              hint: "Phone Number",
                              isValid: true,
                              isObscure: false,
                              isPassword: false,
                              icon: Icons.call,
                              onChanged: (value) => {},
                              controller: fullNameController,
                              isAuthentication: false,
                              setPhoneNumber: setPhoneNumber,
                            ),
                            const SizedBox(
                              height: P2pSizedBox.betweenOrderInputs,
                            ),
                            Text(
                              "Pickup Location",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: P2pFontSize.p2p11,
                                color: P2pAppColors.black,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Stack(
                              children: [
                                TextField(
                                  controller: pickupLocationController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 50.0, vertical: 15),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    prefixIcon: Icon(Icons.location_on),
                                    labelText: 'Enter Pickup Location',
                                  ),
                                ),
                                Positioned.fill(
                                  child: GestureDetector(
                                    onTap: getPickUpLocation,
                                    behavior: HitTestBehavior.translucent,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: P2pSizedBox.betweenOrderInputs,
                            ),
                            Text(
                              "Dropoff Location",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: P2pFontSize.p2p11,
                                color: P2pAppColors.black,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Stack(
                              children: [
                                TextField(
                                  controller: dropoffLocationController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 50.0, vertical: 15),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    prefixIcon: Icon(Icons.location_on),
                                    labelText: 'Enter Dropoff Location',
                                  ),
                                ),
                                Positioned.fill(
                                  child: GestureDetector(
                                    onTap: getDropoffLocation,
                                    behavior: HitTestBehavior.translucent,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: P2pSizedBox.betweenOrderInputs,
                            ),
                            Textarea(
                                context: context,
                                setDateTime: showPickUpDate,
                                title: "Pick Up Date",
                                hint: "DD/MM/YYYY",
                                isValid: true,
                                isObscure: false,
                                isPassword: false,
                                isDate: true,
                                icon: Icons.date_range_outlined,
                                onChanged: (value) => {},
                                controller: pickUpDateController,
                                isAuthentication: true),
                            const SizedBox(
                              height: P2pSizedBox.betweenOrderInputs,
                            ),
                            Textarea(
                                context: context,
                                setDateTime: showDropOffDate,
                                title: "Drop of Date",
                                hint: "DD/MM/YYYY",
                                isValid: true,
                                isObscure: false,
                                isPassword: false,
                                isDate: true,
                                icon: Icons.date_range_outlined,
                                onChanged: (value) => {},
                                controller: dropoffDateController,
                                isAuthentication: true),

                            // const SizedBox(height: P2pSizedBox.betweenOrderInputs),
                            const SizedBox(
                              height: P2pSizedBox.betweenOrderInputs,
                            ),
                            const Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Vehicle type :",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: P2pFontSize.p2p11,
                                  color: P2pAppColors.black,
                                ),
                              ),
                            ),
                            FutureBuilder<List<Map<String, dynamic>>>(
                              future: loadVehicles(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return const Center(
                                      child: Text('Error loading data'));
                                } else if (!snapshot.hasData) {
                                  return const Center(
                                      child: Text('No data available'));
                                } else {
                                  List<Map<String, dynamic>> vehicles =
                                      snapshot.data!;
                                  loadedVehicleTypes = vehicles;
                                  print("vaycles---------: $vehicles");

                                  return SizedBox(
                                    height: 130,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: vehicles.length,
                                      itemBuilder: (context, index) {
                                        var vehicle = vehicles[index];
                                        return VehicleType(
                                            vehicleImage:
                                                vehicle["vehicle_image"],
                                            selectedIndex: selectedIndex,
                                            index: index,
                                            setSelectedIndex: setSelectedIndex,
                                            vehicleType:
                                                vehicle["vehicle_name"]);
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(
                              height: P2pSizedBox.betweenOrderInputs,
                            ),

                            const SizedBox(
                                height: P2pSizedBox.betweenOrderInputs),

                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddItemScreen(
                                            addItemCallback: addItemCallback,
                                          )),
                                );
                                // Navigator.of(context).push(MyForm());
                              },
                              icon: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'Add Package to Deliver',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Icon(Icons.add),
                                  Container(
                                    width: 45.0,
                                    height: 45.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 30.0,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4.0,
                                  ), // Space between the icon and text
                                ],
                              ),
                            ),
                            Consumer<ItemsProvider>(
                              builder: (context, addeditmes, _) {
                                return SizedBox(
                                  height: addeditmes.items.isEmpty ? 50 : 130,
                                  child: addeditmes.items.isEmpty
                                      ? Center(
                                          child: Container(
                                            margin: EdgeInsets.all(8.0),
                                            child: Text('No items added.'),
                                          ),
                                        )
                                      : ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: addeditmes.items.length,
                                          itemBuilder: (context, index) {
                                            return ItemComponent(
                                              removeItemCallback:
                                                  removeItemCallback,
                                              size:
                                                  addeditmes.items[index].size,
                                              itemName:
                                                  addeditmes.items[index].name,
                                              index: index,
                                              isFromAddOrder: true,
                                              measurement: addeditmes
                                                  .items[index].sizeMeasurement,
                                            );
                                          },
                                        ),
                                );
                              },
                            ),
                            Consumer<ItemsProvider>(
                              builder: (context, addeditmes, _) {
                                if (addeditmes.items.length == 0)
                                  return Button(
                                    hint: "Send Request",
                                    onPressed: null,
                                  );
                                else if (addeditmes.items.length > 0)
                                  return Button(
                                    hint: "Send Request",
                                    onPressed: sendRequest,
                                  );
                                else
                                  return Button(
                                    hint: "Send Request",
                                    onPressed: sendRequest,
                                  );
                              },
                            ),

// return Text('data');
                            SizedBox(
                              height: 2,
                            ),
                          ],
                        ))
                  ]),
              if (isSendingRequest)
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.5,
                  left: MediaQuery.of(context).size.width * 0.5,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        P2pAppColors.yellow), // Set the desired color here
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getPickUpLocation() async {
    final pickedData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );
    print('data---------------getpuloc:${pickedData["latLang"]}');
    setState(() {
      pickupLocationController.text = pickedData["street"];
      pickUpLocationLatLang = pickedData["latLang"].toString();
    });
  }

  Future<void> getDropoffLocation() async {
    final dropoffData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );
    print('data---------------getdofloc:${dropoffData["latLang"]}');

    setState(() {
      dropoffLocationController.text = dropoffData["street"];
      dropoffLocationLatLang = dropoffData["latLang"].toString();
    });
  }

  Future<List<Map<String, dynamic>>> loadVehicles() async {
    String data = await rootBundle.loadString('lib/data/vehicles.json');
    List<dynamic> jsonList = json.decode(data);
    return jsonList.cast<Map<String, dynamic>>();
  }

  void setPhoneNumber(String value) {
    setState(() {
      phoneNumberController.text = value;
    });
  }

  void setSelectedIndex(index) {
    selectedvehicleType = loadedVehicleTypes![index]["vehicle_name"];
    setState(() {
      selectedIndex = index;
    });
  }

//date picke for pick up date
  Future<Function?> showPickUpDate(
    BuildContext context,
  ) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2029),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );

      if (selectedTime != null) {
        DateTime selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        setState(() {
          String formattedDate =
              DateFormat('dd MMMM yyyy HH:mm').format(selectedDateTime);

          pickUpDateController.text = formattedDate;

          // pickupLocationController.text = selectedDateTime.toString();
        });
        print('Selected Date and Time: $selectedDateTime');
        // Do something with the selected date and time (selectedDateTime)
      }
    }
  }

  //drop of date controller
  Future<Function?> showDropOffDate(BuildContext context,
      [bool isPickup = false]) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2029),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );

      if (selectedTime != null) {
        DateTime selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        setState(() {
          String formattedDate =
              DateFormat('dd MMMM yyyy HH:mm').format(selectedDateTime);

          dropoffDateController.text = formattedDate;

          // pickupLocationController.text = selectedDateTime.toString();
        });
        print('Selected Date and Time: $selectedDateTime');
        // Do something with the selected date and time (selectedDateTime)
      }
    }
  }

//add item
  void addItemCallback(Item newItem) {
    Provider.of<ItemsProvider>(context, listen: false).addItem(newItem);
  }

//
// remove item
  void removeItemCallback(int index) {
    Provider.of<ItemsProvider>(context, listen: false).removeItem(index);
  }

  void sendRequest() async {
    //

    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      if (pickUpDateController.text.isEmpty) {
        throw Exception('Fill the form correctlly');
      }
      if (dropoffDateController.text.isEmpty) {
        throw Exception('Fill the form correctlly');
      }
      if (phoneNumberController.text.isEmpty) {
        throw Exception('Fill the form correctlly');
      }
      if (pickupLocationController.text!.isEmpty) {
        throw Exception('Fill the form correctlly');
      }
      if (dropoffLocationController.text.isEmpty) {
        throw Exception('Fill the form correctlly');
      }
      if (fullNameController.text.isEmpty) {
        throw Exception('Fill the form correctlly');
      }
      if (selectedvehicleType.isEmpty) {
        throw Exception('Fill the form correctlly');
      }
      setState(() {
        isSendingRequest = true;
      });
      print(isSendingRequest);
      final deliveryItem =
          Provider.of<ItemsProvider>(context, listen: false).items;
      final pid = await prefs.getString('pid');
      final util = Utilities();
      final pickuppointt = await util.reverseGeocode(
          pickUpLocationLatLang, pickupLocationController.text);
      final dropoffponitt = await util.reverseGeocode(
          dropoffLocationLatLang, dropoffLocationController.text);

      Order orderData = Order(
        id: null,
        userId: null,
        OrderedBy: null,
        orderedDate: null,
        deliveryItem: deliveryItem,
        quotedPrice: null,
        finalPrice: null,
        isPayed: null,
        pickupPoint: pickuppointt,
        pickupDate:
            DateFormat('dd MMMM yyyy HH:mm').parse(pickUpDateController.text) ??
                null,
        destinationPoint: dropoffponitt,
        destinationDate: DateFormat('dd MMMM yyyy HH:mm')
                .parse(dropoffDateController.text) ??
            null,
        transportationRequirement: null,
        vehicleType: selectedvehicleType,
        receiverName: fullNameController.text,
        deliveryStatus: null,
        receiverPhoneNumber: "0" +
            phoneNumberController.text
                .substring(phoneNumberController.text.length - 9),
        remark: null,
        deliveryProgressId: null,
        createdOn: null,
      );

      //
      print('after order object${orderData.pickupPoint!.street}');
      print('after order object${orderData!.destinationPoint!.street}');
      int statusCode = await Provider.of<OrderService>(context, listen: false)
          .sendOrder(orderData);
      print('Status Code: $statusCode');

      if (statusCode == 200 || statusCode == 201) {
        // Navigator.of(context).pushNamed(MyOrderScreen.routeName);
        // onPressed: () => ))),
        Provider.of<ItemsProvider>(context, listen: false).removeList();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => User_Home(
                toIndex: 2,
              ),
            ));
      }
      setState(() {
        isSendingRequest = false;
      });
    } catch (error) {
      setState(() {
        isSendingRequest = false;
      });
      print('Error: $error');
      showalert(error.toString());
    }
  }
}
