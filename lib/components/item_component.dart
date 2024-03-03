import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/appStyles/app_fontsize.dart';
import 'package:p2p/appStyles/fontsfamiliy.dart';
import 'package:p2p/models/item.dart';
import 'package:p2p/screens/user/edit_item_screen.dart';
import 'package:p2p/screens/user/view_item_screen.dart';

// ignore: must_be_immutable
class ItemComponent extends StatelessWidget {
  final Item? orderItem;
  final Function(int)? removeItemCallback;
  final bool? isFromEditOrder;
  final bool? isFromAddOrder;
  String? itemName;
  String? category;
  double? size;
  String? measurement;
  int index;
  ItemComponent(
      {super.key,
      this.orderItem,
      this.isFromAddOrder,
      this.isFromEditOrder,
      this.removeItemCallback,
      required this.size,
      required this.itemName,
      required this.index,
      required this.measurement});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 15, left: 15),
      elevation: 2.0,
      child: Container(
        height: 300,
        width: 130,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16, left: 5, bottom: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: 8.0),
                  if (itemName != null)
                    Text(
                      itemName.toString(),
                      style: TextStyle(
                        fontFamily:
                            P2pAppFontsFamily.descriptionTexts.fontFamily,
                      ),
                    ),
                  if (size != null)
                    Row(
                      children: [
                        Text(
                          size.toString(),
                          style: TextStyle(
                            fontFamily:
                                P2pAppFontsFamily.descriptionTexts.fontFamily,
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          measurement.toString(),
                          style: TextStyle(
                            fontFamily:
                                P2pAppFontsFamily.descriptionTexts.fontFamily,
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ),
            // if (isFromEditOrder != true)
            Positioned(
              top: -5,
              right: -5,
              child: InkWell(
                onTap: () {
                  removeItem(index);
                },
                child: Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ),
            // if (isFromEditOrder != true)
            Positioned(
              left: -5,
              top: -10,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditItemScreen(
                        index: index,
                      ),
                    ),
                  );
                },
                child: Icon(
                  Icons.edit_note_rounded,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
            ),
            Positioned(
              left: -5,
              top: -10,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewItemScreen(
                        index: index,
                      ),
                    ),
                  );
                },
                child: Icon(
                  Icons.edit_note_rounded,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //remove
  void removeItem(int index) {
    removeItemCallback!(index);
  }
}
