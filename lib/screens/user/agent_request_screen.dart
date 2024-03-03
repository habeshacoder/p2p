import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/appStyles/app_fontsize.dart';
import 'package:p2p/appStyles/fontsfamiliy.dart';
import 'package:p2p/appStyles/sized_boxes.dart';
import 'package:p2p/models/agent_model.dart';
import 'package:p2p/models/areaofcoverage.dart';
import 'package:p2p/models/user_model.dart';
import 'package:p2p/service/agent_service.dart';
import 'package:p2p/widgets/button.dart';
import 'package:path/path.dart' as path;
import 'package:p2p/service/profile_service.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class AgentRequestScreen extends StatefulWidget {
  final User? profileData;
  AgentRequestScreen({
    required this.profileData,
    // required this.areasOFcoverage,
  });
  @override
  State<AgentRequestScreen> createState() => _AgentRequestScreenState();
}

class _AgentRequestScreenState extends State<AgentRequestScreen> {
  var init = true;
  List<AreaOfCoverage>? areasOFcoverage;

  late TextEditingController firstNameController = TextEditingController();
  late TextEditingController lastNameController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController streetController = TextEditingController();
  late TextEditingController cityController = TextEditingController();
  late TextEditingController phoneNumberController = TextEditingController();
  @override
  void didChangeDependencies() {
    if (init) {
      firstNameController.text = widget.profileData!.firstName!;
      lastNameController.text = widget.profileData!.lastName!;
      emailController.text = widget.profileData!.email!;
      streetController.text = widget.profileData!.address!.street!;
      cityController.text = widget.profileData!.address!.city!;
      phoneNumberController.text = widget.profileData!.userName!;
      areasOFcoverage = Provider.of<AgentService>(context, listen: false)
          .getAreasOfCoverage();
    }
    init = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    streetController.dispose();
    cityController.dispose();
    phoneNumberController.dispose();
    super.dispose();
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
              height: 160,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Text(
                        'BECOME AN AGENT',
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: P2pFontSize.p2p18,
                            fontFamily:
                                P2pAppFontsFamily.descriptionTexts.fontFamily),
                      ),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    child: Center(
                      child: Text(
                        '${widget.profileData!.firstName![0].toUpperCase()}${widget.profileData!.lastName![0].toUpperCase()}',
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
                  )
                ],
              ),
            ),
            //personal details
            Container(
              margin: EdgeInsets.only(
                top: 140,
                // left: MediaQuery.of(context).size.width * 0.1
              ),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //personal detail
                      Card(
                        color: P2pAppColors.white,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'PERSONAL DETAILS',
                                    style: TextStyle(
                                        fontSize: P2pFontSize.p2p14,
                                        fontFamily: P2pAppFontsFamily
                                            .descriptionTexts.fontFamily),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '',
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
                              TextFormField(
                                controller: firstNameController,
                                decoration: InputDecoration(
                                  labelText: 'First Name:',
                                  border: UnderlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 0.0),
                                ),
                              ),
                              SizedBox(
                                height: P2pSizedBox.betweenInputFields,
                              ),
                              TextFormField(
                                // initialValue: '${widget.userData!.lastName}',
                                controller: lastNameController,
                                decoration: InputDecoration(
                                  labelText: 'Last  Name:',
                                  border: UnderlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 0.0),
                                ),
                              ),
                              SizedBox(
                                height: P2pSizedBox.betweenInputFields,
                              ),
                              TextFormField(
                                // initialValue: '${widget.userData!.lastName}',
                                controller: emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email:',
                                  border: UnderlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 0.0),
                                ),
                              ),
                              // Text('${widget.userData!.email}'),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                // initialValue: '${widget.userData!.lastName}',
                                controller: phoneNumberController,
                                decoration: InputDecoration(
                                  labelText: 'Phone Number:',
                                  border: UnderlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 0.0),
                                ),
                              ),
                              // Text('${widget.userData!.userName}'),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Address:',
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: P2pSizedBox.betweenInputFields,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          // initialValue: '${widget.userData!.lastName}',
                                          controller: cityController,
                                          decoration: InputDecoration(
                                            labelText: 'City:',
                                            border: UnderlineInputBorder(),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0.0),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          // initialValue: '${widget.userData!.lastName}',
                                          controller: streetController,
                                          decoration: InputDecoration(
                                            labelText: 'Street:',
                                            border: UnderlineInputBorder(),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                              // Text('${widget.userData!.address!.street}'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          width: double.infinity,
                          child: MoreAgentInfo(
                            areasOFcoverage: areasOFcoverage,
                            user: widget.profileData!,
                            firstName: firstNameController,
                            lastName: lastNameController,
                            email: emailController,
                            street: streetController,
                            city: cityController,
                            phoneNumber: phoneNumberController,
                          )),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MoreAgentInfo extends StatefulWidget {
  final User user;
  final List<AreaOfCoverage>? areasOFcoverage;
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController email;
  final TextEditingController street;
  final TextEditingController city;
  final TextEditingController phoneNumber;

  const MoreAgentInfo(
      {super.key,
      required this.areasOFcoverage,
      required this.user,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.street,
      required this.city,
      required this.phoneNumber});

  @override
  State<MoreAgentInfo> createState() => _MoreAgentInfoState();
}

