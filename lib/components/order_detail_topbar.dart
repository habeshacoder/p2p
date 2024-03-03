import 'package:flutter/material.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/components/vehicle_component.dart';
import 'package:p2p/widgets/vehicle_Type.dart';

class OrderDetailTopBar extends StatelessWidget {
  final String? VehicleType;
  final int? orderId;
  OrderDetailTopBar({required this.VehicleType, required this.orderId});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            color: P2pAppColors.yellow,
          ),
          child: Row(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Image.asset(
                      "assets/images/Box on top of Order detail.png")),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        "Order Id: $orderId",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    Container(
                      child: Text(
                        "REQUESTED",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: VehicleTypeWidget(VehicleType)),
            ],
          ),
        ),
        Positioned(
            left: 20,
            top: 10,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back_ios_new_outlined),
            ))
      ],
    );
  }
}
