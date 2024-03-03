import 'package:flutter/material.dart';
import 'package:p2p/utilities/utilities.dart';

class VehicleTypeWidget extends StatelessWidget {
  final String? orderVehicleType;

  VehicleTypeWidget(this.orderVehicleType);

  @override
  Widget build(BuildContext context) {
    final vehicleImagePath = Utilities.getVehicleImage(orderVehicleType);
    if (vehicleImagePath != null) {
      return Image.asset(vehicleImagePath);
    } else {
      return Text('Invalid vehicle type');
    }
  }
}