class _MoreAgentInfoState extends State<MoreAgentInfo> {
  String? selectedVehicle = 'Bike';
  late String selectedVehicleImageUrl;
  String? _areaOfCoverage;
  List<String>? areasOfCoverageList = [];

  bool isSendingrequest = false;
  String _carType = 'PICKUP_TRUCK';
  final _formKey = GlobalKey<FormState>();
  BikeInfo bikeInfo = BikeInfo();
  CarInfo carInfo = CarInfo();
  MotorBikeInfo motoBikeInfo = MotorBikeInfo();
  bool init = true;
  @override
  void didChangeDependencies() async {
    if (init) {
      for (var area in widget.areasOFcoverage!) {
        areasOfCoverageList!.add(area.locationName);
      }
      _areaOfCoverage = widget.areasOFcoverage![0].locationName;
    }
    print('---inised moreagentInfo${areasOfCoverageList}');
    print('---inised moreagentInfo${_areaOfCoverage}');
    init = false;
    super.didChangeDependencies();
  }

  //dropdown for measurments
  List<DropdownMenuItem<String>> _buildDropdownCarTypes() {
    List<String> _carTypeOptions = [
      'BOX_TRUCK',
      'COURIER',
      'CARGO_VAN',
      'PICKUP_TRUCK',
    ];
    return _carTypeOptions.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value, overflow: TextOverflow.ellipsis),
      );
    }).toList();
  }

  //dropdown for measurments
  List<DropdownMenuItem<String>> _buildDropDownsCoverageArea() {
    return areasOfCoverageList!.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

//upload vehicle image to firebase
  void uploadVehicleImage(String imageUrl) {
    selectedVehicleImageUrl = imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: P2pAppColors.white,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 100),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  text: 'Area of Coverage',
                  children: [
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: P2pAppColors.yellow,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 3.0,
                      horizontal: 5,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
                value: _areaOfCoverage,
                items: _buildDropDownsCoverageArea(),
                onChanged: (value) {
                  setState(() {
                    _areaOfCoverage = value!;
                  });
                },
              ),
              Text.rich(
                TextSpan(
                  text: 'Vehicle type ',
                  children: [
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: P2pAppColors.yellow,
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                // scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedVehicle = 'Bike';
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Image.asset(
                                color: selectedVehicle == "Bike"
                                    ? P2pAppColors.black
                                    : null,
                                'assets/images/vehicle_images/bicycle.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            'Bike',
                            style: TextStyle(
                                color: selectedVehicle == "Bike"
                                    ? P2pAppColors.black
                                    : null),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedVehicle = 'Motor';
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Image.asset(
                                color: selectedVehicle == "Motor"
                                    ? P2pAppColors.black
                                    : null,
                                'assets/images/vehicle_images/motor.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            'Motor',
                            style: TextStyle(
                                color: selectedVehicle == "Motor"
                                    ? P2pAppColors.black
                                    : null),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedVehicle = 'Car';
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Image.asset(
                                color: selectedVehicle == "Car"
                                    ? P2pAppColors.black
                                    : null,
                                'assets/images/vehicle_images/truck.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            'Car',
                            style: TextStyle(
                                color: selectedVehicle == "Car"
                                    ? P2pAppColors.black
                                    : null),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: P2pSizedBox.betweenInputFields,
              ),
              // VehicleDetail(selectedVehicle: selectedVehicle)
              Column(
                children: [
                  if (selectedVehicle == 'Car')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: 'Plate Number',
                            children: [
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  color: P2pAppColors.yellow,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextFormField(
                          onSaved: (newValue) {
                            carInfo.plateNumber = newValue;
                          },
                          validator: (value) {
                            if (value == "" || value == null) {
                              return "please enter valid value";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10),
                              labelText: 'Enter PlateNumber ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )),
                        ),
                        SizedBox(
                          height: P2pSizedBox.betweenInputFields,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: 'Make',
                                    children: [
                                      TextSpan(
                                        text: '*',
                                        style: TextStyle(
                                          color: P2pAppColors.yellow,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextFormField(
                                  onSaved: (newValue) {
                                    carInfo.make = newValue;
                                  },
                                  validator: (value) {
                                    if (value == "" || value == null) {
                                      return "please enter valid value";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10),
                                      labelText: 'Enter Make ',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      )),
                                ),
                              ],
                            )),
                            SizedBox(
                              width: 3,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: 'Model',
                                    children: [
                                      TextSpan(
                                        text: '*',
                                        style: TextStyle(
                                          color: P2pAppColors.yellow,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextFormField(
                                  onSaved: (newValue) {
                                    carInfo.model = newValue;
                                  },
                                  validator: (value) {
                                    if (value == "" || value == null) {
                                      return "please enter valid value";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10),
                                      labelText: 'Enter Model ',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      )),
                                ),
                              ],
                            )),
                            SizedBox(
                              width: 3,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: P2pSizedBox.betweenInputFields,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: 'Car Type',
                                    children: [
                                      TextSpan(
                                        text: '*',
                                        style: TextStyle(
                                          color: P2pAppColors.yellow,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 3.0,
                                        horizontal: 1.3,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      )),
                                  value: _carType,
                                  items: _buildDropdownCarTypes(),
                                  onChanged: (value) {
                                    setState(() {
                                      _carType = value!;
                                      carInfo.carType = _carType;
                                    });
                                  },
                                ),
                              ],
                            )),
                            SizedBox(
                              width: 3,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: 'Color',
                                    children: [
                                      TextSpan(
                                        text: '*',
                                        style: TextStyle(
                                          color: P2pAppColors.yellow,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextFormField(
                                  onSaved: (newValue) {
                                    carInfo.color = newValue;
                                  },
                                  validator: (value) {
                                    if (value == "" || value == null) {
                                      return "please enter valid value";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10),
                                      labelText: 'Enter Color',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      )),
                                ),
                              ],
                            )),
                          ],
                        ),
                        Text('Description:'),
                        TextFormField(
                          // controller: _textEditingController,
                          onSaved: (newValue) {
                            carInfo.description = newValue;
                          },
                          minLines: 2,
                          maxLines: 3,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10),
                              labelText: 'Enter Description',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )),
                        ),
                        SizedBox(
                          height: P2pSizedBox.betweenInputFields,
                        ),
                        VehicleImageUpload(
                          title: 'Car',
                          uploadVehicleImage: uploadVehicleImage,
                        ),
                        SizedBox(
                          height: P2pSizedBox.betweenButtonAndInputField,
                        ),
                      ],
                    ),
                  if (selectedVehicle == 'Motor')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: 'Plate Number',
                            children: [
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  color: P2pAppColors.yellow,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextFormField(
                          onSaved: (newValue) {
                            motoBikeInfo.plateNumber = newValue;
                          },
                          validator: (value) {
                            if (value == "" || value == null) {
                              return "please enter valid value";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10),
                              labelText: 'Enter PlateNumber ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )),
                        ),
                        SizedBox(
                          height: P2pSizedBox.betweenInputFields,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: 'Make',
                                    children: [
                                      TextSpan(
                                        text: '*',
                                        style: TextStyle(
                                          color: P2pAppColors.yellow,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextFormField(
                                  onSaved: (newValue) {
                                    motoBikeInfo.make = newValue;
                                  },
                                  validator: (value) {
                                    if (value == "" || value == null) {
                                      return "please enter valid value";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10),
                                      labelText: 'Enter Make ',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      )),
                                ),
                              ],
                            )),
                            SizedBox(
                              width: 3,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: 'Color',
                                    children: [
                                      TextSpan(
                                        text: '*',
                                        style: TextStyle(
                                          color: P2pAppColors.yellow,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextFormField(
                                  onSaved: (newValue) {
                                    motoBikeInfo.color = newValue;
                                  },
                                  validator: (value) {
                                    if (value == "" || value == null) {
                                      return "please enter valid value";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10),
                                      labelText: 'Enter Color',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      )),
                                ),
                              ],
                            )),
                          ],
                        ),
                        SizedBox(
                          height: P2pSizedBox.betweenInputFields,
                        ),
                        Text('Description:'),
                        TextFormField(
                          // controller: _textEditingController,
                          onSaved: (newValue) {
                            motoBikeInfo.description = newValue;
                          },
                          minLines: 2,
                          maxLines: 3,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10),
                              labelText: 'Enter Description',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )),
                        ),
                        SizedBox(
                          height: P2pSizedBox.betweenInputFields,
                        ),
                        VehicleImageUpload(
                          title: 'Motor',
                          uploadVehicleImage: uploadVehicleImage,
                        ),
                        SizedBox(
                          height: P2pSizedBox.betweenButtonAndInputField,
                        ),
                      ],
                    ),
                  if (selectedVehicle == 'Bike')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description:'),
                        TextFormField(
                          onSaved: (newValue) {
                            bikeInfo.description = newValue;
                          },
                          // controller: _textEditingController,
                          minLines: 2,
                          maxLines: 3,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10),
                              labelText: 'Enter Description',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )),
                        ),
                        SizedBox(
                          height: P2pSizedBox.betweenInputFields,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            VehicleImageUpload(
                              title: 'Bike',
                              uploadVehicleImage: uploadVehicleImage,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      text: 'Color',
                                      children: [
                                        TextSpan(
                                          text: '*',
                                          style: TextStyle(
                                            color: P2pAppColors.yellow,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextFormField(
                                    onSaved: (newValue) {
                                      bikeInfo.color = newValue;
                                    },
                                    validator: (value) {
                                      if (value == "" || value == null) {
                                        return "please enter valid value";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 10),
                                        labelText: 'Enter Color',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: P2pSizedBox.betweenButtonAndInputField,
                        ),
                      ],
                    )
                ],
              ),
              if (isSendingrequest == false)
                Button(
                  hint: 'Send Request',
                  onPressed: SendAgentRequest,
                ),
              if (isSendingrequest == true)
                Container(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          P2pAppColors.black), // Background color
                      side: MaterialStateProperty.all<BorderSide>(
                        const BorderSide(
                          width: 2.0, // Border width
                        ),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20.0), // Border radius
                        ),
                      ),
                    ),
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void SendAgentRequest() async {
    if (widget.firstName.text == null && widget.lastName.text == null ||
        widget.email.text == null ||
        widget.lastName.text == null ||
        widget.city.text == null ||
        widget.street.text == null ||
        widget.phoneNumber.text == null ||
        selectedVehicleImageUrl == null ||
        _areaOfCoverage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill all entries of the form above'),
      ));
    }
    _formKey.currentState!.save();
    setState(() {
      isSendingrequest = true;
    });
    // BikeInfo bikeInfoOjec = BikeInfo(id: null, color: bikeInfo[""]);
    AreaOfCoverage targetObject = widget.areasOFcoverage!
        .firstWhere((obj) => obj.locationName == _areaOfCoverage);

    User user = User(
        id: widget.user.id,
        userPublicId: widget.user.userPublicId,
        firstName: widget.firstName.text,
        lastName: widget.lastName.text,
        userName: widget.phoneNumber.text,
        userPassword: widget.user.userPassword,
        email: widget.email.text,
        address: Address(
          id: widget.user.address!.id,
          street: widget.street.text,
          city: widget.city.text,
          createdOn: widget.user.address!.createdOn,
          updatedOn: widget.user.address!.updatedOn,
        ));
    bikeInfo.imageUrl = selectedVehicleImageUrl;
    carInfo.imageUrl = selectedVehicleImageUrl;
    motoBikeInfo.imageUrl = selectedVehicleImageUrl;
    DeliveryAgentModel agentRequestData = DeliveryAgentModel(
      areaOfCoverageIds: [targetObject.id!],
      bikeInfo: bikeInfo,
      carInfo: carInfo,
      motorBikeInfo: motoBikeInfo,
      user: user,
    );
    try {
      await Provider.of<AgentService>(context, listen: false)
          .becomeAgent(agentData: agentRequestData);
      setState(() {
        isSendingrequest = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text('Thank you! we received your request'),
      ));
      Navigator.of(context).pop();
    } catch (error) {
      setState(() {
        isSendingrequest = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$error'),
      ));
    }
  }
}

