//add item
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:p2p/appStyles/app_fontsize.dart';
import 'package:p2p/appStyles/fontsfamiliy.dart';
import 'package:p2p/models/item.dart';
import 'package:p2p/providers/items_provider.dart';
import 'package:p2p/widgets/button.dart';
import 'package:provider/provider.dart';

class ViewItemScreen extends StatefulWidget {
  final int? index;
  final bool? isFromEditOrderScreen;
  final Item? orderItem;
  ViewItemScreen({this.index, this.orderItem, this.isFromEditOrderScreen});
  @override
  _ViewItemScreenState createState() => _ViewItemScreenState();
}

class _ViewItemScreenState extends State<ViewItemScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _packageDescription = '';
  String? _itemCategory = '';
  var initvalue = {};

  String? _measurement = '';
  double? _size;
  String _remark = '';
  String _other = '';
  bool? _isBrittle = false;
  bool? _isFlammable = false;
  bool? _isSensitive = false;
// new edited item
  Item editedItem = Item.fromJson({
    "id": null, // Assuming id is nullable in the Item class
    "name": "",
    "description": "",
    "itemCategory": "",
    "sizeMeasurement": "",
    "size": 0.0, // Assign a default double value here
    "isBrittle": false, // Assign a default boolean value here
    "isFlammable": false, // Assign a default boolean value here
    "isSensitive": false, // Assign a default boolean value here
    "other": "",
    "remark": "",
    "createdOn": null,
    "updatedOn": null,
  });
  @override
  void initState() {
    super.initState();
  }

  var init = true;
  @override
  void didChangeDependencies() {
    if (init) {
      if (widget.isFromEditOrderScreen == true) {
        editedItem = widget.orderItem!;
      } else {
        editedItem = Provider.of<ItemsProvider>(context).getById(widget.index);
      }
      initvalue = {
        "id": null, // Assuming id is nullable in the Item class
        "name": editedItem.name,
        "description": editedItem.description,
        "sizeMeasurement": editedItem.sizeMeasurement,
        "size": editedItem.size,
        "isBrittle": editedItem.isBrittle,
        "isFlammable": editedItem.isFlammable,
        "isSensitive": editedItem.isSensitive,
        "other": editedItem.other,
        "remark": editedItem.remark,
        "createdOn": null,
        "updatedOn": null,
      };
      _measurement = editedItem.sizeMeasurement.toString();
      _isBrittle = editedItem.isBrittle;
      _isFlammable = editedItem.isFlammable;
      _isSensitive = editedItem.isSensitive;
    }
    init = false;
    super.didChangeDependencies();
  }

