//add item
import 'dart:convert';
import 'dart:core';
import 'dart:core';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/appStyles/app_fontsize.dart';
import 'package:p2p/appStyles/fontsfamiliy.dart';
import 'package:p2p/appStyles/sized_boxes.dart';
import 'package:p2p/components/item_component.dart';
import 'package:p2p/components/vehicle_component.dart';
import 'package:p2p/models/item.dart';
import 'package:p2p/models/order.dart';
import 'package:p2p/models/user_model.dart';
import 'package:p2p/providers/items_provider.dart';
import 'package:p2p/providers/map_provider.dart';
import 'package:p2p/screens/user/add_item_screen.dart';
import 'package:p2p/screens/user/map_screen.dart';
import 'package:p2p/screens/user/myorder.dart';
import 'package:p2p/screens/user/user_home.dart';
import 'package:p2p/service/order_service.dart';
import 'package:p2p/utilities/utilities.dart';
import 'package:p2p/widgets/button.dart';
import 'package:p2p/widgets/text_area.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditOrderScreen extends StatefulWidget {
  final Order order;

  EditOrderScreen({required this.order});
  @override
  _EditOrderScreenState createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  final _formKey = GlobalKey<FormState>();

  var initvalue = {};
  bool isSendingRequest = false;
  late TextEditingController pickupLocationController = TextEditingController();
  late TextEditingController phoneNumberController = TextEditingController();
  late TextEditingController receiverNameController = TextEditingController();
  late TextEditingController dropoffLocationController =
      TextEditingController();
  late TextEditingController pickUpDateController = TextEditingController();
  late TextEditingController dropoffDateController = TextEditingController();
  String? vehicleType;
  List<Map<String, dynamic>>? loadedVehicleTypes;

  String? pickUpLocationLatLang;
  String? dropoffLocationLatLang;
  String selectedvehicleType = "";
  int selectedIndex = 0;

  List<Map<String, dynamic>> vehicles = [];
  DateTime dt = DateTime.now();
  String? pickUpDate;
  String? pickupTime;
  bool isPickUpTimeChanged = false;
  bool isDropoffTimeChanged = false;
  late List<Item> itemsInOrder;