class VehicleImageUpload extends StatefulWidget {
  // VehicleImageUpload({required this.uploadVehicleImage});
  final Function(String) uploadVehicleImage;
  String title;
  VehicleImageUpload({required this.title, required this.uploadVehicleImage});
  @override
  State<VehicleImageUpload> createState() => _VehicleImageStateUpload();
}

class _VehicleImageStateUpload extends State<VehicleImageUpload> {
  dynamic loadedImageUrl;
  dynamic imageUrl;
  String? pngFormateCheck;
  String? sizeCheck;
  String? dimensionCheck;
  String? isImageUrlEmpty;
  bool isuploading = false;
  bool isSendingCreateProfileRequest = false;
  //display error message to user
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

  String? uploadToFirebaseStorage(XFile? imageFile) {
    String imagePath = imageFile!.path;
    String imageName = imagePath.split('/').last;
    String? downloadUrl;

    final FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageRef = storage.ref().child('images/$imageName');
    UploadTask uploadTask = storageRef.putFile(File(imagePath));

    uploadTask.then((TaskSnapshot snapshot) async {
      downloadUrl = await snapshot.ref.getDownloadURL();
      if (downloadUrl != null) {
        widget.uploadVehicleImage(downloadUrl!);
      }
    }).catchError((error) {});
    return downloadUrl;
  }

