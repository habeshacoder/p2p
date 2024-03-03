import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/appStyles/app_fontsize.dart';

// ignore: must_be_immutable
class VehicleType extends StatelessWidget {
  VehicleType(
      {super.key,
      required this.vehicleImage,
      required this.selectedIndex,
      required this.index,
      required this.setSelectedIndex,
      required this.vehicleType});
  String vehicleImage;
  int selectedIndex;
  String vehicleType;
  int index;
  Function setSelectedIndex;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setSelectedIndex(index),
      child: Stack(
        children: [
          Positioned(
            top: 50,
            right: 20,
            child: Container(
              width: 80,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(P2pFontSize.vehicleRadius),
                color: index == selectedIndex
                    ? P2pAppColors.orange
                    : P2pAppColors.white,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                    bottom: 10,
                  ),
                  // Set the width explicitly
                  child: AutoSizeText(
                    vehicleType,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: P2pAppColors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          Image.asset(
            vehicleImage,
            width: 100,
            height: 100,
          ),
        ],
      ),
    );
  }
}