// new edited order
  Order editedOrder = Order(
      id: null,
      receiverName: null,
      userId: null,
      OrderedBy: null,
      orderedDate: null,
      deliveryItem: [],
      quotedPrice: null,
      finalPrice: null,
      isPayed: null,
      pickupPoint: null,
      pickupDate: null,
      destinationPoint: null,
      destinationDate: null,
      transportationRequirement: null,
      receiverPhoneNumber: null,
      vehicleType: null,
      remark: null,
      deliveryStatus: null,
      deliveryProgressId: null,
      createdOn: null);
  int? id;
  @override
  void initState() {
    super.initState();
    // phoneNumberController.text = widget.order.receiverPhoneNumber.toString();
    phoneNumberController.text = widget.order.receiverPhoneNumber!
        .substring(widget.order.receiverPhoneNumber!.length - 9);
    receiverNameController.text = widget.order.receiverName!;
    id = widget.order.id;
  }

  int returnIndexByName(String carName) {
    List<String> vehicleList = [
      "PICKUP_TRUCK",
      "CARGO_VAN",
      "BOX_TRUCK",
      "COURIER",
      "MOTOR_BIKE",
      "BIKE"
    ];

    return vehicleList.indexOf(carName);
  }

  var init = true;
  @override
  void didChangeDependencies() {
    Provider.of<ItemsProvider>(context, listen: false)
        .addItems(widget.order.deliveryItem);
    if (init) {
      editedOrder = widget.order;
      selectedvehicleType = widget.order.vehicleType!;
      selectedIndex = returnIndexByName(selectedvehicleType);
      pickUpDateController.text = widget.order.pickupDate.toString();
      print("pick up date controller:------${widget.order.pickupDate}");
      dropoffDateController.text = widget.order.destinationDate.toString();

      pickupLocationController.text =
          widget.order.pickupPoint!.street! ?? 'no address';
      pickUpLocationLatLang = LatLng(widget.order.pickupPoint!.latitude!,
              widget.order.pickupPoint!.longitude!)
          .toString();

      dropoffLocationController.text =
          widget.order.destinationPoint!.street! ?? 'no address';
      dropoffLocationLatLang = LatLng(widget.order.destinationPoint!.latitude!,
              widget.order.destinationPoint!.longitude!)
          .toString();

      initvalue = {
        "id": editedOrder.id, // Assuming id is nullable in the Item class
        "receiverName": editedOrder.receiverName,
        // "receiverPhone": editedOrder.receiverPhoneNumber,
        "receiverPhone": editedOrder.receiverPhoneNumber!
            .substring(editedOrder.receiverPhoneNumber!.length - 9),
        "userId": editedOrder.userId,
        "OrderedBy": editedOrder.OrderedBy,
        "orderedDate": editedOrder.orderedDate,
        "deliveryItem":
            editedOrder.deliveryItem, // Assign a default double value here
        "quotedPrice":
            editedOrder.quotedPrice, // Assign a default boolean value here
        "finalPrice":
            editedOrder.finalPrice, // Assign a default boolean value here
        "isPayed": editedOrder.isPayed, // Assign a default boolean value here
        "pickupPoint": editedOrder.pickupPoint,
        "pickupDate": editedOrder.pickupDate,
        "destinationPoint": editedOrder.destinationPoint,
        "transportationRequirement": editedOrder.transportationRequirement,
        "vehicleType": editedOrder.vehicleType,
        "remark": editedOrder.remark,
        "deliveryProgressId": editedOrder.deliveryItem,
        "createdOn": editedOrder.createdOn,
      };
    }
    print(
        "edited order in edit o screen didchan, dependancy:${editedOrder.receiverName}");
    init = false;
    super.didChangeDependencies();
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

//add item
  void addItemCallback(Item newItem) {
    Provider.of<ItemsProvider>(context, listen: false).addItem(newItem);
  }

//remove item call back
  void removeItemCallback(int index) {
    Provider.of<ItemsProvider>(context, listen: false).removeItem(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Your Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Edit the form below and hit the save changes button to save your changes!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: P2pAppFontsFamily.descriptionTexts.fontFamily,
                      fontSize: P2pFontSize.descriptionalTexts),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: receiverNameController,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                      labelText: 'Enter Receiver Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                IntlPhoneField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    labelText: 'Enter Phone Number',
                    hintText: 'Enter phone number',
                  ),
                  initialCountryCode: 'ET',
                  // initialValue: initvalue["receiverPhone"],
                  onChanged: (phone) {},
                ),
                SizedBox(
                  height: 10,
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
                SizedBox(
                  height: 10,
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
                SizedBox(
                  height: 10,
                ),
                Textarea(
                    context: context,
                    setDateTime: showDropOffDate,
                    title: "Dropoff Date",
                    hint: "DD/MM/YYYY",
                    isValid: true,
                    isObscure: false,
                    isPassword: false,
                    isDate: true,
                    icon: Icons.date_range_outlined,
                    onChanged: (value) => {},
                    controller: dropoffDateController,
                    isAuthentication: true),
                SizedBox(
                  height: 10,
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
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error loading data'));
                    } else if (!snapshot.hasData) {
                      return const Center(child: Text('No data available'));
                    } else {
                      List<Map<String, dynamic>> vehicles = snapshot.data!;
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
                                vehicleImage: vehicle["vehicle_image"],
                                selectedIndex: selectedIndex,
                                index: index,
                                setSelectedIndex: setSelectedIndex,
                                vehicleType: vehicle["vehicle_name"]);
                          },
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                SizedBox(
                  height: 10,
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
                                  orderItem: addeditmes.items[index],
                                  isFromEditOrder: true,
                                  size: addeditmes.items[index].size,
                                  itemName: addeditmes.items[index].name,
                                  index: index,
                                  // isFromAddOrder: true,
                                  removeItemCallback: removeItemCallback,
                                  measurement:
                                      addeditmes.items[index].sizeMeasurement,
                                );
                              },
                            ),
                    );
                  },
                ),
                Button(
                  hint: "Save Changes",
                  onPressed: sendRequest,
                ),
                SizedBox(
                  height: 6,
                ),
              ],
            ),
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
      firstDate: DateTime(2023),
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
          isPickUpTimeChanged = true;
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
      firstDate: DateTime(2023),
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
          isDropoffTimeChanged = true;
          dropoffDateController.text = formattedDate;

          // pickupLocationController.text = selectedDateTime.toString();
        });
        print('Selected Date and Time: $selectedDateTime');
        // Do something with the selected date and time (selectedDateTime)
      }
    }
  }

  void sendRequest() async {
    print('vlaues when adding order----------------:${widget.order.id}');
    print('fullname:${receiverNameController.text}');
    print('phon----:${phoneNumberController.text}');
    print('pickup date :${pickUpDateController.text}');
    print('dropoff date :${dropoffDateController.text}');
    print('vehicle type :${selectedvehicleType}');
    print('drop off location:${dropoffLocationController.text}');
    print("pick up location :${pickupLocationController.text}");
    //

    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      if (pickUpDateController.text.isEmpty) {
        throw Exception('Fill the form correctlly');
      }
      if (dropoffDateController.text.isEmpty) {
        throw Exception('Fill the form correctlly');
      }
      if (pickupLocationController.text!.isEmpty) {
        throw Exception('Fill the form correctlly');
      }
      if (dropoffLocationController.text.isEmpty) {
        throw Exception('Fill the form correctlly');
      }
      if (receiverNameController.text.isEmpty) {
        throw Exception('Fill the form correctlly');
      }
      if (phoneNumberController.text.isEmpty) {
        throw Exception('Fill the form correctlly');
      }
      if (selectedvehicleType.isEmpty) {
        throw Exception('Fill the form correctlly');
      }
      //
      setState(() {
        isSendingRequest = true;
      });
      //
      print(isSendingRequest);
      final deliveryItem =
          Provider.of<ItemsProvider>(context, listen: false).items;
      final pid = await prefs.getString('pid');
      final util = Utilities();
      final pickuppointt = await util.reverseGeocode(
          pickUpLocationLatLang, pickupLocationController.text);
      final dropoffponitt = await util.reverseGeocode(
          dropoffLocationLatLang, dropoffLocationController.text);
      print("pickuploc----${pickuppointt!.street}");
      print("dropoffloc-----: ${dropoffponitt!.street}");

      Order orderData = Order(
        id: widget.order.id,
        userId: null,
        OrderedBy: null,
        orderedDate: null,
        deliveryItem: deliveryItem,
        quotedPrice: null,
        finalPrice: null,
        isPayed: null,
        pickupPoint: pickuppointt,
        pickupDate: isPickUpTimeChanged
            ? DateFormat('dd MMMM yyyy HH:mm').parse(pickUpDateController.text)
            : DateFormat('dd-MM-yyyy HH:mm').parse(
                    DateTime.parse(pickUpDateController.text).toString()) ??
                null,
        destinationPoint: dropoffponitt,
        destinationDate: isDropoffTimeChanged
            ? DateFormat('dd MMMM yyyy HH:mm').parse(dropoffDateController.text)
            : DateFormat('dd-MM-yy HH:mm').parse(
                    DateTime.parse(dropoffDateController.text).toString()) ??
                null,
        transportationRequirement: null,
        vehicleType: selectedvehicleType,
        receiverName: receiverNameController.text,
        receiverPhoneNumber: phoneNumberController.text,
        remark: null,
        deliveryProgressId: null,
        deliveryStatus: widget.order.deliveryStatus,
        createdOn: null,
      );

      //send request to backend
      int statusCode = await Provider.of<OrderService>(context, listen: false)
          .updateOrder(orderData);
      print('Status Code: $statusCode');

      if (statusCode == 200 || statusCode == 201) {
        Provider.of<ItemsProvider>(context, listen: false).removeList();

        // Navigator.of(context).popAndPushNamed(MyOrderScreen.routeName);
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
      print('Error inside edit order screen---------: $error');
      showalert(error.toString());
    }
  }
}