  //profile image picker
  Future<void> __pickImage() async {
    final pickedFile;
    final imagePicker = ImagePicker();
    try {
      pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final imagePath = pickedFile.path;

        final imageFileFormate = File(imagePath);

        //extention formate validation
        final isPngOrJpg = ['.png', '.jpg', '.jpeg']
            .any((extension) => imagePath.toLowerCase().endsWith(extension));
        if (!isPngOrJpg) {
          print('File must be in PNG or JPG format');
          setState(() {
            pngFormateCheck = 'File must be in PNG or JPG format';
          });
          return;
        }
        // Handle size
        final fileSize = await imageFileFormate.length();
        if (fileSize >= 1000000) {
          print('File size must be less than 1MB');
          setState(() {
            sizeCheck = 'File size must be less than 1MB';
          });
          return;
        }
        setState(() {
          isuploading = true;
        });
        uploadToFirebaseStorage(pickedFile);
        setState(() {
          isuploading = false;
        });
        //update value
        setState(() {
          sizeCheck = null;
          dimensionCheck = null;
          pngFormateCheck = null;
          loadedImageUrl = path.basename(imagePath);
          imageUrl = imageFileFormate;
        });
      }

      // widget.uploadProfileImage(imageUrl);
    } catch (error) {
      print('error:..${error}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: '${widget.title} Image',
              children: [
                TextSpan(
                  text: '*',
                  style: TextStyle(
                    color: P2pAppColors.yellow,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child: imageUrl != null
                    ? Image.file(
                        imageUrl as File,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    : Center(
                        child: Icon(
                          Icons.photo,
                          fill: 1,
                          size: MediaQuery.of(context).size.width * 0.2,
                          color: Colors.grey,
                          // Customize the icon color
                        ),
                      ),
              ),
              TextButton(
                onPressed: __pickImage,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      P2pAppColors.black), // Background color
                  side: MaterialStateProperty.all<BorderSide>(
                    const BorderSide(
                      width: 2.0, // Border width
                    ),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Border radius
                    ),
                  ),
                ),
                child: isuploading == true
                    ? CircularProgressIndicator()
                    : Text(
                        'Upload Image',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: P2pAppColors.white, // Text color
                          fontSize: P2pFontSize.p2p14,
                        ),
                      ),
              ),
            ],
          ),
          if (sizeCheck != null)
            Text(
              '. ${sizeCheck}',
              style: TextStyle(color: Colors.red),
            ),
          if (pngFormateCheck != null)
            Text(
              '. ${pngFormateCheck}',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }
}
