//add item
import 'package:flutter/material.dart';
import 'package:p2p/appStyles/app_fontsize.dart';
import 'package:p2p/appStyles/fontsfamiliy.dart';
import 'package:p2p/models/item.dart';
import 'package:p2p/widgets/button.dart';

class AddItemScreen extends StatefulWidget {
  final Function(Item) addItemCallback;
  AddItemScreen({required this.addItemCallback});
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _packageDescription = '';
  String _itemCategory = 'All';
  String _measurement = 'Count';
  double? _size;
  String _remark = '';
  String _other = '';
  bool _isBrittle = false;
  bool _isFlammable = false;
  bool _isSensitive = false;

//dropdown for measurments
  List<DropdownMenuItem<String>> _buildDropdownItems() {
    List<String> _measurementOptions = [
      'Count',
      'Kilograms',
    ];
    return _measurementOptions.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

//dropdown for categories
  List<DropdownMenuItem<String>> _dropDownForCategories() {
    List<String> categories = [
      'All',
      'Category 2',
      'Category 3',
      // Add more categories here
    ];

    return categories.map((String category) {
      return DropdownMenuItem<String>(
        value: category,
        child: Text(category),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Delivery Item'),
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
                  "Please fill out the form below carefully and hit the Add button to add your item!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: P2pAppFontsFamily.descriptionTexts.fontFamily,
                      fontSize: P2pFontSize.descriptionalTexts),
                ),
                SizedBox(
                  height: 6,
                ),
                Text('Name:'),
                SizedBox(
                  height: 6,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == "" || value == null) {
                      return "please enter valid value";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                      labelText: 'Enter Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      )),
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),
                SizedBox(height: 8),
                //package desscription
                Text('Package Description:'),
                SizedBox(
                  height: 6,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == "" || value == null) {
                      return "please enter valid value";
                    }
                    return null;
                  },
                  maxLines: 3,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                      labelText: 'Enter Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      )),
                  onChanged: (value) {
                    setState(() {
                      _packageDescription = value;
                    });
                  },
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text('Size:'),
                          SizedBox(height: 6),
                          TextFormField(
                            validator: (value) {
                              if (value == "" || value == null) {
                                return "please enter valid value";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10),
                              labelText: 'Enter Size',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _size = double.tryParse(value.trim());
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 3),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Measurement:"),
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
                            value: _measurement,
                            items: _buildDropdownItems(),
                            onChanged: (value) {
                              setState(() {
                                _measurement = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text('Remark:'),
                SizedBox(
                  height: 6,
                ),
                TextFormField(
                  maxLines: 3,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                      labelText: ' Enter Remark',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      )),
                  onChanged: (value) {
                    setState(() {
                      _remark = value;
                    });
                  },
                ),

                SizedBox(height: 10.0),
                Text('About the Item:'),
                SizedBox(
                  height: 30,
                  child: CheckboxListTile(
                    title: Text('Is Brittle'),
                    value: _isBrittle,
                    onChanged: (value) {
                      setState(() {
                        _isBrittle = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.trailing,
                    activeColor: Colors.blue,
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: CheckboxListTile(
                    title: Text('Is Flammable'),
                    value: _isFlammable,
                    onChanged: (value) {
                      setState(() {
                        _isFlammable = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.trailing,
                    activeColor: Colors.blue,
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: CheckboxListTile(
                    title: Text('Is Sensitive'),
                    value: _isSensitive,
                    onChanged: (value) {
                      setState(() {
                        _isSensitive = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.trailing,
                    activeColor: Colors.blue,
                  ),
                ),
                SizedBox(height: 12),
                Button(
                  hint: "Add",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Perform form submission
                      _formKey.currentState!.save();
                      // Process the form data as needed
                      // List<Map<String, dynamic>> categoryList = [
                      //   {
                      //     "id": null,
                      //     "category": _itemCategory,
                      //     "createdOn": null,
                      //     "updatedOn": null,
                      //   }
                      // ];
                      print('before');

                      Item newItem = Item.fromJson({
                        "id": null, // Assuming id is nullable in the Item class
                        "name": _name.trim(),
                        "description": _packageDescription.trim(),
                        "sizeMeasurement": _measurement.trim(),
                        "size": _size,
                        "isBrittle": _isBrittle,
                        "isFlammable": _isFlammable,
                        "isSensitive": _isSensitive,
                        "other": _other,
                        "remark": _remark,
                        "createdOn": null,
                        "updatedOn": null,
                      });
                      print('after');
                      if (newItem != null) {
                        widget.addItemCallback(newItem);
                        Navigator.of(context).pop();
                      }
                    }
                  },
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
}