//dropdown for measurments
  List<DropdownMenuItem<String>> _buildDropdownItems() {
    print(_measurement);

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
    print(_itemCategory);

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
        title: Text('Update the Delivery Item'),
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
                  "Please edit the form below carefully and hit the update button to add your item!",
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
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                      labelText: 'Enter Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      )),
                  initialValue: initvalue["name"],
                  onSaved: (value) {
                    editedItem = Item.fromJson({
                      "id": null, // Assuming id is nullable in the Item class
                      "name": value,
                      "description": editedItem.description,

                      "sizeMeasurement": editedItem.sizeMeasurement,
                      "size": editedItem.size,
                      "isBrittle": editedItem.isBrittle,
                      "isFlammable": editedItem.isFlammable,
                      "isSensitive": editedItem.isSensitive,
                      "other": editedItem.other,
                      "remark": editedItem.remark,
                      "createdOn": null,
                      "updatedOn": null,
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
                  maxLines: 3,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                      labelText: 'Enter Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      )),
                  initialValue: initvalue["description"],
                  onSaved: (value) {
                    editedItem = Item.fromJson({
                      "id": null, // Assuming id is nullable in the Item class
                      "name": editedItem.name,
                      "description": value,
                      "sizeMeasurement": editedItem.sizeMeasurement,
                      "size": editedItem.size,
                      "isBrittle": editedItem.isBrittle,
                      "isFlammable": editedItem.isFlammable,
                      "isSensitive": editedItem.isSensitive,
                      "other": editedItem.other,
                      "remark": editedItem.remark,
                      "createdOn": null,
                      "updatedOn": null,
                    });
                    print("des:  ${editedItem.description}");
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
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10),
                              labelText: 'Enter Size',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            initialValue: initvalue["size"].toString(),
                            onSaved: (value) {
                              editedItem = Item.fromJson({
                                "id":
                                    null, // Assuming id is nullable in the Item class
                                "name": editedItem.name,
                                "description": editedItem.description,
                                "sizeMeasurement": editedItem.sizeMeasurement,
                                "size": double.parse(value.toString()),
                                "isBrittle": editedItem.isBrittle,
                                "isFlammable": editedItem.isFlammable,
                                "isSensitive": editedItem.isSensitive,
                                "other": editedItem.other,
                                "remark": editedItem.remark,
                                "createdOn": null,
                                "updatedOn": null,
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
                            onSaved: (value) {
                              editedItem = Item.fromJson({
                                "id":
                                    null, // Assuming id is nullable in the Item class
                                "name": editedItem.name,
                                "description": editedItem.description,
                                "sizeMeasurement": value,
                                "size": editedItem.size,
                                "isBrittle": editedItem.isBrittle,
                                "isFlammable": editedItem.isFlammable,
                                "isSensitive": editedItem.isSensitive,
                                "other": editedItem.other,
                                "remark": editedItem.remark,
                                "createdOn": null,
                                "updatedOn": null,
                              });
                            },
                            onChanged: (value) {
                              _measurement = value;
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
                  initialValue: initvalue["remark"],
                  onSaved: (value) {
                    editedItem = Item.fromJson({
                      "id": null, // Assuming id is nullable in the Item class
                      "name": editedItem.name,
                      "sizeMeasurement": editedItem.sizeMeasurement,
                      "description": editedItem.description,

                      "size": editedItem.size,
                      "isBrittle": editedItem.isBrittle,
                      "isFlammable": editedItem.isFlammable,
                      "isSensitive": editedItem.isSensitive,
                      "other": editedItem.other,
                      "remark": value,
                      "createdOn": null,
                      "updatedOn": null,
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
                        _isBrittle = value;

                        editedItem = Item.fromJson({
                          "id": null,
                          "name": editedItem.name,
                          "sizeMeasurement": editedItem.sizeMeasurement,
                          "size": editedItem.size,
                          "isBrittle": value,
                          "isFlammable": editedItem.isFlammable,
                          "isSensitive": editedItem.isSensitive,
                          "other": editedItem.other,
                          "remark": editedItem.remark,
                          "createdOn": null,
                          "updatedOn": null,
                        });
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
                        _isFlammable = value;
                        editedItem = Item.fromJson({
                          "id":
                              null, // Assuming id is nullable in the Item class
                          "name": editedItem.name,
                          "sizeMeasurement": editedItem.sizeMeasurement,
                          "size": editedItem.size,
                          "isBrittle": editedItem.isBrittle,
                          "isFlammable": value,
                          "isSensitive": editedItem.isSensitive,
                          "other": editedItem.other,
                          "remark": editedItem.remark,
                          "createdOn": null,
                          "updatedOn": null,
                        });
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
                        _isSensitive = value;

                        editedItem = Item.fromJson({
                          "id":
                              null, // Assuming id is nullable in the Item class
                          "name": editedItem.name,
                          "sizeMeasurement": editedItem.sizeMeasurement,
                          "size": editedItem.size,
                          "isBrittle": editedItem.isBrittle,
                          "isFlammable": editedItem.isFlammable,
                          "isSensitive": value,
                          "other": editedItem.other,
                          "remark": editedItem.remark,
                          "createdOn": null,
                          "updatedOn": null,
                        });
                      });
                    },
                    controlAffinity: ListTileControlAffinity.trailing,
                    activeColor: Colors.blue,
                  ),
                ),
                SizedBox(height: 12),
                Button(
                  hint: "Update Item",
                  onPressed: () {
                    print("desc:---------${editedItem.description}");
                    if (_formKey.currentState!.validate()) {
                      print(editedItem.name);
                      // Perform form submission
                      _formKey.currentState!.save();
                      if (widget.index == null &&
                          widget.isFromEditOrderScreen != true) {
                        return;
                      }
                      print(editedItem.name);
                      print(editedItem.size);
                      Provider.of<ItemsProvider>(context, listen: false)
                          .editItem(widget.index, editedItem);
                      Navigator.of(context).pop();
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
